# Kontrak API yang diusulkan (mock sementara)

Folder ini berisi **respons JSON dummy untuk endpoint yang belum dibangun
marketplace-api**. Aplikasi buyer sudah memanggil endpoint-endpoint ini persis
seolah sudah ada; di build debug, `PendingApiMockInterceptor`
(`lib/config/network/mock/`) menjawabnya dengan berkas di sini.

**Untuk tim backend:** setiap berkas adalah bentuk respons yang diharapkan app.
Kalau endpoint dibangun dengan bentuk yang sama, cukup hapus rute mock-nya di
`lib/config/network/mock/routes/*` — tidak ada kode lain yang perlu diubah.
Kalau bentuknya berbeda, beri tahu tim FE supaya model ikut disesuaikan.

Aturan yang berlaku untuk seluruh kontrak di sini sama dengan API yang sudah
ada: amplop `{success, data, error, meta}`, angka boleh dikirim sebagai string,
timestamp `YYYY-MM-DD HH:MM:SS` WIB, kode error di `error.code`.

Respons mock selalu membawa `meta.mock = true` (atau `meta.mock_fields` untuk
field yang disisipkan ke respons sungguhan) — field itu **tidak** perlu dikirim
backend.

Mematikan mock: `flutter run --dart-define=PENDING_API_MOCK=false`.

## Daftar endpoint

<!-- Tiap domain menambahkan tabelnya di bawah. -->

### Account

Rute mock: `lib/config/network/mock/routes/account_mock_routes.dart`.
Konvensi fixture domain ini: **isi `data` saja** (bukan amplop lengkap); mock
membungkusnya dengan amplop dan menimpa field yang bergantung pada keadaan
(id, status, waktu). Seluruh keadaan mock disimpan di memori dan hilang saat
app dimulai ulang. Semua endpoint di bawah **butuh token** (`Authorization:
Bearer …`), seperti `/me` lainnya.

#### Verifikasi identitas / KTP — docs/22 #4 (+ #11)

| | |
|---|---|
| **`GET /me/identity-verification`** | Status verifikasi KTP akun ini. Akun yang belum pernah mengajukan dibalas `200` dengan `status: "none"` (bukan `404`), sama seperti `/me/points` yang dibuat otomatis. |
| Respons `200` | [`account/identity_verification.json`](account/identity_verification.json) (belum mengajukan), [`account/identity_verification_verified.json`](account/identity_verification_verified.json) (terverifikasi). Field: `status` (`none` \| `pending` \| `verified` \| `rejected`), `id_card_number_masked` (hanya 4 digit terakhir, NIK utuh **tidak pernah** dikirim balik), `full_name` (nama sesuai KTP yang diajukan), `rejection_reason` (teks untuk user, hanya saat `rejected`), `submitted_at`, `verified_at`. |
| **`POST /me/identity-verification`** | Body `{"id_card_number": "3171…" (16 digit, string), "full_name": "…"}`. |
| Respons `201` | Bentuk yang sama dengan `GET`, `status: "pending"`. |
| Error | `422 VALIDATION_ERROR` (NIK bukan 16 digit / nama kosong) · `409 ID_CARD_ALREADY_USED` (NIK sudah dipakai akun lain — aturan "1 KTP = 1 akun") · `422 INVALID_STATE` (sedang `pending` atau sudah `verified`; `rejected` boleh mengajukan ulang). |
| Usulan skema | `users.id_card_number` (unique, nullable), `users.identity_status`, `users.identity_verified_at` — sesuai saran docs/22 #4. |
| Perilaku mock | `pending` berubah jadi hasil akhir pada `GET` pertama ≥10 detik sesudah pengajuan. **Pemicu khusus mock**: NIK berisi satu digit berulang (`1111111111111111`) → `ID_CARD_ALREADY_USED`; NIK berakhiran `0000` → `rejected`. |

