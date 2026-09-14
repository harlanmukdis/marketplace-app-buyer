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
flutter test                          # run all tests (68; all pass — integration needs the backend up)
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

`dio` and `get_it` **are** wired now — `initialize()` runs before `runApp` and registers a named `"api"` Dio plus ten services and ten repositories. But only the auth domain actually talks to the current backend. Everything else splits three ways, and telling them apart is the single most important thing to get right before editing:

| tree | data source | safe to build on? |
|---|---|---|
| `lib/ui/main/auth/` | marketplace-api, live | **yes** |
| the other `lib/ui/main/*` + the services/repositories/models behind them | the **old Markas backend** — endpoints that no longer exist | **no — see "The dead layer" in Part 2** |
| `lib/features/` (the UI kit's sample tree) | hardcoded lists inside cubits (`HomePageCubit.productsTShirt`) | as sample UI only |

The dead middle row compiles cleanly and fails only at runtime, so `flutter analyze` gives you no warning about it. Never copy a pattern from it or extend it.

The UI kit's own models (`lib/features/home/data/models/product_model.dart`) carry `fromJson` factories, but they were shaped for the kit's sample JSON, not for marketplace-api — treat them as sample data, not as a starting point for the real catalog models.

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
> Per 14 September 2026, diverifikasi dengan menembak `http://localhost:8000/api/v1` memakai akun buyer sungguhan: **20 produk**, **8 toko**, **12 kategori induk + 39 anak** (lengkap dengan `icon_url`/gambar picsum), plus `payment-methods` dan `loyalty/tiers`. Seluruh alur beli — `cart/items` → `checkout/sessions` → `shipping-options` → `shipping` → `confirm` → `orders/{id}` → `payments/{id}/pay` — **berhasil dijalankan sampai keluar QR string**.
>
> Catatan lama di file ini yang bilang "`/products` kosong, jadi lapisan katalog sengaja belum ditulis" **tidak berlaku lagi**. Bentuk respons nyatanya ada di bagian "Kontrak sisi member" di bawah — pakai itu, jangan `docs/03-api-documentation.md`.
>
> Yang masih mati: `/search/*` → `503 SEARCH_UNAVAILABLE` karena **OpenSearch di port 9200 tidak jalan** (`docker compose up -d` menghidupkannya), dan dua endpoint yang rusak betulan — lihat tabel di bawah.

**Status: foundation (steps 1-5) plus the auth domain implemented.** What exists today:

- `lib/config/env/env.dart` + `.env` + `.env.example` (envied; `API_BASE_URL`)
- `lib/config/network/` — `dio_client.dart` (named `"api"` Dio), `api_envelope.dart`, `api_exception.dart`, `token_refresher.dart`, `interceptors/{auth,logging}_interceptor.dart`
- `lib/core/data_state.dart` — `DataState<T>` union
- `lib/core/services/` — `token_store.dart`, `auth_events.dart`
- `lib/util/` — `format_helper.dart`, `json_converters.dart`
- `lib/di/` — `injector.dart` (called from `main.dart` before `runApp`), `injector_service.dart`, `injector_repository.dart`. **These are not empty**: ten services and ten repositories are registered, but only `AuthService`/`AuthRepository` point at a backend that exists — see "The dead layer" below.
- **Auth domain (step 2)** — `AuthSessionModel` + `UserModel` (freezed), `AuthService`, `AuthRepository`/`AuthRepositoryImpl`, `AuthCubit`/`AuthState`, and the API-wired `LoginScreen`/`RegisterScreen` under `lib/ui/main/auth/`
- `lib/util/error_message.dart` — maps `DataError.code` to localized copy; **never** shows `error.message` to users
- Tests: `test/util/` (17, pure), `test/data/` (11, fake service+store), `test/ui/` (23, fake repository), `test/integration/` (17, needs the backend running) — 68 total, all passing

Still absent: Firebase and `lib/firebase_options.dart`; every feature domain other than auth.

### The dead layer

`lib/core/data/`, plus `lib/ui/main/{cart,checkout,home,order,product,wallet}`, is a **complete data + UI stack written against the old Markas backend**. The 13 September migration commit (`45d5794`) rewrote auth and `/me` only; it did not delete the rest, and nothing in the build complains — `flutter analyze` reports 24 issues, all info-level `withOpacity` deprecations. It fails at runtime, not at compile time.

Of the 53 distinct paths those services call, **37 no longer exist** in marketplace-api's 188 registered routes. Alive: `/auth/*` (all 7), `/me`, `/categories`, `/orders`, `/orders/{id}`, `/orders/{id}/cancel`, `/vouchers/validate`, `/wallet`, `/wallet/topup`, `/wishlist`. Dead, with their replacements:

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

The warnings in `injector_service.dart` about `GET /shipments` and `POST /vouchers/apply` describe **the old backend's** holes and no longer apply to anything; they survive only because that file was never revisited.

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

**Tipe data umum:** hampir semua angka dan boolean datang sebagai **string** (`"id": "1"`, `"quantity": "2"`, `"is_active": "1"`, `"base_price": "75000.00"`), tapi `GET /cart/summary` (`subtotal`, `item_count`) dan seluruh `shipping-options` (`cost`, `etd_*_days`) datang sebagai **angka asli**. Jangan pernah mengetik field `int`/`bool` karena satu respons kebetulan begitu.

**Endpoint member yang rusak / tidak bisa dipakai sekarang:**

| endpoint | hasil |
|---|---|
| `GET /recommendations/recently-viewed` | **500**, `Call to a member function result() on false` — query gagal di server. Jangan dipanggil |
| `GET /search/products`, `/search/stores`, `/search/autocomplete`, `/search/trending` | **503 `SEARCH_UNAVAILABLE`** selama OpenSearch 9200 mati |
| `POST /analytics/events` | jalan (**201**), tapi field wajibnya `event_name` — mengirim `event_type` membuat **500** |
| `GET /legal/documents/active` | `404 LEGAL_DOCUMENT_NOT_FOUND` — belum ada dokumen; `requires_reconsent: false` di respons login sejalan dengan itu |
| `GET /vouchers/validate?code=…` | `422 VOUCHER_INVALID` — belum ada voucher yang di-seed |

**Endpoint privileged memang menolak buyer** (memperkuat deviation 3 di bawah): `/admin/users`, `/admin/settings`, `/stores/{id}/orders`, `/stores/{id}/wallet`, `POST /orders/{id}/accept` semuanya membalas **403 `PERMISSION_DENIED`** dengan pesan menyebut permission yang kurang (`admin.user.view`, `order.view`, `order.process`, …). Kalau kamu melihat kode itu muncul, artinya alur yang sedang dibangun salah sisi.

**Login juga membawa `requires_reconsent`** (boolean) di samping `access_token`/`refresh_token`/`expires_in` — belum dimodelkan di `AuthSessionModel`. `expires_in` = 900 detik terbukti lagi: token habis di tengah sesi eksplorasi ini.

### Presentation lives in two trees right now

`lib/ui/main/auth/` (Part 2) and `lib/features/` (the UI kit's sample tree) coexist deliberately. A screen moves to `lib/ui/` **when it gets wired to the API**, not before — so `login`/`register` moved and were rewritten, while `welcome_view` and `reset_password_view` stayed in `lib/features/auth/presentation/views/`.

**`reset_password_view` is no longer blocked** (an earlier revision of this file claimed the API had no password-reset endpoint — it does). `POST /auth/forgot-password` and `POST /auth/reset-password` are both registered routes, `AuthService.forgotPassword`/`resetPassword` already call them, `AuthRepository` already declares them, and `test/integration/auth_service_test.dart` covers forgot-password against the live server. What is missing is only the last hop — `AuthCubit` exposes neither, and no screen calls them. Wiring that screen is a presentation-layer job now.

The kit's social-login buttons were dropped, not ported — the backend has no OAuth, and a button that does nothing is worse than no button.

### freezed 3 gotcha

A `@freezed` class with custom getters or methods **must** declare a private constructor (`const UserModel._();`), otherwise generation fails with `Getters require a MyClass._() constructor`. Also prefer getters **inside** the class over an `extension`: an extension is only in scope where its own library is imported, so `user.isVerified` silently fails to resolve in a file that imported the model only transitively.

**Backend contract**: the member app talks to **marketplace-api** (CodeIgniter 3 modular HMVC + JWT), a multi-vendor marketplace. Reference material lives in that repo, not this one: `docs/02-database-schema.md` + `database/schema/*.sql` for field shapes, `docs/04-rbac-permission-matrix.md` for roles, and `postman/Marketplace-API.postman_collection.json` for the authoritative request bodies.

**`application/config/routes.php` is the only authority on which endpoints exist** — `docs/03-api-documentation.md` is a design document and is ahead of the implementation. It lists `/auth/otp/send` + `/auth/otp/verify` (never registered; the real pair is `/auth/verify-email` + `/auth/resend-verification`), `DELETE /cart/vouchers/{code}`, `/products/{id}/images`, `/bundles/{id}`, and `/products/{id}/subscriptions` — none of which are routed. Its base URL is also still `https://api.marketplace.id/api/v1`. Conversely the Postman collection carries whole folders the doc never mentions: **Wishlist**, **Media** (`/media/upload`), **Compliance** (Tax / Legal & Consent / Product Certification), and **Advanced Features** (Seller Tier, Shipping Insurance, Content Moderation, Restricted Products). Postman tracks routes.php closely; the doc does not.

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
6. **Next, and it gates everything after it.** Clear out the dead layer — the nine Markas-era service/repository/model sets, the `lib/ui/main/*` screens on top of them, and their DI registrations. See "The dead layer" above for the full inventory. The earlier reason for waiting (server had no products, so shapes would be guesswork) **no longer applies**: the DB is seeded and the real shapes are recorded in "Kontrak sisi member".
7. **After step 6.** Rebuild each feature domain against marketplace-api, one at a time, against "Kontrak sisi member" and live responses — never `docs/03-api-documentation.md`. Auth is the reference implementation of the target shape. Suggested order, following the buyer flow that was verified end to end: catalog (`/products`, `/categories`) → cart → address → checkout → order → payment → wallet/wishlist.
8. **In progress** (auth done). Convert the UI kit's marker states to `@freezed` unions and switch its cubits from public mutable fields to emitted state data — for whatever of `lib/features/` survives step 10.
9. Split [app_routes.dart](lib/core/utils/app_routes.dart) into per-domain route files under `lib/config/route/`.
10. Decide the fate of `lib/features/` vs `lib/ui/` — the target names the presentation root `ui/`, which is a rename of the existing tree, not a second one.

## Follow-ups when starting a new project from this base

- **Firebase**: this repo has no Firebase at all today. If it is adopted (or if this project is duplicated from one that has it), run `flutterfire configure` rather than inheriting another project's `firebase.json`, `lib/firebase_options.dart`, and platform config files — a copied config points at the origin project.
- **App identifier**: already unified — Android `namespace`/`applicationId` and the iOS/macOS `PRODUCT_BUNDLE_IDENTIFIER` all read `com.marketplace.member`, and `name:` in `pubspec.yaml` is `marketplace_app_member`. See "Project identity" at the top of this file before changing either; renaming the Dart package breaks every absolute import.
