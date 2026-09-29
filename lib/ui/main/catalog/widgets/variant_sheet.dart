import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/ui/main/cart/cubit/cart_cubit.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Tujuan sheet dibuka: dari ikon keranjang atau dari "Beli Sekarang".
///
/// Keduanya **sama-sama memasukkan ke keranjang** — API ini tidak punya
/// endpoint beli-langsung; checkout selalu dibangun dari baris keranjang yang
/// tercentang. Bedanya hanya ke mana user dibawa sesudahnya.
enum VariantSheetIntent { addToCart, buyNow }

/// Hasil sheet: varian terakhir yang dipilih (supaya halaman produk ikut
/// berganti) dan apakah barangnya berhasil masuk keranjang.
typedef VariantSheetResult = ({ProductVariantModel? variant, bool added});

/// Membuka pemilih varian (design_buyer.md §5: pemilih varian **selalu**
/// bottom sheet, tidak pernah chip di halaman).
///
/// Varian yang dipilih tetap dikembalikan walau sheet ditutup tanpa menambah,
/// termasuk saat diusap ke bawah — karena itu dibaca dari [ValueNotifier],
/// bukan dari nilai `pop`, yang `null` pada usapan.
Future<VariantSheetResult> showVariantSheet(
  BuildContext context, {
  required ProductModel product,
  required ProductVariantModel? initialVariant,
  required VariantSheetIntent intent,
}) async {
  final selection = ValueNotifier<ProductVariantModel?>(initialVariant);
  final added = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: XpColors.surface,
    barrierColor: XpColors.signatureBlack.withValues(alpha: 0.55),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(XpRadius.xl)),
    ),
    constraints: const BoxConstraints(maxWidth: 440),
    builder: (_) => BlocProvider(
      // CartCubit lokal: pembatasan kuantitas dan aturan baca-ulang keranjang
      // tetap di satu tempat. Sengaja TANPA `..load()` — lihat [_VariantSheet].
      create: (_) => CartCubit(),
      child: _VariantSheet(product: product, selection: selection, intent: intent),
    ),
  );
  final variant = selection.value;
  selection.dispose();
  return (variant: variant, added: added ?? false);
}

/// Stok varian yang bisa dibeli, `0` kalau habis atau tidak diketahui.
///
/// ⚠️ Berlaku untuk **semua** mode stok, termasuk Pre-Order dan Stok Selalu
/// Ada: `Checkout_model::reserve_stock()` tetap menuntut
/// `quantity_on_hand − quantity_reserved ≥ qty` apa pun `fulfillment_mode`
/// produknya. Menawarkan tombol beli untuk varian berstok nol hanya berujung
/// `STOCK_INSUFFICIENT` di checkout.
int purchasableStockOf(ProductVariantModel variant) {
  if (!variant.isActive) return 0;
  final stock = variant.stock;
  return stock == null || stock < 0 ? 0 : stock;
}

class _VariantSheet extends StatefulWidget {
  const _VariantSheet({
    required this.product,
    required this.selection,
    required this.intent,
  });

  final ProductModel product;
  final ValueNotifier<ProductVariantModel?> selection;
  final VariantSheetIntent intent;

  @override
  State<_VariantSheet> createState() => _VariantSheetState();
}

class _VariantSheetState extends State<_VariantSheet> {
  int _quantity = 1;

  /// 🔴 **Sibuk dilacak di sini, bukan disimpulkan dari `CartLoading`.**
  ///
  /// `CartCubit` lahir dalam keadaan `loading` dan tidak dimuat di sini, jadi
  /// `busy = state is CartLoading` akan mematikan tombolnya selamanya — bug
  /// yang dulu membuat produk tidak bisa dimasukkan keranjang sama sekali
  /// (lihat CLAUDE.md, "Bug pertama yang ditemukan lapisan ini"). Memuat
  /// keranjang (`..load()`) juga menghidupkannya, tapi dengan ongkos satu
  /// `GET /cart` tiap sheet dibuka.
  bool _submitting = false;
  String? _error;

  ProductModel get _product => widget.product;
  ProductVariantModel? get _variant => widget.selection.value;

  List<ProductVariantModel> get _variants =>
      _product.variants.where((v) => v.isActive).toList();

  int get _maxQuantity {
    final variant = _variant;
    if (variant == null) return 0;
    final stock = purchasableStockOf(variant);
    return stock > CartCubit.maxQuantityPerLine ? CartCubit.maxQuantityPerLine : stock;
  }

  bool get _canBuy =>
      _product.stockMode.isPurchasable && _variant != null && _maxQuantity > 0;

  /// Flash sale berlaku di tingkat produk, jadi ia menang atas harga varian —
  /// aturan yang sama dengan `ProductDetailState.displayPrice`.
  double get _unitPrice {
    if (_product.flashSale != null) return _product.effectivePrice;
    return _variant?.price ?? _product.effectivePrice;
  }

  void _select(ProductVariantModel variant) {
    setState(() {
      widget.selection.value = variant;
      _error = null;
      final max = _maxQuantity;
      if (max > 0 && _quantity > max) _quantity = max;
      if (_quantity < 1) _quantity = 1;
    });
  }

