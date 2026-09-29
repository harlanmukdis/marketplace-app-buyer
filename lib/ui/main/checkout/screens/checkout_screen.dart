import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/address/cubit/address_cubit.dart';
import 'package:marketplace_app_member/ui/main/address/screens/address_form_sheet.dart';
import 'package:marketplace_app_member/ui/main/address/screens/address_list_screen.dart'
    show maskPhone;
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/ui/main/checkout/cubit/checkout_cubit.dart';
import 'package:marketplace_app_member/ui/main/checkout/widgets/checkout_error_text.dart';
import 'package:marketplace_app_member/ui/main/checkout/widgets/topup_sheet.dart';
import 'package:marketplace_app_member/ui/main/checkout/widgets/wallet_payment_block.dart';
import 'package:marketplace_app_member/ui/main/checkout/widgets/wallet_pin_sheet.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Layar checkout (desain `checkout_xpedia_wallet_2`, + b18 untuk multi-toko):
/// alamat tujuan, barang dan kurir per toko, metode bayar, ringkasan.
///
/// Membuka layar ini **mereservasi stok selama 15 menit**. Hitung mundurnya
/// ditampilkan, dan meninggalkan layar membatalkan sesinya (lihat
/// `CheckoutCubit.close`).
///
/// **Pembayaran: Xpedia Wallet + PIN 6 digit** (§3.9–§3.11, docs/22 #1–#2),
/// terhadap kontrak yang **diusulkan** — `wallet-summary` dan `confirm`
/// dengan `pin`. Di debug keduanya dijawab mock (lencana "Simulasi"); kalau
/// server tidak mengenal rutenya, layar kembali ke pemilih metode
/// pembayaran lama tanpa perubahan (lihat `CheckoutPaymentMode`). Saldo dan
/// total tagihan selalu berada di **satu kartu** (design_buyer.md §5).
///
/// Juga tidak dibangun: **Xpedia Secure+** dan biaya layanan (tidak ada
/// backend), **catatan pesanan** (tidak ada field di sesi), **stepper
/// kuantitas** (kuantitas terkunci di `cart_snapshot`; mengubahnya berarti
/// sesi baru), dan klaim "Terenkripsi 256-Bit".
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
          AddressLoading() => const _Frame(
              body: Center(child: CircularProgressIndicator()),
            ),
          AddressError(:final error) => _Frame(
              body: XpEmptyState(
                icon: Icons.cloud_off_rounded,
                title: 'Alamat belum bisa dimuat',
                message: errorMessageFor(context, error),
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

/// Scaffold dasar layar ini, supaya app bar-nya sama di setiap keadaan.
class _Frame extends StatelessWidget {
  const _Frame({required this.body, this.bottom});

  final Widget body;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(
        title: 'Checkout Pembayaran',
        actions: [SupportActionButton()],
      ),
      body: body,
      bottomNavigationBar: bottom,
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
    final state = AddressCubit.get(context).state;
    return _Frame(
      body: XpEmptyState(
        icon: Icons.location_off_outlined,
        title: hasIncomplete
            ? 'Alamat kamu belum lengkap'
            : 'Belum ada alamat pengiriman',
        message: hasIncomplete
            ? 'Lengkapi dulu alamatmu sebelum checkout.'
            : 'Tambahkan alamat supaya pesanan bisa dikirim.',
        // Alamat tak lengkap tetap menghabiskan kuota 3 alamat; kalau
        // kuotanya penuh, jalan keluarnya adalah melengkapinya lewat layar
        // kelola alamat, bukan menambah baru.
        actionLabel: state.canAddMore ? 'Tambah alamat' : 'Kelola alamat',
        onAction: () async {
          if (state.canAddMore) {
            await AddressFormSheet.show(context);
            return;
          }
          await context.push(AppRoutes.addresses);
          if (context.mounted) AddressCubit.get(context).load();
        },
      ),
    );
  }
}

class _CheckoutBody extends StatelessWidget {
  const _CheckoutBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) =>
          current is CheckoutReady &&
          (current.actionError != null || current.pendingTopupTxId != null),
      listener: (context, state) async {
        final ready = state as CheckoutReady;
        final cubit = CheckoutCubit.get(context);
        final topupTx = ready.pendingTopupTxId;
        if (topupTx != null) {
          // Top up memakai ulang layar pembayaran yang sama dengan checkout;
          // sekembalinya, saldo dibaca ulang dari server.
          cubit.topupHandled();
          await context.push(AppRoutes.paymentPath(topupTx));
          if (context.mounted) await cubit.reloadWallet();
          return;
        }
        final error = ready.actionError!;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(checkoutErrorText(context, error))),
          );
        cubit.clearActionError();
      },
      builder: (context, state) {
        return switch (state) {
          CheckoutPreparing() =>
            const _Frame(body: Center(child: CircularProgressIndicator())),
          CheckoutError(:final error) =>
            _Frame(body: _StartFailedView(error: error)),
          CheckoutConfirmed(:final result, :final meta) =>
            _Frame(body: _ConfirmedView(result: result, meta: meta)),
          CheckoutReady() => _Frame(
              body: _CheckoutForm(state: state),
              bottom: _ConfirmBar(state: state),
            ),
        };
      },
    );
  }
}

