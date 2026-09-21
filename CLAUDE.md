# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **This document has two parts, and they do not describe the same thing.**
> **Part 1 — Current state** is what the code actually is today; re-verified against the repo on 13 September 2026 and against a running, seeded backend on 14 September 2026.
> **Part 2 — Target architecture** is where the project is headed. Its foundation (env, network, DI, `DataState`) and the auth domain are built; every other feature domain is not.
> Never run a command or follow a pattern from Part 2 until the corresponding migration step is done. If the two parts conflict, Part 1 wins for any change you make right now.

## Project identity

Buyer app for a **multi-vendor marketplace**, built on a purchased Flutter UI kit. All three names were unified on 13 September 2026:

- Directory / GitHub repo: `marketplace-app-member`
- Dart package name (`pubspec.yaml`): **`marketplace_app_member`** — absolute imports are `package:marketplace_app_member/...`. Renaming this breaks every absolute import, in `lib/` and in all four `test/` directories.
- Bundle id: `com.marketplace.member` (Android `namespace` + `applicationId`, iOS/macOS `PRODUCT_BUNDLE_IDENTIFIER`, Linux `CMakeLists.txt`). The Android `MainActivity.kt` package **must** match the namespace — the manifest resolves `.MainActivity` against it — so the file lives at `android/app/src/main/kotlin/com/marketplace/member/`.

`MaterialApp.title` and the visible product copy still say Shopapay/Markas in places; those are product decisions, not identifiers.

---

# Part 1 — Current state

## Commands

```bash
flutter pub get                       # install dependencies
flutter run                           # run on connected device/emulator
flutter analyze                       # static analysis (flutter_lints 4.0.0 via analysis_options.yaml)
flutter test                          # run all tests (462; all pass)
# Integrasi: butuh backend hidup, WAJIB serial — DAN penghitung rate limit auth
# harus dikosongkan dulu, kalau tidak ~100 test merah dengan 429. Lihat
# "Rate limit auth" di Part 2.
mysql -u root --socket=/Applications/XAMPP/xamppfiles/var/mysql/mysql.sock \
  marketplace -e "DELETE FROM auth_rate_limits;"
flutter test test/integration --concurrency=1
flutter test integration_test/member_journey_test.dart -d macos  # app sungguhan, satu berkas per invokasi
flutter test test/data                # one directory
flutter test test/data/auth_repository_impl_test.dart                       # single file
flutter test test/ui --plain-name 'token ditolak server berujung logout'    # single test case
flutter build apk --release           # Android
flutter build ios --release           # iOS
```

Regenerate localizations after editing `lib/l10n/*.arb`:

```bash
dart run intl_utils:generate          # requires: dart pub global activate intl_utils (not a declared dev_dependency)
```

`build_runner` **is now installed and required** for `lib/config/env/env.g.dart`:

```bash
dart run build_runner build          # after editing .env or any freezed/json model
dart run build_runner watch          # while iterating
```

Note: `build_runner` 2.15 **removed `--delete-conflicting-outputs`** — passing it prints a warning and is ignored. Drop the flag.

## Architecture

`dio` and `get_it` **are** wired now — `initialize()` runs before `runApp` and registers a named `"api"` Dio plus the services and repositories that exist. The tree splits two ways, and telling them apart is the first thing to get right before editing:

| tree | data source | safe to build on? |
|---|---|---|
| `lib/ui/main/{auth,catalog,cart,address,checkout,order,payment,wishlist,review,wallet,notification,reward,chat}/` | marketplace-api, live | **yes** — `catalog` is the reference implementation |
| `lib/features/` (the UI kit's sample tree) | hardcoded lists inside cubits (`HomePageCubit.productsTShirt`) | as sample UI only |

The third tree that used to sit between them — a complete data + UI stack written against the old Markas backend — **was deleted on 14 September 2026**. See "~~The dead layer~~" in Part 2 for what went and the endpoint translation table that survived it.

The UI kit's own models (`lib/features/home/data/models/product_model.dart`) carry `fromJson` factories, but they were shaped for the kit's sample JSON, not for marketplace-api — treat them as sample data. The real one is `lib/core/domain/model/catalog/product_model.dart`.

### Feature-first layout

```
lib/core/       # cross-cutting: routes, theme, styles, constants, cached prefs, shared widgets
lib/features/<feature>/data/models/
lib/features/<feature>/presentation/{cubits,views,views/widgets}
lib/generated/  # Flutter Intl output — DO NOT EDIT
lib/l10n/       # .arb translation sources
```

The convention is applied loosely: `favorites`, `trending`, and `spalsh` are single files with no `presentation/` layer. Directory names contain typos that are part of the real paths — `spalsh` (splash), `presentaion` (profile only), and `notifications&messages` (literal `&`). Match the existing spelling rather than "fixing" it, or every import breaks.

### State: Cubits with mutable fields, not immutable state

`flutter_bloc` cubits are created **locally** — each view wraps its own body in `BlocProvider(create: ...)` inside `build()`. There is no global provider and no DI container.

Cubits hold **public mutable fields** (`currentIndex`, `products`, controllers) and emit **marker states** that carry no data (`class HomeChangeBottomNav extends HomeLayoutState {}`). `BlocBuilder` reacts to the emit, then reads the field off the cubit. Follow this pattern; do not convert to data-carrying states piecemeal. (Part 2 replaces this with freezed sealed unions — a deliberate, project-wide migration, not a per-file change.)

Every cubit exposes `static XCubit get(context) => BlocProvider.of(context);` — used as `HomePageCubit.get(context)`.

`MyBlocObserver` (`lib/core/utils/bloc_observer.dart`) logs all cubit lifecycle in debug.

`lib/core/cubits/app_cubit.dart` (`AppCubit`) is **dead code** — never provided or referenced. The live theme toggle is the top-level function in `components.dart` (below).

### Navigation: go_router, one flat table

All routes live in one file, [app_routes.dart](lib/core/utils/app_routes.dart): an `AppRoutes` class of path string constants plus a single flat `GoRouter` route list. Every route uses `FadeThroughTransitionPageWrapper` for a consistent transition. Arguments are passed untyped via `state.extra` and cast (`state.extra! as String`).

The `router` object is global and often called directly (`router.go(AppRoutes.onboarding)` in the splash screen) rather than through `context.go`. Adding a screen = add a constant to `AppRoutes` + a `GoRoute` entry with the wrapper.

Note: `AppRoutes.contactUs` is registered twice; the first entry wins.

### Theming: preferences-driven, not `Theme.of(context)`

This is the most important convention to get right. `lightTheme`/`darkTheme` exist in [app_theme.dart](lib/core/utils/app_theme.dart), but **widgets almost never read `Theme.of(context)`**. Instead every color decision is written inline as:

```dart
color: isAppDarkMode() ? kDarkSecondColor : kLightSecondColor,
```

`isAppDarkMode()` reads SharedPreferences **synchronously** via `CachedHelper.getData(kAppTheme)`. Colors are `k`-prefixed constants in [constant.dart](lib/core/utils/constant.dart). New UI should use these constants + `isAppDarkMode()`, not theme lookups.

**Theme and language changes restart the app.** `toggleAppTheme()` / `changeAppLanguage()` in [components.dart](lib/core/function/components.dart) persist the value then call `Phoenix.rebirth(context)`. This is why `CachedHelper.init()` must complete before `runApp` in [main.dart](lib/main.dart) — the whole app reads prefs synchronously at build time.

### Text and spacing helpers

- **Text**: `AppStyles.styleSemiBold16(context)` etc. in [app_styles.dart](lib/core/utils/app_styles.dart). Every style takes `context` because font size is scaled by `getResponsiveFontSize()` against a 375pt base width, clamped to ±20%. Never hardcode a `TextStyle` with a raw `fontSize`.
- **Spacing**: extensions in [extensions.dart](lib/core/utils/extensions.dart) — `16.pa`, `16.ps`/`.pe` (start/end), `.pt`/`.pb`, `.psh`/`.psv` all return **`EdgeInsetsDirectional`** (RTL-aware — important, Arabic is supported). Gaps use `12.sbh` / `12.sbw` for `SizedBox`. Screen size via `context.screenWidth` / `context.screenHeight`.
- **Assets**: referenced through `AppImages` constants; `assets/images/` and `assets/icon/` are glob-registered in `pubspec.yaml`, so new files need only an `AppImages` entry.
- **App bar**: `customAppBar(context, title, action: ...)` in [custom_app_bar.dart](lib/core/function/custom_app_bar.dart).

### Localization

Generated by the **Flutter Intl IDE plugin** (Localizely), not `flutter gen-l10n`. `lib/generated/l10n.dart` and `lib/generated/intl/*` are generated — edit `lib/l10n/*.arb` and regenerate. Usage in views: `final l = S.of(context); ... l.home`.

Adding a language: add `lib/l10n/intl_<code>.arb`, regenerate, then add a `LanguageModel` to `supportedLanguages` in [language_model.dart](lib/features/shared/models/language_model.dart) (this list drives the settings picker and RTL direction, and is separate from `S.delegate.supportedLocales`).

Current state: `en` and `ar` are complete (284 keys) and selectable. `fr` appears in `S.delegate.supportedLocales` but `intl_fr.arb` is **empty** and `fr` is not in `supportedLanguages` — so device-locale French resolves to a locale with no translations. Either fill it in or drop it.

## Known rough edges

- The Flutter counter template `test/widget_test.dart` is **gone** — the suite is real (462 tests, all passing) and is a usable signal. `test/integration/` (141 of those) hits a live backend, so it fails with connection errors when the API is not running; that is the environment, not a regression. Note the API is started with `php -S`, **not** `docker compose` — see "Menyalakan backend dev" in Part 2 — and the integration suite must run `--concurrency=1`.
- 14 stale `*.dart~` backup files litter `lib/` (and `android/`). They are not compiled but **do show up in grep results** — always confirm a hit isn't in a `~` file before editing.
- `lib/features/my_cart/presentation/views/map_screen.dart` is 100% commented out, and the `com.google.android.geo.API_KEY` meta-data in `android/app/src/main/AndroidManifest.xml` is commented out too. Restoring the map needs both, plus an iOS key. Location permissions are already declared in the manifest.
- **The app builds now, but every image is a placeholder.** The UI kit's asset folders were never copied into this repo, so all 67 files in `assets/images/` and `assets/icon/` are grey 64×64 stubs, and the `Hanimation` font declaration in `pubspec.yaml` stays **commented out** (a fake OTF crashes at start, so it could not be stubbed — all text falls back to the system font). What you see on screen is therefore not the kit's design. `assets/PLACEHOLDER-README.md` documents what was stubbed and how to restore the originals.
- Android `usesCleartextTraffic` / iOS ATS are **not** configured, so the `http://` base URL will fail on mobile. Not needed for the current web target; required before the first Android/iOS run.
- `DevicePreview` wraps the app when `kDebugMode`, so debug builds render inside a simulated device frame — layout that looks wrong in debug may be the preview frame, not the code.
- Orientation is locked to portrait in `main()`.
- `flutter_launcher_icons` and `flutter_native_splash` config blocks in `pubspec.yaml` are commented out, though `flutter_launcher_icons.yaml` / `flutter_native_splash.yaml` exist at the root.

---

# Part 2 — Target architecture

> ### 📘 BACA DULU: `docs/20-frontend-integration-guide.md`
>
> ⚠️ **Nomornya sudah berubah dua kali: 18 → 19 → 20** (21 September 2026). Slot 19 kini dipakai `19-security-audit-findings.md`, slot 18 oleh `18-reward-engine.md`. Berkasnya **tetap belum di-commit** di repo API — ia ada di working copy saja, jadi `git log` tidak akan menunjukkan perubahannya. Periksa `git status` repo API, bukan hanya `git log`. Jangan menyalin nomornya ke catatan baru tanpa mengecek: ia bergeser tiap kali backend menambah dokumen.
>
> Backend menerbitkan **panduan integrasi frontend khusus untuk app member & app seller** (14 September 2026). Itu titik masuk tunggal untuk pekerjaan FE: cara menjalankan API, kontrak dasar, peta 33 modul → endpoint → app mana yang memakainya, alur inti buyer dari browse sampai terima barang, dan daftar jebakan yang sudah diuji ke server. Poin bertanda **[terverifikasi]** di sana sudah ditembak ke server sungguhan, bukan dibaca dari dokumen.
>
> Urutan otoritas kalau sumber saling bertentangan: **`application/config/routes.php` > panduan 20 > Postman > docs lainnya.** Seluruh catatan di bawah ini sudah diselaraskan dengan panduan itu dan diverifikasi ulang ke server pada 14 September 2026.
>
> ### 🔴 Rate limit auth — dan kenapa ia mematikan suite integrasi (21 September 2026)
>
> Backend v1.2.0 (commit `17df39e`) membatasi endpoint auth. Lewat batas → `429` dengan `error.code = TOO_MANY_REQUESTS`:
>
> | endpoint | batas | jendela |
> |---|---|---|
> | `POST /auth/login` | **5× per email** | 15 menit |
> | `POST /auth/login` | **20× per IP** | 15 menit |
> | `POST /auth/resend-verification` | 3× per email | 1 jam |
> | `POST /auth/forgot-password` | 3× per email | 1 jam |
> | `POST /auth/reset-password` | 10× per IP | 1 jam |
>
> Sisi aplikasi sudah ditangani: `ApiErrorCode.tooManyRequests` dipetakan di `error_message.dart` jadi pesan tersendiri, dan **tidak ada retry otomatis** — satu-satunya retry di `auth_interceptor.dart` hanya menyala pada `401`. Pesannya sengaja tidak menyebut angka menit: server **tidak** mengirim `Retry-After` maupun sisa waktu di `details` (diperiksa ke seluruh kode API).
>
> 🔴 **Penghitungnya bertambah SEBELUM `password_verify`, jadi login yang BERHASIL pun dihitung.** Diuji langsung ke server: lima login berturut-turut dengan password yang **benar** lolos, yang keenam dibalas `429`. Ini bukan pertahanan brute-force — ia mengunci user yang tidak pernah salah password sekali pun. Dipatok di `test/integration/auth_service_test.dart`.
>
> Dampaknya melampaui test. Batas **20× per IP** yang juga menghitung keberhasilan berarti satu IP CGNAT operator seluler — yang di Indonesia dibagi ribuan pelanggan — bisa mengunci pengguna yang tidak berbuat apa-apa. Perbaikan lazimnya: hitung percobaan **gagal** saja, lalu kosongkan penghitung begitu login berhasil.
>
> **Akibatnya untuk `test/integration/`**: suite ini punya ~135 test yang masing-masing mendaftar + login di `setUp`, jadi ia menembus batas per-IP di sekitar test ke-21 — **100 dari 140 test merah**, semuanya `429`. Tidak ada cara mengakalinya dari sisi FE: `register` tidak mengembalikan token, `verify-email` juga tidak, dan `proxy_ips` kosong sehingga `X-Forwarded-For` diabaikan. Suite **sengaja tidak ditulis ulang** supaya muat di 20 login — lihat alasannya di `test/integration/support/test_account.dart`. Sampai backend memperbaikinya:
>
> ```bash
> # kosongkan penghitung di DB dev sebelum/selama menjalankan suite
> mysql -u root --socket=/Applications/XAMPP/xamppfiles/var/mysql/mysql.sock \
>   marketplace -e "DELETE FROM auth_rate_limits;"
> ```
>
> `registerAndLogin`/`loginAs` di `test/integration/support/test_account.dart` mengubah kegagalan berantai itu jadi **satu pesan yang menyebut sebab dan jalan keluarnya**, bukan 100 error tanpa konteks.
>
> ### 🔁 Backend ganti total pada 13 September 2026
>
> Aplikasi ini sekarang berbicara ke **marketplace-api** (`~/Desktop/Harlan/marketplace-api`), sebuah **marketplace multi-vendor umum** model Tokopedia/Shopee — bukan lagi Markas Bangunan. Dokumennya di `<api-repo>/docs/00-…15-*.md` plus koleksi Postman di `<api-repo>/postman/`. Base URL: **`http://localhost:8000/api/v1`** (port 8000, bukan 80).
>
> Seluruh peringatan backend lama yang dulu ada di sini **dihapus**, bukan diarsipkan: semuanya menyangkut endpoint yang tidak ada lagi (`/offers`, `/sku-master`, `/cart/view`, RFQ, tier PROJECT), dan membiarkannya hanya menyesatkan. Riwayatnya ada di git sampai commit `b18380e`.
>
> **Yang selamat tanpa perubahan:** amplop `{success, data, error}` + `meta`, nama kode error (`UNAUTHENTICATED`, `INVALID_CREDENTIALS`, `VALIDATION_ERROR`, `NOT_FOUND`), angka-sebagai-string, dan tinyint sebagai `"0"`/`"1"`. Jadi `DataState`, `parseEnvelope`, dan seluruh `json_converters` dipakai apa adanya.
>
> **Yang hilang beserta fiturnya:** satuan majemuk, kalkulator kebutuhan, tier harga PROJECT/B2B, RFQ & kontrak bertahap, struktur order tiga lapis, dan retur berbasis `shipment_id`. `TokenStore.isB2B` kini selalu `false`, tapi **belum dihapus** — ia masih dibaca `CatalogHomeCubit` dan masih memilih label `'Harga proyek (B2B)'` di `catalog_home_screen.dart`, serta menyaring `PriceTierModel` bersegmen `PROJECT` yang tidak pernah lagi dikirim server. Semuanya ikut terbuang bersama lapisan mati di bawah.
>
> ### ✅ Bug header `Authorization` case-sensitive SUDAH TIDAK ADA
>
> Ini penghalang terbesar backend lama: hanya ejaan `Authorization` persis yang diterima, sehingga `dart:io` — yang melowercase nama header — membuat **seluruh Android/iOS/desktop tidak bisa memakai endpoint ber-token**. Di API ini ketiga ejaan sama-sama dijawab **200**, diverifikasi ke server dan dipatok di `test/integration/auth_service_test.dart`. Native hidup lagi, dan tidak ada lagi `skip: kIsWeb` di test integrasi.
>
> ### 🔴 `verify-email` menaikkan status tapi tidak pernah menyetel `email_verified`
>
> Sudah dibuktikan ke server: akun baru lahir `status: "pending_verification"`. `POST /auth/verify-email` mengubahnya jadi `"active"` — **tapi kolom `email_verified` tetap `"0"` selamanya**, sementara tokennya sudah terpakai (panggilan kedua dibalas `INVALID_TOKEN`).
>
> Karena itu `UserModel.isVerified` membaca **`status`**, bukan `email_verified`. Aplikasi yang menunggu kolom itu berubah akan menahan user di layar "verifikasi dulu" tanpa jalan keluar.
>
> Verifikasi juga **bukan gerbang login**: akun `pending_verification` tetap diberi token. Jangan memblokir masuk karenanya.
>
> ### ⚠️ Tiga kontrak yang berbeda dari dokumen dan koleksi Postman
>
> Semuanya ditemukan dengan menembak server, bukan membaca dokumen:
>
> | hal | yang tertulis | yang sebenarnya |
> |---|---|---|
> | `POST /auth/register` → `phone` | tampak opsional di contoh Postman | **wajib**; tanpa itu `422 VALIDATION_ERROR` "Field wajib belum lengkap" dengan `details: null` — tidak menyebut field mana |
> | `POST /auth/register` → respons | — | **tanpa token apa pun**, hanya `user_id` + `dev_verification_token`. Wajib disusul `login`; itu sebabnya `AuthRepository.register` menggabungkan keduanya |
> | `PATCH /me` → respons | — | `data: null`. Perubahannya tersimpan, tapi user hasilnya tidak dikembalikan — repository membaca ulang `GET /me` |
>
> Login juga **berbasis email**, bukan nomor HP, dan responsnya **tidak membawa data user sama sekali** — identitas hanya dari `GET /me`. `expires_in` = **900 detik**, bukan 2 jam, jadi refresh berjalan sering dan single-flight di `TokenRefresher` jadi penting.
>
> ### ⚠️ URL tak dikenal membalas HTML, bukan amplop JSON
>
> CodeIgniter menyajikan halaman 404 HTML untuk rute tak terdaftar. Body itu sampai ke `ApiException` sebagai `ClientErrorCode.badResponse`, dan sebelum diperbaiki ia lolos sebagai `isDataNotFound` — artinya salah ketik URL di aplikasi tampil ke user sebagai "data tidak ditemukan". `DataError.isRouteNotFound` kini ikut menganggap `badResponse` + 404 sebagai kesalahan rute.
>
> **Rute yang benar pun bisa membalas HTML**: error SQL dan exception PHP keluar sebagai halaman 500 HTML, bukan amplop JSON — terbukti pada `POST /me/addresses` dengan field asing dan pada `GET /recommendations/recently-viewed`. Jadi `badResponse` harus ditangani di setiap panggilan, bukan hanya diasumsikan sebagai salah ketik URL.
>
> ### ⚠️ Peran kini jamak
>
> Satu akun boleh merangkap Buyer, Seller, Affiliate, dan seterusnya; `GET /me` mengembalikan `roles[]` berisi `{code, name}` plus `stores[]`. **Jangan** menulis `user.role == 'buyer'` — pakai `hasRole`/`isBuyer`.
>
> ### ✅ Database sudah di-seed — penghalang menulis lapisan katalog SUDAH HILANG
>
> Diverifikasi 14 September 2026 dengan akun buyer sungguhan: seluruh alur beli — `cart/items` → `checkout/sessions` → `shipping-options` → `shipping` → `confirm` → `orders/{id}` → `payments/{id}/pay` — **berhasil dijalankan sampai keluar QR string**. Catatan lama yang bilang "`/products` kosong, jadi lapisan katalog sengaja belum ditulis" **tidak berlaku lagi**.
>
> Seed sekarang: **133 tabel, 51 kategori, 8 toko, 19 produk, 9 user**. **DB sering di-seed ulang** — akun probe dan order hasil percobaan hilang tanpa aba-aba, jadi jangan menyandarkan test pada id yang di-hardcode.
>
> Panduan 18 §3 memuat **9 akun seed lengkap dengan password** (`budi.santoso@kedaikopi.id` / `RahasiaAman123`, dst; semuanya `active` dan terverifikasi). Pakai itu untuk test integrasi alih-alih mendaftar akun baru tiap kali. Belum ada akun buyer-murni — daftar sendiri kalau perlu menguji pengalaman member baru.
>
> ### ⚠️ `docker compose up` TIDAK jalan — API dijalankan dengan `php -S`
>
> Catatan sebelumnya di file ini yang menyarankan `docker compose up -d` **salah**. `Dockerfile` menyalin `infra/docker/nginx.conf` yang tidak ada di repo, dan stage runtime-nya nginx tanpa php-fpm. Cara yang benar ada di panduan 20 §1: siapkan MySQL, jalankan `database/schema/*.sql` lalu `database/seeds/*.sql`, kemudian `php -S 127.0.0.1:8000 -t . router.php` dengan `router.php` yang isinya diberikan di panduan itu (tidak ada di repo).
>
> Konsekuensinya untuk `/search/*`: **Elasticsearch/OpenSearch di 9200 tidak punya cara mudah dinyalakan**, jadi anggap search mati secara default dan pakai fallback yang dijelaskan di bawah.
>
> ### 🔧 Menyalakan backend dev (langkah nyata, sudah dijalankan)
>
> Servernya mati tiap mesin reboot, dan `router.php` **tidak ada di repo** — kalau ia pernah ditaruh di direktori sementara, ia ikut terhapus dan seluruh request dibalas `Fatal error: Failed opening required …`. Taruh di root repo API, seperti disarankan panduan §1:
>
> ```bash
> # 1. MySQL (XAMPP) — butuh hak root, nyalakan lewat XAMPP Control Panel
> ls /Applications/XAMPP/xamppfiles/var/mysql/mysql.sock   # cek sudah hidup
>
> # 2. router.php di root repo API (jangan di-commit)
> cat > ~/Desktop/Harlan/marketplace-api/router.php <<'EOF'
> <?php
> $path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
> if ($path !== '/' && is_file(__DIR__ . $path)) return false;
> $_SERVER['SCRIPT_NAME'] = '/index.php';
> require __DIR__ . '/index.php';
> EOF
>
> # 3. Jalankan — socket XAMPP wajib disebut, PHP CLI Homebrew tidak menemukannya sendiri
> cd ~/Desktop/Harlan/marketplace-api && php \
>   -d mysqli.default_socket=/Applications/XAMPP/xamppfiles/var/mysql/mysql.sock \
>   -S 127.0.0.1:8000 -t . router.php
>
> curl -s http://localhost:8000/api/v1/health
> ```
>
> ### ✅ CORS sudah ada — build web bisa memanggil API (20 September 2026)
>
> Sampai 20 September 2026 backend **tidak mengirim satu pun header `Access-Control-*`** dan menjawab `OPTIONS` dengan `405` (endpoint `/auth/*`, yang `extends REST_Controller` langsung) atau `401` (sisanya, yang constructor-nya memanggil `authenticate_or_fail()` sebelum routing method). Akibatnya **build web tidak bisa menghubungi API sama sekali** — dan gejalanya menyesatkan: Dio melaporkannya sebagai kegagalan jaringan, sehingga app menampilkan "No internet connection" padahal server sehat. Itu yang dulu memaksa `integration_test/` menarget macOS.
>
> Backend memperbaikinya di `index.php`, **sebelum CI bootstrap** — satu-satunya tempat yang berjalan lebih dulu daripada constructor mana pun dan `_remap()`. Diverifikasi ulang dari sisi sini: preflight `204` di ketiga jenis endpoint, header terpasang pada respons **sukses maupun error**, `Allow-Credentials` sengaja tidak ada (app tidak memakai cookie), dan pemanggil non-browser tidak terpengaruh.
>
> Dua jalan buntu yang sempat terlihat masuk akal, dicatat supaya tidak diulang:
>
> - **Menambahkan `*_options` ke `$public_actions`** tidak bisa bekerja: `MY_REST_Controller` merangkai nama method dengan verb HTTP, jadi `index_options` tidak akan pernah cocok dengan `'index_get'` yang terdaftar.
> - **`$config['check_cors'] = TRUE`** di `application/config/rest.php` tidak berpengaruh apa pun: berkas config itu memuat delapan opsi CORS, tapi `REST_Controller.php` yang di-bundle **tidak membaca satu pun** — config-nya berasal dari versi library yang lebih baru daripada yang dipakai.
>
> Kalau `POST /checkout/sessions` mendadak **500**, kemungkinan besar skema DB tertinggal dari repo API. Periksa `git diff <commit-lama>..HEAD -- database/` lalu jalankan berkas schema yang baru (`22_cart_applied_voucher.sql`, `23_reward_engine.sql`, dst) — bukan seluruh folder, supaya seed lama tidak tergandakan.

**Status: foundation (steps 1-5) plus the auth domain implemented.** What exists today:

- `lib/config/env/env.dart` + `.env` + `.env.example` (envied; `API_BASE_URL`)
- `lib/config/network/` — `dio_client.dart` (named `"api"` Dio), `api_envelope.dart`, `api_exception.dart`, `token_refresher.dart`, `interceptors/{auth,logging}_interceptor.dart`
- `lib/core/data_state.dart` — `DataState<T>` union
- `lib/core/services/` — `token_store.dart`, `auth_events.dart`
- `lib/util/` — `format_helper.dart`, `json_converters.dart`
- `lib/di/` — `injector.dart` (called from `main.dart` before `runApp`), `injector_service.dart`, `injector_repository.dart`. Berisi `AuthService`/`AuthRepository` dan `CatalogService`/`CatalogRepository`; keduanya menembak endpoint yang benar-benar ada.
- **Auth domain** — `AuthSessionModel` + `UserModel` (freezed), `AuthService`, `AuthRepository`/`AuthRepositoryImpl`, `AuthCubit`/`AuthState`, and the API-wired `LoginScreen`/`RegisterScreen` under `lib/ui/main/auth/`
- **Catalog domain** — model, service, repository, cubit, dan layar di bawah `lib/core/…/catalog/` + `lib/ui/main/catalog/`; lihat "Domain katalog" di bawah
- **Cart domain** — `lib/core/…/cart/` + `lib/ui/main/cart/`; menegakkan pembatasan kuantitas yang tidak dilakukan server, lihat "Domain keranjang" di bawah
- **Address + Checkout domain** — `lib/core/…/{address,checkout}/` + `lib/ui/main/{address,checkout}/`; memuat jalan memutar untuk tiga bug server, lihat "Domain alamat & checkout" di bawah
- **Order + Payment domain** — `lib/core/…/{order,payment}/` + `lib/ui/main/{order,payment}/`; melengkapi alur beli, lihat "Domain pesanan & pembayaran" di bawah
- **Wishlist + Review domain** — `lib/core/…/{wishlist,review}/` + `lib/ui/main/{wishlist,review}/`; lihat "Domain wishlist & ulasan" di bawah
- **Wallet domain** — `lib/core/…/wallet/` + `lib/ui/main/wallet/`; lihat "Domain dompet" di bawah
- `lib/util/error_message.dart` — maps `DataError.code` to localized copy; **never** shows `error.message` to users
- **Notification domain** — `lib/core/…/notification/` + `lib/ui/main/notification/`; lihat "Domain notifikasi" di bawah
- **Reward domain** — `lib/core/…/reward/` + `lib/ui/main/reward/`; lihat "Domain reward" di bawah
- **Chat domain** — `lib/core/…/chat/` + `lib/ui/main/chat/`; lihat "Domain chat" di bawah
- Tests: `test/util/` (17, murni), `test/data/` (162, fake service/store + parsing JSON asli), `test/ui/` (142, fake repository), `test/integration/` (141, butuh backend hidup — **jalankan `--concurrency=1`**, dan kosongkan `auth_rate_limits` dulu) — **462 total, semuanya lulus**
- **`integration_test/`** — app sungguhan di perangkat sungguhan, **di luar `flutter test`**; lihat "Test app sungguhan" di bawah

Still absent: Firebase and `lib/firebase_options.dart`.

### ~~The dead layer~~ — sudah dihapus (14 September 2026)

**Lapisan mati warisan backend Markas sudah tidak ada lagi.** 97 berkas dibuang: 9 service, 3 repository impl + 3 antarmuka, 48 berkas model, dan 33 berkas layar di `lib/ui/main/{cart,checkout,home,order,product,wallet}`, beserta registrasi DI, rute, dan entri menu yang menunjuk ke sana. Yang tersisa dari lapisan lama hanya `RepositoryGuard` — ia agnostik backend dan menegakkan kontrak "repository tidak pernah throw".

Tabel di bawah **dipertahankan sebagai peta terjemahan**, bukan daftar utang: ia berguna saat menulis ulang domain berikutnya (cart, checkout, order, wallet) dan saat membaca commit lama. Dari 53 path yang dulu dipanggil, 37 sudah tidak ada di marketplace-api:

| called by the app | marketplace-api equivalent |
|---|---|
| `/offers`, `/offers/{id}`, `/offers/facets`, `/offers/prices`, `/offers/best-sellers`, `/offers/flash-sale` | `/products`, `/products/{id}`, `/stores/{id}/flash-sales` |
| `/offers/{id}/reviews`, `/offers/reviews-summary` | `/products/{id}/reviews` |
| `/sku-master`, `/sku-master/{id}` | `/products/{id}/variants` |
| `/cart/view`, `/cart/add`, `/cart/remove`, `/cart/clear` | `GET /cart`, `POST /cart/items`, `PATCH`/`DELETE /cart/items/{id}`, `/cart/summary` |
| `/cart/voucher`, `/cart/voucher_remove` | `/cart/apply-voucher` — **tidak ada rute untuk melepas voucher** |
| `/checkout` | `/checkout/sessions` + `/shipping-options`, `/shipping`, `/address`, `/confirm`, `/cancel` |
| `/addresses`, `/addresses/{id}` | `/me/addresses`, `/me/addresses/{id}` |
| `/payments/initiate`, `/payments/detail` | `/payments/{txId}/pay`, `/payments/{txId}`, `/payment-methods` |
| `/shipments/{id}`, `/sub-orders/{id}` | `/orders/{id}/tracking` — order sekarang **satu lapis**, bukan tiga |
| `/search` | `/search/products` |
| `/sellers/directory` | `/stores/search` |
| `/wishlist/add`, `/wishlist/remove` | `POST /wishlist/items`, `DELETE /wishlist/items/{id}` |
| `/wallet/history` | masuk ke dalam `GET /wallet` |

No equivalent at all: `/brands`, `/zones`, `/fleet-types`, `/config/parameters`, `/categories/{id}`, `/chat/seller_response_rate`, `/payments/manual_transfer_proof`, `/shipments/{id}/complete`, `/vouchers`.

### Domain katalog — implementasi rujukan

Katalog adalah domain pertama yang ditulis ulang menembak marketplace-api, dan bentuknya yang ditiru domain berikutnya:

```
lib/core/domain/model/catalog/     product_model.dart (+ variant/image/courier/flash sale),
                                   category_model.dart, product_facets.dart
lib/core/data/datasources/…/       catalog_service.dart      — HTTP + cache detail per id
lib/core/data/repositories/        catalog_repository_impl.dart — pakai RepositoryGuard
lib/core/domain/repositories/      catalog_repository.dart   — antarmuka untuk cubit
lib/ui/main/catalog/               cubit/, screens/, widgets/
```

Keputusan yang sengaja diambil dan sebaiknya dipertahankan:

- **`ProductModel.stock` nullable, bukan `@Default(0)`.** `null` = "belum diketahui" (item listing), `0` = "benar-benar habis". Memberi default 0 akan menandai seluruh listing sebagai habis, karena `GET /products` memang tidak mengirim stok. `isOutOfStock` membedakan keduanya.
- **Satu model untuk listing dan detail**, karena listing benar-benar subset detail — bukan dua bentuk berbeda.
- **Aturan harga tinggal di model** (`effectivePrice`, `strikethroughPrice`, `discountPercent`), bukan di widget, supaya listing dan detail tidak pernah menampilkan harga berbeda untuk produk yang sama.
- **`CatalogLoaded` membawa `isLoadingMore` dan `loadMoreError`** alih-alih memancarkan `loading()` saat menambah halaman — kalau tidak, layar yang sedang dibaca user akan kosong setiap kali ia menggulir.
- **Kegagalan `GET /categories` tidak menggagalkan layar**; produk tetap tampil tanpa baris kategori.
- **Pencarian memakai `GET /products?q=`, bukan `/search/products`** — lihat catatan Elasticsearch di atas. `CatalogService` sengaja tidak punya method untuk `/search/*`.

Tesnya terbagi tiga, dan pembagian itu disengaja: `test/data/catalog_model_test.dart` (memakai potongan JSON yang disalin apa adanya dari server), `test/ui/catalog_home_cubit_test.dart` (repository palsu), `test/integration/catalog_service_test.dart` (server sungguhan — mematok kejanggalan bentuk data supaya perubahan diam-diam di backend menjadi test merah, bukan layar rusak).

#### Estimasi ongkir di halaman produk

`GET /products/{id}/shipping-estimate?address_id=&variant_id=` menjawab "berapa ongkir ke alamat saya?" **tanpa membuat sesi checkout**.

Kata "tanpa" itulah nilainya: satu-satunya cara lain mengetahui ongkir adalah `POST /checkout/sessions`, yang **mereservasi stok 15 menit**. Memakainya untuk sekadar mengintip ongkir berarti menahan stok orang lain setiap kali seseorang penasaran.

Balasannya **memakai ulang `ShippingOptionModel` milik checkout** — bentuknya benar-benar sama, dan dua salinan akan berbeda diam-diam begitu salah satunya diperbarui. Sudah disaring menurut `store_couriers` dan **urut termurah**, jadi opsi pertama langsung dipakai sebagai "ongkir mulai dari". **Butuh login**, berbeda dari `GET /products/{id}` yang publik.

Berbeda dari banyak endpoint lain di API ini, **tiap penolakannya punya kode sendiri** dan tidak diseragamkan: `422 VALIDATION_ERROR` tanpa `address_id`, `404 ADDRESS_NOT_FOUND`, `404 VARIANT_NOT_FOUND`, `401 UNAUTHENTICATED`, `409 STOCK_INSUFFICIENT`. Semuanya diuji.

Keputusan yang membentuk `ShippingEstimateCubit`:

- **Hampir semua kegagalan menyembunyikan seksinya**, bukan memunculkan error. Ongkir di sini informasi pelengkap; belum masuk, belum punya alamat, atau jaringan bermasalah tidak layak jadi spanduk error di halaman produk. Stok habis pun disembunyikan — indikator stok di halaman yang sama sudah mengatakannya.
- **Nol opsi kurir tetap ditampilkan**, sebagai "belum ada kurir yang melayani alamat ini". Sejak backend menyaring per toko ini mungkin terjadi, dan lebih baik diketahui **sebelum** barangnya masuk keranjang — tanpa kurir, checkout buntu di pemilihan pengiriman.
- **Alamatnya dipilih dengan `primaryAddressOf` yang sama dengan checkout.** Kalau berbeda, angka yang diintip di halaman produk tidak cocok dengan yang dibayar.
- **Alamat tak lengkap tidak dipakai** — checkout pun menolaknya, jadi ongkirnya akan menyesatkan.
- Alamatnya **ditahan setelah panggilan pertama**, sehingga berganti varian hanya menembak estimasi, bukan `/me/addresses` lagi.

### Domain keranjang — dan lubang validasi di server

Keranjang ditulis setelah katalog dan mengikuti bentuk yang sama, dengan dua perbedaan yang disengaja.

**1. `CartRepository` mengembalikan `CartSnapshot`, bukan `void`, untuk setiap mutasi.** Ini dipaksa API: `PATCH` dan `DELETE` membalas `data: null`, **dan mutasi terhadap baris yang tidak ada pun dibalas `200`** (terverifikasi: `PATCH /cart/items/99999999` sukses). Artinya status sukses **bukan bukti** sesuatu berubah — satu-satunya cara tahu keadaan keranjang adalah membacanya ulang. Repository yang menanggung baca-ulang itu, supaya tidak ada layar yang lupa.

**2. `CartCubit` adalah satu-satunya tempat kuantitas dibatasi.** 🔴 **Server tidak memvalidasi kuantitas sama sekali** — `quantity: 999999` untuk varian berstok 150 dibalas `200` dan benar-benar tersimpan; `0` juga diterima. Konsekuensinya:

- Kuantitas dipotong ke `CartCubit.maxQuantityPerLine` (999) sebelum dikirim. Itu angka kewarasan, bukan aturan bisnis — **`GET /cart` tidak mengirim stok**, jadi layar keranjang memang tidak bisa tahu batas sesungguhnya. Batas terhadap stok ditegakkan di halaman detail produk, yang tahu `variant.stock`.
- Kuantitas `< 1` **menghapus baris**, tidak dikirim sebagai `0`. Mengirim `0` diterima server dan menyisakan baris hantu berkuantitas nol yang tetap tampil dan tetap dihitung `item_count`.
- Ketukan ganda pada baris yang sama diabaikan selagi permintaan pertama berjalan (`mutatingItemIds`), supaya dua permintaan tidak saling mendahului.

Bentuk data yang mudah salah ditebak:

- **Grup toko di `GET /cart` hanya membawa `store_name`, tanpa `store_id`.** Id-nya ada di tiap item; `CartStoreGroup.storeId` menurunkannya dari item pertama. Checkout membutuhkannya sebagai kunci pemilihan kurir per toko.
- **`GET /cart/summary` berisi `subtotal`, `item_count`, `vouchers`, dan `discount_amount`** — semuanya **angka asli**, bukan string. Dua field terakhir ditambahkan bersama penumpukan voucher; catatan lama di sini yang menyebut "hanya dua field" sudah tidak berlaku. Ongkir tetap **tidak** ada di sini — baru muncul di `checkout/sessions/{id}/shipping-options`.
- **Ringkasan hanya menghitung baris tercentang**, dan `item_count` menghitung **baris**, bukan unit — dua baris berisi 5 dan 1 unit tetap `2`. Karena itu layar menulis "N barang terpilih", bukan "N barang".
- **`POST /cart/items` untuk varian yang sudah ada menggabungkan kuantitas** ke baris lama dan mengembalikan id baris itu — bukan membuat baris baru. Id balasannya kadang number, kadang string.
- Baris keranjang membawa data produk terdenormalisasi (`product_name`, `sku`, `price`, `variant_options`), jadi layar keranjang **tidak perlu** menembak `/products/{id}` per baris. Yang tidak ada: gambar dan stok.
Satu-satunya validasi server yang benar-benar ada di endpoint ini: varian tidak dikenal dibalas `404 VARIANT_NOT_FOUND`.

#### ✅ Voucher keranjang: kini bertumpuk, dan BISA dilepas (commit `90751bf`)

Catatan lama di sini — "tidak ada endpoint untuk melepas voucher, jangan sediakan tombolnya" — **sudah tidak berlaku**. Yang berubah:

- **`POST /cart/apply-voucher` sekarang MENYIMPAN**, bukan sekadar pratinjau, lewat tabel baru `cart_applied_vouchers` (jadi bertahan setelah reload dan lintas perangkat).
- **Beberapa voucher boleh terpasang sekaligus**: maks 1 voucher ongkir + 1 platform + 1 **per toko**. Kategorinya diturunkan dari field yang sudah ada (`discount_type=free_shipping` → ongkir, `store_id` null → platform, selebihnya → toko), bukan kolom baru. Memasang voucher ke slot yang sudah terisi **mengganti** yang lama, bukan ditolak.
- **`DELETE /cart/vouchers/{code}` ada sekarang** → `CartService.removeVoucher`. Seperti mutasi keranjang lainnya, `200` bukan bukti apa pun: melepas kode yang tidak pernah terpasang tetap `200`.

Field body `apply-voucher` adalah **`code`**, bukan `voucher_code` — dicek ke controllernya (`$this->post('code')`). Bedanya tidak kelihatan dari percobaan: nama field yang salah menghasilkan `VOUCHER_INVALID` yang sama persis dengan kode voucher yang salah.

🔴 **Dua nilai di `vouchers[]` yang TIDAK boleh ditampilkan sebagai potongan.** `discount_amount` per voucher sengaja diisi begini oleh server:

| jenis | `discount_amount` | alasan |
|---|---|---|
| voucher **ongkir** | **`null`** | ongkir belum dihitung di keranjang; nilainya baru ketahuan saat checkout |
| voucher **cashback** | **`0`** | cashback **tidak** mengurangi yang dibayar — nilainya jadi coins setelah pesanan selesai |

Menampilkan `null` sebagai `Rp0` membuat voucher ongkir terlihat tidak berguna; menampilkan cashback sebagai potongan membuat **total yang dilihat pembeli tidak cocok dengan yang ditagih**. `AppliedVoucherModel.reducesPayment` membedakannya. Konsekuensinya juga: `discount_amount` ringkasan yang nol **tidak** berarti tidak ada voucher terpasang.

Server **membuang sendiri voucher yang sudah tidak valid** terhadap isi keranjang saat ini (`list_applied_vouchers` menghapusnya dari tabel), jadi daftar yang sampai ke aplikasi selalu masih berlaku.

⚠️ **Jalur suksesnya belum bisa diuji**: tidak ada voucher yang di-seed (`GET /me/vouchers` → `[]`), jadi memasang voucher yang benar-benar berlaku mustahil di dev — `vouchers` selalu `[]`. Bentuk entrinya **diturunkan dari sumber backend** (`Cart_model::validate_voucher()`), bukan dari respons yang teramati; periksa ulang begitu ada voucher sungguhan. Layar voucher sengaja belum dibuat sampai ada data.

🔴 **`GET /cart/recommended-vouchers` membalas 500 kalau keranjang KOSONG.** Bukan "endpointnya rusak" — `list_eligible_vouchers` menyusun `store_id IN ()` yang bukan SQL sah saat tidak ada toko di keranjang. Dengan keranjang terisi ia `200`. Catatan sebelumnya di file ini yang menyebutnya rusak total **terlalu luas**: probe-nya kebetulan dijalankan sebelum keranjang diisi. Layar voucher nanti tidak boleh memanggilnya sebelum ada isi; keduanya dipatok test.

### Domain alamat & checkout — dan tiga bug server

Ditulis setelah keranjang, dan paling banyak menabrak keanehan server dari semua domain sejauh ini.

#### ✅ Drift dua zona waktu SUDAH DIPERBAIKI (19 September 2026)

Dulu satu respons checkout memakai dua zona sekaligus: `created_at: "2026-09-15 07:52:59"` waktu dinding **WIB**, sedangkan `expires_at: "2026-09-15 01:07:59"` **UTC** — selisihnya tepat 15 menit hanya kalau `expires_at` digeser +7 jam. Penyebabnya PHP `date()` mengikuti `php.ini date.timezone` (UTC) sementara kolom lain diisi `CURRENT_TIMESTAMP` MySQL (WIB). Aplikasi menambalnya dengan converter khusus `ServerUtcDateTimeJson`.

Backend memperbaikinya di commit **`93c6a14`** dengan `date_default_timezone_set('Asia/Jakarta')` di `application/config/config.php` — sengaja di kode, bukan di `php.ini`, supaya tidak bergantung konfigurasi PHP di luar aplikasi. Commit `0d09a26` dan `8a8cb85` menuntaskan sisanya (validasi voucher dan worker cron).

**`ServerUtcDateTimeJson` sudah dihapus**; `expires_at`, `payment_deadline`, dan `expired_at` kini memakai `ServerDateTimeJson` seperti field waktu lainnya. Yang menemukan perubahan ini adalah **test integrasi yang memaku selisih 15 menit / 1 jam** — ketiganya merah dengan selisih 7:15:00 dan 8:00:00 begitu server diperbarui. Kalau pola itu muncul lagi, driftnya kembali.

#### ✅ `PATCH /checkout/sessions/{id}/address` SUDAH DIPERBAIKI

Dulu selalu 500: controllernya membaca body dengan `$this->post('address_id')` pada rute PATCH, sehingga nilainya selalu `null` dan `UPDATE … SET shipping_address_id = NULL` ditolak foreign key. Ketiga encoding sama-sama gagal, jadi aplikasi mengganti alamat dengan `cancelSession` lalu `startSession` — cara yang bekerja tapi **melepas lalu mengambil ulang reservasi stok**, sehingga user bisa kehilangan barangnya ke pembeli lain hanya karena salah pilih alamat.

Diperbaiki backend di commit **`8235c33`**, dan kepemilikan alamat divalidasi di **`28adce7`**. Diverifikasi ke server: `shipping_address_id` benar-benar berubah dan status sesi tetap `stock_reserved`. `CheckoutService.changeAddress` kini mengubahnya di tempat.

⚠️ Balasannya `data: null` (repository membaca ulang), dan **alamat milik orang lain maupun `address_id` yang tidak dikirim sama-sama dibalas `422 VALIDATION_ERROR`** dengan pesan identik. Tidak berdampak besar karena aplikasi hanya menawarkan alamat milik user sendiri — di praktiknya kode itu berarti alamatnya baru saja terhapus.

#### 🔴 `selected_couriers` tersimpan sebagai string JSON

Yang paling menjebak, karena **balasan `PATCH .../shipping` mengirim field bernama sama sebagai objek sungguhan** — sementara yang tersimpan di sesi berupa string. Tanpa `JsonMapJson`, `GET /checkout/sessions/{id}` melempar `type 'String' is not a subtype of type 'Map<String, dynamic>?'` **persis setelah user memilih kurir**, di tengah alur checkout. Ditemukan hanya karena test integrasi menjalankan alur beli sungguhan, bukan potongan JSON karangan. Berlaku juga untuk `applied_vouchers` dan `cart_snapshot`.

#### Perilaku lain yang dipatok test

- **Alamat tanpa validasi**: `POST /me/addresses` dengan seluruh field kosong dibalas `201` dan tersimpan. Kelengkapan divalidasi `AddressCubit` + formulir; `AddressModel.isComplete` yang jadi acuan, dan checkout hanya menawarkan alamat yang lolos.
- **Nama field alamat**: `full_address` dan `is_primary`. ⚠️ Nama ala Markas (`address_line`, `district`, `is_default`) dulu membuat server membalas **500 HTML**; sejak commit `a1ef5ec` field asing **dibuang diam-diam** dan responsnya `201`. Gagalnya jadi lebih senyap, bukan hilang — lihat catatan whitelist di bawah.
- **Boleh ada beberapa alamat "utama" sekaligus** — menyetel `is_primary` pada alamat kedua tidak melepas tanda pada yang pertama. Karena itu ada `primaryAddressOf` (pemilihan deterministik) dan `AddressRepositoryImpl.setPrimary` yang melepas tanda lama satu per satu.
- **Sesi yang dibatalkan berstatus `expired`**, bukan `cancelled` — sama dengan sesi yang lewat tenggat.
- **`order_ids` berupa array**: keranjang multi-toko pecah jadi satu order per toko, tapi tetap satu `payment_transaction_id`.
- **Konfirmasi kedua dibalas `422 CHECKOUT_CONFIRM_FAILED`.** Itu satu-satunya perlindungan yang ada — `Idempotency-Key` belum diimplementasikan backend, jadi **jangan pernah mengulang `confirm` secara otomatis**. `CheckoutCubit` juga menolak panggilan kedua selagi yang pertama berjalan.
- **Checkout menghapus baris tercentang dari keranjang**, dan hanya itu — baris yang tidak dicentang tetap tinggal, karena memang tidak ikut ke sesi. Karena itu layar keranjang membaca ulang saat kembali dari checkout alih-alih mengosongkan sendiri.

  Ini **perilaku baru sejak 15 September 2026** (commit backend `08ae0e7`, "Clear checked-out cart items after checkout confirm"). Sebelum itu barang yang sudah dipesan benar-benar tertinggal di keranjang dan bisa di-checkout ulang — double order sungguhan, seperti ditulis sendiri di pesan commit-nya. Catatan di file ini sempat menyebut temuan lama itu sebagai salah baca; **bukan** — temuannya benar, backend-nya yang berubah di antara dua kali pengujian.

#### ⚠️ Opsi kurir kini disaring per toko — nol opsi jadi mungkin

Sejak 15 September 2026 (commit backend `ea86e5d`), `Shipping_model::compute_options()` menyaring kurir menurut `store_couriers` milik toko. **Bentuk responsnya tidak berubah** — yang berubah hanya isinya bisa lebih sedikit.

Rancangannya "default-terbuka": toko yang belum pernah mengatur `store_couriers` tetap mendapat semua tarif aktif, jadi tidak ada toko lama yang mendadak nol opsi. Dan karena tabel itu **belum punya seed sama sekali**, penyaringannya belum bisa diamati di lingkungan dev — test untuk itu akan hampa, jadi sengaja tidak dibuat.

Yang tetap berubah untuk aplikasi: **daftar opsi kosong bukan lagi kasus mustahil.** Tanpa penanganan, user terjebak — tombol Bayar mati selamanya karena konfirmasi menuntut setiap toko punya kurir, sementara barang toko itu tidak bisa dilepas dari dalam layar checkout. Karena itu `_StoreShipping` menampilkan jalan keluar: batalkan sesi lalu kembali ke keranjang.

#### Sesi checkout menahan sumber daya di server

Membuat sesi mereservasi stok **15 menit**. Karena itu `CheckoutCubit.close()` membatalkan sesi yang belum dikonfirmasi — tanpa itu, stok tertahan sampai tenggat hanya karena user menutup layar. Sesi yang **sudah** dikonfirmasi sengaja tidak dibatalkan (reservasinya sudah jadi order).

### Domain pesanan & pembayaran

Domain terakhir dari alur beli. Alur pembeli kini lengkap di aplikasi: katalog → keranjang → checkout → **pembayaran** → **pesanan**.

#### 🔴 `POST /orders/{id}/complete` membalas HTML dengan status 200

Controllernya tidak punya `try/catch` seperti `confirm_delivery_post` yang bersebelahan, jadi `RuntimeException` untuk transisi tidak sah lolos dan dirender sebagai **halaman HTML berstatus `200`**. Dio tidak menganggapnya error (status 2xx), dan `parseEnvelope` menolaknya sebagai `CLIENT_BAD_RESPONSE` — pesan yang tidak bisa dijelaskan ke user.

Dua lapis penjagaan: `OrderService.complete` menerjemahkan `badResponse` jadi `INVALID_TRANSITION`, dan `OrderDetailCubit` **memeriksa status lebih dulu** (`OrderModel.canComplete`) sehingga tombolnya tidak pernah muncul di status yang salah. Bandingkan `/confirm-delivery`, yang membungkus kondisi yang sama jadi `422 VALIDATION_ERROR` dengan rapi.

#### 🔴 `GET /orders` hanya membaca `page`

Controllernya memanggil `list_for_buyer($userId, $page)` — persis satu parameter. Akibatnya:

- **`?status=` diabaikan.** Meminta `completed` tetap mengembalikan `pending` dan `cancelled`. Karena itu `OrderService.fetchOrders` **tidak punya parameter status** dan layar daftar tidak menawarkan filter: filter yang terlihat bekerja tapi tidak menyaring lebih buruk daripada tidak ada. Menyaring di sisi klien juga salah — hanya berlaku pada halaman yang sudah dimuat, sehingga pesanan di halaman berikutnya seolah hilang. (Sisi penjual, `list_for_store`, memang mendukung filter ini.)
- **`?per_page=` diabaikan**; ukuran halaman dipatok **20** di server (`OrderService.serverPageSize`).
- **`meta` tidak dikirim sama sekali** — tidak ada `total`. `OrderListCubit` menyimpulkan adanya halaman berikutnya dari "halaman terakhir terisi penuh", yang berarti satu permintaan sia-sia kalau jumlah pesanan kebetulan kelipatan 20. Itu disengaja — lebih baik daripada diam-diam menyembunyikan pesanan.

#### ⚠️ Metode pembayaran dipilih saat CHECKOUT, bukan saat membayar

Field `payment_method` di body `POST /payments/{txId}/pay` **diabaikan server** — diuji untuk lima metode: transaksi yang dibuat dengan `virtual_account` tetap membalas instruksi VA walau diminta `qris`. Metodenya terikat saat `POST /checkout/sessions/{id}/confirm`. Karena itu pemilihan metode ada di layar checkout, dan `PaymentService.pay` sengaja **tidak punya parameter metode**.

**Bentuk instruksinya berbeda per metode, tanpa field penanda jenis**: `qris` → `{qr_string, expires_at}`, selebihnya → `{va_number, bank, expires_at}`. `PaymentInstructionModel.kind` menyimpulkannya dari field mana yang terisi.

#### Bentuk data lain yang dipatok test

- **Pola zona waktu yang sama dulu berulang di sini**: `payment_deadline` (order) dan `expired_at` (payment) UTC sementara `created_at` WIB. **Sudah diperbaiki** bersama checkout — lihat catatan `93c6a14` di atas; keduanya kini `ServerDateTimeJson`.
- **`shipping_address_snapshot` hanya berisi `{"address_id": "59"}`** — bukan alamat lengkap, dan berupa string JSON. Menampilkan alamat tujuan butuh `GET /me/addresses`.
- **`payments.order_id` selalu `null`.** Transaksi menempel pada `checkout_session_id`: satu pembayaran menutup **semua** order dari sesi itu. Jangan memakainya untuk mencari order.
- Item order memakai **snapshot** nama, harga, dan opsi varian saat order dibuat — pesanan lama tetap benar walau produknya berubah.
- `GET /orders/{id}` untuk pesanan orang lain dibalas **403 `PERMISSION_DENIED`**, bukan 404.
- `GET /orders/{id}/tracking` membalas `data: null` selama belum dikirim. Itu normal, bukan error.

### Domain wishlist & ulasan

Dua domain di luar alur beli, ditulis setelahnya. Keduanya kecil, tapi masing-masing membawa satu jebakan.

#### 🔴 `DELETE /wishlist/items/{id}` memakai **product_id**, bukan `wishlist_item_id`

Baris wishlist membawa **dua id sekaligus** (`wishlist_item_id` dan `product_id`), dan yang diterima endpoint hapus adalah yang kedua. Diuji dengan keduanya sengaja dibuat berbeda. Mengirim id yang salah **tetap dibalas `200`** — jadi kesalahannya tidak terlihat sampai user sadar produk lain yang hilang.

Perilaku lain: menambah produk yang sudah ada **tidak menggandakan** barisnya (tombol simpan aman ditekan berkali-kali), menghapus produk yang tidak ada tetap `200`, dan satu-satunya validasi sungguhan adalah `404 PRODUCT_NOT_FOUND`.

Catatan kecil yang berguna: **wishlist membawa `image_url`**, padahal `GET /products` tidak membawa gambar sama sekali.

#### 🔴 Ulasan hanya bisa dikirim untuk pesanan berstatus `completed`

`POST /order-items/{id}/review` mencari order item lewat `orders.status = 'completed'`. Status lain dibalas **`404 ORDER_ITEM_NOT_FOUND`**, kode yang sama dengan order item yang benar-benar tidak ada. Karena itu `error_message.dart` menerjemahkannya jadi "Ulasan hanya bisa dikirim untuk pesanan yang sudah selesai" — menulis "tidak ditemukan" akan terbaca user sebagai pesanannya hilang.

Konsekuensi untuk pengujian: **alur ulas tidak bisa dijalankan ujung ke ujung dari app member saja**, karena `pending → … → delivered` butuh aksi penjual. Test integrasi hanya memastikan penolakannya, bukan pembuatannya.

#### Yang TIDAK dikirim daftar ulasan, walau tabelnya ada

`list_for_product` masih menyisakan dua lubang, jadi responsnya **tidak membawa**:

- **nama pengulas** — hanya `user_id`, dan tidak ada endpoint publik untuk menukarnya jadi nama. `ReviewModel.displayName` karena itu selalu `'Pembeli'`, dan `is_anonymous` praktis tidak berpengaruh apa pun.
- **foto/video** — tabel `review_media` ada dan `POST` menerimanya, tapi tidak ikut di daftar.

✅ **Balasan penjual kini IKUT** (commit `d614bd8`). Sebelumnya `list_for_product` hanya `SELECT *` dari tabel `reviews`, sehingga balasan yang sudah tersimpan lewat `POST /reviews/{id}/reply` tidak pernah sampai ke siapa pun — bukan ke pembeli, bukan pula ke penjualnya sendiri. Sekarang ada LEFT JOIN ke `review_replies`, aman karena `review_id`-nya UNIQUE.

Bentuknya **objek bersarang** `{reply_text, created_at}` atau `null` — bukan string JSON seperti `data` di notifikasi dan `selected_couriers` di sesi checkout, karena server merakitnya sendiri di PHP. Dimodelkan `ReviewReplyModel`, dan `ReviewModel.hasReply` sengaja memeriksa isinya: endpoint balasan tidak memvalidasi panjang, jadi `reply` bisa ada tapi hampa. ⚠️ **Tanpa nama penjual** — nama tokonya harus diambil dari konteks halaman produk.

⚠️ Belum teramati di server: tidak ada ulasan yang di-seed (`GET /products/1/reviews` → `[]`), jadi bentuknya diturunkan dari kode backend dan dipatok di `test/data/`, bukan dari respons sungguhan. Layar ulasan **belum menampilkannya** — modelnya siap, widgetnya belum.

#### Hal-hal yang di sini justru berjalan benar

Berbeda dari `/orders`, endpoint ulasan **mengirim `meta` lengkap** (`page`/`per_page`/`total`) sehingga paginasi bisa **dihitung**, bukan ditebak — dan **filter `?rating=` benar-benar bekerja**. Histogramnya dihitung server untuk **seluruh produk**, bukan untuk hasil yang tersaring, jadi barnya tetap tampil saat filter menghasilkan nol ulasan.

Jangan tertukar: `meta.rating_histogram` menghitung **ulasan per bintang persis**; `meta.facets.rating` di `GET /products` menghitung **produk per ambang rating** dan bersifat kumulatif.

### Domain dompet

Saldo, riwayat mutasi, topup, dan penarikan.

#### 🔴 Dua penolakan penarikan memakai kode error yang SAMA

`POST /wallet/withdraw` membalas `422 WITHDRAWAL_REJECTED` baik untuk "di bawah minimum" maupun "saldo tidak mencukupi" — yang berbeda hanya `error.message`, sementara panduan FE melarang mencocokkan `message`. Dua situasi yang tindakannya bertolak belakang ("kecilkan nominal" vs "isi saldo dulu") jadi tidak bisa dibedakan.

Karena itu `WalletCubit` **memvalidasi minimum dan kecukupan saldo sendiri sebelum menyentuh jaringan**. Sisanya — `WITHDRAWAL_REJECTED` yang benar-benar sampai dari server — praktis hanya berarti saldo kurang, sehingga pesannya bisa tepat.

⚠️ Minimumnya (`Rp50.000`) **hardcoded di server sebagai fallback**, dengan komentar bahwa nilai aktifnya semestinya dari `admin_settings.min_withdrawal_amount`. Konstanta di aplikasi bisa melenceng kalau admin mengubahnya; server tetap penjaga terakhirnya.

#### Arah mutasi dari `type`, bukan tanda `amount`

Kolom `wallet_transactions.amount` dikomentari "**selalu positif**; arah ditentukan oleh `type`". Menampilkan `amount` apa adanya akan membuat penarikan terlihat seperti pemasukan. `WalletTxType` memetakan sepuluh jenis ke arahnya; jenis tak dikenal sengaja dianggap **kredit**, karena salah tanda pada uang lebih merugikan daripada label yang kurang spesifik — dan `balance_after` tetap menunjukkan kebenarannya.

#### Topup memakai ulang alur pembayaran

`POST /wallet/topup` **tidak menambah saldo**; ia membuat `payment_transactions` berstatus `pending` dan mengembalikan `payment_transaction_id`. Saldo baru dikredit callback penyedia setelah dibayar. Id itu bisa langsung dibuka `PaymentScreen` yang sudah ada — tidak ada layar pembayaran kedua.

#### Yang sengaja tidak dibuat

- **`POST /wallet/transfer`** ada dan berfungsi, tapi menuntut `to_user_id` — **id internal numerik** penerima. Satu-satunya endpoint yang bisa menukar email/nama jadi id adalah `/admin/users*`, yang ditolak `403` untuk token buyer. Jadi tidak ada cara sah bagi app member menemukan id tujuan, dan method-nya tidak dibuat sampai backend menyediakan pencarian penerima.
- **`/stores/{id}/wallet`** — dompet toko, butuh permission `wallet.view`.

#### ⚠️ Mutasi saldo tidak bisa diuji di dev

Satu-satunya jalan menambah saldo adalah callback penyedia pembayaran, yang menuntut HMAC dengan `WEBHOOK_SIGNING_SECRET` yang **tidak ada di repo**. Jadi bentuk baris mutasi diturunkan dari skema (`get_user_wallet` melakukan `SELECT *`, jadi kolom = field) dan diuji di `test/data/`; test integrasi hanya memastikan dompet kosong, bentuk hasil topup, dan penolakan penarikan.

Catatan sampingan: jalur **penolakan** signature callback itu sendiri rusak — ia mencatat `payment_transaction_id: null` yang melanggar foreign key, sehingga signature salah dibalas **500 HTML**, bukan `400 INVALID_SIGNATURE`. Tidak berdampak ke app member (aplikasi tidak pernah memanggil callback).

#### ⚠️ Test integrasi harus dijalankan serial

`php -S` **single-threaded**, sedangkan `flutter test` menjalankan berkas secara paralel. Empat berkas integrasi yang masing-masing mendaftar user, mengisi keranjang, dan membuat order sekaligus membuat server kewalahan — gejalanya kegagalan yang berpindah-pindah, termasuk `/products` yang sesaat mengembalikan daftar kosong. Jalankan dengan:

```bash
flutter test test/integration --concurrency=1
```

#### ⚠️ Test integrasi MENGHABISKAN stok

Test checkout dan order membuat pesanan sungguhan, jadi setiap kali suite dijalankan stok berkurang. Versi awalnya selalu memakai `products[0]`, sehingga suite perlahan menghabiskan stok produk itu lalu **gagal sendiri** dengan `409 STOCK_INSUFFICIENT` — dan benar terjadi setelah beberapa hari.

`test/integration/support/seeded_product.dart` sekarang mencari varian yang masih berstok, jadi suite hijau selama **ada** produk berstok, bukan selama produk tertentu berstok. Kalau seluruh katalog habis, helper itu melempar pesan yang menyuruh seed ulang — jauh lebih berguna daripada `STOCK_INSUFFICIENT` di tengah alur checkout.

### Domain notifikasi

Tiga endpoint: `GET /me/notifications`, `POST /me/notifications/{id}/read`, dan
`POST /me/notifications/read-all`.

#### 🔴 Kotak masuknya praktis SELALU kosong — dan itu bukan bug aplikasi

Ditelusuri ke seluruh kode backend: **satu-satunya pemanggil
`Notification_model->create()` adalah undangan staf toko**
(`store_staff/controllers/Staff.php`). Tidak ada notifikasi yang terbit dari
pesanan, pembayaran, pengiriman, chat, atau voucher — padahal
`notification_templates.code` sendiri mencantumkan `order_paid`,
`order_shipped`, `voucher_expiring`, dan `chat_new_message` sebagai niatnya,
dan tabel `notification_queues` beserta `workers/notification_worker.php` sudah
siap memprosesnya.

Jadi seorang pembeli biasa **tidak akan pernah** menerima notifikasi sampai
backend memasang pemanggilan itu di alur-alurnya. Layar tetap dibangun —
endpointnya nyata dan bentuknya sudah dipatok test — tapi **keadaan kosong
adalah kasus normalnya**, bukan sudut yang jarang. Karena itu `NotificationState`
punya `empty()` tersendiri dengan penjelasan, bukan daftar hampa.

Konsekuensi untuk pengujian: test integrasi harus **menerbitkan notifikasinya
sendiri**, dengan login sebagai dua penjual seed lalu mengundang akun uji
sebagai staf. Kalau suatu saat notifikasi terbit dari alur pesanan, test itu
bisa disederhanakan jadi "beli lalu periksa kotak masuk".

#### 🔴 Urutannya tidak stabil, dan paginasinya ikut terpengaruh

`list_for_user` mengurutkan `ORDER BY created_at DESC` **tanpa pemecah seri**,
sementara `created_at` bertipe `DATETIME` yang resolusinya satu detik. Diuji ke
server: tiga notifikasi yang terbit dalam detik yang sama kembali dengan id 13,
14, 15 — **menaik**, alias terlama dulu, kebalikan dari yang dijanjikan.

Dua akibatnya, keduanya ditambal `NotificationCubit._merge`:

- **urutan tampil salah** untuk notifikasi yang lahir berbarengan → daftar
  diurutkan ulang menurut `(createdAt, id)` menurun. Untuk stempel waktu yang
  berbeda hasilnya sama persis dengan urutan server;
- **paginasi bisa menggandakan atau melewatkan baris**, karena `LIMIT`/`OFFSET`
  di atas urutan tak deterministik tidak menjamin satu baris hanya muncul di
  satu halaman → baris berulang dibuang menurut id saat halaman digabung.

Saat menggabung, baris **lama yang dipertahankan**, bukan salinan dari halaman
baru — kalau tidak, tanda "terbaca" yang baru disetel di aplikasi tertimpa
kembali jadi belum terbaca.

#### Tidak ada endpoint jumlah belum dibaca

Tidak ada `unread-count`, dan responsnya **tanpa `meta`** sama sekali. Jumlah
belum dibaca karena itu hanya bisa dihitung dari halaman yang sudah dimuat —
sebuah **batas bawah**, bukan angka pasti. `NotificationLoaded.unreadLabel`
menambahkan `+` selama `hasMore`, dan **tidak ada lencana di ikon lonceng
beranda**: menampilkannya menuntut satu permintaan tiap aplikasi dibuka untuk
daftar yang selalu kosong, dan angkanya tetap tidak bisa dipercaya.

Seperti `/orders`, `?per_page=` diabaikan dan ukuran halaman dipatok **20** di
server (`NotificationService.serverPageSize`); adanya halaman berikutnya
disimpulkan dari "halaman terakhir terisi penuh".

#### Bentuk data dan perilaku lain yang dipatok test

- **`data` datang sebagai string berisi JSON**, bukan objek — jebakan yang sama
  persis dengan `selected_couriers` di sesi checkout, jadi field-nya memakai
  `@JsonMapJson()`. Nilai di dalamnya pun ikut aturan angka-sebagai-string
  (`{"store_id":"1"}`), jadi `order_id` dibaca lewat `asIntOrNull`, bukan cast.
- **Menandai terbaca dibalas `200` untuk id yang tidak ada maupun milik orang
  lain** — pola "sukses bukan bukti sesuatu berubah" yang sama dengan mutasi
  keranjang. Klausa `WHERE user_id` tetap melindungi datanya; hanya statusnya
  yang menyesatkan. Karena itu `NotificationCubit` memperbarui tandanya
  **optimistis lalu mengembalikannya kalau permintaannya gagal**, alih-alih
  membaca ulang daftar (yang akan menghabiskan satu permintaan penuh dan
  melompatkan posisi gulir setiap kali satu baris disentuh).
- **`type` berupa `VARCHAR(80)` bebas, bukan `ENUM`**, jadi `NotificationKind`
  memetakannya lewat **pencocokan kata kunci berurut**, bukan daftar tertutup.
  Perhatikan `paid` terdaftar terpisah dari `pay`: kata "paid" tidak mengandung
  "pay", jadi mengandalkan satu di antaranya meleset pada `order_paid`.
- Rute `/notifications` sekarang mengarah ke layar ber-API. `NotificationsLayout`
  milik kit — cangkang dua tab (Notifikasi | Pesan) berisi data contoh —
  **tidak dibawa serta**: domain chat belum ditulis, dan tab palsu di sebelah
  tab sungguhan lebih menyesatkan daripada tidak ada tab.

### Domain reward

Poin, koin, tingkat loyalitas, cashback, dan estimasi koin sebelum checkout.

#### 🔴 `POST /me/points/redeem` SENGAJA tidak dibuatkan method

Dua alasan, keduanya diverifikasi ke server dan ke kode backend.

**1. Nominal negatif MENCETAK poin.** Penjaganya ditulis `if ($wallet->balance < $amount) throw`. Untuk `amount = -1000` itu `0 < -1000` yang `false`, jadi lolos — lalu `balance - (-1000)` **menambah** saldo. Diuji: saldo `0` → tukar `-1000` → saldo `1000`, dan poin hasilnya benar-benar bisa dibelanjakan. Nominal `0` juga diterima, dan body tanpa `amount` membalas **500 HTML**.

**2. Menukar poin tidak memberi apa pun.** `redeem_points()` hanya mengurangi `user_points.balance` lalu mencatat satu baris `point_transactions` bertipe `redeem` — dan **tidak ada satu pun kode lain di backend yang membaca baris itu**. Tidak ada voucher terbit, tidak ada saldo dikredit. Tombolnya hanya akan menghanguskan poin user.

Keduanya dipatok test integrasi, jadi perbaikannya akan terlihat. Pola yang sama dengan `WalletService.transfer`: endpoint yang ada tapi tidak bisa dipakai dengan benar tidak dibuatkan method.

#### Bentuk data yang membentuk layarnya

- **`GET /me/points` dan `GET /me/coins` identik**, jadi satu `RewardBalanceModel` untuk keduanya — bukan dua hal berbeda yang kebetulan mirip. Barisnya **dibuat otomatis saat pertama dibaca**, seperti dompet: akun baru dapat `0`, bukan `404`.
- **`GET /me/loyalty` sudah menyisipkan objek `tier`**, jadi nama tingkat tidak butuh panggilan kedua. `GET /loyalty/tiers` (publik) hanya dibutuhkan untuk menghitung jarak ke tingkat berikutnya.
- ✅ **`tier_valid_until` kini sezona dengan `updated_at`.** Catatan sebelumnya di file ini yang menyebutnya UTC **sudah tidak berlaku** — pengukurannya dilakukan sebelum backend menyeragamkan zona waktu (commit `93c6a14`). Diverifikasi ulang: selisihnya tepat satu tahun, tanpa sisa 7 jam.
- **`benefits` pada tier `null` di seluruh seed**, jadi bentuk isinya belum pernah teramati; dibaca lewat `JsonMapJson` supaya string berisi JSON maupun objek sama-sama terserap. Dipatok test supaya ketahuan begitu diisi.
- **Dua angka poin yang berbeda di satu layar.** `user_points.balance` (saldo yang bisa dipakai) terpisah dari `loyalty_memberships.tier_points` (yang menentukan tingkat) — menukar poin **tidak** menurunkan tingkat. Layarnya menjelaskan ini, karena dua angka poin tanpa keterangan pasti membingungkan.
- **Kemajuan ke tingkat berikutnya dihitung dari ambang tingkat SEKARANG**, bukan dari nol. Kalau dari nol, seorang Gold (5000) dengan 12.500 poin terlihat baru 62% menuju Platinum padahal sudah menempuh separuh jarak Gold→Platinum.
- 🔴 **Tidak ada endpoint riwayat poin maupun koin.** `point_transactions` dan `coin_transactions` diisi server, tapi tak satu pun rute membacanya — hanya saldonya yang bisa ditampilkan. Hanya cashback yang punya daftar (`GET /me/cashback`).
- **`GET /me/cashback` hidup tapi tidak tercantum** di daftar rute reward mana pun di dokumen. `[]` di dev karena cashback baru terbit dari pesanan yang selesai.

#### `POST /checkout/calculate` — estimasi koin tanpa mereservasi stok

Rutenya di bawah `/checkout`, tapi muatannya murni reward dan ia **tidak membuat sesi checkout maupun mereservasi stok** — jadi aman dipanggil dari layar keranjang, dan methodnya ditaruh di `RewardService`.

Bentuknya **tidak seragam**: `subtotal` di tingkat teratas sementara angka rewardnya bersarang di `rewards`. Itu alasan ada `RewardPreviewModel.fromResponse` tersendiri.

🔴 **Hasilnya estimasi, bukan saldo.** `status: "pending_release"` berarti koinnya belum masuk — baru dilepas saat pesanan selesai, dan **dibatalkan kalau pesanan batal** (tabel `order_pending_rewards`). Menampilkannya sebagai saldo membuat pembeli mengira sudah punya koin yang belum tentu terbit.

#### ⚠️ Saldo tidak bisa ditumbuhkan secara sah di dev

Poin dan koin hanya bertambah lewat reward engine yang dipicu pesanan **selesai**, dan menyelesaikan pesanan butuh aksi penjual. Jadi test integrasi memaku bentuk respons, pembuatan-otomatis, dan penolakan — bukan perjalanan poinnya. Bentuk baris cashback diturunkan dari skema dan diuji di `test/data/`.

`earn_points` lama memakai `$pointsPerIdr = 0.001` hardcoded; sejak commit `eb18722` nilainya dari tabel `reward_configs` (base rate + pengali per tier + bonus per metode bayar).

#### Layarnya menggabungkan lima endpoint, dan hanya satu yang fatal

`RewardRepositoryImpl.fetchOverview` menembak poin, koin, loyalitas, daftar tier, dan cashback **bersamaan** — di-`await` terpisah supaya kegagalan salah satunya tidak jadi *unhandled async error*. Hanya **saldo poin** yang menggagalkan layar; sisanya boleh kosong. Menampilkan saldo tanpa bar loyalitas jauh lebih berguna daripada layar error penuh karena satu endpoint sampingan bermasalah.

### Test app sungguhan (`integration_test/`)

Lapisan kelima, di luar empat direktori `test/`: mem-boot **pohon widget yang
sama dengan `main()`**, menekan tombol aslinya, dan membiarkan layar memanggil
API sendiri. `flutter test` hanya memungut `test/`, jadi berkas ini tidak
pernah ikut berjalan tanpa sengaja.

| lapisan | yang dijalankan | yang dibuktikan |
|---|---|---|
| `test/integration/` | service + Dio, tanpa widget | **kontrak endpoint** |
| `integration_test/` | app utuh, perangkat sungguhan | **layarnya tersambung** ke endpoint itu |

```bash
flutter test integration_test/member_journey_test.dart -d macos
```

Seluruh rinciannya — enam jebakan setup, pola yang membuatnya tidak rapuh, dan
batas yang tidak bisa dilewati — ada di **`integration_test/README.md`**. Yang
paling mudah menyita waktu:

- **macOS.** Dulu keharusan — backend tidak mengirim header CORS sama sekali dan
  menjawab `OPTIONS` dengan `405`/`401`, sehingga build web **tidak bisa
  menghubungi API sama sekali**. ✅ **Sudah diperbaiki backend** (20 September
  2026, di `index.php` sebelum CI bootstrap; preflight `204`, header terpasang
  pada respons sukses maupun error — diverifikasi ulang dari sisi sini). macOS
  tetap dipakai karena Chrome menuntut **chromedriver** yang belum terpasang,
  bukan lagi karena API tak terjangkau.
- **`macos/Runner/*.entitlements` wajib punya `com.apple.security.network.client`.**
  Repo ini dulu tidak punya entri itu di `DebugProfile` maupun `Release`;
  tanpanya sandbox memblokir semua request dan gejalanya persis seperti backend
  mati. Sudah ditambahkan.
- **Satu berkas per invokasi** — berkas kedua tidak bisa start app.
- **`DevicePreview` dilewati**, karena frame perangkat simulasinya membuat
  koordinat tap meleset.

#### 🔴 Dua bug yang hanya bisa ditemukan lapisan ini

**Layar profil menampilkan identitas orang lain.** Nama, email, dan lencana
terverifikasi di `profile_view.dart` **ditulis langsung di kode** — warisan UI
kit (`Mahmodul Hasan` / `info.mamodul@gmail.com`), dengan centang terverifikasi
yang tampil tanpa syarat. `GET /me` sudah dipanggil dan `UserModel` sudah
lengkap; layarnya saja yang tidak pernah membacanya. Kini dibaca dari
`AuthCubit`, dan lencananya bergantung pada `UserModel.isVerified` — yang
membaca **`status`**, bukan `email_verified` (kolom itu tidak pernah berubah
jadi `1` di backend ini).

Dua kerusakan menyertainya di layar yang sama:

- **Tombol Simpan di "Ubah Profil" adalah `onPressed: () {}`** — formulirnya
  juga tanpa controller, jadi ketikan user dipungut lalu dibuang. Sekarang
  memanggil `PATCH /me`. Formulirnya dipangkas dari empat field jadi satu:
  email jadi teks (identitas login, tidak diterima endpoint), alamat dialihkan
  ke `/me/addresses` yang punya layar sendiri, dan kata sandi diganti tautan
  ke alur reset — **tidak ada endpoint ganti sandi** di backend ini, hanya
  `forgot-password` → `reset-password` lewat token email.
- 🔴 **"Keluar" tidak mengeluarkan siapa pun.** Dialognya hanya
  `router.go(login)`; tokennya tidak pernah dihapus, jadi sesi tetap hidup dan
  app memulihkannya saat dibuka berikutnya. Kini memanggil `AuthCubit.logout()`
  lebih dulu.

`member_journey_test.dart` kini singgah ke tab profil dan memeriksa nama
akun yang baru didaftarkan muncul, nama contoh UI kit tidak, dan lencana
terverifikasi **tidak** tampil untuk akun `pending_verification`.

#### 🔴 Bug pertama yang ditemukan lapisan ini

Test pertama yang ditulis langsung menemukan **tombol "Tambah ke Keranjang"
mati di setiap halaman produk**. `ProductDetailScreen` membuat `CartCubit()`
tanpa `..load()`, sedangkan keadaan awal cubit itu `CartState.loading()` — dan
tombolnya menghitung `busy = cartState is CartLoading`. Tidak ada yang pernah
memindahkan cubit itu dari `loading`, karena satu-satunya jalan keluar adalah
`addItem`, yang butuh tombolnya hidup. Kebuntuan sempurna: **produk tidak bisa
dimasukkan ke keranjang sama sekali.**

Tidak ada test lama yang bisa menangkapnya, dan itu bukan kebetulan:
`CartService` benar (dipatok `test/integration/`), `CartCubit.addItem` benar
(dipatok `test/ui/`), dan test cubit memanggil methodnya **langsung tanpa
melewati tombol**. Yang salah hanya perkawinan keduanya di widget.

Perbaikannya melacak "sibuk" di `_AddToCartButton` sendiri, bukan
menyimpulkannya dari keadaan cubit. Memanggil `CartCubit()..load()` juga akan
menghidupkan tombolnya, tapi dengan ongkos satu `GET /cart` tiap halaman produk
dibuka **dan** satu bug baru: transisi `loading → ready` dari pemuatan itu akan
memicu snackbar "Ditambahkan ke keranjang" sebelum user menekan apa pun.

#### 🔴 Batas yang dilaporkan, bukan dilewati diam-diam

**Tidak ada pesanan yang bisa mencapai `paid` di lingkungan ini.** Callback
pembayaran menolak signature lalu **500 saat mencatat penolakan itu** — ia
menulis `payment_transaction_id = 0` yang melanggar foreign key. Jadi alur
pasca-bayar (lacak kiriman → terima barang → ulas) tidak bisa diuji ujung ke
ujung sampai backend memperbaikinya, dan test berhenti di `pending`.

Ini juga yang membuat **ulasan** tidak bisa diuji ujung ke ujung: ulasan
menuntut pesanan berstatus `completed`.

### Domain chat

Percakapan pembeli↔toko. Lima endpoint, semuanya hidup.

#### 🔴 `/poll` SENGAJA tidak dibuatkan method — ia membekukan seluruh aplikasi

`GET /chat/conversations/{id}/poll` adalah long-polling: ia **menahan request
sampai 25 detik** menunggu pesan baru. Di atas server multi-proses itu wajar.
Di sini tidak — API dijalankan dengan `php -S` yang **single-threaded**.

Diukur dua kali, sebelum dan sesudah pembaruan backend: pollnya menggantung
**25 detik**, dan `GET /products` yang dikirim 4 detik sesudahnya baru dijawab
**21 detik kemudian**. Artinya **satu layar chat terbuka membekukan katalog,
keranjang, dan checkout sekaligus**.

`ChatRoomCubit` karena itu menyegarkan diri dengan **membaca ulang halaman
pertama tiap 5 detik**. Lebih boros satu permintaan kecil, tapi tidak pernah
menahan koneksi. Hidupkan poll hanya setelah backend berjalan di php-fpm —
dan ukur ulang sebelum mempercayainya.

Test integrasi chat juga **tidak menyentuh `/poll`**: satu panggilan akan
membekukan seluruh suite serial, bukan hanya berkasnya.

#### 🔴 Transkrip yang dikembalikan server teracak

`list_messages` mengurutkan `ORDER BY created_at DESC` **tanpa pemecah seri**,
sementara `created_at` bertipe `DATETIME` beresolusi **satu detik**. Hasil
nyata dari server:

```
12  16:55:37   Pesan ke-4
 9  16:55:35   Pesan ke-1
10  16:55:35   Pesan ke-2
11  16:55:35   Pesan ke-3
```

Blok detik menurun, isi tiap detik menaik. Membalik daftarnya menghasilkan
`11, 10, 9, 12` — percakapan yang kacau.

⚠️ **Arah serinya sembarang, bukan konsisten.** Diamati menaik (`9, 10, 11`)
pada satu run dan **menurun** (`19, 18, 17`) pada run lain. Karena itu test
integrasi tidak memaku salah satu arah — yang dipatok adalah fakta
deterministiknya: tiga pesan berbagi satu stempel waktu, sehingga `id` wajib
jadi pemecah seri. `ChatRoomCubit._merge` mengurutkan `(createdAt, id)`
**menaik** (arah baca percakapan) dan membuang baris berulang.

Catatan notifikasi di atas yang menyebut serinya "menaik, alias terlama dulu"
karena itu **terlalu pasti** — testnya sudah diperbaiki agar tidak rapuh.

#### Bentuk data dan perilaku lain yang dipatok test

- **`buyer_unread_count` dan `store_unread_count` permanen `0`.** Kolomnya ada
  di skema, tapi **tidak ada satu pun kode backend yang pernah mengisinya** —
  `send_message` hanya memperbarui `last_message_at`, `mark_read` hanya
  menyentuh `chat_messages.read_at`. Tidak ada lencana "belum dibaca" di daftar
  percakapan; menghitungnya sendiri berarti menembak `/messages` per baris.
  `ChatConversationModel.hasReliableUnreadCount` menandainya eksplisit.
- **`POST /chat/conversations` adalah get-or-create** (`UNIQUE (buyer_id,
  store_id)`), jadi tombol "Chat penjual" aman ditekan berkali-kali. Idnya
  **kadang number, kadang string**: pembuatan pertama `{"id": 5}` dari
  `insert_id()`, panggilan berikutnya `{"id": "5"}` dari baris database.
- **Percakapan baru lahir tanpa `last_message_at`.** MySQL menaruh `NULL` di
  akhir pada urutan menurun, sehingga percakapan yang baru dibuka tenggelam di
  bawah yang lama — `ChatListCubit` mengurutkan ulang memakai `sortedAt`, yang
  jatuh ke `created_at`.
- **Server tidak memvalidasi apa pun.** Body tanpa `content` dibalas `201`
  dengan isi `null`, dan `message_type` di luar `ENUM` tersimpan sebagai
  **string kosong** (MySQL non-strict; diuji dengan `"sticker"`). Karena itu
  `ChatRoomCubit` menolak teks kosong sendiri — gelembung hampa yang terlanjur
  terkirim tidak bisa dihapus.
- **`mark_read` tidak pernah menandai pesan sendiri**: klausanya hanya
  menyentuh pesan yang pengirimnya bukan pemanggil. Jadi centang ganda di
  gelembung sendiri benar-benar berarti lawan bicara sudah membuka percakapan.
- **Tidak ada field "dari saya"** di respons. Sisi gelembung ditentukan dengan
  membandingkan `sender_user_id` terhadap `TokenStore.userId`.
- **Percakapan yang tidak ada dan milik orang lain sama-sama `403
  NOT_PARTICIPANT`** — keduanya tidak bisa dibedakan, jadi layar tidak boleh
  menulis "percakapan dihapus".
- ⚠️ **Judul ruang jatuh ke "Chat" kalau dibuka dari halaman produk.**
  `GET /products/{id}` hanya membawa `store_id`, tanpa nama toko, dan tidak ada
  endpoint publik untuk menukarnya. Nama baru muncul lewat daftar percakapan,
  yang responsnya di-join ke `stores`.

### Kontrak sisi member (diverifikasi ke server, 14 September 2026)

Semua di bawah ini hasil menembak server dengan token buyer, bukan membaca dokumen. Ini yang dipakai saat menulis model — `docs/03-api-documentation.md` tidak memuat satu pun dari detail ini dan sebagian bertentangan.

**Enam kejutan bentuk data yang akan merusak model kalau ditebak:**

1. **`checkout_session_id` adalah UUID string, bukan integer.** `POST /checkout/sessions` membalas `"id": "4e2e1970-cde4-4237-b30e-51866d55bce2"`. Itu sebabnya rutenya `(:any)`, bukan `(:num)`. Model yang menaruh `int id` di sini langsung gagal parse.
2. **`GET /checkout/sessions/{id}/shipping-options` membalas MAP, bukan LIST** — dikunci `store_id` sebagai **string**: `{"1": [ {courier_code, service_code, service_name, zone, weight_kg, cost, etd_min_days, etd_max_days}, … ]}`. Di Dart ini `Map<String, List<ShippingOptionModel>>`. `PATCH .../shipping` juga menerima map berbentuk sama: `{"1": {"courier_code": "jnt", "service_code": "ez"}}`.
3. **`cart_snapshot` dan `shipping_address_snapshot` adalah JSON yang di-*string*-kan**, bukan objek bersarang. Isinya harus `jsonDecode` sekali lagi setelah amplopnya dibuka.
4. **`grand_total` berubah tipe antar endpoint — terbukti, bukan dugaan.** `POST /checkout/sessions` → `"grand_total": 150000` (angka); `GET /checkout/sessions/{id}` → `"grand_total": "150000.00"` (string berdesimal). Inilah alasan setiap field angka wajib lewat converter di `lib/util/json_converters.dart`.
5. **`POST /checkout/sessions/{id}/confirm` membalas `{"order_ids": [1], "payment_transaction_id": 1}`** — `order_ids` **array**, karena keranjang multi-toko pecah jadi beberapa order. Jangan modelkan sebagai satu order.
6. **Order sekarang satu lapis.** `GET /orders/{id}` = order + `items[]` + `status_history[]` + `refund`. Tidak ada `sub_orders`, tidak ada `shipments`. Ongkir ada di order (`shipping_cost`, `courier_code`, `courier_service`, `tracking_number`).

**Field alamat memakai nama lain dari app lama.** `POST /me/addresses` menerima `label`, `recipient_name`, `phone`, `full_address`, `city`, `province`, `city_id`, `postal_code`, `is_primary` (+ `latitude`/`longitude` opsional). Cek `database/schema/01_users_auth.sql` kalau ragu.

⚠️ **Field di luar daftar itu kini dibuang diam-diam** (commit `a1ef5ec`, 21 September 2026). Sebelumnya body request diteruskan mentah ke `INSERT`, sehingga nama ala Markas (`address_line`, `district`, `is_default`) memicu **500 halaman HTML**. Sekarang `create_address`/`update_address` menyaringnya lewat `array_intersect_key`, dan diverifikasi ke server: body berisi `address_line` + `is_default` dibalas **`201`** dengan id sungguhan.

Perubahannya benar — client memang tidak boleh menyelipkan `id` atau `created_at` — tapi **mode gagalnya jadi lebih senyap**: salah nama field tidak lagi meledak, ia menyimpan alamat yang bolong. Aplikasi ini tidak terdampak (nama fieldnya sudah benar dan `AddressModel.isComplete` menyaring alamat tak lengkap sebelum checkout menawarkannya), tapi jangan lagi mengandalkan 500 sebagai tanda salah field. Catatan lain: `update_address` sekarang **tidak melakukan apa-apa** kalau seluruh field yang dikirim asing — `200` tanpa satu pun kolom berubah.

**Tipe data umum:** hampir semua angka dan boolean datang sebagai **string** (`"id": "1"`, `"quantity": "2"`, `"is_active": "1"`, `"base_price": "75000.00"`) — ini perilaku driver MySQL PHP, bukan kesengajaan. Pengecualiannya justru yang penting: `GET /cart/summary` (`subtotal`, `item_count`), seluruh `shipping-options` (`cost`, `etd_*_days`), dan **`stock` di detail produk** datang sebagai **angka asli**. Jangan pernah mengetik field `int`/`bool` karena satu respons kebetulan begitu.

#### Katalog — listing vs detail

**`GET /products` kini membawa `image_url`, tapi masih tanpa stok.** Isinya kolom tabel `products` + `compare_at_price` + `image_url` (+ `flash_sale` bila sedang promo). Stok, varian, dan kurir **hanya ada di `GET /products/{id}`**. **Jangan N+1 request detail per kartu.**

✅ `image_url` ditambahkan backend di commit **`db8a626`**; sebelumnya listing tidak membawa gambar sama sekali dan setiap kartu terpaksa memakai placeholder. Bentuknya **satu URL datar**, bukan `images[]` — dan sebaliknya, `GET /products/{id}` **tidak** mengirim `image_url` melainkan `images[]` bersusun. `ProductModel.primaryImageUrl` menyerap keduanya; jangan membaca `listingImageUrl` langsung.

**`GET /products/{id}` cukup untuk merender seluruh halaman detail** dalam satu request: `variants[]` (masing-masing dengan `stock` **integer** dan `variant_options` berupa JSON opsi), `images[]`, `couriers[]`, `stock` **integer** total lintas gudang, dan `compare_at_price` (harga coret, `null` kalau tidak ada).

**`flash_sale` adalah key OPSIONAL** — ia *tidak ada* saat produk tidak sedang flash sale, bukan `null`. Cek keberadaan key-nya, jangan `?? null`. Bentuknya `{flash_price, sold_count, stock_quota, ends_at}`, dan disisipkan juga ke item listing. `compare_at_price` dan `flash_sale` bisa muncul bersamaan — FE yang memutuskan mana menang (umumnya flash sale).

**Produk tanpa varian tetap punya satu default variant.** `cart_items` dan `order_items` selalu merujuk `product_variant_id`, **tidak pernah** `product_id`.

**Parameter `GET /products`:** `q` (LIKE nama+deskripsi), `category_id`, `store_id`, `min_price`, `max_price`, `min_rating`, `city`, `province`, `courier`, `sort_by` (`latest` default, `popular`, `trending`, `price_asc`, `price_desc`, `rating` — nilai asing diabaikan jadi `latest`), `page`, `per_page` (maks 100).

**Varian membawa `warehouse_city` / `warehouse_province`** (ditambahkan backend 15 September 2026). Dipakai menampilkan "Dikirim dari …" di halaman detail **tanpa memanggil endpoint apa pun**. `null` untuk varian yang tidak punya stok di gudang mana pun. ⚠️ Belum terdokumentasi di panduan FE §8 walau servernya sudah mengirimkannya.

**Dua facet di `meta.facets` berbeda bentuk — jangan satu parser untuk keduanya:**

| | `facets.rating` | `facets.category` |
|---|---|---|
| kapan muncul | **selalu** | **hanya kalau ada `q`** |
| bentuk | `{min_rating, count}` | `{category_id, cnt}` |
| tipe angka | `count` **integer** | `cnt` **string** |
| sifat | kumulatif (`>= n`) | hitung per kategori |

Jangan pula tertukar dengan `meta.rating_histogram` di `GET /products/{id}/reviews` — itu menghitung **ulasan per bintang persis** untuk satu produk (`{total, breakdown:[{rating, count, percentage}]}`), bukan produk per ambang.

#### Dua hal yang mengubah konfigurasi app, bukan sekadar model

**`Idempotency-Key` BELUM diimplementasikan backend.** `docs/03` menyebutnya wajib untuk endpoint finansial, tapi tidak ada kode yang membacanya — idempotensi nyata hanya di level DB. Artinya **retry otomatis pada `checkout/confirm`, `wallet/topup`, dan `wallet/withdraw` berisiko menggandakan transaksi**. Kalau interceptor Dio diberi retry, endpoint-endpoint itu wajib dikecualikan.

**Bahasa bisa dinegosiasikan** dengan urutan `?lang=id|en` → header `X-Language` → `Accept-Language` → default `id` (ketiganya terverifikasi). Tapi ini **tidak menggantikan `lib/util/error_message.dart`**: API hanya punya `id`/`en` sementara app juga mendukung `ar`, dan aturan "jangan pernah tampilkan `error.message` ke user, petakan `error.code`" tetap berlaku. Kirim `X-Language` hanya supaya log dan pesan tak terpetakan terbaca.

**Endpoint member yang rusak / kosong sekarang** (dicek ulang 14 September 2026 sesudah pembaruan backend):

| endpoint | hasil |
|---|---|
| `GET /recommendations/recently-viewed` | ✅ **sudah diperbaiki** — dulu 500, sekarang `200` dengan list. Catatan lama yang menyuruh menghindarinya sudah dicabut |
| `GET /search/products`, `/search/stores`, `/search/autocomplete` | **503 `SEARCH_UNAVAILABLE`** selama ES/OpenSearch 9200 mati — dan itu keadaan normal, lihat catatan docker di atas. **Fallback: `GET /products?q=…`** yang berbasis MySQL dan tetap memberi `meta.facets`. Rancang lapisan search supaya bisa berpindah di antara keduanya |
| `GET /search/trending` | tetap **200** tanpa ES — jangan ikut dimatikan bersama endpoint search lain |
| `GET /home/layout` | **200 tapi `[]`** — tabel home CMS tidak punya seed. Homepage wajib punya tampilan fallback; jangan berasumsi ada minimal satu section |
| `POST /analytics/events` | jalan (**201**), tapi field wajibnya `event_name` — mengirim `event_type` membuat **500** |
| `GET /legal/documents/active` | `404 LEGAL_DOCUMENT_NOT_FOUND` — belum ada dokumen; `requires_reconsent: false` di respons login sejalan dengan itu |
| `GET /vouchers/validate?code=…`, `POST /vouchers/claim` | `422 VOUCHER_INVALID` — belum ada voucher yang di-seed |

**Endpoint member baru** (18 rute ditambahkan backend; total kini 206): `GET /home/layout` (home CMS — lihat `docs/16-home-layout-cms.md`), `GET /categories/{id}/layout`, `GET /couriers` (publik; `jne`, `jnt`, `sicepat`, …), `GET /me/favorite-categories`, `GET /me/vouchers`, `POST /vouchers/claim` (POST saja — GET dibalas 405), `GET /campaigns/{id}/products` (lihat `docs/17-campaign-engine.md`).

**`POST /stores` adalah tombol "Buka Toko".** Tidak ada endpoint "upgrade jadi seller" terpisah — memanggil `POST /stores` yang memberi role `seller` dan mengisi `stores[]` di `GET /me`. Ini satu-satunya endpoint seller yang wajar ada di app member.

**Endpoint privileged memang menolak buyer** (memperkuat deviation 3 di bawah): `/admin/users`, `/admin/settings`, `/stores/{id}/orders`, `/stores/{id}/wallet`, `POST /orders/{id}/accept` semuanya membalas **403 `PERMISSION_DENIED`** dengan pesan menyebut permission yang kurang (`admin.user.view`, `order.view`, `order.process`, …). Kalau kamu melihat kode itu muncul, artinya alur yang sedang dibangun salah sisi.

**Login membawa `requires_reconsent`** (boolean) di samping `access_token`/`refresh_token`/`expires_in`. Field ini **sudah dimodelkan** `AuthSessionModel` sejak commit auth pertama (`45d5794`) dan dipatok `test/integration/auth_service_test.dart` — catatan sebelumnya di file ini yang menyebutnya belum dimodelkan salah.

Yang **belum** ada adalah tindakannya: `true` berarti ada versi baru dokumen legal, dan panduan FE §2 menuntut modal blocking lalu `GET /legal/documents/active` → `POST /legal/documents/{id}/accept`. Masuk backlog langkah 7b, dengan catatan bahwa alurnya **belum bisa diuji**: `/legal/documents/active` membalas `404 LEGAL_DOCUMENT_NOT_FOUND` karena tabelnya belum di-seed.

`expires_in` = 900 detik terbukti berulang kali: token habis dua kali di tengah sesi eksplorasi ini, jadi refresh otomatis bukan kemewahan.

**Register `409` bisa karena email ATAU nomor telepon.** Bedakan lewat `error.code` — `EMAIL_TAKEN` vs `PHONE_TAKEN` — lalu sorot field yang tepat. Keduanya perlu entri di `lib/util/error_message.dart`.

**Upload file** lewat `POST /media/upload`, multipart dengan nama field **`file`**; balasan `201` berisi `{url, file_name, file_size_kb, mime_type}`, dan `url`-nya dikirim di payload JSON berikutnya. ⚠️ `url` dirakit dari `$config['base_url']` yang di repo masih `http://localhost:8080/marketplace-api/` — selama itu belum disetel, URL hasil upload akan salah.

### Presentation lives in two trees right now

`lib/ui/main/auth/` (Part 2) and `lib/features/` (the UI kit's sample tree) coexist deliberately. A screen moves to `lib/ui/` **when it gets wired to the API**, not before — so `login`/`register` moved and were rewritten, while `welcome_view` and `reset_password_view` stayed in `lib/features/auth/presentation/views/`.

**`reset_password_view` is no longer blocked** (an earlier revision of this file claimed the API had no password-reset endpoint — it does). `POST /auth/forgot-password` and `POST /auth/reset-password` are both registered routes, `AuthService.forgotPassword`/`resetPassword` already call them, `AuthRepository` already declares them, and `test/integration/auth_service_test.dart` covers forgot-password against the live server. What is missing is only the last hop — `AuthCubit` exposes neither, and no screen calls them. Wiring that screen is a presentation-layer job now.

The kit's social-login buttons were dropped, not ported — the backend has no OAuth, and a button that does nothing is worse than no button.

### freezed 3 gotcha

A `@freezed` class with custom getters or methods **must** declare a private constructor (`const UserModel._();`), otherwise generation fails with `Getters require a MyClass._() constructor`. Also prefer getters **inside** the class over an `extension`: an extension is only in scope where its own library is imported, so `user.isVerified` silently fails to resolve in a file that imported the model only transitively.

**Backend contract**: the member app talks to **marketplace-api** (CodeIgniter 3 modular HMVC + JWT), a multi-vendor marketplace. Reference material lives in that repo, not this one. Start at **`docs/20-frontend-integration-guide.md`** — it is written for exactly this app and marks which claims were tested against a running server. Then `docs/02-database-schema.md` + `database/schema/*.sql` for field shapes, `docs/04-rbac-permission-matrix.md` for roles, `docs/16-home-layout-cms.md` and `docs/17-campaign-engine.md` for the two newest modules, and `postman/Marketplace-API.postman_collection.json` (223 request, 32 folder) for request bodies.

⚠️ **Koleksi Postman-nya kini bentrok dengan data seed.** Variabel `store_id`/`product_id`/`warehouse_id` masih bernilai `1`, padahal id 1–8 sudah dipakai toko milik seller seed — menjalankan koleksinya apa adanya menghasilkan `403` berulang. Body request-nya tetap sahih; yang salah hanya nilai variabelnya.

**`application/config/routes.php` is the only authority on which endpoints exist** — `docs/03-api-documentation.md` is a design document and is ahead of the implementation. It was expanded on 14 September 2026 (and now covers the new home/campaign modules), but **the phantom endpoints below survived that update**, so do not read the refresh as a correction. It lists `/auth/otp/send` + `/auth/otp/verify` (never registered; the real pair is `/auth/verify-email` + `/auth/resend-verification`), `DELETE /cart/vouchers/{code}`, `/products/{id}/images`, `/bundles/{id}`, and `/products/{id}/subscriptions` — none of which are routed. Its base URL is also still `https://api.marketplace.id/api/v1`. Conversely the Postman collection carries whole folders the doc never mentions: **Wishlist**, **Media** (`/media/upload`), **Compliance** (Tax / Legal & Consent / Product Certification), and **Advanced Features** (Seller Tier, Shipping Insurance, Content Moderation, Restricted Products). Postman tracks routes.php closely; the doc does not.

Three deviations from the generic plan below were forced by the API and are deliberate:

1. **`DataSuccess` carries `meta` and `statusCode`.** Paginated endpoints put `page`/`per_page`/`total` in `meta`, and status codes distinguish created-vs-returned. A repository that forwards only `data` loses both.
2. **Every numeric and boolean model field must use a converter from `lib/util/json_converters.dart`.** Verified on this backend: `POST /checkout/sessions` answers `"grand_total": 150000` while `GET /checkout/sessions/{id}` answers `"grand_total": "150000.00"` — the same field, two types, two endpoints. Ints and `tinyint` booleans normally arrive as strings (`"id": "1"`, `"is_active": "1"`), but `/cart/summary` and `shipping-options` send real numbers. Full list in "Kontrak sisi member" above.
3. **Admin- and seller-scoped endpoints must never get a member service method.** The collection mixes them in freely (`/admin/*`, `/stores/{id}/products`, `/orders/{id}/accept|pack|ship`, `/payments/callback/*`). Verified: a buyer token gets `403 PERMISSION_DENIED` naming the missing permission. Calling them is a sign the wrong flow is being built.

This is the layering the project is being moved toward: **data → domain → presentation** per feature, wired with `get_it` for DI and `go_router` for navigation.

## Additional commands (only after the deps below are added)

Models use `freezed` + `json_serializable`; env vars use `envied`. Changes to `*_model.dart`, `*_state.dart`, `*_cubit.dart` (freezed part files), or `.env` require regenerating the related `*.freezed.dart` / `*.g.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs   # while iterating
```

`lib/config/env/env.dart` reads `.env` (the gitignored key names are listed in `.gitignore`) and produces `env.g.dart` via `envied`. It starts with a single `API_BASE_URL` placeholder — add one `EnviedField` per new base URL / API key as feature domains are added.

## Target layout

```
lib/
  config/         # env, network (Dio), routing, theming
  core/
    data/
      datasources/remote/service/   # Dio-based *Service classes, one per API
      repositories/                 # *RepositoryImpl — calls Service, wraps result in DataState<T>
    domain/
      model/        # freezed/json_serializable models, grouped per API
      repositories/ # abstract repository interfaces consumed by cubits
    data_state.dart # DataState<T> result wrapper: DataLoading/DataSuccess/DataEmpty/DataFailed(DataError)
  di/               # get_it registration, split into injector (Dio client) / injector_service / injector_repository
  ui/
    main/           # shared shell: splash, login, register, home, profile + their cubits
    <feature>/<subfeature>/{cubit,screens,widgets}/   # new feature domains use this layout
  util/             # format_helper, list_slice_extension
```

## Conventions to preserve once migrated

**DI wiring order matters.** `lib/di/injector.dart` registers one **named** `Dio` singleton (`"api"` — see `DioClient` in `lib/config/network/dio_client.dart`), then calls `initializeService()` (services take the named Dio instance), then `initializeRepository()` (repositories take the services). New services/repositories must be registered in `injector_service.dart` / `injector_repository.dart` **in that same dependency order**, and `initialize()` must run before `runApp` in `main.dart`. When adding a feature domain that calls its own API, register another named `Dio` singleton here (see the example comments in `dio_client.dart` / `injector.dart`).

**Repositories never throw.** Every repository method wraps its service call in try/catch and returns `DataState<T>` (`DataSuccess` / `DataFailed(DataError(...))`), so cubits pattern-match on state instead of using try/catch for control flow. Follow this for every new repository method.

**Services own caching and raw HTTP errors.** `*Service` classes are the layer that catches `DioException` and rethrows a plain `Exception` with context. For expensive per-ID lookups, keep an in-memory `Map<int, Model>` cache (see the `PokemonService` pattern in the origin GameHub project) and chunk calls into `Future.wait` batches rather than firing unbounded concurrent requests.

**Cubits use freezed sealed state.** Each feature's `*_state.dart` is an `@freezed` union (initial/loading/loaded/error or similar), declared via `part 'x_state.dart'; part 'x_cubit.freezed.dart';` in the cubit file. Cubits pull their repository directly with `injector<XRepository>()` — **not** constructor injection — and are provided to widgets via `BlocProvider`/`BlocBuilder` from `flutter_bloc`.

**Routes split per domain, combined into one `GoRouter`.** `lib/config/route/app_route.dart` holds the shared shell routes; spread a new `appRouterMyFeature` from its own `app_route_myfeature.dart`, following the marked example pattern. Add new feature routes to that domain file, **not** directly into `app_route.dart`.

## Migration checklist (current → target)

Derived from the gap between Part 1 and Part 2. Steps 0-5 are done and the auth slice of step 8 is done; the rest is open, and **step 6 gates everything after it**.

0. ~~Unblock `flutter pub get`: `intl` was constrained to `^0.19.0` while `flutter_localizations` on Flutter 3.41 requires `0.20.2`, so the project could not resolve at all.~~ **Done** — bumped to `^0.20.2`.
1. ~~Add `freezed_annotation`, `json_annotation`, `envied` to dependencies and `build_runner`, `freezed`, `json_serializable`, `envied_generator` to dev_dependencies.~~ **Done** (also `flutter_secure_storage` for tokens).
2. ~~Create `lib/config/env/env.dart` + `.env` with `API_BASE_URL`; add `.env` to `.gitignore`.~~ **Done.** `.env.example` lists the base URL per target; current target is **Flutter web on Chrome** (`http://localhost:8000/api/v1` — port 8000, the `docker compose` mapping, not port 80). The per-target notes in `.env.example` still describe the old Markas paths and need rewriting.
3. ~~Create `lib/config/network/dio_client.dart` with the named `"api"` Dio singleton.~~ **Done**, plus auth/refresh/logging interceptors.
4. ~~Add `lib/core/data_state.dart` with the `DataState<T>` union.~~ **Done** — see deviation 1 above.
5. ~~Build `lib/di/{injector,injector_service,injector_repository}.dart` and call `initialize()` before `runApp`.~~ **Done**; both registries are populated, but nine of the ten service/repository pairs point at the dead backend.
6. ~~Bersihkan lapisan mati warisan Markas.~~ **Selesai** — 97 berkas dihapus; hanya `RepositoryGuard` yang dipertahankan.
7. **In progress.** Tulis ulang tiap domain menembak marketplace-api, satu per satu, berpedoman pada "Kontrak sisi member" dan respons sungguhan — jangan `docs/03-api-documentation.md`. **Alur beli selesai seluruhnya**: katalog → keranjang → alamat → checkout → pembayaran → pesanan. Katalog jadi rujukan bentuk domain; checkout jadi rujukan untuk domain yang menahan sumber daya di server. **Seluruh domain langkah 7 selesai**: wishlist, ulasan, dompet, notifikasi, reward, dan chat. Sisanya ada di backlog 7b.
7b. **Backlog: endpoint backend yang sudah ada tapi belum dipakai aplikasi.** Dikerjakan **setelah** domain di langkah 7 selesai, bukan menyela. Backend bergerak lebih cepat dari aplikasi, jadi daftar ini akan bertambah — **periksa `git log` repo API setiap kali melanjutkan.**

   ⚠️ **Pemeriksaan itu bukan formalitas.** Pada 19 September 2026 backend ternyata sudah 24 commit di depan (`eff67e7..70ac372`), dan **tiga di antaranya membatalkan akalan yang sudah tertanam di kode jadi**: drift dua zona waktu (`93c6a14`), `PATCH .../address` yang dulu selalu 500 (`8235c33`), dan listing produk yang dulu tanpa gambar (`db8a626`). Yang menemukannya adalah **test integrasi yang memaku perilaku buruk itu** — empat test merah sekaligus. Itulah gunanya memaku bug server, bukan hanya fitur: perbaikannya jadi terlihat alih-alih diam-diam membuat aplikasi salah 7 jam.

   - ~~**`GET /products/{id}/shipping-estimate`**~~ — **selesai**, lihat "Estimasi ongkir di halaman produk" di bawah.
   - **`GET /home/layout`** dan `GET /categories/{id}/layout` — home CMS. Masih `[]` di server karena tabelnya belum di-seed; tunggu ada isinya supaya modelnya tidak ditulis dari dokumen saja.
   - **`GET /me/favorite-categories`**, `GET /me/vouchers`, `POST /vouchers/claim` — sudah diverifikasi hidup, belum ada layarnya.
   - **Alur consent ulang.** `requires_reconsent: true` pada respons login menuntut modal blocking → `GET /legal/documents/active` → `POST /legal/documents/{id}/accept` (panduan FE §2). Field-nya sudah dimodelkan, tindakannya belum. ⚠️ **Belum bisa diuji**: `/legal/documents/active` membalas `404 LEGAL_DOCUMENT_NOT_FOUND` karena tabel dokumen legal belum di-seed — jadi nilai `true` tidak pernah muncul di dev.
   - **`POST /media/upload`** — multipart, nama field **`file`**, balasan `{url, file_name, file_size_kb, mime_type}`. Baru dibutuhkan saat ulasan berfoto atau ganti avatar dikerjakan. ⚠️ `url` dirakit dari `$config['base_url']` yang di repo masih `http://localhost:8080/marketplace-api/`, jadi URL hasil upload akan salah sampai backend menyetelnya.

   **Ditambahkan 19 September 2026** (dari 24 commit backend `eff67e7..70ac372`):

   - **Layar voucher keranjang.** Endpointnya sudah lengkap sejak `90751bf` (pasang, lepas, tumpuk maks 1 ongkir + 1 platform + 1 per toko) dan `CartRepository` sudah punya `applyVoucher`/`removeVoucher`. Yang belum ada layarnya. ⚠️ **Tunggu ada voucher yang di-seed** — `GET /me/vouchers` masih `[]`, jadi alur suksesnya tidak bisa diuji sama sekali dan modelnya akan ditulis dari dokumen saja.
   - **`POST /cart/vouchers/auto-apply`** (commit `2033a15`) — "Gunakan Otomatis" ala Tokopedia/Shopee: menghitung kombinasi terbaik lalu memasangnya sekaligus. Hidup (`200`, `[]` di dev), begitu juga `GET /cart/recommended-vouchers` **selama keranjang tidak kosong**.
   - ~~**`POST /checkout/calculate`**~~ — **selesai**, termasuk badge "Dapat … koin" di ringkasan keranjang (`RewardPreviewBadge`).
   - ~~**Reward engine config-driven**~~ — **selesai** bersama domain reward: `POST /checkout/calculate` sudah dipakai, dan rate per tier kini dibaca server dari `reward_configs`.
   - **`flash_sale` per varian** di `GET /products/{id}` (commit `ad270c3`) — key-nya sudah dikirim server tapi **`null` di seluruh seed**, jadi bentuknya belum bisa diamati. Sama seperti `store_couriers` dan home CMS: tunggu ada isinya.
   - **`GET /flash-sales/{id}/products`** (commit `9c5b9a7` + `1784186`) — kini membawa `product_id`, `image_url`, dan `original_price`.

   **Ditambahkan 21 September 2026** (dari 25 commit backend `70ac372..90ab9db`, rilis v1.1.0 + v1.2.0):

   - **Ikuti toko** — `POST/DELETE /stores/{id}/follow` + `GET /me/following` (commit `2ac6e9e`). Fitur member sungguhan yang belum ada di aplikasi sama sekali: belum ada tombol, model, maupun service.
   - **Etalase toko** — `GET /stores/{id}/showcases` (publik) + `GET /showcases/{id}/products`. Hidup, tapi **`[]` di dev** karena belum ada seed. Sama seperti home CMS: tunggu ada isinya sebelum memodelkannya.
   - **`POST /orders/{id}/rating`** (commit `987458c`) — rating **toko**, terpisah dari ulasan **produk** (`POST /order-items/{id}/review`). Maksimal sekali per order, dan menuntut status `completed`; ulangan dibalas `409 ORDER_ALREADY_RATED`, status lain `422 ORDER_NOT_COMPLETED`. ⚠️ **Tidak bisa diuji ujung ke ujung** — kendala yang sama dengan ulasan: tidak ada pesanan yang bisa mencapai `completed` di dev.
   - **Master lokasi** — `GET /locations/provinces` dan `GET /locations/cities?province_id=` (commit `d025b40`), keduanya **publik dan sudah ada isinya**: 11 provinsi, 15 kota. Kolom alamat juga menerima **`city_id`** sekarang. Ini peluang nyata memperbaiki formulir alamat, yang hari ini masih mengetik `city`/`province` sebagai teks bebas — sumber ongkir salah kalau ejaannya meleset. ⚠️ Seednya masih tipis (15 kota untuk 11 provinsi), jadi dropdown murni akan memblokir user di kota yang belum terdaftar; sediakan jalan ketik-bebas sampai seednya lengkap. Perhatikan pula konvensi kolomnya **berbeda dari seluruh API**: `province_name`/`city_name`, `active`, `created_date` — bukan `name`, `is_active`, `created_at`.
   - **Bundel produk** — `GET /stores/{id}/bundles`, `GET /bundles/{id}` (commit `53768d9`). ⚠️ **Butuh token** walau isinya katalog, berbeda dari `/products` yang publik.
   - **Paginasi `/recommendations/personalized` dan `/trending`** (commit `9536015`) — sekarang menerima `page`/`per_page`. Aplikasi belum memakai endpoint rekomendasi mana pun.

   **Sudah ditangani, tidak perlu pekerjaan lagi:** rate limit auth (lihat catatan tersendiri di atas), balasan penjual di daftar ulasan (`ReviewReplyModel`), dan whitelist field alamat. Seluruh 12 parameter `GET /products` di panduan §7 sudah dikirim `CatalogService`; jebakan §6 nomor 1, 2, 3, 5, dan 8 semuanya sudah ditangani dan dipatok test. Nomor 6 dan 7 khusus app seller.

   **Tidak relevan untuk app member** (semuanya admin/seller): `GET /admin/dashboard/counts`, `/admin/reports/revenue-by-store`, `/admin/reports/store-signups`, `/admin/locations/*`, pembuatan etalase dan bundel, serta lima perbaikan audit keamanan selain rate limit — race condition dompet (`f6fc9b5`), IDOR laporan ulasan (`afe623f`), dan whitelist gudang (`f7a9670`) semuanya di sisi server.

8. **In progress** (auth done). Convert the UI kit's marker states to `@freezed` unions and switch its cubits from public mutable fields to emitted state data — for whatever of `lib/features/` survives step 10.
9. Split [app_routes.dart](lib/core/utils/app_routes.dart) into per-domain route files under `lib/config/route/`.
10. Decide the fate of `lib/features/` vs `lib/ui/` — the target names the presentation root `ui/`, which is a rename of the existing tree, not a second one.

## Follow-ups when starting a new project from this base

- **Firebase**: this repo has no Firebase at all today. If it is adopted (or if this project is duplicated from one that has it), run `flutterfire configure` rather than inheriting another project's `firebase.json`, `lib/firebase_options.dart`, and platform config files — a copied config points at the origin project.
- **App identifier**: already unified — Android `namespace`/`applicationId` and the iOS/macOS `PRODUCT_BUNDLE_IDENTIFIER` all read `com.marketplace.member`, and `name:` in `pubspec.yaml` is `marketplace_app_member`. See "Project identity" at the top of this file before changing either; renaming the Dart package breaks every absolute import.
