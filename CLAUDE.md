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
flutter test                          # run all tests (304; all pass)
flutter test test/integration --concurrency=1   # integrasi: butuh backend hidup, WAJIB serial
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
| `lib/ui/main/{auth,catalog,cart,address,checkout,order,payment,wishlist,review,wallet}/` | marketplace-api, live | **yes** — `catalog` is the reference implementation |
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

- The Flutter counter template `test/widget_test.dart` is **gone** — the suite is real (68 tests, all passing) and is a usable signal. `test/integration/` (17 of those) hits a live backend, so it fails with connection errors when `docker compose up` is not running in the API repo; that is the environment, not a regression.
- 14 stale `*.dart~` backup files litter `lib/` (and `android/`). They are not compiled but **do show up in grep results** — always confirm a hit isn't in a `~` file before editing.
- `lib/features/my_cart/presentation/views/map_screen.dart` is 100% commented out, and the `com.google.android.geo.API_KEY` meta-data in `android/app/src/main/AndroidManifest.xml` is commented out too. Restoring the map needs both, plus an iOS key. Location permissions are already declared in the manifest.
- **The app builds now, but every image is a placeholder.** The UI kit's asset folders were never copied into this repo, so all 67 files in `assets/images/` and `assets/icon/` are grey 64×64 stubs, and the `Hanimation` font declaration in `pubspec.yaml` stays **commented out** (a fake OTF crashes at start, so it could not be stubbed — all text falls back to the system font). What you see on screen is therefore not the kit's design. `assets/PLACEHOLDER-README.md` documents what was stubbed and how to restore the originals.
- Android `usesCleartextTraffic` / iOS ATS are **not** configured, so the `http://` base URL will fail on mobile. Not needed for the current web target; required before the first Android/iOS run.
- `DevicePreview` wraps the app when `kDebugMode`, so debug builds render inside a simulated device frame — layout that looks wrong in debug may be the preview frame, not the code.
- Orientation is locked to portrait in `main()`.
- `flutter_launcher_icons` and `flutter_native_splash` config blocks in `pubspec.yaml` are commented out, though `flutter_launcher_icons.yaml` / `flutter_native_splash.yaml` exist at the root.

---

# Part 2 — Target architecture

> ### 📘 BACA DULU: `docs/18-frontend-integration-guide.md`
>
> Backend menerbitkan **panduan integrasi frontend khusus untuk app member & app seller** (14 September 2026). Itu titik masuk tunggal untuk pekerjaan FE: cara menjalankan API, kontrak dasar, peta 33 modul → endpoint → app mana yang memakainya, alur inti buyer dari browse sampai terima barang, dan daftar jebakan yang sudah diuji ke server. Poin bertanda **[terverifikasi]** di sana sudah ditembak ke server sungguhan, bukan dibaca dari dokumen.
>
> Urutan otoritas kalau sumber saling bertentangan: **`application/config/routes.php` > panduan 18 > Postman > docs lainnya.** Seluruh catatan di bawah ini sudah diselaraskan dengan panduan itu dan diverifikasi ulang ke server pada 14 September 2026.
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
> Catatan sebelumnya di file ini yang menyarankan `docker compose up -d` **salah**. `Dockerfile` menyalin `infra/docker/nginx.conf` yang tidak ada di repo, dan stage runtime-nya nginx tanpa php-fpm. Cara yang benar ada di panduan 18 §1: siapkan MySQL, jalankan `database/schema/*.sql` lalu `database/seeds/*.sql`, kemudian `php -S 127.0.0.1:8000 -t . router.php` dengan `router.php` yang isinya diberikan di panduan itu (tidak ada di repo).
>
> Konsekuensinya untuk `/search/*`: **Elasticsearch/OpenSearch di 9200 tidak punya cara mudah dinyalakan**, jadi anggap search mati secara default dan pakai fallback yang dijelaskan di bawah.

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
- Tests: `test/util/` (17, murni), `test/data/` (114, fake service/store + parsing JSON asli), `test/ui/` (84, fake repository), `test/integration/` (89, butuh backend hidup — **jalankan `--concurrency=1`**) — **304 total, semuanya lulus**

Still absent: Firebase and `lib/firebase_options.dart`; domain chat dan notifikasi.

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