/// Sesi gagal dibuat. Dua sebab punya jalan keluar sendiri:
///
/// * `SHIPPING_COVERAGE_UNAVAILABLE` (dicek server **sebelum** stok
///   direservasi, jadi tidak ada sesi yang perlu dibatalkan) — ada produk yang tidak melayani alamat
///   tujuan. Pesan server menyebut nama produknya, tapi `error.message` tidak
///   boleh tampil ke user; jadi yang ditawarkan adalah **ganti alamat** atau
///   kembali ke keranjang untuk melepas barangnya;
/// * `STOCK_INSUFFICIENT` — kembali ke keranjang.
class _StartFailedView extends StatelessWidget {
  const _StartFailedView({required this.error});

  final DataError error;

  @override
  Widget build(BuildContext context) {
    final checkout = CheckoutCubit.get(context);

    if (error.code == ApiErrorCode.shippingCoverageUnavailable) {
      return _TwoActionState(
        icon: Icons.local_shipping_outlined,
        title: 'Barang tidak bisa dikirim ke alamat ini',
        message: 'Ada barang di keranjangmu yang tidak melayani pengiriman ke '
            'kota tujuan. Ganti alamat, atau lepas barang itu dari keranjang.',
        primaryLabel: 'Ganti Alamat',
        onPrimary: () => _pickAddress(context),
        secondaryLabel: 'Kembali ke keranjang',
        onSecondary: () => Navigator.of(context).maybePop(),
      );
    }

    if (error.code == ApiErrorCode.stockInsufficient) {
      return _TwoActionState(
        icon: Icons.inventory_2_outlined,
        title: 'Stok tidak mencukupi',
        message: errorMessageFor(context, error),
        primaryLabel: 'Kembali ke keranjang',
        onPrimary: () => Navigator.of(context).maybePop(),
      );
    }

    return XpEmptyState(
      icon: Icons.cloud_off_rounded,
      title: 'Checkout belum bisa dimulai',
      message: errorMessageFor(context, error),
      actionLabel: 'Ulangi',
      onAction: () {
        final addressId = checkout.addressId;
        if (addressId != null) checkout.start(addressId: addressId);
      },
    );
  }
}

class _TwoActionState extends StatelessWidget {
  const _TwoActionState({
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: XpColors.warningSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: const Color(0xff8C5002)),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: XpText.titleM(context), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onPrimary, child: Text(primaryLabel)),
            if (secondaryLabel != null)
              TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
          ],
        ),
      ),
    );
  }
}

