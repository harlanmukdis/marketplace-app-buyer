# Peta fitur & panduan melanjutkan — Xpedia Buyer

> Dokumen serah-terima untuk developer **dan AI asisten** (Claude Code, Cursor, dll.) yang
> melanjutkan pekerjaan di mesin lain. Dibaca **bersama** `CLAUDE.md`:
>
> - `CLAUDE.md` = aturan, konvensi, dan seluruh keanehan backend yang sudah diuji ke server.
> - Dokumen ini = **apa saja yang sudah ada**, di mana letaknya, sumber datanya (API sungguhan / mock), dan apa yang belum.
>
> Terakhir diperbarui: 29 September 2026 malam (sinkron backend `45568d9` — **sebagian**, sisanya di §7; desain Stitch Xpedia, mock API putaran 2).

---

## 0. WAJIB setiap mulai bekerja: cek update API dulu

Backend (`marketplace-api`, `https://github.com/albertnagawan14/marketplace-api`) bergerak lebih cepat dari app ini. Sudah **tiga kali** perubahan backend diam-diam membatalkan akalan yang tertanam di kode. Jadi **sebelum mengerjakan apa pun**, AI atau developer wajib menjalankan langkah ini.

**Commit backend terakhir yang sudah disinkronkan: `45568d9`** (`origin/main`, 29 September 2026) — sebagian; item yang belum dikerjakan ada di §7.

⚠️ **Repo API lokal ada di branch `main-harlan`, bukan `main`.** Branch itu punya commit sendiri (dokumen v2, perbaikan CORS di `index.php`) yang tidak ada di `origin/main`, jadi `git pull --ff-only` tidak jalan dan `git diff <acuan>..origin/main` menyesatkan (CORS terlihat "dihapus"). Bandingkan dari merge-base (tiga titik), lalu **merge** `origin/main` ke `main-harlan`:

```bash
cd <marketplace-api>
git fetch origin
git log --oneline 45568d9..origin/main                        # ada commit baru?
git diff 45568d9...origin/main --stat                         # TIGA titik
git diff 45568d9...origin/main -- application/config/routes.php
git diff 45568d9...origin/main -- database/                   # skema berubah → jalankan file schema barunya saja
git diff 45568d9...origin/main -- CHANGELOG.md docs/
git merge --no-edit origin/main                               # sesudah dilaporkan ke user
```

Kalau **tidak ada commit baru**, lanjutkan pekerjaan. Kalau **ada**, sinkronkan dulu sebelum mengerjakan fitur:

1. **Endpoint baru di `routes.php` yang saat ini di-mock** (lihat §6 dan `assets/mock/pending_api/README.md`):
   - hapus rute mock-nya di `lib/config/network/mock/routes/*`;
   - tembak endpoint sungguhan dengan `curl`;
   - sesuaikan model hanya bila bentuk respons berbeda dari fixture;
   - ubah kolom "Sumber" di §5 dari MOCK menjadi API.
2. **Endpoint atau field yang berubah atau dihapus:** cari pemakainya di `lib/core/data/datasources/`, lalu perbarui service, model, dan test.
3. **Kode error baru:** tambahkan ke `ApiErrorCode` (`lib/core/data_state.dart`) dan `errorMessageFor` (`lib/util/error_message.dart`).
4. **Skema DB berubah:** jalankan file `database/schema/NN_*.sql` yang baru saja, bukan seluruh folder (supaya seed tidak ganda). Tanda skema tertinggal: endpoint mendadak `500`. Pakai klien **XAMPP** (`/Applications/XAMPP/xamppfiles/bin/mysql`): `mysql` Homebrew v9 tidak bisa login ke MariaDB 10.4 XAMPP (ERROR 2059).
5. **Jalankan detektor.** `flutter test test/integration --concurrency=1` memaku perilaku server, termasuk bug-bugnya. Test merah biasanya berarti backend berubah, bukan app yang rusak. Baca perubahannya, lalu perbarui app dan test-nya.
6. **Verifikasi ke server, jangan percaya dokumen.** Urutan otoritas: `routes.php` > kode controller/model > `docs/23` > Postman > docs lain.
7. **Catat hasilnya:**
   - perbarui commit acuan di atas (`45568d9` → hash baru) dan tanggal "Terakhir diperbarui";
   - tambahkan temuan ke CLAUDE.md (bagian "Backend v…");
   - perbarui tabel §5 dan checklist §7 di dokumen ini;
   - commit perubahan app bersama dokumennya.

