import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/address/cubit/address_cubit.dart';
import 'package:marketplace_app_member/ui/main/address/screens/address_form_sheet.dart';
import 'package:marketplace_app_member/ui/main/checkout/cubit/checkout_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Layar checkout: alamat tujuan, kurir per toko, lalu konfirmasi.
///
/// Membuka layar ini **mereservasi stok selama 15 menit**. Hitung mundurnya
/// ditampilkan, dan meninggalkan layar membatalkan sesinya (lihat
/// `CheckoutCubit.close`).
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AddressCubit()..load()),
        BlocProvider(create: (_) => CheckoutCubit()),
      ],
      child: const _CheckoutGate(),
    );
  }
}

/// Memulai sesi begitu alamat tersedia.
///
/// Sesi tidak bisa dibuat tanpa `address_id`, jadi alamat harus dimuat lebih
/// dulu — dan kalau user belum punya alamat yang lengkap, yang ditampilkan
/// adalah ajakan menambah, bukan error checkout.
class _CheckoutGate extends StatefulWidget {
  const _CheckoutGate();

  @override
  State<_CheckoutGate> createState() => _CheckoutGateState();
}

class _CheckoutGateState extends State<_CheckoutGate> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(
      listener: (context, state) {
        if (_started) return;
        final address = state.primary;
        if (address == null || !address.isComplete) return;
        _started = true;
        CheckoutCubit.get(context).start(addressId: address.id);
      },
      builder: (context, addressState) {
        return switch (addressState) {
          AddressLoading() => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          AddressError(:final error) => Scaffold(
              appBar: customAppBar(context, 'Checkout'),
              body: _Message(
                icon: Icons.cloud_off_rounded,
                title: errorMessageFor(context, error),
                actionLabel: 'Coba lagi',
                onAction: () => AddressCubit.get(context).load(),
              ),
            ),
          AddressReady() => addressState.usable.isEmpty
              ? _NoAddressView(hasIncomplete: addressState.addresses.isNotEmpty)
              : const _CheckoutBody(),
        };
      },
    );
  }
}

class _NoAddressView extends StatelessWidget {
  const _NoAddressView({required this.hasIncomplete});

  /// User punya alamat, tapi tidak ada yang lengkap — pesannya berbeda dari
  /// "belum punya alamat sama sekali", karena tindakannya berbeda: melengkapi
  /// versus menambah.
  final bool hasIncomplete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Checkout'),
      body: _Message(
        icon: Icons.location_off_outlined,
        title: hasIncomplete
            ? 'Alamat kamu belum lengkap. Lengkapi dulu sebelum checkout.'
            : 'Belum ada alamat pengiriman.',
        actionLabel: 'Tambah alamat',
        onAction: () => AddressFormSheet.show(context),
      ),
    );
  }
}

class _CheckoutBody extends StatelessWidget {
  const _CheckoutBody();

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(context, 'Checkout'),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listenWhen: (previous, current) =>
            current is CheckoutReady && current.actionError != null,
        listener: (context, state) {
          final error = (state as CheckoutReady).actionError!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(errorMessageFor(context, error))),
            );
          CheckoutCubit.get(context).clearActionError();
        },
        builder: (context, state) {
          return switch (state) {
            CheckoutPreparing() =>
              const Center(child: CircularProgressIndicator()),
            CheckoutError(:final error) => _Message(
                icon: Icons.cloud_off_rounded,
                title: errorMessageFor(context, error),
                actionLabel: 'Ulangi',
                onAction: () {
                  final addressId = CheckoutCubit.get(context).addressId;
                  if (addressId != null) {
                    CheckoutCubit.get(context).start(addressId: addressId);
                  }
                },
              ),
            CheckoutConfirmed(:final result) => _ConfirmedView(result: result),
            CheckoutReady() => _CheckoutForm(state: state),
          };
        },
      ),
      bottomNavigationBar: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) {
          if (state is! CheckoutReady) return const SizedBox.shrink();
          return _ConfirmBar(state: state);
        },
      ),
    );
  }
}

class _CheckoutForm extends StatelessWidget {
  const _CheckoutForm({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    final snapshot = state.snapshot;

    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        _ReservationTimer(expiresAt: snapshot.session.expiresAt),
        16.sbh,
        const _AddressCard(),
        24.sbh,
        for (final storeId in snapshot.storeIds) ...[
          _StoreShipping(
            storeId: storeId,
            options: snapshot.shippingOptions[storeId] ?? const [],
            selected: snapshot.selectedFor(storeId),
            enabled: state.canInteract,
          ),
          16.sbh,
        ],
        _PaymentMethodPicker(state: state),
        24.sbh,
      ],
    );
  }
}