/// Memilih alamat lain lewat lembar bawah.
///
/// Mengganti alamat pada sesi berjalan memakai `PATCH .../address`, yang
/// mempertahankan reservasi stok; tanpa sesi terbuka (mis. sesudah
/// `SHIPPING_COVERAGE_UNAVAILABLE`) alamatnya dipakai memulai sesi baru.
Future<void> _pickAddress(BuildContext context) async {
  final checkout = CheckoutCubit.get(context);
  final addresses = AddressCubit.get(context);
  final usable = addresses.state.usable;
  final currentId = checkout.addressId;

  final picked = await showModalBottomSheet<Object>(
    context: context,
    showDragHandle: true,
    backgroundColor: XpColors.surface,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text('Pilih Alamat Pengiriman', style: XpText.headingM(sheetContext)),
          const SizedBox(height: 12),
          for (final address in usable)
            XpCard(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              borderColor: address.id == currentId ? XpColors.primary : null,
              onTap: () => Navigator.of(sheetContext).pop(address),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${address.label} · ${address.recipientName}',
                          style: XpText.titleM(sheetContext),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          address.summary,
                          style: XpText.bodyS(sheetContext)
                              .copyWith(color: XpColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (address.id == currentId)
                    Icon(Icons.check_circle, color: XpColors.primary),
                ],
              ),
            ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.of(sheetContext).pop(AppRoutes.addresses),
            icon: const Icon(Icons.edit_location_alt_outlined, size: 18),
            label: const Text('Kelola Alamat'),
          ),
        ],
      ),
    ),
  );

  if (!context.mounted) return;
  if (picked == AppRoutes.addresses) {
    await context.push(AppRoutes.addresses);
    // Alamat bisa berubah di sana (tambah/ubah/hapus); sesi tetap memakai
    // alamatnya yang sekarang sampai user memilih lagi.
    if (context.mounted) await addresses.load();
    return;
  }
  if (picked is! AddressModel) return;
  if (picked.id == currentId && checkout.state is CheckoutReady) return;
  await checkout.changeAddress(picked.id);
}

class _CheckoutForm extends StatelessWidget {
  const _CheckoutForm({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    final snapshot = state.snapshot;
    final storeIds = snapshot.storeIds;
    final storeIdInts = <int>[
      for (final id in storeIds)
        if (int.tryParse(id) case final parsed?) parsed,
    ];
    // Sesi hanya membawa `store_id`; nama dan status toko dari direktori.
    context.read<StoreDirectoryCubit>().ensure(storeIdInts);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _ReservationTimer(expiresAt: snapshot.session.expiresAt),
        const SizedBox(height: 12),
        _AddressCard(sessionAddressId: snapshot.session.shippingAddressId),
        const SizedBox(height: 12),
        for (final storeId in storeIds) ...[
          _StoreCard(
            storeId: storeId,
            items: [
              for (final item in snapshot.session.snapshotItems)
                if (item['store_id']?.toString() == storeId) item,
            ],
            options: snapshot.shippingOptions[storeId] ?? const [],
            selected: snapshot.selectedFor(storeId),
            enabled: state.canInteract,
          ),
          const SizedBox(height: 12),
        ],
        _SummaryCard(
          snapshot: snapshot,
          wallet: WalletPaymentBlock(
                  wallet: state.wallet,
                  meta: state.walletMeta,
                  loading: state.walletLoading,
                  error: state.walletError,
                  toppingUp: state.isToppingUp,
                  onTopup: () => _openTopup(context, state),
                  onRetry: () => CheckoutCubit.get(context).reloadWallet(),
                  onCreatePin: () async {
                    // Layar PIN yang ada ditulis untuk penarikan; PIN yang
                    // sama dipakai membayar (satu PIN Wallet).
                    await context.push(AppRoutes.withdrawalPin);
                    if (context.mounted) {
                      await CheckoutCubit.get(context).reloadWallet();
                    }
                  },
                ),
        ),
      ],
    );
  }
}