Tesnya terbagi tiga, dan pembagian itu disengaja: `test/data/catalog_model_test.dart` (21, memakai potongan JSON yang disalin apa adanya dari server), `test/ui/catalog_home_cubit_test.dart` (16, repository palsu), `test/integration/catalog_service_test.dart` (15, server sungguhan — mematok kejanggalan bentuk data supaya perubahan diam-diam di backend menjadi test merah, bukan layar rusak).

### Domain keranjang — dan lubang validasi di server

Keranjang ditulis setelah katalog dan mengikuti bentuk yang sama, dengan dua perbedaan yang disengaja.

**1. `CartRepository` mengembalikan `CartSnapshot`, bukan `void`, untuk setiap mutasi.** Ini dipaksa API: `PATCH` dan `DELETE` membalas `data: null`, **dan mutasi terhadap baris yang tidak ada pun dibalas `200`** (terverifikasi: `PATCH /cart/items/99999999` sukses). Artinya status sukses **bukan bukti** sesuatu berubah — satu-satunya cara tahu keadaan keranjang adalah membacanya ulang. Repository yang menanggung baca-ulang itu, supaya tidak ada layar yang lupa.

**2. `CartCubit` adalah satu-satunya tempat kuantitas dibatasi.** 🔴 **Server tidak memvalidasi kuantitas sama sekali** — `quantity: 999999` untuk varian berstok 150 dibalas `200` dan benar-benar tersimpan; `0` juga diterima. Konsekuensinya:

- Kuantitas dipotong ke `CartCubit.maxQuantityPerLine` (999) sebelum dikirim. Itu angka kewarasan, bukan aturan bisnis — **`GET /cart` tidak mengirim stok**, jadi layar keranjang memang tidak bisa tahu batas sesungguhnya. Batas terhadap stok ditegakkan di halaman detail produk, yang tahu `variant.stock`.
- Kuantitas `< 1` **menghapus baris**, tidak dikirim sebagai `0`. Mengirim `0` diterima server dan menyisakan baris hantu berkuantitas nol yang tetap tampil dan tetap dihitung `item_count`.
- Ketukan ganda pada baris yang sama diabaikan selagi permintaan pertama berjalan (`mutatingItemIds`), supaya dua permintaan tidak saling mendahului.

Bentuk data yang mudah salah ditebak:

- **Grup toko di `GET /cart` hanya membawa `store_name`, tanpa `store_id`.** Id-nya ada di tiap item; `CartStoreGroup.storeId` menurunkannya dari item pertama. Checkout membutuhkannya sebagai kunci pemilihan kurir per toko.
- **`GET /cart/summary` hanya berisi `subtotal` dan `item_count`** — keduanya **angka asli**, bukan string. `docs/03` menyebut endpoint ini juga mengembalikan estimasi ongkir dan promo aktif; **tidak**. Ongkir baru muncul di `checkout/sessions/{id}/shipping-options`.
- **Ringkasan hanya menghitung baris tercentang**, dan `item_count` menghitung **baris**, bukan unit — dua baris berisi 5 dan 1 unit tetap `2`. Karena itu layar menulis "N barang terpilih", bukan "N barang".
- **`POST /cart/items` untuk varian yang sudah ada menggabungkan kuantitas** ke baris lama dan mengembalikan id baris itu — bukan membuat baris baru. Id balasannya kadang number, kadang string.
- Baris keranjang membawa data produk terdenormalisasi (`product_name`, `sku`, `price`, `variant_options`), jadi layar keranjang **tidak perlu** menembak `/products/{id}` per baris. Yang tidak ada: gambar dan stok.
- **Tidak ada endpoint untuk melepas voucher.** `docs/03` menyebut `DELETE /cart/vouchers/{code}`; rutenya tidak terdaftar. Jangan menyediakan tombol yang tidak punya endpoint.

Satu-satunya validasi server yang benar-benar ada di endpoint ini: varian tidak dikenal dibalas `404 VARIANT_NOT_FOUND`.

### Domain alamat & checkout — dan tiga bug server

Ditulis setelah keranjang, dan paling banyak menabrak keanehan server dari semua domain sejauh ini.

#### 🔴 Satu respons checkout memakai DUA zona waktu

