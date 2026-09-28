# Product Requirement Document (PRD)
## Xpedia — Buyer Mobile Marketplace

---

### 1. Project Overview & Executive Summary

* **Product Name:** Xpedia (Buyer Mobile)
* **Target Platform:** Mobile First (Viewport: 390 × 844 dp, responsive)
* **Core Technology Target:** Flutter / Hybrid Mobile Framework
* **Primary Language:** Bahasa Indonesia (formal, familiar, and transparent)
* **Design Philosophy:** Familiar, fast, trustworthy. A regular Indonesian e-commerce user can operate the app intuitively without cognitive friction. Differentiation is rooted in absolute transparency, deterministic logistics, and uncompromising payment trust.

---

### 2. Strategic Objectives & Core Value Proposition

1. **Deterministic Commerce Experience:** Eliminating confusion by enforcing clarity at every checkout, return, and payment stage.
2. **Frictionless On-Demand Delivery & Tracking:** Seamless end-to-end tracking featuring real-time map visualization and transparent milestone checkpoints.
3. **Ironclad Financial Integrity:** Closed-loop, secure payment architecture powered exclusively by **Xpedia Wallet** with strict multi-factor PIN/Biometric authentication on every single transaction.
4. **Transparent Conflict & Cancellation Management:** Strict tripartite cancellation/complaint rules dividing rights by the exact stage of the shipment waybill.

---

### 3. Non-Negotiable Product Rules (System Invariants)

These constraints are core to Xpedia's system architecture and must not be altered:

1. **Universal No-Filter Search:**
   - Search results contain **no manual Filter button**, **no Sort recommendation dropdown**, and no arbitrary algorithm boosters.
   - Relevance, geographic proximity, and instant shipping eligibility are determined server-side before rendering.
2. **Single Search Bar:**
   - One search input simultaneously parses product queries, official brand names, and store entities. Results are strictly **product-first** without tab fragmentation.
3. **Home Iconography:**
   - The Xpedia brand logo acts as the primary Home reset control. No secondary Home buttons are allowed.
4. **Exclusive Payment Method (Xpedia Wallet):**
   - All transactions are routed exclusively through **Xpedia Wallet**.
   - No external Virtual Accounts, Credit Cards, or standalone QRIS are exposed during checkout.
   - If balance is insufficient, "Bayar Sekarang" is disabled, displaying the exact deficit and an immediate Top-Up trigger (minimum Rp 10.000).
   - The Wallet balance and invoice total **must always reside within the same viewport summary card** without requiring scrolling.
5. **Mandatory Explicit Authentication:**
   - Every transaction requires user verification via a 6-digit PIN or biometrics (Fingerprint / Face ID). Zero-tap or single-click instant payments are forbidden.
6. **Seller-Specific Product Detail Page:**
   - Product detail views are bound strictly to the visited seller. Comparison widgets of alternative sellers for the exact same item are intentionally prohibited.
7. **Tripartite Cancellation & Dispute Lifecycle:**
   - **Stage 1 (Before Waybill/Resi is Printed):** Instant cancellation by buyer, immediate full refund to Xpedia Wallet, zero seller approval needed, zero proof required.
   - **Stage 2 (Processing / Resi Printed):** Cancellation converted to a formal request requiring seller review/approval. Reason selection required, no evidence upload.
   - **Stage 3 (Order Status "Diterima"):** Formal complaint and refund flow unlocked. Compulsory photographic or video unboxing evidence (max 10MB).
8. **Final Invoice Availability:**
   - Official tax invoices (`.PDF`) are issued **only after** an order reaches the **Selesai** status. Cancelled, refunded, or ongoing orders do not produce invoices.
9. **Single-Target Product Reviews:**
   - Rating and review forms exclusively evaluate the product item. Store reviews do not exist. Ratings can be updated by the buyer within a 30-day window. Unreviewed items display no star badges (never 0.0).
10. **Structured Chat Policy:**
    - Real-time chat supports plain text, photographs, product contextual cards, order references, return/refund shortcuts, and verified system vouchers.
    - Documents, voice notes, and videos are prohibited in buyer-seller chats.
    - Messages cannot be edited or unsent. Displays 4 discrete delivery ticks: *Pending, 1 Grey Tick, 2 Grey Ticks, 2 Blue Ticks*.
11. **Unified Customer Care Branding:**
    - No separate "Help Center" or fragmented insurance hubs. The unified emergency and escalation helpline is branded strictly as **Xpedia 911**.
12. **Shipping Address Quota:**
    - Buyers may register a maximum of **3 shipping addresses** (1 Primary default, 2 secondary).

---

### 4. User Journeys & Screen Specifications

#### 4.1 Discovery & Storefront
* **Beranda Buyer (Home Screen):**
  - Interactive promotional hero carousel showcasing seasonal campaigns.
  - Quick action category grid (*Elektronik, Fashion, Groceries, Otomotif, dll.*).
  - Live shopping channel ribbons with viewer count and live checkout indicators.
  - Persistent 5-tab Bottom Navigation: *Beranda, Wishlist, Pesanan Saya, Chat, My Xpedia*.
* **Hasil Pencarian (Search Results):**
  - Universal top search bar with voice search shortcut.
  - 2-column product card grid displaying: square product image, title (max 2 lines), price, single-star rating (`★ 4.9 (1.2k) · 12.3k terjual`), stock chip (*Ready Stok, Pre-Order, Custom Order*), official store badge, and wishlist toggle.
* **Detail Produk & Varian Selector:**
  - Full-width product media carousel with zoom preview.
  - Seller trust badges (Official Store / Xpedia Signature).
  - Bottom sheet variant selector: dynamic price, thumbnail switch, color/package chip selection, and 36dp height quantity stepper.
