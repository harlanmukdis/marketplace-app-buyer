# DESIGN.md — Xpedia (Buyer Mobile)

Design system rules for this project. Follow these exactly. Do not invent colors,
type sizes, spacing values, or component shapes that are not listed here.

Product: Xpedia — the buyer-facing marketplace app for Indonesia.
Platform: Mobile first, 390 × 844 dp. Target implementation is Flutter.
UI language: **Bahasa Indonesia**.
Tone: familiar, fast, trustworthy. A buyer used to Indonesian marketplaces must
understand it instantly. Differentiation comes from trust and transparency,
never from an unfamiliar checkout.

---

## 1. Color

### Brand
| Token | Hex | Use |
|---|---|---|
| brand-navy | #0F286C | Wallet balance card, dark headers |
| brand-primary | #0056FE | Primary buttons, links, active tab, selected state |
| brand-primary-pressed | #0047D1 | Pressed state |
| brand-subtle | #EBF2FF | Selected chip, info banner, promo background |

### Surface & text
bg-canvas #F7F8FA · bg-surface #FFFFFF · bg-sunken #EFF1F4 ·
text-primary #111827 · text-secondary #4B5563 · text-tertiary #6B7280 ·
text-placeholder #9CA3AF · text-on-brand #FFFFFF ·
border-subtle #E5E7EB · border-default #D1D5DB · border-strong #9CA3AF

### Feedback
danger #FB132D / subtle #FFECEE · success #109553 / subtle #E8F8EF ·
warning #F59E0B / subtle #FFF6E5

### Order status (background / foreground)
Pembayaran Berhasil #E8F8EF / #0C7A44 · Diproses #FFF6E5 / #8C5002 ·
Menunggu Konfirmasi #E0D9FD / #4E34AB · Dalam Pengiriman #EBF2FF / #0047D1 ·
Diterima #E6F7FA / #08677B · Selesai #E8F8EF / #0C7A44 ·
Dibatalkan #EFF1F4 / #4B5563

### Stock mode chips
Ready Stock and Stok Selalu Ada #E8F8EF / #0C7A44 · Stok Menipis #FFF6E5 / #8C5002 ·
Pre-Order #F1EEFE / #6344D6 · Custom Order #E0D9FD / #4E34AB ·
Stok Habis and Tidak Dijual Lagi #EFF1F4 / #4B5563

### Xpedia Signature
Black #101014 with gold #C9A227. An awarded badge, never purchasable, never loud.

### Dark theme
canvas #0B1220 · surface #111827 · text-primary #F7F8FA · text-secondary #9CA3AF ·
border-subtle #1F2937 · primary #4682FF · danger #FD4258 · success #22B268 ·
warning stays #F59E0B.

---

## 2. Typography

Inter only.

Heading/XL 24/32 w700 · Heading/L 20/28 w600 · Heading/M 18/26 w600 ·
Title/L 16/24 w600 · Title/M 14/20 w600 · Body/L 16/24 w400 · Body/M 14/20 w400 ·
Body/S 12/18 w400 · Label/L 14/20 w500 · Label/M 12/16 w500 · Label/S 11/14 w500 ·
Caption 11/14 w400 · Overline 10/14 w600 +0.6 tracking ·
Price/L 18/24 w700 · Price/M 16/22 w700 · Price/S 14/20 w600 · Numeric/Stat 22/28 w700

Never below 11 px. Product names wrap to a maximum of 2 lines.

---

## 3. Spacing, radius, size

Spacing scale: 0 2 4 6 8 12 16 20 24 32 40 48 64. Nothing else.
Screen padding 16 · card padding 12 for product cards, 16 for content cards ·
gap between cards 12 · gap between sections 24.
Radius 4 / 6 / **8 default** / 12 / 16 / 24 / full.
Icon 16 20 24 · avatar 32 40 56 · store logo 44 · control height 36 44 52 ·
app bar 56 · bottom nav 64 · **minimum touch target 48**.
Borders 1 dp. Focus 2 dp. Cards use a border, not a heavy shadow.

---

## 4. Buyer component rules

**Product card (grid, 2 columns).** Square image on top, then in order: product name
(Title/M, max 2 lines), price (Price/M), a rating line showing stars, value and sold
count (Caption), the stock-mode chip, store name with its Primary Seller Status, and a
wishlist heart in the image's top-right corner. **If the product has no reviews, omit
the rating line entirely — never render 0,0 or empty stars.**