> Untuk AI: laporkan hasil pengecekan ini ke user (jumlah commit baru, dampaknya ke app) **sebelum** mulai mengerjakan permintaan. Kalau repo backend tidak ada di mesin, minta user meng-clone-nya. Jangan melewati langkah ini diam-diam.

## 1. Setup di mesin baru (urut)

```bash
git clone git@github.com:harlanmukdis/marketplace-app-buyer.git
cd marketplace-app-buyer
cp .env.example .env                 # pilih API_BASE_URL sesuai target (lihat komentar di file)
flutter pub get
dart run build_runner build          # WAJIB: env.g.dart + seluruh *.freezed.dart / *.g.dart
flutter analyze && flutter test test/util test/data test/ui   # harus hijau tanpa backend
```

Backend (`marketplace-api`, repo terpisah) — detail lengkap di CLAUDE.md "Menyalakan backend dev":

```bash
# MySQL harus hidup (XAMPP / MySQL lain), schema + seed dari database/schema & database/seeds
cd <marketplace-api> && php -d mysqli.default_socket=<socket-mysql> -S 127.0.0.1:8000 -t . router.php
curl -s http://localhost:8000/api/v1/health
```

- Akun seed: `budi.santoso@kedaikopi.id` / `RahasiaAman123` (dan 8 lainnya — lihat panduan backend docs/23 §3).
- Login dibatasi **5×/email & 20×/IP per 15 menit, login BERHASIL ikut dihitung**. Kalau kena `429`: `DELETE FROM auth_rate_limits;` di DB `marketplace` (klien XAMPP, lihat §0 langkah 4).
- Checkout **wallet-only**: test integrasi menyuntik PIN `123456` + saldo lewat SQL (`test/integration/support/dev_db.dart`), jadi MySQL XAMPP wajib bisa dijangkau dari `flutter test`.
- Test integrasi: `flutter test test/integration --concurrency=1` (wajib serial, maks 2 putaran per 15 menit).
- E2E app sungguhan: `flutter test integration_test/member_journey_test.dart -d macos`.

## 2. Aturan kerja untuk AI (ringkas — detail di CLAUDE.md)

1. **Layar baru di `lib/ui/main/<domain>/{cubit,screens,widgets}`**, bukan `lib/features/`.
2. **Warna & teks hanya dari `XpColors.*` / `XpText.*`** (`lib/core/design/`). Jangan `Theme.of(context)`, jangan `TextStyle(fontSize: …)` mentah, jangan warna hex baru di widget.
3. **Repository tidak pernah throw** — selalu `DataState<T>` lewat `RepositoryGuard`.
4. **Jangan tampilkan `error.message` server** ke user — petakan `error.code` di `lib/util/error_message.dart`. Satu-satunya pengecualian: `ClientErrorCode.localValidation`.
5. **Semua field angka/boolean model pakai converter** `lib/util/json_converters.dart` (server kirim `"1"`, `"150000.00"`, kadang angka asli).
6. Sesudah mengubah model freezed / `.env`: `dart run build_runner build` (tanpa `--delete-conflicting-outputs`, flag itu sudah dihapus).
7. **Otoritas endpoint = `application/config/routes.php` di repo API**, bukan docs/Postman.
8. Endpoint admin/seller **tidak boleh** dibuatkan method di app ini.
9. Jangan retry otomatis `checkout/confirm`, `wallet/topup`, `wallet/withdraw` (tidak ada idempotency).
10. **Sebelum mulai: jalankan §0 (cek update API).** Backend sering berubah dan bisa membatalkan akalan yang ada di sini.