* **Profil & Etalase Toko (Storefront):**
  - Header banner with prestigious **Xpedia Signature** badge (Black `#101014` & Gold `#C9A227`).
  - 4 transparency metrics: Store Rating, Success Rate (`98.7%`), Response Time (`≤ 4 mnt`), and Live Online status.
  - Tab views: *Beranda Toko, Produk, Live, Ulasan*.

#### 4.2 Purchase & Payment Flow
* **Keranjang Belanja (Cart):**
  - Multi-store grouping with distinct store headers and batch selection checkboxes.
  - Item rows featuring 36dp steppers, stock status pills, and Xpedia Secure+ add-on toggle.
  - Sticky bottom summary bar with collective item count and total price.
* **Checkout (Sufficient vs Insufficient Wallet States):**
  - Primary shipping address preview with express pinpoint verification.
  - Item overview with logistics partner selector (JNE, SiCepat).
  - **Payment Block:** Dual display of available Wallet Balance and Total Invoice. If balance is deficient, disables checkout and presents instant "+ Top Up Saldo" CTA.
* **Autentikasi Keamanan PIN 6-Digit:**
  - Secure full-height overlay with 6-dot indicator.
  - Taktil 3×4 numerical pad with Biometric shortcut (Face ID / Fingerprint) and PIN recovery link.

#### 4.3 Post-Purchase, Tracking & Support
* **Pesanan Saya (Order Management Hub):**
  - Tab navigation: *Semua, Diproses, Dikirim, Diterima, Selesai, Dibatalkan*.
  - Order cards with status pills (*Diproses* amber, *Dalam Pengiriman* blue, *Selesai* green).
  - Quick action buttons: *Lacak Paket, Hubungi Penjual, Batalkan Pesanan, Ajukan Komplain, Beli Lagi*.
* **Lacak Paket Real-Time:**
  - Dynamic vector map showing delivery courier origin, destination pinpoint, and live transit path.
  - One-tap tracking number clipboard copier.
  - Detailed chronological milestone timeline with timestamps.
* **Detail Pesanan Selesai & Faktur Pajak:**
  - 5-stage completed step indicator.
  - Official Invoice Card with one-click **Download Invoice Resmi (.PDF)** CTA.
  - Order breakdown including subtotal, logistics fee, promo deductions, and zero-fee service assurance.
* **Beri Ulasan Produk:**
  - 5-star rating selector with sentiment labels.
  - Product aspect chips (*Bahan Nyaman, Ukuran Pas, Jahitan Rapi*).
  - Photo/Video unboxing upload zone (+500 Koin incentive).
  - Privacy toggle: *"Ulas Secara Anonim"* masking buyer username.
* **3-Stage Order Cancellation & Complaint Screens:**
  - *Direct Cancellation (Pre-Resi):* Instant execution with guarantee banner of 100% refund into Xpedia Wallet.
  - *Cancellation Request (Post-Resi):* Reason picker, conditional seller review warning banner.
  - *Complaint & Refund (Post-Delivery):* Compulsory media file uploader, issue classifier, independent review commitment by Xpedia team.

#### 4.4 Communication & Account Hub
* **Chat Toko (Messaging):**
  - Pinned context card of the actively discussed product or order.
  - Real-time status indicators (1 grey, 2 grey, 2 blue checkmarks).
  - Direct shortcut to Xpedia 911 arbitration.
* **My Xpedia Hub:**
  - User identity badge (*Verified Buyer*).
  - Deep Navy (`#0F286C`) Xpedia Wallet balance widget with quick Top-Up.
  - Grid menu for Saved Addresses, Following Stores, Account Security, and direct 24/7 hotline to **Xpedia 911**.
* **Kelola Alamat Pengiriman:**
  - Capacity counter: *"2 / 3 Alamat Terpakai — Sisa 1 slot alamat"*.
  - Address cards with Primary badge, logistics pinpoint, and quick edit/reassign controls.

---

### 5. Design System & Token Specifications

| Category | Token / Value | Application |
|---|---|---|
| **Primary Color** | `#0056FE` | Primary CTA, active navigation, links, checkboxes |
| **Navy Accent** | `#0F286C` | Xpedia Wallet card, header emphasis |
| **Background Canvas** | `#F7F8FA` | Global background behind cards |
| **Surface** | `#FFFFFF` | Content cards, bottom sheets, navigation bars |
| **Danger / Accent Red** | `#FB132D` / Sub: `#FFECEE` | Cancellation buttons, error banners, price highlights |
| **Success / Green** | `#109553` / Sub: `#E8F8EF` | Ready stock pills, completed order states, invoice badges |
| **Warning / Amber** | `#F59E0B` / Sub: `#FFF6E5` | Low stock pills, processing order status, review alerts |
| **Typography** | Inter (11px to 24px) | Strict scale; zero font size under 11px |
| **Corner Radius** | 8px (default), 12px/16px (cards/sheets) | Rounded containers, pill tags |
| **Touch Targets** | Min. 48 × 48 dp | All buttons, steppers, icons, and interactive elements |

---

### 6. Technical & Non-Functional Requirements

1. **Performance & Responsiveness:**
   - First Contentful Paint (FCP) under 1.2s on standard 4G mobile networks.
   - Smooth 60fps scrolling performance on complex list views.
2. **Security & Data Privacy:**
   - 256-bit SSL/TLS encryption for all checkout and chat payloads.
   - Masked buyer phone numbers (`0812****456`) and names (`S*******o`) when sharing data with 3rd-party logistics and public reviews.
3. **Offline Resilience:**
   - Local caching of active shipping tracking data and completed invoice PDF previews.
