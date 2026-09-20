# Integration tests — app sungguhan, backend sungguhan

Berkas di sini mem-boot **pohon widget yang sama dengan `main()`**, menekan
tombol aslinya, dan membiarkan layar memanggil API sendiri.

Ini **bukan** pengganti `test/integration/`. Keduanya berbeda tujuan:

| lapisan | yang dijalankan | yang dibuktikan |
|---|---|---|
| `test/integration/` | service + Dio, tanpa widget | **kontrak endpoint**: bentuk respons, kode error, kejanggalan server |
| `integration_test/` | app utuh di perangkat sungguhan | **layarnya tersambung** ke endpoint itu, dan alurnya bisa dilalui |

`flutter test` hanya memungut `test/`, jadi berkas ini **tidak pernah ikut
berjalan tanpa sengaja** di lingkungan yang tidak punya backend.

```bash
# Backend harus hidup dan ter-seed lebih dulu — lihat "Menyalakan backend dev"
# di CLAUDE.md, atau §1 panduan integrasi FE di repo API.
curl -s http://localhost:8000/api/v1/health

flutter test integration_test/member_journey_test.dart -d macos
```

## Enam hal yang menghabiskan waktu kalau tidak tahu

**1. Target macOS.** Dulu ini **keharusan**: backend tidak mengirim header
`Access-Control-*` sama sekali dan menjawab `OPTIONS` dengan `405`/`401`, jadi
build web tidak bisa menghubunginya sama sekali — setiap request diblokir
browser, dan Dio melaporkannya sebagai kegagalan jaringan sehingga app
menampilkan "No internet connection" padahal server sehat.

**Backend sudah memperbaikinya** (20 September 2026, di `index.php` sebelum CI
bootstrap): preflight dijawab `204`, dan header CORS terpasang pada respons
sukses **maupun** respons error. Diverifikasi ulang dari sisi sini — handshake
browser penuh untuk `POST /auth/login` dan `GET /me` sama-sama lolos. Jadi
build web kini bisa memanggil API.

macOS tetap jadi target test ini karena alasan yang berbeda: menjalankan
`integration_test` di Chrome menuntut **chromedriver** (`flutter drive` +
driver di port 4444), yang belum terpasang di mesin ini. Bukan lagi karena API
tidak bisa dihubungi.

**2. `macos/Runner/*.entitlements` wajib punya
`com.apple.security.network.client`.** Tanpa itu app sandbox memblokir semua
request keluar, dan gejalanya **persis seperti backend mati**. Repo ini dulu
tidak punya entri itu di `DebugProfile` maupun `Release`; keduanya sudah
ditambahkan bersama test ini.

**3. Satu berkas per invokasi.** `flutter test integration_test` dengan
beberapa berkas gagal — berkas kedua tidak bisa start app karena instance
pertama belum melepas perangkatnya.

**4. `DevicePreview` dilewati.** `main()` membungkus app dengan DevicePreview
saat debug, dan frame perangkat simulasinya membuat hit-test bergantung pada
penskalaan preview — koordinat tap jadi meleset. Test memanggil inisialisasi
yang sama (`CachedHelper.init()`, `initialize()`), membersihkan sesi tersimpan,
lalu `pumpWidget(Phoenix(child: MyApp()))` langsung.

**5. Build debug macOS butuh beberapa GB kosong.** Saat disk penuh,
kegagalannya sama sekali tidak terbaca sebagai masalah disk — `lipo: can't
write to output file` di dalam `Target debug_unpack_macos failed`. Cek
`df -h` dulu.

**6. `Failed to foreground app; open returned 1` itu normal.** Muncul di setiap
run dan tidak menggagalkan apa pun; app tetap berjalan di latar.

## Pola yang wajib, kalau tidak testnya rapuh

**Jangan `pumpAndSettle` untuk menunggu jaringan.** Ia berhenti saat tidak ada
animasi terjadwal — bisa **sebelum** respons datang — dan kalau ada indikator
berputar, ia justru tidak pernah selesai. Pakai `pumpUntil(finder)`, yang
memompa sampai finder cocok atau waktunya habis. Sesudah cocok, **pompa
beberapa frame lagi**: setiap rute memakai `FadeThroughTransition`, dan widget
yang sudah *ada* masih bisa menolak tap selagi animasinya berjalan.