## 3. Desain (Stitch Xpedia)

- Sumber: `assets/stitch_xpedia_buyer_project/` (di-commit, **tidak** dibundel ke app).
  - **`design_buyer.md` = aturan desain** (token, skala tipe Inter, aturan non-negotiable §5, gaya copy §6).
  - Folder berisi `code.html` + `screen.png` = layar mobile 390dp. `bXX_*.png` = mockup desktop (kecuali b16 toko diikuti, b32 lacak paket).
- Implementasi:
  - Token: `lib/core/design/xp_colors.dart`, `xp_text.dart` (+`XpRadius`), `xp_widgets.dart` (`XpCard`, `XpPill`, `XpEmptyState`, `XpBanner`, `XpBottomBar`, `XpQuantityStepper`, `XpKeyValueRow`, …).
  - App bar: `lib/ui/main/shell/xp_app_bars.dart` — `XpHomeAppBar` (beranda), `XpTabAppBar` (root tab lain), `XpStackAppBar` (layar tumpuk, tombol kembali bertooltip **"Kembali"** — dipakai e2e test).
  - Widget dagang: `lib/ui/main/shell/xp_commerce.dart` — `StockChip`, `SellerStatusBadge`, `SignatureBadge`, `RatingLine` (tidak tampil tanpa ulasan, **tak pernah "0,0"**), `PriceBlock`, `StoreLine`, `OrderStatusPill`, `XpProductImage`.
  - Kartu produk: `lib/ui/main/catalog/widgets/product_card.dart` + `productGridDelegate(width)` — tinggi sel dihitung; **menambah baris di kartu = hitung ulang `textBlock`** atau overflow.
  - `SimulatedBadge` (`shell/simulated_badge.dart`) = label "Simulasi" untuk data dari mock.
- Font Inter di `assets/fonts/inter/`. Tema gelap: `XpColors` otomatis via `isAppDarkMode()` (belum dicek visual menyeluruh).

## 4. Navigasi

- Cangkang: `lib/features/shared/views/home_layout.dart` — **tepat 5 tab**: Beranda · Wishlist · Pesanan Saya · Chat · My Xpedia (dibangun malas di `IndexedStack`). Keranjang **bukan tab** → ikon berlencana di app bar.
- `AppScope` (`lib/ui/main/shell/app_scope.dart`, dipasang di `MaterialApp.builder`): `StoreDirectoryCubit` (nama toko per id), `CartBadgeCubit`, `WishlistCubit` app-wide.
- Semua rute di `lib/core/utils/app_routes.dart` (argumen lewat `state.extra`).

## 5. Peta fitur

Legenda sumber data: **API** = endpoint sungguhan · **MOCK** = endpoint belum ada di backend, dijawab mock JSON (debug saja) · **API+MOCK** = endpoint ada, sebagian field disisipkan mock · **LOKAL** = dihitung di app.