Terbukti dua kali ke server: pada sesi yang sama, `created_at: "2026-09-15 07:52:59"` adalah waktu dinding **WIB**, sedangkan `expires_at: "2026-09-15 01:07:59"` adalah **UTC**. Selisihnya tepat 15 menit hanya kalau `expires_at` digeser +7 jam lebih dulu.

`ServerDateTimeJson` memperlakukan semua timestamp sebagai WIB — benar untuk `created_at`, **salah 7 jam untuk `expires_at`**. Memakainya di sana membuat hitung mundur reservasi langsung menampilkan "kedaluwarsa" pada sesi yang baru dibuat. Karena itu ada `ServerUtcDateTimeJson`, dipakai **hanya** untuk tenggat yang dihitung server (`expires_at`, dan nanti `payment_deadline` di order). Jangan menyeragamkannya.

#### 🔴 `PATCH /checkout/sessions/{id}/address` selalu 500

Controllernya membaca body dengan `$this->post('address_id')` pada rute PATCH, sehingga nilainya selalu `null`, server menjalankan `UPDATE … SET shipping_address_id = NULL`, dan foreign key menolaknya. Ketiga encoding (JSON, form, query string) sama-sama gagal. Bandingkan `/shipping` yang memakai `$this->body()` dan bekerja normal.

Akibatnya **tidak ada method untuk itu di `CheckoutService`**, dan ganti alamat dilakukan dengan `cancelSession` lalu `startSession` lagi. Urutannya penting: tanpa membatalkan lebih dulu, stok yang sama tertahan dua kali dan sesi baru bisa gagal karena "habis" oleh sesi user itu sendiri.

#### 🔴 `selected_couriers` tersimpan sebagai string JSON

Yang paling menjebak, karena **balasan `PATCH .../shipping` mengirim field bernama sama sebagai objek sungguhan** — sementara yang tersimpan di sesi berupa string. Tanpa `JsonMapJson`, `GET /checkout/sessions/{id}` melempar `type 'String' is not a subtype of type 'Map<String, dynamic>?'` **persis setelah user memilih kurir**, di tengah alur checkout. Ditemukan hanya karena test integrasi menjalankan alur beli sungguhan, bukan potongan JSON karangan. Berlaku juga untuk `applied_vouchers` dan `cart_snapshot`.

#### Perilaku lain yang dipatok test

- **Alamat tanpa validasi**: `POST /me/addresses` dengan seluruh field kosong dibalas `201` dan tersimpan. Kelengkapan divalidasi `AddressCubit` + formulir; `AddressModel.isComplete` yang jadi acuan, dan checkout hanya menawarkan alamat yang lolos.
- **Nama field alamat**: `full_address` dan `is_primary`. Nama ala Markas (`address_line`, `district`, `is_default`) membuat server membalas **500 HTML**, bukan `VALIDATION_ERROR`.
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

- **Pola zona waktu yang sama berulang**: `payment_deadline` (order) dan `expired_at` (payment) **UTC**, sementara `created_at` di respons yang sama **WIB**. Keduanya memakai `ServerUtcDateTimeJson`.
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

`list_for_product` hanya `SELECT *` dari tabel `reviews`, jadi responsnya **tidak membawa**:

- **nama pengulas** — hanya `user_id`, dan tidak ada endpoint publik untuk menukarnya jadi nama. `ReviewModel.displayName` karena itu selalu `'Pembeli'`, dan `is_anonymous` praktis tidak berpengaruh apa pun.
- **foto/video** — tabel `review_media` ada dan `POST` menerimanya, tapi tidak ikut di daftar.
- **balasan penjual** — tabel `review_replies` dan endpoint `reply` ada, isinya juga tidak ikut.

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

### Kontrak sisi member (diverifikasi ke server, 14 September 2026)

Semua di bawah ini hasil menembak server dengan token buyer, bukan membaca dokumen. Ini yang dipakai saat menulis model — `docs/03-api-documentation.md` tidak memuat satu pun dari detail ini dan sebagian bertentangan.

**Enam kejutan bentuk data yang akan merusak model kalau ditebak:**