/// Pemilihan metode pembayaran.
///
/// Ada di **checkout**, bukan di layar pembayaran: metode terikat pada
/// transaksi saat `confirm`, dan `POST /payments/{txId}/pay` mengabaikan
/// metode yang dikirim belakangan (sudah diuji untuk lima metode).
class _PaymentMethodPicker extends StatelessWidget {
  const _PaymentMethodPicker({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    if (state.paymentMethods.isEmpty) {
      return Text(
        'Metode pembayaran belum bisa dimuat. Muat ulang halaman ini.',
        style:
            AppStyles.styleRegular12(context).copyWith(color: kWarningColor),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metode Pembayaran',
          style: AppStyles.styleSemiBold16(context).copyWith(
            color: dark ? kDarkSecondColor : kLightSecondColor,
          ),
        ),
        8.sbh,
        RadioGroup<String>(
          groupValue: state.selectedPaymentMethod.isEmpty
              ? null
              : state.selectedPaymentMethod,
          onChanged: (value) {
            if (!state.canInteract || value == null) return;
            CheckoutCubit.get(context).selectPaymentMethod(value);
          },
          child: Column(
            children: [
              for (final method in state.paymentMethods)
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  value: method.code,
                  title: Text(method.name),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Hitung mundur reservasi stok.
///
/// 🔴 Angkanya bergantung pada `expires_at` yang dikirim server dalam **UTC**,
/// sementara `created_at` di respons yang sama memakai waktu WIB. Model
/// memakai converter berbeda untuk keduanya; kalau disamakan, hitung mundur
/// ini langsung menunjukkan "habis" pada sesi yang baru dibuat.
class _ReservationTimer extends StatefulWidget {
  const _ReservationTimer({required this.expiresAt});

  final DateTime? expiresAt;

  @override
  State<_ReservationTimer> createState() => _ReservationTimerState();
}

class _ReservationTimerState extends State<_ReservationTimer> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deadline = widget.expiresAt;
    if (deadline == null) return const SizedBox.shrink();

    final left = deadline.difference(DateTime.now().toUtc());
    final expired = left.isNegative;

    return Container(
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: (expired ? kErrorColor : kWarningColor).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined,
              size: 18, color: expired ? kErrorColor : kWarningColor),
          8.sbw,
          Expanded(
            child: Text(
              expired
                  ? 'Waktu reservasi habis. Ulangi dari keranjang.'
                  : 'Stok ditahan ${formatReservationLeft(left)} lagi',
              style: AppStyles.styleMedium14(context).copyWith(
                color: expired ? kErrorColor : kWarningColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard();

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, addressState) {
        final address = addressState.primary;
        if (address == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alamat Pengiriman',
              style: AppStyles.styleSemiBold16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            8.sbh,
            Container(
              padding: const EdgeInsetsDirectional.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                    color: dark ? kDarkThirdColor : kBorderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${address.label} · ${address.recipientName}',
                          style: AppStyles.styleMedium14(context).copyWith(
                            color:
                                dark ? kDarkSecondColor : kLightSecondColor,
                          ),
                        ),
                        2.sbh,
                        Text(
                          address.phone,
                          style: AppStyles.styleRegular12(context).copyWith(
                            color: dark ? kDarkThirdColor : kLightThirdColor,
                          ),
                        ),
                        4.sbh,
                        Text(
                          address.summary,
                          style: AppStyles.styleRegular12(context).copyWith(
                            color: dark ? kDarkThirdColor : kLightThirdColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickAddress(context, addressState),
                    child: const Text('Ubah'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Memilih alamat lain.
  ///
  /// Mengganti alamat **membuat ulang sesi checkout** — `PATCH .../address`
  /// rusak di server. Itu juga berarti pilihan kurir yang sudah dibuat ikut
  /// hilang, jadi user diberi tahu lebih dulu.
  Future<void> _pickAddress(
    BuildContext context,
    AddressState addressState,
  ) async {
    final checkout = CheckoutCubit.get(context);
    final usable = addressState.usable;

    final picked = await showModalBottomSheet<AddressModel>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Text(
                'Pilih alamat',
                style: AppStyles.styleSemiBold16(sheetContext),
              ),
            ),
            for (final address in usable)
              ListTile(
                title: Text('${address.label} · ${address.recipientName}'),
                subtitle: Text(address.summary),
                onTap: () => Navigator.of(sheetContext).pop(address),
              ),
          ],
        ),
      ),
    );

    if (picked == null) return;
    if (picked.id == checkout.addressId) return;
    await checkout.changeAddress(picked.id);
  }
}

class _StoreShipping extends StatelessWidget {
  const _StoreShipping({
    required this.storeId,
    required this.options,
    required this.selected,
    required this.enabled,
  });

  final String storeId;
  final List<ShippingOptionModel> options;
  final ShippingOptionModel? selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengiriman (toko #$storeId)',
          style: AppStyles.styleSemiBold16(context).copyWith(
            color: dark ? kDarkSecondColor : kLightSecondColor,
          ),
        ),
        8.sbh,
        if (options.isEmpty)
          // Sejak 15 September 2026 opsi kurir disaring menurut `store_couriers`
          // milik toko, jadi daftar kosong bukan lagi kasus mustahil. Tanpa
          // jalan keluar, user terjebak: tombol Bayar mati selamanya karena
          // konfirmasi menuntut setiap toko punya kurir, sementara barang toko
          // itu tidak bisa dilepas dari dalam layar checkout.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Toko ini tidak melayani pengiriman ke alamat tujuan.',
                style: AppStyles.styleRegular12(context)
                    .copyWith(color: kErrorColor),
              ),
              4.sbh,
              Text(
                'Batalkan checkout, lalu hapus atau lepas centang barang toko '
                'ini di keranjang.',
                style: AppStyles.styleRegular12(context).copyWith(
                  color: dark ? kDarkThirdColor : kLightThirdColor,
                ),
              ),
              4.sbh,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () async {
                    await CheckoutCubit.get(context).cancel();
                    if (context.mounted) Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali ke keranjang'),
                ),
              ),
            ],
          )
        else
          RadioGroup<String>(
            groupValue: selected?.key,
            // `RadioGroup.onChanged` tidak boleh null, jadi penguncian saat
            // sesi sedang mengirim dilakukan di dalam callback.
            onChanged: (value) {
              if (!enabled) return;
              final option = options.where((o) => o.key == value).firstOrNull;
              if (option == null) return;
              CheckoutCubit.get(context).selectCourier(storeId, option);
            },
            child: Column(
              children: [
                for (final option in options)
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    value: option.key,
                    title: Text(option.serviceName),
                    subtitle: Text(
                      '${formatRupiah(option.cost)} · ${option.etdLabel}',
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final snapshot = state.snapshot;
    final missing = snapshot.session.storesWithoutCourier;
    final total = snapshot.session.grandTotal + snapshot.shippingTotal;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total bayar',
                    style: AppStyles.styleRegular12(context).copyWith(
                      color: dark ? kDarkThirdColor : kLightThirdColor,
                    ),
                  ),
                  Text(
                    formatRupiah(total),
                    style: AppStyles.styleSemiBold18(context).copyWith(
                      color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
                    ),
                  ),
                  if (missing.isNotEmpty)
                    Text(
                      'Pilih kurir untuk ${missing.length} toko lagi',
                      style: AppStyles.styleRegular11(context)
                          .copyWith(color: kWarningColor),
                    ),
                ],
              ),
            ),
            FilledButton(
              // Tidak pernah diulang otomatis: backend belum menangani
              // Idempotency-Key, jadi pengulangan bisa membuat order ganda.
              onPressed: state.canPay
                  ? () => CheckoutCubit.get(context).confirm()
                  : null,
              child: Text(state.isSubmitting ? 'Memproses…' : 'Bayar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmedView extends StatelessWidget {
  const _ConfirmedView({required this.result});

  final CheckoutConfirmResult result;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 64, color: kSuccessColor),
            16.sbh,
            Text(
              result.isMultiStore
                  // Keranjang multi-toko pecah jadi satu order per toko —
                  // ditulis apa adanya supaya user tidak bingung melihat
                  // beberapa pesanan dari satu kali checkout.
                  ? '${result.orderIds.length} pesanan dibuat, satu untuk '
                      'tiap toko.'
                  : 'Pesanan berhasil dibuat.',
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            8.sbh,
            Text(
              'Selesaikan pembayaran sebelum batas waktu.',
              textAlign: TextAlign.center,
              style: AppStyles.styleRegular12(context).copyWith(
                color: dark ? kDarkThirdColor : kLightThirdColor,
              ),
            ),
            24.sbh,
            if (result.paymentTransactionId != null)
              FilledButton(
                // `pushReplacement`: checkout sudah selesai dan sesinya tidak
                // bisa dipakai lagi, jadi tombol kembali tidak boleh
                // mengembalikan user ke layar yang sudah mati.
                onPressed: () => context.pushReplacement(
                  AppRoutes.paymentPath(result.paymentTransactionId!),
                ),
                child: const Text('Lanjut ke pembayaran'),
              )
            else
              FilledButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Kembali'),
              ),
            8.sbh,
            TextButton(
              onPressed: () => context.go(AppRoutes.orders),
              child: const Text('Lihat pesanan saya'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 48, color: dark ? kDarkThirdColor : kLightThirdColor),
            16.sbh,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            if (actionLabel != null) ...[
              16.sbh,
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