### Akun & autentikasi
| Fitur | Layar (`lib/ui/main/…`) | Sumber | Catatan |
|---|---|---|---|
| Splash, onboarding, welcome | `lib/features/…` | — | sudah gaya Xpedia |
| Login / Daftar | `auth/screens/login_screen.dart`, `register_screen.dart` | API | login berbasis email; daftar **wajib NIK 16 digit & unik** (`409 IDENTITY_TAKEN`, backend `3e8906d`); register tanpa token → otomatis login |
| Lupa & atur ulang sandi | `auth/screens/forgot_password_screen.dart`, `reset_password_screen.dart` | API | debug: tombol "Buka tautan reset (dev)" pakai `dev_reset_token` |
| My Xpedia (tab profil) | `profile/screens/my_xpedia_screen.dart` | API `/me` | pintu ke semua layar akun |
| Ubah profil | `profile/screens/edit_profile_screen.dart` | API + MOCK | nama terkunci bila KTP terverifikasi (`IDENTITY_LOCKED`) |
| Verifikasi KTP | di profil | MOCK `/me/identity-verification` | docs/22 #4, #11 |
| Ganti email/HP + OTP | di profil | MOCK `/me/contact-change` | OTP mock `123456`; docs/22 #10 |
| Keamanan akun (sesi perangkat) | `profile/screens/account_security_screen.dart` | API `/me/sessions` | dikelompokkan per perangkat (bug backend: sesi menumpuk tiap refresh) |
| Pengaturan (tema, bahasa, keluar) | `profile/screens/settings_screen.dart` | LOKAL | ganti tema/bahasa = app restart (Phoenix) |
| Alamat (maks 3) + master lokasi | `address/screens/address_list_screen.dart`, `address_form_sheet.dart`, `location_picker.dart` | API `/me/addresses`, `/locations/*` | batas 3 ditegakkan app; kota tetap bisa ketik bebas |