1. **`checkout_session_id` adalah UUID string, bukan integer.** `POST /checkout/sessions` membalas `"id": "4e2e1970-cde4-4237-b30e-51866d55bce2"`. Itu sebabnya rutenya `(:any)`, bukan `(:num)`. Model yang menaruh `int id` di sini langsung gagal parse.
2. **`GET /checkout/sessions/{id}/shipping-options` membalas MAP, bukan LIST** — dikunci `store_id` sebagai **string**: `{"1": [ {courier_code, service_code, service_name, zone, weight_kg, cost, etd_min_days, etd_max_days}, … ]}`. Di Dart ini `Map<String, List<ShippingOptionModel>>`. `PATCH .../shipping` juga menerima map berbentuk sama: `{"1": {"courier_code": "jnt", "service_code": "ez"}}`.
3. **`cart_snapshot` dan `shipping_address_snapshot` adalah JSON yang di-*string*-kan**, bukan objek bersarang. Isinya harus `jsonDecode` sekali lagi setelah amplopnya dibuka.
4. **`grand_total` berubah tipe antar endpoint — terbukti, bukan dugaan.** `POST /checkout/sessions` → `"grand_total": 150000` (angka); `GET /checkout/sessions/{id}` → `"grand_total": "150000.00"` (string berdesimal). Inilah alasan setiap field angka wajib lewat converter di `lib/util/json_converters.dart`.
5. **`POST /checkout/sessions/{id}/confirm` membalas `{"order_ids": [1], "payment_transaction_id": 1}`** — `order_ids` **array**, karena keranjang multi-toko pecah jadi beberapa order. Jangan modelkan sebagai satu order.
6. **Order sekarang satu lapis.** `GET /orders/{id}` = order + `items[]` + `status_history[]` + `refund`. Tidak ada `sub_orders`, tidak ada `shipments`. Ongkir ada di order (`shipping_cost`, `courier_code`, `courier_service`, `tracking_number`).

**Field alamat memakai nama lain dari app lama.** `POST /me/addresses` menerima `label`, `recipient_name`, `phone`, `full_address`, `city`, `province`, `postal_code`, `is_primary` (+ `latitude`/`longitude` opsional). Nama ala Markas — `address_line`, `district`, `is_default` — **tidak ada kolomnya**, dan mengirimnya membuat server membalas **500 halaman HTML**, bukan `VALIDATION_ERROR`: field yang tidak dikenal diteruskan mentah ke `INSERT`. Cek `database/schema/01_users_auth.sql` kalau ragu.

**Tipe data umum:** hampir semua angka dan boolean datang sebagai **string** (`"id": "1"`, `"quantity": "2"`, `"is_active": "1"`, `"base_price": "75000.00"`) — ini perilaku driver MySQL PHP, bukan kesengajaan. Pengecualiannya justru yang penting: `GET /cart/summary` (`subtotal`, `item_count`), seluruh `shipping-options` (`cost`, `etd_*_days`), dan **`stock` di detail produk** datang sebagai **angka asli**. Jangan pernah mengetik field `int`/`bool` karena satu respons kebetulan begitu.

#### Katalog — listing vs detail

**`GET /products` tidak membawa gambar maupun stok.** Isinya hanya kolom tabel `products` (+ `compare_at_price`, + `flash_sale` bila sedang promo). Gambar, stok, varian, dan kurir **hanya ada di `GET /products/{id}`**. Kartu produk di listing harus pakai placeholder — **jangan N+1 request detail per kartu**.

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