**Product card (list, used in search results).** Thumbnail on the left at 104 dp square,
the same information stacked on the right.

**Price.** Always `Rp 2.888.100`. A struck-through original price sits above or before
the current price in Body/S with text-tertiary. No currency symbols other than Rp.

**Rating.** One filled star icon plus the numeric value plus the sold count.
Never a five-star row in a card. Full distribution bars only on review pages.

**Stock mode chip.** Pill, height 22, Label/S, colors from section 1. Always visible on
product cards and in cart rows.

**Quantity stepper.** Minus, value, plus. Height 36. Disabled minus at minimum order.

**Variant selector.** Opens as a bottom sheet, never a new screen. Shows the product
image, price, stock, variant option rows, a quantity stepper, and a sticky primary action.

**Cart row.** Checkbox, thumbnail, name, variant, stock-mode chip, price, quantity
stepper, delete. Rows are grouped under a store header with its own checkbox.

**Wallet summary at checkout.** The Wallet balance and the invoice total must appear in
the **same summary block**, so the buyer sees both numbers together without scrolling.

**Order status chip.** Pill, height 24, Label/M, colors from section 1.

**Order timeline.** Horizontal, 5 stages, completed in success, current in brand-primary,
upcoming in text-tertiary. Custom orders have 6 stages including Menunggu Konfirmasi.

**Empty state.** Icon, one Title/M line, one Body/S line, one primary action.
No large illustration.

**Bottom navigation.** Exactly 5: Beranda, Wishlist, Pesanan Saya, Chat, My Xpedia.
The cart is an app bar icon with a badge, not a nav item.

---

## 5. Non-negotiable product rules

These come from the approved buyer blueprint. Breaking them makes a screen wrong
regardless of how good it looks.

1. **Search has no Filter button, no Sort control, and no recommendation selector.**
   Relevance and shipping eligibility are applied by the backend before ranking.
   Do not add them back "because marketplaces normally have them".
2. **One search bar** handles products, brands and store names. Results are
   product-first. Never split into Products and Stores tabs.
3. **The Xpedia logo is the Home control.** Do not add a separate Home button anywhere.
4. **All payment goes through the Xpedia Wallet.** There is no card, VA, QRIS or
   e-wallet selection at checkout. If the balance is short, disable "Bayar Sekarang",
   show the shortfall, and offer Top Up. Minimum top up Rp 10.000.
5. **Every payment requires authentication** — a 6-digit Wallet PIN or device biometrics.
   There is no one-tap payment at any amount.
6. **Product Detail is seller-specific.** Never show a list comparing other sellers of
   the same product.
7. **Cancellation has three stages, divided by the waybill.** Before the seller prints
   it: "Batalkan Pesanan", instant, no evidence, full refund to Wallet. After it:
   "Ajukan Pembatalan", reason required, seller may refuse, still no evidence upload.
   After the order is Diterima: complaint and refund, photo or video evidence allowed.
8. **Final Invoice exists only after an order is Selesai.** Cancelled and fully refunded
   orders produce no invoice. Before that, only the order detail and summary exist.
9. **Reviews are for products only.** No separate store rating form. All review content
   is editable for 30 days, then locked. A store with no reviews shows no stars at all.
10. **Chat** allows text, photo, product card, order reference, return/refund shortcut
    and system vouchers. No documents, video or audio. Sent messages cannot be edited or
    deleted. Show 4 message states: pending, 1 grey tick, 2 grey ticks, 2 blue ticks.
11. **No separate Secure+ hub and no separate Help Center.** Secure+ status attaches to
    the order it belongs to. The only support brand is **Xpedia 911**.
12. Buyers may save a **maximum of 3 shipping addresses**, one marked as primary.

---

## 6. Copy style

Bahasa Indonesia, plain and familiar. Use Pesanan Saya, Keranjang, Bayar Sekarang,
Top Up, Lacak Paket, Ajukan Pembatalan, Ikuti Toko, Xpedia 911.
Never use: iklan, ads, budget, sponsor, asuransi, Help Center, Pusat Bantuan.
Money `Rp 2.888.100` · percentage `98,7%` · datetime `18 Jan 2025, 14:32 WIB`.
Masked name `D******` · masked phone `0812****456`.