  Future<void> _submit() async {
    final variant = _variant;
    if (variant == null || !_canBuy || _submitting) return;
    setState(() {
      _submitting = true;
      _error = null;
    });

    final cubit = context.read<CartCubit>();
    await cubit.addItem(productVariantId: variant.id, quantity: _quantity);
    if (!mounted) return;

    // Keadaan cubit sesudah mutasi: `CartReady` tanpa actionError berarti
    // berhasil. Kegagalan saat cubit masih `loading` (belum pernah dimuat)
    // jatuh ke `CartError`, bukan `CartReady.actionError`.
    final DataError? error = switch (cubit.state) {
      CartReady(:final actionError) => actionError,
      CartError(:final error) => error,
      _ => null,
    };
    if (error != null) {
      setState(() {
        _submitting = false;
        _error = errorMessageFor(context, error);
      });
      cubit.clearActionError();
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: XpColors.borderDefault.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          _Header(
            product: _product,
            variant: _variant,
            unitPrice: _unitPrice,
          ),
          Container(height: 6, color: XpColors.sunken),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Options(
                    variants: _variants,
                    selected: _variant,
                    onSelect: _select,
                  ),
                  _QuantityRow(
                    quantity: _quantity,
                    max: _maxQuantity,
                    enabled: _canBuy && !_submitting,
                    onChanged: (value) => setState(() => _quantity = value),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!,
                        style: XpText.bodyS(context).copyWith(color: XpColors.danger)),
                  ],
                ],
              ),
            ),
          ),
          _SheetBar(
            intent: widget.intent,
            enabled: _canBuy,
            submitting: _submitting,
            total: _unitPrice * _quantity,
            unavailableLabel: !_product.stockMode.isPurchasable
                ? _product.stockMode.label
                : 'Stok Habis',
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.product, required this.variant, required this.unitPrice});

  final ProductModel product;
  final ProductVariantModel? variant;
  final double unitPrice;

  @override
  Widget build(BuildContext context) {
    final strike = product.strikethroughPrice;
    final image = (variant?.imageUrl ?? '').trim().isNotEmpty
        ? variant!.imageUrl
        : product.primaryImageUrl;
    final stock = variant == null ? null : purchasableStockOf(variant!);
    final label = variant?.optionLabel ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XpProductImage(url: image, size: 80, radius: XpRadius.l),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formatRupiah(unitPrice),
                    style: XpText.priceL(context).copyWith(color: XpColors.primary)),
                if (strike != null && strike > unitPrice)
                  Text(
                    formatRupiah(strike),
                    style: XpText.bodyS(context).copyWith(
                      color: XpColors.textTertiary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(height: 6),
                if (stock != null)
                  XpPill(
                    label: stock > 0 ? 'Sisa Stok: ${formatNumber(stock)} buah' : 'Stok Habis',
                    tone: stock > 0 ? XpStockTones.ready : XpStockTones.unavailable,
                  ),
                if (label.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                      children: [
                        const TextSpan(text: 'Varian: '),
                        TextSpan(
                          text: label,
                          style: XpText.labelM(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: 'Tutup',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => Navigator.of(context).pop(false),
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: XpColors.sunken, shape: BoxShape.circle),
              child: Icon(Icons.close, size: 20, color: XpColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Grup opsi varian, diturunkan dari `variant_options` tiap varian.
///
/// Server tidak mengirim daftar "grup opsi" tersendiri — hanya varian dengan
/// peta opsinya (`{"warna":"Hitam","ukuran":"L"}`). Grupnya karena itu
/// dirakit di sini dari gabungan kunci seluruh varian aktif. Varian tanpa
/// opsi sama sekali (produk tanpa pilihan) tidak menggambar grup apa pun.
class _Options extends StatelessWidget {
  const _Options({required this.variants, required this.selected, required this.onSelect});

  final List<ProductVariantModel> variants;
  final ProductVariantModel? selected;
  final ValueChanged<ProductVariantModel> onSelect;

  @override
  Widget build(BuildContext context) {
    final keys = <String>[];
    for (final v in variants) {
      for (final key in (v.variantOptions ?? const <String, dynamic>{}).keys) {
        if (!keys.contains(key)) keys.add(key);
      }
    }

    if (keys.isEmpty) {
      // Beberapa varian tanpa peta opsi: tampilkan satu grup datar menurut
      // SKU supaya tetap bisa dipilih.
      if (variants.length <= 1) return const SizedBox.shrink();
      return _Group(
        title: 'Pilih Varian',
        count: variants.length,
        chips: [
          for (final v in variants)
            _OptionChip(
              label: v.optionLabel.isNotEmpty ? v.optionLabel : (v.sku ?? 'Varian ${v.id}'),
              selected: v.id == selected?.id,
              soldOut: purchasableStockOf(v) <= 0,
              onTap: () => onSelect(v),
            ),
        ],
      );
    }

    final current = _optionsOf(selected);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final key in keys) _groupFor(key, current),
      ],
    );
  }

  Widget _groupFor(String key, Map<String, String> current) {
    final values = <String>[];
    for (final v in variants) {
      final value = _optionsOf(v)[key];
      if (value != null && value.isNotEmpty && !values.contains(value)) values.add(value);
    }
    return _Group(
      title: 'Pilih ${_titleCase(key)}',
      count: values.length,
      chips: [
        for (final value in values)
          _chipFor(key, value, current),
      ],
    );
  }

  Widget _chipFor(String key, String value, Map<String, String> current) {
    final target = _resolve(key, value, current);
    // "Habis" hanya kalau tidak ada varian berstok sama sekali untuk nilai
    // ini — memilihnya tetap mungkin kalau opsi lain ikut berganti ke
    // kombinasi yang masih ada.
    final soldOut = target == null || purchasableStockOf(target) <= 0;
    return _OptionChip(
      label: value,
      selected: current[key] == value,
      soldOut: soldOut,
      onTap: target == null ? null : () => onSelect(target),
    );
  }

  /// Varian yang dipilih saat nilai [value] untuk [key] diketuk: kombinasi
  /// persisnya kalau masih berstok, kalau tidak varian berstok mana pun yang
  /// punya nilai itu — supaya satu ketukan tidak berujung pilihan buntu.
  ProductVariantModel? _resolve(String key, String value, Map<String, String> current) {
    final exact = _exact({...current, key: value});
    if (exact != null && purchasableStockOf(exact) > 0) return exact;
    final withValue = variants.where((v) => _optionsOf(v)[key] == value).toList();
    for (final v in withValue) {
      if (purchasableStockOf(v) > 0) return v;
    }
    return exact ?? (withValue.isEmpty ? null : withValue.first);
  }

  ProductVariantModel? _exact(Map<String, String> wanted) {
    for (final v in variants) {
      final options = _optionsOf(v);
      if (wanted.entries.every((e) => options[e.key] == e.value)) return v;
    }
    return null;
  }

  static Map<String, String> _optionsOf(ProductVariantModel? variant) => {
        for (final entry in (variant?.variantOptions ?? const <String, dynamic>{}).entries)
          if (entry.value != null) entry.key: entry.value.toString(),
      };

  static String _titleCase(String key) {
    final words = key.replaceAll('_', ' ').trim().split(RegExp(r'\s+'));
    return words
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.count, required this.chips});

  final String title;
  final int count;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: XpText.titleM(context))),
              Text('$count Pilihan',
                  style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: chips),
        ],
      ),
    );
  }
}