/// Hitung mundur reservasi stok (15 menit), sebagai strip di atas layar.
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
    final left = remainingUntil(widget.expiresAt);
    if (left == null) return const SizedBox.shrink();
    final expired = left.isNegative;

    final minutes = left.inMinutes.toString().padLeft(2, '0');
    final seconds = (left.inSeconds % 60).toString().padLeft(2, '0');

    return XpBanner(
      icon: expired ? Icons.timer_off_outlined : Icons.timer_outlined,
      tone: expired ? XpBannerTone.danger : XpBannerTone.warning,
      title: expired
          ? 'Waktu reservasi habis. Ulangi dari keranjang.'
          : 'Stok ditahan $minutes:$seconds lagi',
      message: expired
          ? null
          : 'Selesaikan checkout sebelum waktu habis supaya barangmu tidak '
              'dilepas ke pembeli lain.',
    );
  }
}

/// Header kartu: ikon + judul + aksi kanan opsional.
class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: XpColors.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: XpText.titleM(context))),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.sessionAddressId});

  /// Alamat yang benar-benar tersimpan di sesi — **bukan** selalu alamat
  /// utama: setelah user mengganti alamat, yang dikirimi adalah pilihan itu.
  final int? sessionAddressId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, addressState) {
        final addresses =
            addressState is AddressReady ? addressState.addresses : const [];
        final id = sessionAddressId ?? CheckoutCubit.get(context).addressId;
        final address = addresses.cast<AddressModel?>().firstWhere(
              (a) => a?.id == id,
              orElse: () => addressState.primary,
            );

        return XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardHeader(
                icon: Icons.location_on,
                title: 'Alamat Pengiriman',
                trailing: TextButton(
                  onPressed: () => _pickAddress(context),
                  child: const Text('Ubah Alamat'),
                ),
              ),
              const SizedBox(height: 8),
              if (address == null)
                Text('Alamat tidak ditemukan.',
                    style: XpText.bodyS(context)
                        .copyWith(color: XpColors.textSecondary))
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: XpColors.canvas,
                    borderRadius: BorderRadius.circular(XpRadius.m),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(address.recipientName,
                              style: XpText.titleM(context)),
                          Text(
                            maskPhone(address.phone),
                            style: XpText.bodyS(context)
                                .copyWith(color: XpColors.textSecondary),
                          ),
                          if (address.isPrimary)
                            XpPill(
                              label: 'Utama',
                              tone: XpTone(
                                  XpColors.primarySubtle, XpColors.primary),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(address.summary,
                          style: XpText.bodyM(context)
                              .copyWith(color: XpColors.textSecondary)),
                      if (address.label.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.home_outlined,
                                size: 16, color: XpColors.textPlaceholder),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${address.label} (Maks. '
                                '${AddressCubit.maxAddresses} alamat '
                                'tersimpan)',
                                style: XpText.caption(context)
                                    .copyWith(color: XpColors.textTertiary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({
    required this.storeId,
    required this.items,
    required this.options,
    required this.selected,
    required this.enabled,
  });

  final String storeId;

  /// Baris `cart_snapshot` milik toko ini. Isinya `product_name`, `price`,
  /// `quantity` — tanpa gambar dan tanpa opsi varian.
  final List<Map<String, dynamic>> items;
  final List<ShippingOptionModel> options;
  final ShippingOptionModel? selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(storeId);
    final store = context
        .select<StoreDirectoryCubit, StoreModel?>((c) => c.state[id ?? -1]);

    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storefront_outlined,
                  size: 20, color: XpColors.textPrimary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  store?.name ?? 'Toko #$storeId',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: XpText.titleM(context),
                ),
              ),
              if (store != null) ...[
                const SizedBox(width: 6),
                SellerStatusBadge(status: store.sellerStatus, compact: true),
              ],
            ],
          ),
          for (final item in items) _SnapshotLine(item: item),
          const SizedBox(height: 12),
          _CourierBlock(
            storeId: storeId,
            options: options,
            selected: selected,
            enabled: enabled,
          ),
        ],
      ),
    );
  }
}

