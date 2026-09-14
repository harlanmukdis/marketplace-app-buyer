import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Satu simpul pohon kategori dari `GET /categories`.
///
/// Endpoint ini mengembalikan **pohon yang sudah tersusun**, bukan daftar
/// datar: simpul level 0 membawa anaknya di [children], sehingga tidak perlu
/// merakit ulang dari `parent_id` di sisi aplikasi. Seed saat ini berisi 12
/// kategori induk dengan 39 anak.
///
/// Tidak ada `GET /categories/{id}` — rute itu tidak terdaftar. Kalau butuh
/// satu kategori, cari di pohon yang sudah diambil (lihat [findById]).
@freezed
abstract class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    @IntJson() required int id,
    @IntOrNullJson() @JsonKey(name: 'parent_id') int? parentId,
    @StringJson() @Default('') String name,
    @StringJson() @Default('') String slug,
    @StringOrNullJson() @JsonKey(name: 'icon_url') String? iconUrl,
    @IntJson() @Default(0) int level,
    @IntJson() @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @BoolJson() @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default(<CategoryModel>[]) List<CategoryModel> children,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  bool get hasChildren => children.isNotEmpty;

  /// Mencari kategori di seluruh pohon, termasuk cucu.
  ///
  /// Mengembalikan `null` kalau tidak ada, bukan melempar — id kategori bisa
  /// datang dari deep link atau dari filter yang tersimpan, dan keduanya bisa
  /// menunjuk kategori yang sudah dinonaktifkan.
  CategoryModel? findById(int target) {
    if (id == target) return this;
    for (final child in children) {
      final found = child.findById(target);
      if (found != null) return found;
    }
    return null;
  }
}

/// Mencari sebuah kategori di daftar pohon tingkat atas.
CategoryModel? findCategoryById(List<CategoryModel> roots, int target) {
  for (final root in roots) {
    final found = root.findById(target);
    if (found != null) return found;
  }
  return null;
}
