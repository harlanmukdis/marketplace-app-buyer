import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'format_helper.dart';

/// Parser JSON yang toleran tipe, untuk dipakai model `freezed`.
///
/// **Kenapa ini wajib, bukan pemanis.** marketplace-api mengirim field numerik
/// yang sama dengan tipe berbeda tergantung endpoint-nya. Sudah dibuktikan ke
/// server: `POST /checkout/sessions` membalas `"grand_total": 150000` (number),
/// sedangkan `GET /checkout/sessions/{id}` membalas `"grand_total": "150000.00"`
/// (string berdesimal, karena nilainya lewat begitu saja dari driver MySQL).
/// Hal yang sama terjadi pada boolean `tinyint`, yang datang sebagai
/// `"0"`/`"1"`, dan string `"0"` itu **truthy** kalau diperiksa sembarangan.
///
/// Arah sebaliknya juga ada dan sama menjebaknya: mayoritas field berupa string,
/// tapi `stock` di `GET /products/{id}`, `subtotal`/`item_count` di
/// `GET /cart/summary`, serta `cost`/`etd_*_days` di `shipping-options` justru
/// datang sebagai angka asli.
///
/// Kalau model memakai `int` telanjang, halaman yang memanggil endpoint
/// "sisi string" melempar `CastError` — persis di alur yang paling sering
/// dipakai. Karena itu **setiap field numerik dan boolean di model wajib
/// memakai converter di sini**, bukan hanya yang kelihatan berisiko.
///
/// ```dart
/// @freezed
/// abstract class OrderModel with _$OrderModel {
///   const factory OrderModel({
///     @IntJson() required int id,
///     @IntJson() required int grandTotal,
///     @BoolJson() required bool forcedBankTransfer,
///     @ServerDateTimeJson() DateTime? paymentDeadline,
///   }) = _OrderModel;
///
///   factory OrderModel.fromJson(Map<String, dynamic> json) =>
///       _$OrderModelFromJson(json);
/// }
/// ```

/// `int` dari number, string numerik, atau `null`. `null`/tidak terbaca →
/// [fallback].
int asInt(Object? value, {int fallback = 0}) => asIntOrNull(value) ?? fallback;

int? asIntOrNull(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.round();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    // Nominal rupiah bisa datang sebagai "6500000.00" dari kolom DECIMAL.
    return int.tryParse(trimmed) ?? double.tryParse(trimmed)?.round();
  }
  return null;
}

double asDouble(Object? value, {double fallback = 0}) =>
    asDoubleOrNull(value) ?? fallback;

double? asDoubleOrNull(Object? value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }
  return null;
}

/// `bool` dari `true`/`false`, `1`/`0`, atau `"1"`/`"0"`/`"true"`/`"false"`.
///
/// Kolom `tinyint(1)` MySQL sampai ke JSON sebagai `"0"`/`"1"`, dan string
/// `"0"` itu **truthy** kalau diperiksa sembarangan — sumber bug yang halus.
bool asBool(Object? value, {bool fallback = false}) =>
    asBoolOrNull(value) ?? fallback;

bool? asBoolOrNull(Object? value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    switch (value.trim().toLowerCase()) {
      case '1':
      case 'true':
      case 'yes':
        return true;
      case '0':
      case 'false':
      case 'no':
      case '':
        return false;
    }
  }
  return null;
}

/// `String` dari nilai apa pun. Dipakai untuk field id yang kadang number,
/// kadang string, tapi selalu diperlakukan sebagai identitas.
String asString(Object? value, {String fallback = ''}) =>
    value?.toString() ?? fallback;

String? asStringOrNull(Object? value) {
  final s = value?.toString().trim();
  return (s == null || s.isEmpty) ? null : s;
}

// ---------------------------------------------------------------------------
// JsonConverter untuk dipakai sebagai anotasi field di model freezed.
// ---------------------------------------------------------------------------

class IntJson extends JsonConverter<int, Object?> {
  const IntJson();
  @override
  int fromJson(Object? json) => asInt(json);
  @override
  Object? toJson(int object) => object;
}

class IntOrNullJson extends JsonConverter<int?, Object?> {
  const IntOrNullJson();
  @override
  int? fromJson(Object? json) => asIntOrNull(json);
  @override
  Object? toJson(int? object) => object;
}

class DoubleJson extends JsonConverter<double, Object?> {
  const DoubleJson();
  @override
  double fromJson(Object? json) => asDouble(json);
  @override
  Object? toJson(double object) => object;
}

class DoubleOrNullJson extends JsonConverter<double?, Object?> {
  const DoubleOrNullJson();
  @override
  double? fromJson(Object? json) => asDoubleOrNull(json);
  @override
  Object? toJson(double? object) => object;
}

class BoolJson extends JsonConverter<bool, Object?> {
  const BoolJson();
  @override
  bool fromJson(Object? json) => asBool(json);
  @override
  Object? toJson(bool object) => object;
}

class StringJson extends JsonConverter<String, Object?> {
  const StringJson();
  @override
  String fromJson(Object? json) => asString(json);
  @override
  Object? toJson(String object) => object;
}

class StringOrNullJson extends JsonConverter<String?, Object?> {
  const StringOrNullJson();
  @override
  String? fromJson(Object? json) => asStringOrNull(json);
  @override
  Object? toJson(String? object) => object;
}

/// `DateTime?` dari `"YYYY-MM-DD HH:MM:SS"` waktu server.
///
/// Hasilnya adalah **instan UTC yang benar**, bukan angka jam mentahnya —
/// lihat [parseServerInstant] untuk alasannya.
class ServerDateTimeJson extends JsonConverter<DateTime?, Object?> {
  const ServerDateTimeJson();
  @override
  DateTime? fromJson(Object? json) => parseServerInstant(json?.toString());
  @override
  Object? toJson(DateTime? object) => formatForServer(object);
}

/// `Map<String, dynamic>?` dari objek JSON **atau dari string berisi JSON**.
///
/// Backend menyimpan sebagian kolom sebagai teks JSON dan meneruskannya apa
/// adanya, sehingga field yang sama bisa sampai sebagai objek di satu endpoint
/// dan sebagai string di endpoint lain. Yang sudah terbukti berbentuk string:
/// `product_variants.variant_options` (`'{"warna":"Hitam"}'` dari
/// `GET /products/{id}`), `checkout_sessions.cart_snapshot`, dan
/// `orders.shipping_address_snapshot`.
///
/// String yang bukan JSON valid — atau JSON yang ternyata bukan objek —
/// menghasilkan `null`, bukan lemparan: satu varian dengan data rusak tidak
/// boleh menggagalkan seluruh halaman produk.
class JsonMapJson extends JsonConverter<Map<String, dynamic>?, Object?> {
  const JsonMapJson();

  @override
  Map<String, dynamic>? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Map) return Map<String, dynamic>.from(json);
    if (json is String) {
      final text = json.trim();
      if (text.isEmpty) return null;
      try {
        final decoded = jsonDecode(text);
        return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
      } on FormatException {
        return null;
      }
    }
    return null;
  }

  @override
  Object? toJson(Map<String, dynamic>? object) => object;
}