class _SnapshotLine extends StatelessWidget {
  const _SnapshotLine({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final name = item['product_name']?.toString() ?? 'Produk';
    final price = double.tryParse(item['price']?.toString() ?? '') ?? 0;
    final quantity = int.tryParse(item['quantity']?.toString() ?? '') ?? 1;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const XpProductImage(url: null, size: 56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: XpText.labelL(context)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(formatRupiah(price),
                          style: XpText.priceS(context)),
                    ),
                    Text('${quantity}x',
                        style: XpText.bodyS(context)
                            .copyWith(color: XpColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Opsi Pengiriman" satu toko.
class _CourierBlock extends StatelessWidget {
  const _CourierBlock({
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      decoration: BoxDecoration(
        color: XpColors.canvas,
        borderRadius: BorderRadius.circular(XpRadius.m),
        border: Border.all(color: XpColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined,
                  size: 18, color: XpColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                  child:
                      Text('Opsi Pengiriman', style: XpText.labelL(context))),
              if (selected != null)
                Text(formatRupiah(selected!.cost),
                    style: XpText.priceS(context)),
            ],
          ),
          if (options.isEmpty)
            // Sejak 15 September 2026 opsi kurir disaring menurut
            // `store_couriers` milik toko, jadi daftar kosong bukan lagi kasus
            // mustahil. Tanpa jalan keluar, user terjebak: tombol Bayar mati
            // selamanya karena konfirmasi menuntut setiap toko punya kurir,
            // sementara barang toko itu tidak bisa dilepas dari dalam layar
            // checkout.
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toko ini tidak melayani pengiriman ke alamat tujuan.',
                    style:
                        XpText.bodyS(context).copyWith(color: XpColors.danger),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Batalkan checkout, lalu hapus atau lepas centang barang '
                    'toko ini di keranjang.',
                    style: XpText.bodyS(context)
                        .copyWith(color: XpColors.textSecondary),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await CheckoutCubit.get(context).cancel();
                      if (context.mounted) Navigator.of(context).maybePop();
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali ke keranjang'),
                  ),
                ],
              ),
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
                      dense: true,
                      value: option.key,
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(option.serviceName,
                                style: XpText.labelL(context)),
                          ),
                          if (option.key == selected?.key) ...[
                            const SizedBox(width: 6),
                            XpPill(
                              label: 'Terpilih',
                              tone: XpTone(
                                  XpColors.primarySubtle, XpColors.primary),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        '${formatRupiah(option.cost)} · Estimasi tiba '
                        '${option.etdLabel}',
                        style: XpText.bodyS(context)
                            .copyWith(color: XpColors.textSecondary),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// "Ringkasan Pesanan".
///
/// 🔴 `grand_total` sesi **sudah termasuk ongkir** begitu kurir dipilih
/// (`Checkout_model::set_shipping` menulis ulang kolomnya), dan itulah angka
/// yang ditagih transaksi. Versi layar sebelumnya menambahkan ongkir sekali
/// lagi di atasnya, sehingga total yang dilihat lebih besar dari tagihan.
/// Rincian di sini karena itu diturunkan: subtotal dari `cart_snapshot`,
/// ongkir dari kurir terpilih, dan selisihnya terhadap `grand_total` adalah
/// potongan voucher.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot, this.wallet});

  final CheckoutSnapshot snapshot;

  /// Blok Xpedia Wallet — **di dalam kartu yang sama** dengan total tagihan.
  final Widget? wallet;

  @override
  Widget build(BuildContext context) {
    final breakdown = _Breakdown.of(snapshot);

    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.receipt_long_outlined,
            title: 'Ringkasan Pesanan',
            trailing: Text(
              '${snapshot.storeIds.length} Toko • ${breakdown.units} Barang',
              style: XpText.caption(context)
                  .copyWith(color: XpColors.textTertiary),
            ),
          ),
          const SizedBox(height: 8),
          XpKeyValueRow(
            label: 'Subtotal Produk (${breakdown.units} barang)',
            value: formatRupiah(breakdown.subtotal),
          ),
          XpKeyValueRow(
            label: 'Ongkos Kirim',
            value: snapshot.session.storesWithoutCourier.isEmpty
                ? formatRupiah(breakdown.shipping)
                : 'Pilih kurir',
          ),
          if (breakdown.discount > 0)
            XpKeyValueRow(
              label: 'Potongan Voucher',
              value: '-${formatRupiah(breakdown.discount)}',
              valueColor: XpColors.success,
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: XpColors.canvas,
              borderRadius: BorderRadius.circular(XpRadius.m),
              border: Border.all(color: XpColors.borderSubtle),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Tagihan Pesanan',
                          style: XpText.bodyS(context)
                              .copyWith(color: XpColors.textSecondary)),
                      Text(formatRupiah(snapshot.session.grandTotal),
                          style: XpText.priceL(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (wallet != null) ...[
            const SizedBox(height: 12),
            wallet!,
          ],
        ],
      ),
    );
  }
}

/// Nama penerima pembayaran untuk lembar PIN: nama toko kalau hanya satu,
/// "N toko" kalau keranjang multi-toko (satu pembayaran menutup semua order).
String _payeeOf(BuildContext context, CheckoutSnapshot snapshot) {
  final ids = snapshot.storeIds;
  if (ids.length != 1) return '${ids.length} toko';
  final store =
      context.read<StoreDirectoryCubit>().state[int.tryParse(ids.first) ?? -1];
  return store?.name ?? 'penjual';
}

Future<void> _openTopup(BuildContext context, CheckoutReady state) async {
  final cubit = CheckoutCubit.get(context);
  final wallet = state.wallet;
  final amount = await showCheckoutTopupSheet(
    context,
    suggested: wallet?.suggestedTopup ?? CheckoutCubit.minimumTopup,
    minimum: wallet?.minTopup ?? CheckoutCubit.minimumTopup,
    simulated: isMockMeta(state.walletMeta),
  );
  if (amount == null || !context.mounted) return;
  await cubit.startTopup(amount);
}

Future<void> _openPinSheet(BuildContext context, CheckoutReady state) async {
  final meta = state.walletMeta;
  final outcome = await showWalletPinSheet(
    context,
    amount: state.wallet?.grandTotal ?? state.snapshot.session.grandTotal,
    payee: _payeeOf(context, state.snapshot),
    simulatedPin:
        meta != null && isMockMeta(meta) ? meta['mock_pin']?.toString() : null,
  );
  if (outcome == WalletPinOutcome.forgotPin && context.mounted) {
    await context.push(AppRoutes.support);
  }
}

class _Breakdown {
  const _Breakdown({
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.units,
  });

  final double subtotal;
  final double shipping;
  final double discount;
  final int units;

  factory _Breakdown.of(CheckoutSnapshot snapshot) {
    var subtotal = 0.0;
    var units = 0;
    for (final item in snapshot.session.snapshotItems) {
      final price = double.tryParse(item['price']?.toString() ?? '') ?? 0;
      final quantity = int.tryParse(item['quantity']?.toString() ?? '') ?? 0;
      subtotal += price * quantity;
      units += quantity;
    }
    final shipping = snapshot.shippingTotal;
    final discount = subtotal + shipping - snapshot.session.grandTotal;
    return _Breakdown(
      subtotal: subtotal,
      shipping: shipping,
      // Pembulatan desimal server bisa menyisakan sen; di bawah Rp1 bukan
      // potongan sungguhan.
      discount: discount >= 1 ? discount : 0,
      units: units,
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({required this.state});

  final CheckoutReady state;

  @override
  Widget build(BuildContext context) {
    final snapshot = state.snapshot;
    final missing = snapshot.session.storesWithoutCourier;
    final walletMode = state.paymentMode == CheckoutPaymentMode.wallet;
    final wallet = state.wallet;
    final insufficient = walletMode && (wallet?.isInsufficient ?? false);

    final String? helper;
    if (missing.isNotEmpty) {
      helper = null;
    } else if (!walletMode) {
      helper = null;
    } else if (insufficient) {
      helper = 'Isi saldo untuk melanjutkan';
    } else if (wallet != null && !wallet.pinSet) {
      helper = 'Buat PIN Wallet dulu untuk membayar';
    } else {
      helper = 'Memerlukan PIN 6-digit Xpedia Wallet';
    }

    return XpBottomBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _barRow(context, snapshot, missing, walletMode, insufficient),
          if (helper != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(insufficient ? Icons.info_outline : Icons.pin_outlined,
                    size: 14, color: XpColors.textTertiary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(helper,
                      style: XpText.caption(context)
                          .copyWith(color: XpColors.textTertiary)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _barRow(
    BuildContext context,
    CheckoutSnapshot snapshot,
    Set<String> missing,
    bool walletMode,
    bool insufficient,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Wrap, bukan Row: di layar sempit (atau font besar) pil
              // "Saldo Kurang" turun ke baris berikutnya alih-alih meluap.
              Wrap(
                spacing: 6,
                runSpacing: 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Total Pembayaran',
                      style: XpText.caption(context)
                          .copyWith(color: XpColors.textTertiary)),
                  if (insufficient) ...[
                    XpPill(
                      label: 'Saldo Kurang',
                      tone: XpTone(XpColors.dangerSubtle, XpColors.danger),
                    ),
                  ],
                ],
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  formatRupiah(snapshot.session.grandTotal),
                  style:
                      XpText.priceL(context).copyWith(color: XpColors.primary),
                ),
              ),
              if (missing.isNotEmpty)
                Text(
                  'Pilih kurir untuk ${missing.length} toko lagi',
                  style: XpText.caption(context)
                      .copyWith(color: const Color(0xff8C5002)),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            // Tidak pernah diulang otomatis: backend belum menangani
            // Idempotency-Key, jadi pengulangan bisa membuat order ganda.
            // Wallet: tombol hanya membuka lembar PIN — pembayaran baru
            // dikirim setelah enam digit PIN masuk.
            onPressed: state.canPay ? () => _openPinSheet(context, state) : null,
            icon: state.isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.lock, size: 18),
            label: Text(state.isSubmitting ? 'Memproses…' : 'Bayar Sekarang'),
          ),
        ),
      ],
    );
  }
}

/// Checkout wallet-only: order yang terbentuk selalu sudah dibayar.
class _ConfirmedView extends StatelessWidget {
  const _ConfirmedView({required this.result, this.meta});