**Backend contract**: the member app talks to **marketplace-api** (CodeIgniter 3 modular HMVC + JWT), a multi-vendor marketplace. Reference material lives in that repo, not this one. Start at **`docs/18-frontend-integration-guide.md`** — it is written for exactly this app and marks which claims were tested against a running server. Then `docs/02-database-schema.md` + `database/schema/*.sql` for field shapes, `docs/04-rbac-permission-matrix.md` for roles, `docs/16-home-layout-cms.md` and `docs/17-campaign-engine.md` for the two newest modules, and `postman/Marketplace-API.postman_collection.json` (223 request, 32 folder) for request bodies.

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
7. **In progress.** Tulis ulang tiap domain menembak marketplace-api, satu per satu, berpedoman pada "Kontrak sisi member" dan respons sungguhan — jangan `docs/03-api-documentation.md`. **Alur beli selesai seluruhnya**: katalog → keranjang → alamat → checkout → pembayaran → pesanan. Katalog jadi rujukan bentuk domain; checkout jadi rujukan untuk domain yang menahan sumber daya di server. **Wishlist, ulasan, dan dompet juga selesai.** Sisa yang belum ditulis: **notifikasi** (`/me/notifications`), **chat** (`/chat/conversations`, ada polling di `/poll`), serta modul reward (`/me/points`, `/me/coins`, `/me/loyalty`).
7b. **Backlog: endpoint backend yang sudah ada tapi belum dipakai aplikasi.** Dikerjakan **setelah** domain di langkah 7 selesai, bukan menyela. Backend bergerak lebih cepat dari aplikasi, jadi daftar ini akan bertambah — periksa `git log` repo API setiap kali melanjutkan.

   - **`GET /products/{id}/shipping-estimate?address_id=&variant_id=`** (commit `ea86e5d`, 15 Sep 2026). Menjawab "berapa ongkir ke alamat saya?" di halaman produk **tanpa membuat sesi checkout** — jadi tanpa mereservasi stok. Butuh login; `variant_id` opsional. Balasannya **list `ShippingOptionModel` yang sudah ada** (`cost` angka asli), sudah disaring `store_couriers`, urut termurah. Error yang perlu ditangani: `422 VALIDATION_ERROR` tanpa `address_id`, `404 ADDRESS_NOT_FOUND`, `404 VARIANT_NOT_FOUND`, `409 STOCK_INSUFFICIENT`. Sebagian nilainya sudah didapat lebih murah lewat `warehouse_city`/`warehouse_province` di varian, jadi ini peningkatan, bukan penambal lubang.
   - **`GET /home/layout`** dan `GET /categories/{id}/layout` — home CMS. Masih `[]` di server karena tabelnya belum di-seed; tunggu ada isinya supaya modelnya tidak ditulis dari dokumen saja.
   - **`GET /me/favorite-categories`**, `GET /me/vouchers`, `POST /vouchers/claim` — sudah diverifikasi hidup, belum ada layarnya.
   - **Alur consent ulang.** `requires_reconsent: true` pada respons login menuntut modal blocking → `GET /legal/documents/active` → `POST /legal/documents/{id}/accept` (panduan FE §2). Field-nya sudah dimodelkan, tindakannya belum. ⚠️ **Belum bisa diuji**: `/legal/documents/active` membalas `404 LEGAL_DOCUMENT_NOT_FOUND` karena tabel dokumen legal belum di-seed — jadi nilai `true` tidak pernah muncul di dev.
   - **`POST /media/upload`** — multipart, nama field **`file`**, balasan `{url, file_name, file_size_kb, mime_type}`. Baru dibutuhkan saat ulasan berfoto atau ganti avatar dikerjakan. ⚠️ `url` dirakit dari `$config['base_url']` yang di repo masih `http://localhost:8080/marketplace-api/`, jadi URL hasil upload akan salah sampai backend menyetelnya.

   **Sudah dicek cocok, tidak perlu pekerjaan:** seluruh 12 parameter `GET /products` di panduan §7 sudah dikirim `CatalogService`; jebakan §6 nomor 1, 2, 3, 5, dan 8 semuanya sudah ditangani dan dipatok test. Nomor 6 dan 7 khusus app seller.

8. **In progress** (auth done). Convert the UI kit's marker states to `@freezed` unions and switch its cubits from public mutable fields to emitted state data — for whatever of `lib/features/` survives step 10.
9. Split [app_routes.dart](lib/core/utils/app_routes.dart) into per-domain route files under `lib/config/route/`.
10. Decide the fate of `lib/features/` vs `lib/ui/` — the target names the presentation root `ui/`, which is a rename of the existing tree, not a second one.

## Follow-ups when starting a new project from this base

- **Firebase**: this repo has no Firebase at all today. If it is adopted (or if this project is duplicated from one that has it), run `flutterfire configure` rather than inheriting another project's `firebase.json`, `lib/firebase_options.dart`, and platform config files — a copied config points at the origin project.
- **App identifier**: already unified — Android `namespace`/`applicationId` and the iOS/macOS `PRODUCT_BUNDLE_IDENTIFIER` all read `com.marketplace.member`, and `name:` in `pubspec.yaml` is `marketplace_app_member`. See "Project identity" at the top of this file before changing either; renaming the Dart package breaks every absolute import.