### Belanja
| Fitur | Layar | Sumber | Catatan |
|---|---|---|---|
| Beranda | `catalog/screens/catalog_home_screen.dart` | API `/products?sort_by=recommended`, `/home/layout`, `/categories` + MOCK Live | kartu Wallet, banner CMS, strip Live (mock), kategori, grid produk; filter kota dari alamat utama |
| Pencarian | `catalog/screens/search_screen.dart` | API `/products?q=` | **bukan** `/search/*` (Elasticsearch mati di dev); tanpa kontrol sort/filter (aturan blueprint) |
| Detail produk | `catalog/screens/product_detail_screen.dart` | API | varian, stok/`StockMode`, estimasi ongkir, ulasan + balasan penjual, kartu toko, "Tanyakan produk ini" (chat), berbagi |
| Toko (storefront) | `store/screens/store_screen.dart` | API `/stores/{id}`, `partners-performance` + MOCK online/Live | ikuti/berhenti ikuti, badge status penjual & Signature |
| Toko diikuti | `store/screens/followed_stores_screen.dart` | API `/me/following` | |
| Wishlist (tab) | `wishlist/screens/wishlist_screen.dart` | API + MOCK `alert_enabled` | lonceng pantau harga = mock (docs/22 #13); hapus pakai **product_id** |
| Keranjang | `cart/screens/cart_screen.dart` | API | kuantitas dibatasi app (server tidak validasi); voucher; estimasi koin |
| Voucher | `voucher/screens/voucher_screen.dart` | API | klaim/pasang/lepas/auto-apply; di dev selalu kosong (tak ada seed) |
| Checkout | `checkout/screens/checkout_screen.dart` | API (wallet-only) | saldo dari `GET /wallet` + PIN → order lahir `paid`. Pemilih metode lama dibuang. PIN salah/belum dibuat/sesi kedaluwarsa sama-sama `CHECKOUT_CONFIRM_FAILED` — dibedakan dengan membaca ulang sesi. 🔴 kuota PIN 5/15 mnt ikut menghitung PIN benar |
| Pembayaran (QRIS/VA) | `payment/screens/payment_screen.dart` | API | kini **hanya untuk top up** saldo |

### Pesanan
| Fitur | Layar | Sumber | Catatan |
|---|---|---|---|
| Daftar pesanan (tab) | `order/screens/order_list_screen.dart` | API `/orders` | tanpa filter status (server mengabaikannya) |
| Detail pesanan | `order/screens/order_detail_screen.dart` | API + MOCK | batal (pending/paid), konfirmasi diterima (+kode segel Secure+ `SEAL-XXXXXXXX`), selesai, keputusan kirim-sebagian, Secure+ opt-in, bayar ulang via `OrderPaymentLinkStore` |
| Ajukan pembatalan sesudah resi | `order/screens/order_cancel_screen.dart` | MOCK `/orders/{id}/cancellation-request` | docs/22 #3 |
| Komplain / refund + bukti | `order/screens/order_complaint_screen.dart` | API `refund-request` + `/media/upload` | bukti dikirim sebagai body **`evidence`** dan tersimpan (backend `0307edf`); hanya `delivered`/`completed` |
| Lacak paket | `order/screens/order_tracking_screen.dart` | API + MOCK `tracking_history` | linimasa kurir = mock |
| Invoice + PDF | `order/screens/order_invoice_screen.dart` | API `/orders/{id}/invoice` + LOKAL | PDF dirakit di perangkat (`pdf`/`printing`), alamat disensor app; hanya `completed` |
| Tulis ulasan | `review/screens/review_form_screen.dart` | API | hanya pesanan `completed` |
| Ulasan saya + ubah 30 hari | `review/screens/my_reviews_screen.dart` | MOCK `/me/reviews`, `PATCH /reviews/{id}` | docs/22 #8 |

### Dompet, reward, komunikasi
| Fitur | Layar | Sumber | Catatan |
|---|---|---|---|
| Dompet: saldo, mutasi, topup | `wallet/screens/wallet_screen.dart` | API | min topup Rp10.000 (app + server); mutasi `order_payment` = debit |
| Tarik saldo | `wallet/screens/withdraw_sheet.dart` | API | butuh PIN + rekening; validasi lokal dulu (limiter PIN hitung percobaan benar) |
| PIN Wallet | `wallet/screens/withdrawal_pin_screen.dart` | API `/me/withdrawal-pin` | tidak ada cara cek PIN sudah ada |
| Rekening bank (maks 3) | `wallet/screens/bank_accounts_screen.dart` | API `/me/bank-accounts` | nama pemilik = nama akun |
| Reward (poin/koin/tier/cashback) | `reward/screens/reward_screen.dart` | API | tukar poin sengaja tidak dibuat (bug backend) |
| Notifikasi | `notification/screens/notification_screen.dart` | API | kosong itu normal; kartu kode segel Secure+ |
| Chat (tab) + ruang chat | `chat/screens/chat_list_screen.dart`, `chat_room_screen.dart` | API | refresh tiap 5 dtk (jangan `/poll`); moderasi `CHAT_CONTENT_BLOCKED`; share produk/pesanan; status terkirim/dibaca |
| Xpedia 911 (tiket bantuan) | `support/screens/support_list_screen.dart`, `support_new_ticket_screen.dart`, `support_ticket_screen.dart` | API `/support-tickets` | `related_order_id` hanya dari pesanan sendiri |

## 6. Mock API yang belum dibangun backend

- Kode: `lib/config/network/mock/pending_api_mock.dart` + `routes/{account,checkout,order,discovery}_mock_routes.dart`.
- Fixture + **kontrak untuk tim backend**: `assets/mock/pending_api/<domain>/*.json` dan **`assets/mock/pending_api/README.md`** (baca ini untuk detail tiap endpoint).
- Aktif hanya di debug (`PENDING_API_MOCK`, default `kDebugMode`). Matikan: `flutter run --dart-define=PENDING_API_MOCK=false`.
- Nilai simulasi: OTP `123456`. Opsi debug lain (`MOCK_CANCELLATION_OUTCOME`, …) ada di README mock. Mock checkout/Wallet **sudah dihapus** — checkout memakai server sungguhan.
- **Saat backend membangun endpoint: hapus rute mock-nya saja**, lalu jalankan layar terkait terhadap server; sesuaikan model hanya bila bentuk respons berbeda dari fixture.
- `test/integration/` tidak terpengaruh mock (pakai `DioClient.createBare`).

## 7. Belum dikerjakan / keputusan terbuka

### Sisa sinkron backend `45568d9` (12 commit docs/22)
Sudah: #1–#2 checkout wallet-only, #4 NIK saat daftar, #5 bukti refund (`evidence`), #9 & #12 (ditegakkan server, dipatok test). Belum:
- [ ] **#10 ganti email/HP** — server membangun `/me/{email,phone}/change-request` + `change-confirm {token}`, **beda kontrak** dari mock `/me/contact-change` + OTP. Layar & service harus ditulis ulang.
- [ ] **#3 pembatalan sesudah resi** — `POST /orders/{id}/cancellation-request` ada; `GET`-nya **tidak** (mock GET tetap). Hapus mock POST, sesuaikan bentuk.
- [ ] **#8 ubah ulasan** — `PATCH /reviews/{id}` ada; `GET /me/reviews` tidak (mock tetap).
- [ ] **#13 lonceng wishlist** — `PATCH /wishlist/items/{productId} {alert_enabled}` ada; cek `GET /wishlist` membawa `alert_enabled`, lalu hapus mock.
- [ ] **#4/#11 kunci nama** — server menolak `full_name` dengan `VALIDATION_ERROR`, bukan `IDENTITY_LOCKED` usulan mock. Endpoint verifikasi KTP tetap tidak ada.
- [ ] **#6/#14 invoice** — server kini menyensor alamat; cek nama field lalu lepas sensor lokal.
- [ ] **#7 rating toko** — kini dari ulasan terverifikasi; cek ulang catatan "`rating_avg` salah" di CLAUDE.md.
- [ ] **e2e `member_journey_test`** — sudah disesuaikan untuk NIK & checkout wallet-only, tapi **sudah merah sebelumnya** di langkah katalog (chip "Semua" tergulir keluar saat mencari grid produk di bawah lipatan). Perlu diperbarui untuk beranda Xpedia.
- [ ] 🔴 Laporkan ke backend: hapus alamat yang pernah dipakai checkout → **500 HTML** (FK `RESTRICT` dari `checkout_sessions`); dengan batas 3 alamat, pembeli tak bisa lagi mengganti alamat lama.

- [ ] Cek visual **dark mode** semua layar baru.
- [ ] Lokalisasi **en/ar** untuk layar baru (copy saat ini Bahasa Indonesia hardcoded) — butuh keputusan produk.
- [ ] Alur consent ulang (`requires_reconsent`) — belum bisa diuji, dokumen legal belum di-seed.
- [ ] Etalase toko, bundel, rating toko per order, preferensi notifikasi — tunggu data/perbaikan backend (lihat CLAUDE.md langkah 7b).
- [ ] Elemen desain yang sengaja tidak dibuat karena tak ada datanya: layanan XpediaFood/Ride/Mart, pemutar Live, peta kurir, status online toko asli, biometrik.
- [ ] Migrasi arsitektur (Part 2 CLAUDE.md langkah 8–10): state freezed untuk sisa `lib/features/`, pecah `app_routes.dart` per domain.

### Temuan backend yang perlu dilaporkan
Daftar lengkap di CLAUDE.md "Backend v1.6–v1.28" → "Temuan backend baru". Yang paling penting:
- 🔴 `GET /orders/{id}/tracking` tanpa cek kepemilikan dan membawa `delivery_seal_code` (bisa bypass Secure+).
- 🔴 Refresh token tidak dirotasi — sesi menumpuk, token lama sah 30 hari.
- 🔴 Rate limit login & PIN menghitung percobaan **benar**.
- Insurance opt-in tanpa gerbang status/premi dari klien; `/cart/recommended-vouchers` 500 saat keranjang kosong; `city_id` asing → 500.

## 8. Catatan git

- Remote `main` sempat berisi riwayat **app seller** (repo salah). Sudah ditimpa dengan riwayat buyer. Kalau `git pull` tiba-tiba memunculkan ratusan konflik dengan `pubspec` bernama seller: **`git rebase --abort`** (atau `git merge --abort`), jangan diteruskan, lalu cek remote.
- Pastikan remote folder seller tidak menunjuk ke repo buyer.
- Push gagal `Permission denied (publickey)` padahal kunci ada → kunci SSH ber-passphrase belum dimuat ke agent: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519` (macOS), lalu `ssh -T git@github.com` untuk mengecek.