  final CheckoutConfirmResult result;
  final Map<String, dynamic>? meta;

  @override
  Widget build(BuildContext context) => _PaidView(result: result, meta: meta);
}

/// Sukses: order terbentuk **dan sudah dibayar** dari saldo Wallet — di
/// server langsung berstatus `paid`.
class _PaidView extends StatelessWidget {
  const _PaidView({required this.result, this.meta});

  final CheckoutConfirmResult result;
  final Map<String, dynamic>? meta;

  @override
  Widget build(BuildContext context) {
    final simulated = isMockMeta(meta);
    final single = result.orderIds.length == 1;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: XpColors.successSubtle,
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.check_circle, size: 40, color: XpColors.success),
            ),
            const SizedBox(height: 16),
            SimulatedBadge(meta: meta),
            if (simulated) const SizedBox(height: 8),
            Text('Pembayaran berhasil',
                textAlign: TextAlign.center, style: XpText.headingM(context)),
            const SizedBox(height: 4),
            Text(
              result.isMultiStore
                  ? '${result.orderIds.length} pesanan dibayar dengan Xpedia '
                      'Wallet, satu untuk tiap toko.'
                  : 'Pesananmu dibayar dengan Xpedia Wallet dan diteruskan ke '
                      'penjual.',
              textAlign: TextAlign.center,
              style:
                  XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
            ),
            if (result.balanceAfter != null) ...[
              const SizedBox(height: 16),
              XpCard(
                padding: const EdgeInsets.all(12),
                child: XpKeyValueRow(
                  label: 'Sisa saldo Wallet',
                  value: formatRupiah(result.balanceAfter),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => single
                    ? context.pushReplacement(
                        AppRoutes.orderDetailPath(result.orderIds.first))
                    : context.go(AppRoutes.orders),
                child: Text(single ? 'Lihat Detail Pesanan' : 'Lihat Pesanan'),
              ),
            ),
            const SizedBox(height: 8),
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