/// Chip opsi varian: terpilih (#EBF2FF + centang), belum terpilih (sunken),
/// habis ("(Habis)", redup, tidak bisa diketuk).
class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.soldOut,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool soldOut;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected
        ? XpColors.primary
        : (soldOut ? XpColors.textPlaceholder : XpColors.textSecondary);
    final chip = Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? XpColors.primarySubtle : XpColors.sunken,
        borderRadius: BorderRadius.circular(XpRadius.m),
        border: Border.all(color: selected ? XpColors.primary : Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(soldOut ? '$label (Habis)' : label,
              style: XpText.labelL(context).copyWith(color: fg)),
          if (selected) ...[
            const SizedBox(width: 6),
            Icon(Icons.check, size: 16, color: XpColors.primary),
          ],
        ],
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      enabled: !soldOut,
      child: Opacity(
        opacity: soldOut && !selected ? 0.6 : 1,
        child: InkWell(
          // Varian habis tetap ditampilkan tapi tidak bisa dipilih —
          // menyembunyikannya membuat user mengira pilihan itu tidak pernah ada.
          onTap: soldOut ? null : onTap,
          borderRadius: BorderRadius.circular(XpRadius.m),
          child: chip,
        ),
      ),
    );
  }
}

class _QuantityRow extends StatelessWidget {
  const _QuantityRow({
    required this.quantity,
    required this.max,
    required this.enabled,
    required this.onChanged,
  });

  final int quantity;
  final int max;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jumlah Pembelian', style: XpText.titleM(context)),
              if (max > 0)
                Text(
                  // Batasnya stok varian (server tidak memvalidasi kuantitas
                  // sama sekali), dipotong ke batas kewarasan keranjang.
                  'Maksimal beli ${formatNumber(max)} unit',
                  style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                ),
            ],
          ),
        ),
        XpQuantityStepper(
          value: quantity,
          min: 1,
          max: max < 1 ? 1 : max,
          enabled: enabled,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SheetBar extends StatelessWidget {
  const _SheetBar({
    required this.intent,
    required this.enabled,
    required this.submitting,
    required this.total,
    required this.unavailableLabel,
    required this.onSubmit,
  });

  final VariantSheetIntent intent;
  final bool enabled;
  final bool submitting;
  final double total;
  final String unavailableLabel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final label = !enabled
        ? unavailableLabel
        : switch (intent) {
            VariantSheetIntent.addToCart => 'Tambah ke Keranjang',
            VariantSheetIntent.buyNow => 'Beli Sekarang • ${formatRupiah(total)}',
          };
    return XpBottomBar(
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: FilledButton(
          onPressed: enabled && !submitting ? onSubmit : null,
          child: submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