**Kunci nama (docs/22 #11) — perilaku usulan untuk `PATCH /me` yang sudah ada:**
selama `identity_status` `pending` atau `verified`, body yang memuat
`full_name` ditolak **`422 IDENTITY_LOCKED`** (usulan docs/22 menyebut
"exclude dari whitelist"; app lebih suka ditolak eksplisit daripada diabaikan
diam-diam, karena `PATCH /me` membalas `data: null` dan pengabaian tidak akan
terlihat). Mock menjawab penolakan itu; permintaan lain diteruskan ke server.
App juga sudah mengunci kolom nama di layar Ubah Profil.

#### Ganti email / nomor HP — ✅ dibangun backend, mock DIHAPUS (30 September 2026)

Backend `b501fc3` membangun docs/22 #10 dengan kontrak **satu tahap**, bukan
OTP dua tahap yang diusulkan di sini. Rute mock `/me/contact-change*` dan
fixture `account/contact_change_*.json` sudah dihapus. Catatan untuk backend:

| Usulan | Yang dibangun | Catatan |
|---|---|---|
| `POST /me/contact-change {type, new_value}` | `POST /me/{email\|phone}/change-request {new_email\|new_phone}` | Format **tidak divalidasi** (`bukan-email` diterima); app yang memvalidasi. |
| OTP 6 angka ke kontak lama **lalu** kontak baru | **Satu** token 64 hex (30 menit) ke kontak lama saja → `POST /me/{…}/change-confirm {token}` | Kontak baru tersimpan dengan `*_verified = 0` dan tidak ada cara memverifikasinya ulang. Token terlalu panjang untuk diketik — app menyediakan kolom tempel. |
| `otp_sent_to` tersensor | Tidak ada | App menulis "kontak lama kamu". |
| — | 🔴 **HP: tidak ada yang dikirim** (tidak ada SMS di backend) | Di luar mode development (`dev_verification_token`), ganti HP **tidak bisa diselesaikan**. |
| `EMAIL_TAKEN` untuk kontak orang lain | Juga untuk **kontak akun sendiri** | App menolak nilai yang sama lebih dulu. |
| 429 hanya untuk permintaan berlebih | 3 permintaan/jam/jenis, **setiap** permintaan dihitung (termasuk kirim ulang) | Sesuai usulan. |
| — | 🔴 `change-confirm` **mengonsumsi token sebelum** memeriksa pemilik & ketersediaan | Token milik akun lain tetap hangus; kontak yang keburu dipakai → `409` dan pembeli harus meminta kode baru. |

#### Tidak di-mock (endpoint sudah ada)

| Endpoint | Catatan untuk backend |
|---|---|
| `GET /me/sessions`, `DELETE /me/sessions/{id}` | Dipakai layar Keamanan Akun apa adanya. **Usulan field `is_current`** (boolean) per baris — app kini menebaknya dari `created_at` yang paling dekat dengan saat access token diterbitkan, dan otomatis memakai `is_current` begitu dikirim. 🔴 **Temuan**: `Jwt_auth::refresh()` menyisipkan baris `user_sessions` baru tiap refresh **tanpa mencabut yang lama**, jadi refresh token lama tetap sah 30 hari dan daftar sesi tumbuh satu baris per 15 menit. App mengelompokkan baris per `device_id`+`user_agent`+`ip_address` dan mencabut semuanya saat "Keluarkan"; perbaikan sebenarnya adalah merotasi (mencabut) baris lama saat refresh. `DELETE` juga membalas `200` untuk id apa pun dan tidak menolak sesi yang sedang dipakai. |
| `POST /me/{email,phone}/change-request`, `.../change-confirm` | Lihat tabel di atas. |
| `POST /auth/forgot-password`, `POST /auth/reset-password` | Sudah dipakai layar Lupa/Atur Ulang Kata Sandi. `dev_reset_token` (development) dipakai tombol debug "Buka tautan reset (dev)". Tautan email menunjuk `base_url/reset-password?token=` — belum ada deep link ke app, jadi app menyediakan kolom tempel kode. `reset-password` tidak memvalidasi panjang `new_password` sama sekali. |

### Checkout & Wallet — ✅ dibangun backend, mock DIHAPUS (29 September 2026)

Backend `d9ecb33` (docs/22 #1–#2) menjadikan checkout **wallet-only**, jadi
rute mock `checkout_mock_routes.dart` beserta fixture `checkout/*` sudah
dihapus dan app memakai server sungguhan. Kontraknya **berbeda** dari usulan
di sini; catatan untuk backend:

| Usulan | Yang dibangun | Dampak ke app |
|---|---|---|
| `GET /checkout/sessions/{id}/wallet-summary` | **Tidak dibangun** | App merakit ringkasannya sendiri dari `GET /wallet` + `grand_total` sesi. `pin_set` tidak bisa diketahui — masih diusulkan. |
| `confirm` `{payment_method: "wallet", pin}` | `{pin}` saja; `payment_method` tidak lagi dibaca | Pemilih metode QRIS/VA dibuang dari checkout. |
| Balasan + `paid`, `wallet_transaction_id`, `balance_after`, `paid_at` | Hanya `{order_ids, payment_transaction_id}` | App menandai `paid` sendiri dan membaca sisa saldo dari `GET /wallet`. |
| `422 PIN_NOT_SET`, `422 INVALID_PIN` (`attempts_left`) | 🔴 Keduanya **`422 CHECKOUT_CONFIRM_FAILED`** — kode yang sama dengan sesi kedaluwarsa | App membaca ulang sesi: masih `stock_reserved` → masalah PIN. Salah vs belum-dibuat tetap tak bisa dibedakan. **Usulan: kirim `INVALID_PIN` / `PIN_NOT_SET`.** |
| `INSUFFICIENT_BALANCE` dengan `details: {balance, required}` | Kode sama, **`details: null`** | Selisih dihitung app dari ringkasannya sendiri. |
| Rate limit hanya menghitung PIN **salah** | 🔴 Menghitung **setiap** verifikasi, termasuk yang benar, dan kuotanya **dibagi** dengan penarikan (5 / 15 menit / user) | Pembeli yang tak pernah salah PIN hanya bisa checkout 5× per 15 menit. **Usulan: hitung yang salah saja.** |

Jenis mutasi dompet baru `order_payment` (debit) sudah dipetakan app.
Minimum top up Rp 10.000 kini ditegakkan server (backend `7ce3b92`).

#### Tidak di-mock (endpoint sudah ada, kosong di dev)

| Endpoint | Catatan untuk backend |
|---|---|
| `POST /wallet/topup` | Dipakai dari blok saldo kurang di checkout (minimum Rp 10.000 — kini ditegakkan app **dan** server). Di dev transaksi top up tidak bisa dibayar (callback pembayaran rusak, lihat CLAUDE.md); test integrasi menyuntik saldo lewat SQL (`test/integration/support/dev_db.dart`). |
| `GET /me/vouchers`, `POST /vouchers/claim` | Layar Voucher Saya. Selalu `[]` — tidak ada voucher yang di-seed. `GET /me/vouchers` ikut mengembalikan voucher `expired`/`inactive` (query tidak menyaring status); app menonaktifkan tombol "Pakai"-nya. |
| `GET /cart/recommended-vouchers`, `POST /cart/vouchers/auto-apply` | 🔴 Keduanya **500 HTML kalau tidak ada baris keranjang tercentang** (`store_id IN ()` di `list_eligible_vouchers`). App tidak memanggilnya saat `item_count == 0`; perbaikan server: kembalikan `[]` bila `by_store` kosong. |
| `POST /cart/apply-voucher`, `DELETE /cart/vouchers/{code}` | Sudah dipakai. Kode `VOUCHER_QUOTA_EXCEEDED`, `VOUCHER_ALREADY_USED`, `VOUCHER_MIN_SPEND_NOT_MET` dikirim apa adanya dari `RuntimeException` dan kini dipetakan app. |

### Discovery

Rute mock: `lib/config/network/mock/routes/discovery_mock_routes.dart`.
Konvensi fixture domain ini: **isi `data` saja** (bukan amplop lengkap); mock
membungkusnya dengan amplop. Keadaan mock (pantau harga) disimpan di memori
dan hilang saat app dimulai ulang. Setiap kontrak di bawah dirancang supaya
**tanpa mock** app turun dengan anggun: rute yang belum ada dibalas 404 HTML
(`DataError.isRouteNotFound`) atau field-nya tidak dikirim, dan fitur itu
tidak digambar — jadi begitu backend membangunnya, fitur hidup tanpa
perubahan kode.

#### Daftar sesi live untuk pembeli — gap "no live data" (inventaris §3.1 no. 4, §3.5, b12)

Backend sudah punya modul `live_commerce` (`live_sessions`, `GET /live-sessions/{id}`
publik, dan rute penjual), tapi **tidak ada rute untuk mendaftar sesi**. Path
usulan memakai resource yang sama (`/live-sessions`, bukan `/live/sessions`)
supaya cukup menambah `index_get` di controller `Live`.

| | |
|---|---|
| **`GET /live-sessions?status=live&store_id=&page=`** | **Publik.** `status` dipisah koma (`live`, `scheduled`, `ended`, `cancelled`; bawaan `live`). `store_id` opsional (tab Live storefront memakai `status=live,scheduled&store_id=`). `page` 1-based, `per_page` dipatok 20. Urutan usulan: `live` dulu (`started_at` terbaru), lalu `scheduled` (`scheduled_at` terdekat) — app tetap mengurutkan ulang sendiri. |
| Respons `200` | Array — [`discovery/live_sessions.json`](discovery/live_sessions.json). Field: `id`, `store_id`, `store_name` (join `stores.name`), `title`, `thumbnail_url` (kolom yang sudah ada; nullable), `status`, `viewer_count`, `started_at`, `scheduled_at`, `promo_label` (**kolom baru**, nullable, mis. "Diskon 35%"), `sold_count` (**agregat baru** — atribusi order ke sesi live belum dilacak, lihat `Live_model::update_session_metrics`). `stream_key` **tidak boleh** ikut. `meta`: `{page, per_page, total}`. |
| Error | `422 VALIDATION_ERROR` untuk `status` di luar ENUM. Toko tanpa sesi → `200` dengan `[]`. |
| UI | Strip "LIVE NOW · Xpedia Live Interaktif" di beranda (kartu w144, jumlah penonton, promo, terjual); pita "Live" + tab **Live** storefront (tayang + "Jadwal Live Berikutnya"). Mengetuk kartu membuka storefront — **belum ada pemutar**, karena `playback_url` yang bisa diputar pembeli juga belum ada. |
| Perilaku mock | Menyaring fixture menurut `status`/`store_id` dan memotong per 20. Fixture memakai toko id 1–3 (seed) dengan judul berawalan "Simulasi Live:". |

#### Status online toko — `partners-performance` (inventaris §3.5 metrik "Online / Aktif sekarang", §3.23 sub-header)

Endpoint sudah ada; yang diusulkan hanya **mengisi field yang selalu `null`**.
`avg_reply_minutes` **sudah sungguhan** dan tidak disentuh mock.

| | |
|---|---|
| **`GET /stores/{id}/partners-performance`** (sudah ada) | `service_performance.online_status`: `"online"` \| `"offline"` (hari ini selalu `null` — komentar backend: "codebase ini gak punya field online/last-active sama sekali"). **Field baru** `service_performance.last_active_at` (`YYYY-MM-DD HH:MM:SS` WIB, nullable). Contoh blok: [`discovery/partners_performance_service.json`](discovery/partners_performance_service.json). |
| Usulan sumber | `last_active_at` = aktivitas terakhir pemilik/staf toko (request ber-token dari akun yang punya `store_staff` aktif, atau pesan chat terakhir dari sisi toko). `online` = aktif ≤5 menit terakhir. |
| UI | Metrik keempat di storefront dan kartu toko halaman produk: "Online · Aktif sekarang" (titik hijau) atau "5 mnt lalu · Terakhir aktif". Selama `null` metrik itu tidak digambar. |
| Perilaku mock | `onResponse`: hanya mengisi kalau `online_status` masih `null`, dari [`discovery/store_online_status.json`](discovery/store_online_status.json) per id toko (`default` untuk id lain), `last_active_at` dihitung dari `last_active_minutes_ago`. Ditandai `meta.mock_fields: ["service_performance.online_status", "service_performance.last_active_at"]`. |

#### Pantau harga & stok wishlist — docs/22 #13

| | |
|---|---|
| **`PATCH /wishlist/items/{product_id}`** | Butuh token. Body `{"alert_enabled": true \| false}`. Kuncinya **id produk**, sama dengan `DELETE /wishlist/items/{id}` yang sudah ada (rutenya sudah terdaftar; controller baru punya `items_delete`). |
| Respons `200` | [`discovery/wishlist_alert.json`](discovery/wishlist_alert.json): `{product_id, alert_enabled}`. App tetap membaca ulang `GET /wishlist`. |
| **`GET /wishlist`** (sudah ada) | **Field baru per baris**: `alert_enabled` (`"0"`/`"1"` atau boolean — keduanya diterima). App memakai **keberadaan** key ini sebagai tanda fitur didukung: tanpa key, lonceng tidak digambar. |
| Error | `422 VALIDATION_ERROR` (`alert_enabled` bukan boolean) · `404 WISHLIST_ITEM_NOT_FOUND` (produk tidak ada di wishlist user — usulan; jangan `200` diam-diam seperti `DELETE`). |
| Usulan skema & pemicu | Kolom `wishlist_items.alert_enabled TINYINT(1) DEFAULT 0` (+ `alert_baseline_price`). Notifikasi `wishlist_price_drop` saat harga efektif turun di bawah baseline, dan `wishlist_back_in_stock` saat stok varian kembali >0 — lewat `Notification_model->create()` ke **pembeli** (hari ini tidak ada satu pun notifikasi yang terbit untuk pembeli). |
| UI | Lonceng per kartu wishlist (b15) + lencana "Pantau" + baris ringkasan "N produk dipantau". Toast "Notifikasi perubahan harga aktif" / "Notifikasi promo wishlist dinonaktifkan". |
| Perilaku mock | `PATCH` disimpan di memori per id produk; `GET /wishlist` sungguhan diperkaya `alert_enabled` (bawaan `false`) dan ditandai `meta.mock_fields: ["alert_enabled"]`. |

#### Tidak di-mock (endpoint sudah ada)

| Endpoint | Catatan untuk backend |
|---|---|
| `GET /home/layout` | Dipakai beranda apa adanya (hero carousel, promo grid, baris kategori, flash sale, rel rekomendasi, `companion_banner`, `campaign`). Masih `[]` di dev (tabel CMS belum di-seed) — beranda tampil seperti biasa. Catatan: baris `product_recommendation` adalah `SELECT *` dari `products` **tanpa `image_url`** (berbeda dari `GET /products`), dan produk `campaign` non-flash-sale **tanpa `product_id`** sehingga kartunya tidak bisa membuka halaman produk. `action_type` `URL`/`CAMPAIGN` belum bisa diketuk di app. |
| `GET /locations/provinces`, `GET /locations/cities?province_id=` | Pengisi cepat kolom kota/provinsi formulir alamat; memilih kota mengirim `city_id`. Kolom tetap teks bebas (seed baru 15 kota). `city_id` tak dikenal di `POST /me/addresses` akan melanggar FK (500) — app hanya mengirim id dari master. |
| `POST /chat/conversations/{id}/messages` dengan `message_type: product_share \| order_share` | Dipakai untuk "Tanyakan produk ini" dan lampiran pesanan (tanpa `content`). 🔴 Server **tidak memeriksa** bahwa `shared_order_id` milik partisipan maupun bahwa `shared_product_id` ada — app hanya menawarkan pesanan pembeli sendiri dari toko itu (disaring di app, karena `GET /orders` tidak bisa disaring per toko). |

### Orders & Reviews

Rute mock: `lib/config/network/mock/routes/order_mock_routes.dart`.
Konvensi fixture domain ini: **isi `data` saja** (bukan amplop lengkap); mock
memakainya sebagai templat lalu menimpa id dan stempel waktu. Keadaan mock
disimpan di memori dan hilang saat app dimulai ulang. Semua endpoint di bawah
**butuh token** dan hanya untuk **pembeli pemilik pesanan** (pesanan orang lain
→ `403 PERMISSION_DENIED`, seperti `GET /orders/{id}`). Tanpa mock, rute yang
belum ada dibalas 404 HTML (`DataError.isRouteNotFound`) dan app turun dengan
anggun: formulir permohonan pembatalan diganti penjelasan + Xpedia 911,
"Ulasan Saya" menulis "belum tersedia", kartu Secure+ tetap menawarkan opt-in.

Mock mengamati tiga respons **sungguhan** tanpa mengubahnya (tidak menandai
`mock_fields`): `GET /orders/{id}` (status & baris pesanan, untuk gerbang
status permohonan pembatalan dan nama produk di "Ulasan Saya"),
`POST /orders/{id}/insurance/opt-in` (polis yang dibuat), dan
`POST /order-items/{id}/review` (ulasan yang dibuat).

#### Ajukan Pembatalan sesudah resi — docs/22 #3

Tahap kedua pembatalan (inventaris §3.15). Tahap pertama —
`POST /orders/{id}/cancel` untuk `pending|paid` — sudah ada dan tidak diubah.

| | |
|---|---|
| **`POST /orders/{id}/cancellation-request`** | Body `{"reason": "<kode>", "note": "…"}`. `reason` wajib salah satu `wrong_address` · `wrong_variant` · `change_order` · `eta_too_long` · `changed_mind` · `other` (dikirim sebagai **kode**, bukan label, supaya bisa dilaporkan/disaring). `note` opsional, maks 500 karakter. **Tanpa bukti** (sesuai desain). |
| Respons `201` | [`order/cancellation_request.json`](order/cancellation_request.json): `id`, `order_id`, `status: "pending"`, `reason`, `note`, `rejection_reason: null`, `created_at`, `seller_response_deadline` (= `created_at` + 24 jam, desain "1x24 jam"), `resolved_at: null`. |
| **`GET /orders/{id}/cancellation-request`** | Permohonan **terakhir** pesanan itu, atau `data: null` kalau belum pernah ada (bukan `404`). |
| Status | `pending` → `approved` \| `rejected`. `approved`: server **membatalkan pesanan** (`status = cancelled`, `cancellation_fault = buyer`) dan mengembalikan dana penuh ke Xpedia Wallet — sama dengan pembatalan langsung. `rejected`: pesanan tetap diproses; `rejection_reason` (teks untuk pembeli) wajib diisi penjual. |
| Error | `422 CANCELLATION_NOT_ALLOWED` (status pesanan bukan `packed` \| `shipped` — sebelum itu pakai `/cancel`, sesudahnya pakai komplain) · `409 CANCELLATION_REQUEST_EXISTS` (**satu permohonan per pesanan**, apa pun statusnya) · `422 VALIDATION_ERROR` (`reason` di luar kode, `note` > 500). |
| Belum diputuskan | Apa yang terjadi kalau penjual tidak menjawab sampai `seller_response_deadline`. Usulan: disetujui otomatis oleh worker, meniru SLA custom order yang batal otomatis. Sisi penjual (setuju/tolak) juga perlu rute sendiri, mis. `POST /orders/{id}/cancellation-request/{rid}/approve\|reject` seperti refund. |
| UI | Layar "Ajukan Pembatalan" (6 alasan, catatan 0/500, banner peringatan "dapat disetujui atau ditolak penjual", lembar konfirmasi "Kirim Permohonan?"). Kartu status permohonan di detail pesanan. |
| Perilaku mock | Status pesanan diambil dari `GET /orders/{id}` sungguhan terakhir (kalau belum pernah dibuka, diloloskan). Permohonan tetap `pending` selamanya secara bawaan. **Khusus debug**: `--dart-define=MOCK_CANCELLATION_OUTCOME=approved` (atau `rejected`) membuat permohonan berubah pada `GET` pertama ≥ `MOCK_CANCELLATION_RESOLVE_SECONDS` (bawaan 20) detik sesudah dibuat; status pesanan sungguhan **tidak** ikut berubah. |

#### Riwayat perjalanan kurir — field `tracking_history`

Kolom `order_shipments.tracking_history JSON NULL` sudah ada di skema tapi
**tidak pernah ditulis** kode mana pun (inventaris §3.17, b32).

| | |
|---|---|
| **`GET /orders/{id}/tracking`** (sudah ada) | **Field yang diusulkan diisi**: `tracking_history` — array, **terbaru dulu**, tiap entri `{status, description, location, occurred_at}`. `status` memakai ENUM yang sama dengan `order_shipments.status` (`picked_up` \| `in_transit` \| `delivered` \| `returned` \| `lost`); `description` teks untuk pembeli (Bahasa Indonesia); `location` nullable; `occurred_at` WIB. Contoh: [`order/tracking_history.json`](order/tracking_history.json). App menerima array **maupun string berisi JSON** (driver MySQL mengirim kolom JSON sebagai string). |
| Usulan sumber | Webhook/polling API kurir saat `status` pengiriman berubah; minimal satu entri saat `ship` (`picked_up`) dan saat `confirm-delivery` (`delivered`). |
| Catatan keamanan | Baris ini hari ini juga membawa `delivery_seal_code` **tanpa cek kepemilikan** — siapa pun yang login bisa membaca kode segel pesanan orang lain. App tidak memodelkannya; mohon diperbaiki bersamaan. |
| UI | Linimasa vertikal "Detail Perjalanan" (tahap sebelum kirim tetap dari `status_history`). Tanpa field ini, linimasa jatuh ke riwayat status + `shipped_at`/`delivered_at`. |
| Perilaku mock | `onResponse` pada respons sungguhan yang `data`-nya bukan `null` dan `tracking_history`-nya kosong: menyisipkan sebagian perjalanan fixture sesuai `status` (`picked_up` 1 entri, `in_transit` 5, `delivered` 6 dengan entri terakhir tepat di `delivered_at`), dengan waktu dipadatkan ke `shipped_at` … sekarang. Lokasinya generik ("Hub kota tujuan"). Ditandai `meta.mock_fields: ["tracking_history"]`. Di dev `tracking` selalu `null` (belum ada pesanan yang dikirim), jadi jalur ini dipatok unit test. |

#### Status Xpedia Secure+ — `GET /orders/{id}/insurance`

`POST /orders/{id}/insurance/opt-in` **sudah ada** dan dipakai apa adanya
(`{tier: "secure_plus"}` → `201 {id, premium_amount, tier}`), tapi tidak ada
cara membaca polisnya kembali (`Insurance_model::find_policy_by_order()` ada,
rutenya tidak).

| | |
|---|---|
| **`GET /orders/{id}/insurance`** | Polis pesanan ini, atau `data: null`. |
| Respons `200` | [`order/insurance_policy.json`](order/insurance_policy.json): `id`, `tier` (`basic` \| `secure_plus`), `premium_amount`, `coverage_amount`, `status` (`active` \| `claimed` \| `expired`), `created_at`. |
| UI | Kartu "Aktifkan Xpedia Secure+" di detail pesanan `pending`/`paid` (perkiraan biaya 0,5% `grand_total`, penjelasan foto+video pra-serah-terima dan kode segel), lalu "Xpedia Secure+ aktif" di detail dan Lacak Paket. Teks tidak pernah memakai kata "asuransi". |
| Perilaku mock | Mengembalikan polis yang dibuat lewat opt-in **sungguhan** di sesi ini; selain itu `null`. |
| 🔴 Temuan pada opt-in yang sudah ada | (1) **Tanpa gerbang status** — polis bisa dibuat untuk pesanan yang sudah dikirim/selesai; usulan: `422 INVALID_STATE` selain `pending`/`paid`. (2) **`premium_amount` diterima dari klien** (fallback 0,5%) — pembeli bisa mengirim `0`; app tidak mengirimnya, tapi server sebaiknya mengabaikan field itu. (3) **Premi tidak pernah ditagih** — tidak ada debit dompet maupun baris di checkout. (4) Opt-in kedua menabrak `UNIQUE (order_id)` sebagai error database; usulan: `409 POLICY_EXISTS`. |

#### Ulasan Saya + ubah ulasan 30 hari — docs/22 #8

| | |
|---|---|
| **`GET /me/reviews?page=`** | Ulasan milik user login, terbaru dulu; 20 per halaman. |
| Respons `200` | Array — [`order/my_reviews.json`](order/my_reviews.json). Field: `id`, `order_id`, `order_item_id`, `product_id`, `store_id`, `product_name` (snapshot `order_items.product_name_snapshot`), `variant_options` (snapshot; objek atau string JSON), `rating`, `comment`, `is_anonymous`, `created_at`, `updated_at`, **`editable_until`** (= `created_at` + 30 hari), **`is_editable`** (dihitung server terhadap jam server). `meta`: `{page, per_page, total}` — seperti `GET /products/{id}/reviews`, bukan `/orders` yang tanpa `meta`. |
| **`PATCH /reviews/{id}`** | Body `{"rating": 1-5, "comment": "…" (string kosong = hapus teks), "is_anonymous": 0 \| 1}`. Media tidak diubah lewat endpoint ini. |
| Respons `200` | Ulasan hasil perubahan, bentuk sama dengan satu baris `GET /me/reviews` (**bukan** `data: null`, supaya app tidak perlu membaca ulang). Server juga menghitung ulang `products.rating_avg`. |
| Error | `422 REVIEW_EDIT_WINDOW_CLOSED` (lewat 30 hari) · `404 REVIEW_NOT_FOUND` (tidak ada / milik orang lain) · `422 VALIDATION_ERROR` (`rating` di luar 1–5, `comment` > 500 — hari ini `POST /order-items/{id}/review` tidak memvalidasi `rating` sama sekali). |
| UI | Layar "Ulasan Saya" (tombol "Ubah Ulasan" + "Bisa diubah sampai …", atau pil "Terkunci"); formulir ulasan dalam mode ubah ("Ubah Ulasan" / "Simpan Perubahan"). |
| Perilaku mock | Daftar awal dari fixture, **tanggalnya digeser relatif ke hari ini** (satu masih bisa diubah, satu sudah lewat 30 hari), nama produk berawalan "Produk Simulasi". Ulasan yang dibuat lewat `POST /order-items/{id}/review` sungguhan ikut ditambahkan (nama produk diambil dari `GET /orders/{id}` terakhir). Perubahan hanya tersimpan di mock — ulasan di halaman produk tidak ikut berubah. |

#### Tidak di-mock (endpoint sudah ada)

| Endpoint | Catatan untuk backend |
|---|---|
| `GET /orders`, `GET /orders/{id}` | **Usulan field `payment_transaction_id`** (nullable) — tanpa itu pesanan `pending` tidak bisa dibayar ulang dari detail/daftar pesanan. App memakainya begitu dikirim; sementara itu memakai tautan lokal yang disimpan saat `checkout/confirm` (`OrderPaymentLinkStore`), yang tidak berlaku untuk pesanan dari perangkat lain. |
| `POST /media/upload` | Dipakai untuk bukti komplain (multipart `file`, `context=complaint_evidence`; app membatasi JPG/PNG/WEBP/MP4/MOV/WEBM ≤ 10 MB, server menerima ≤ 20 MB). 🔴 `url` di respons dirakit dari `$config['base_url']` yang masih `http://localhost:8080/marketplace-api/` — host-nya salah. App meneruskan URL itu apa adanya. `422 UPLOAD_FAILED` membawa pesan pustaka CodeIgniter (tidak ditampilkan; app memetakan kodenya). |
| `POST /orders/{id}/refund-request` | **Usulan field `evidence_urls`** (array URL dari `/media/upload`, opsional) — app sudah mengirimnya; controller hari ini hanya membaca `reason` dan `amount`, jadi field itu **diabaikan diam-diam**. Usulan penyimpanan: kolom `order_refunds.evidence_urls JSON` (pola yang sama dengan `insurance_claims.evidence_urls`), dan ikut di `refund` pada `GET /orders/{id}`. Endpoint ini juga **tanpa gerbang status**. |
| `GET /orders/{id}/invoice` | App membuat PDF A4 **di perangkat** dari JSON ini (tombol "Download Invoice (.PDF)"). **Usulan field `shipping_address_masked`** — `{recipient_name: "B*** S******", phone: "0812*****890", full_address: "J** M***** **", city, province, postal_code}` — karena respons hari ini mengirim nama, HP, dan alamat pembeli **utuh** (docs/22 #6); app menyensornya sendiri dengan aturan yang sama. Metode pembayaran dan kurir tidak ada di respons, jadi tidak tercetak. |
| `POST /orders/{id}/confirm-delivery` | Kode segel dibuat `generate_readable_code('SEAL', 8)` = **13 karakter** (`SEAL-XXXXXXXX`). Dialog app sebelumnya meminta 6 karakter sehingga pesanan Secure+ tidak mungkin dikonfirmasi; sudah diperbaiki di app. |