**`ensureVisible` sebelum tap.** Tombol kirim di formulir panjang dan kartu di
beranda sering di luar layar; tap ke sana mengenai kekosongan dan gagal dengan
pesan yang menyesatkan.

**`tester.pageBack()` tidak bekerja.** `customAppBar` membuat tombol kembalinya
sendiri dari `GestureDetector`, bukan `BackButton` Material yang dicari
`pageBack()`. Cari `GestureDetector` yang membungkus
`Icons.arrow_back_ios_new_outlined`.

**Tunggu bukti, bukan penanda yang sudah ada.** Menunggu "Tambah ke Keranjang"
sesudah menekan "Tambah ke Keranjang" langsung lolos — tombolnya memang sudah
di sana — dan langkah berikutnya berangkat selagi `POST` masih terbang. Tunggu
sesuatu yang **hanya muncul setelah** permintaannya selesai (di sini:
snackbar-nya).

**Periksa keadaan widget, bukan teks di sekitarnya.** Tombol beli mati bukan
cuma karena "Stok habis" — "Stok tidak diketahui" juga mematikannya. Membaca
`tester.widget<FilledButton>(...).onPressed != null` menangkap keduanya.

**Jangan assert pada nama data seed.** Seed di-build ulang berkala dan idnya
berubah. Assert pada tipe widget dan teks UI, bukan `"Kopi Arabika Gayo 250g"`.

**Assert juga pada panggilan HTTP.** `LoggingInterceptor` memang mencetak
endpoint yang dipanggil, tapi `flutter test -d macos` **tidak meneruskan stdout
app** ke runner, jadi log itu tidak bisa dibaca test. Karena testnya berjalan
**di dalam proses app yang sama**, ia menempel langsung ke instance `Dio` milik
app dan mencatat tiap request. Tanpa itu, layar yang diam-diam membaca state
lama akan lolos — daftar pesanan yang terisi dari cache terlihat persis sama
dengan yang benar-benar membaca `GET /orders`.

## Dua bahasa dalam satu alur

Layar auth masih memakai `S.of(context)` milik UI kit, yang default-nya **`en`**
("Register", "Create Account"). Layar yang sudah ditulis ulang menembak API
memakai teks **Indonesia hardcoded** ("Tambah ke Keranjang", "Bayar"). Test
harus mengikuti apa yang benar-benar tampil, bukan apa yang konsisten.

## Yang diasumsikan `member_journey_test.dart`

**Mendaftarkan akun baru tiap run.** Belum ada akun buyer-murni di seed —
sembilan akun seed semuanya merangkap penjual — jadi pengalaman pembeli baru
hanya bisa diuji dengan mendaftar.

**Mencari produk yang benar-benar bisa dibeli.** Test ini **mengonsumsi stok**:
setiap run membuat pesanan sungguhan. Produk pertama karena itu tidak bisa
diandalkan — run sebelumnya mungkin sudah menghabiskannya. Kartunya disusuri
sampai ada tombol beli yang hidup, dan kalau tidak ada satu pun, pesan
gagalnya menyuruh seed ulang.

## 🔴 Batas yang tidak bisa dilewati, dan tidak dipalsukan

**Tidak ada pesanan yang bisa mencapai `paid` di lingkungan ini.** Callback
pembayaran menolak signature lalu **500 saat mencatat penolakan itu** — ia
menulis `payment_transaction_id = 0` yang melanggar foreign key. Jadi alur
pasca-bayar (lacak kiriman → terima barang → ulas) **tidak bisa** diuji ujung
ke ujung sampai backend memperbaikinya.

Test ini karena itu berhenti di `pending` dan memastikan pesanannya muncul di
daftar dengan status "Menunggu pembayaran". Itu batas sungguhan, bukan langkah
yang dilewati diam-diam.
