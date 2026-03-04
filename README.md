# Contraktor

A Flutter mobile application built as a take-home assessment for Distrolink Services. The app is an artisan marketplace UI featuring an explore screen, artisan profiles, a service request form, and an admin analytics dashboard.

---

## Screenshots
<img width="1320" height="2868" alt="Simulator Screenshot - iPhone 17 Pro Max - 2026-03-04 at 15 30 25" src="https://github.com/user-attachments/assets/c0be6301-4ce2-4da1-8c6f-731d008c7eb8" />
<img width="1320" height="2868" alt="Simulator Screenshot - iPhone 17 Pro Max - 2026-03-04 at 15 30 29" src="https://github.com/user-attachments/assets/dd5997c6-e531-49f5-a549-e8733ca26bcc" />
<img width="1320" height="2868" alt="Simulator Screenshot - iPhone 17 Pro Max - 2026-03-04 at 15 30 34" src="https://github.com/user-attachments/assets/61f5ebb0-f292-415f-a161-990b293dab4f" />



---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.10.0`
- Dart SDK `>=3.0.0`
- Android Studio or Xcode (for running on device/simulator)

### Setup & Run

```bash
# Clone the repository
git clone https://github.com/devdhan/contraktor.git
cd contraktor

# Install dependencies
flutter pub get

# Run on connected device or simulator
flutter run
```

### Run Tests

```bash
flutter test test/artisan_filter_test.dart
```

---

## Project Structure

```
lib/
├── config/
│   └── routes/
│       └── app_router.dart          # GoRouter config
├── features/
│   ├── artisan/
│   │   ├── app/
│   │   |    ├── providers/           # Riverpod state notifiers
│   │   ├── domain/
│   │   │   ├── entities/            # Pure Dart models (Artisan, ArtisanDetail, etc.)
│   │   │   ├── repositories/        # Abstract repository interfaces
│   │   │   └── usecases/            # Single-responsibility use cases
│   │   ├── data/
│   │   │   ├── models/              # JSON-serialisable models extending entities
│   │   │   ├── datasources/         # Remote (asset JSON) + Local (SharedPreferences)
│   │   │   └── repositories/        # Concrete repository implementation
│   │   └── presentation/
│   │       ├── screens/             # ArtisansScreen, ArtisanProfileScreen
│   │       └── widgets/             # ArtisanCard, FilterSheet, PortfolioCard, etc.
│   └── admin/
│       ├── app/
│       |   ├── providers/           # AnalyticsNotifier
│       ├── domain/
│       │   ├── entities/            # Analytics, Summary, RequestByDay, etc.
│       │   ├── repositories/
│       │   └── usecases/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       └── presentation/
│           ├── screens/             # AdminInsights
│           └── widgets/             # StatCard, RequestsBarChart, TopArtisansList, etc.
assets/
└── mock_data/
    ├── artisans.json                # GET /artisans
    ├── artisan_details.json         # GET /artisans/:id
    └── analytics.json               # GET /analytics/requests-by-day
test/
└── artisan_filter_test.dart
```

---

## Mock API / Data Layer

The app simulates a REST API using static JSON files loaded via Flutter's `rootBundle`. Each "endpoint" is a method in a datasource class with a simulated network delay:

| Endpoint | File | Simulated Delay |
|---|---|---|
| `GET /artisans` | `assets/mock_data/artisans.json` | 800ms |
| `GET /artisans/:id` | `assets/mock_data/artisan_details.json` | 600ms |
| `POST /requests` | _(in-memory, logs to console)_ | 1000ms |
| `GET /analytics` | `assets/mock_data/analytics.json` | 500ms |

All API calls go through the repository layer — the UI never touches JSON directly. The flow is:

```
JSON Asset → RemoteDataSource → RepositoryImpl → UseCase → StateNotifier → UI
```

---

## Key Decisions & Architecture

### State Management — Riverpod

Riverpod was chosen over Bloc for this project size because:
- Less boilerplate for simple async state (`FutureProvider`, `StateNotifierProvider`)
- `StateNotifierProvider.family` makes per-artisan profile state trivial
- Providers are testable in isolation without `BuildContext`

Each feature has its own `StateNotifier` holding a typed state class with `copyWith` — making state transitions explicit and predictable.

### Clean Architecture

The codebase is split into four strict layers per feature:

- **App** — Riverpod providers.
- **Domain** — pure Dart, zero Flutter imports. Entities, abstract repositories, and use cases. This layer could be reused in a Dart backend.
- **Data** — JSON models (extending entities), datasources, and the concrete repository that wires them together.
- **Presentation** — Riverpod providers, screens, and extracted stateless widgets.

The domain layer never depends on the data layer — dependency flows inward only.

### Offline Awareness

`ArtisanRepositoryImpl` uses `connectivity_plus` to check network status on every fetch:
- **Online** → fetch from remote → cache to SharedPreferences (10-minute expiry)
- **Offline + valid cache** → serve cached data
- **Offline + no cache** → throw exception → UI shows error with retry button

### Search Debouncing

The search field uses a manual 400ms debounce — `_lastSearchTime` is updated on every keystroke, and the provider is only called if 400ms has elapsed since the last keystroke. This prevents a re-fetch on every character typed.

### SharedPreferences — Trade Preference

When a user applies a trade filter, it is persisted via `SharedPreferences`. On next launch, `ArtisansNotifier._init()` restores the saved trade and pre-filters the list before the first fetch.

---

## Screens

### 1. Explore Artisans
- Lists artisans loaded from `artisans.json`
- Debounced search (name or trade)
- Filter sheet: trade, location, min rating, available only
- Active filter chips with individual clear buttons
- Loading spinner, empty state, error state with retry

### 2. Artisan Profile
- Header loaded immediately from the already-fetched list (no double load)
- Portfolio, availability, and reviews loaded separately from `artisan_details.json`
- "Request Service" bottom sheet with full form validation
- Keyboard-aware layout, date picker, urgency selector
- Submit disables button + shows spinner while in-flight
- Success/error snackbar on completion

### 3. Admin Insights
- Period selector (7 Days / 30 Days / 3 Months / Year)
- Overview stat cards (total, completed, pending, avg rating)
- Active artisans banner
- Bar chart (total vs completed requests per day) using `fl_chart`
- Requests by trade horizontal progress bars
- Top artisans leaderboard with gold/silver/bronze badges
- Pull-to-refresh, error state with retry

---

## Testing

Tests are located in `test/artisan_filter_test.dart` and cover:

- Filter logic (search by name, search by trade, trade filter, rating filter, availability filter, combined filters)
- `ArtisanFilterParams.copyWith` immutability
- `AnalyticsModel.fromJson` — correct parsing of all fields, trade sorting by count descending, and graceful handling of missing `image` field

```bash
flutter test
```

---

## Dependencies

```yaml
flutter_riverpod: ^2.6.1       # State management
go_router: ^14.0.0             # Navigation (Navigator 2.0)
fl_chart: ^0.69.0              # Bar chart for admin insights
shared_preferences: ^2.3.0    # Local preference persistence
connectivity_plus: ^6.0.0     # Offline detection
cached_network_image: ^3.4.0  # Efficient image loading
```

---

## Android Build & Deployment

### Generating a Release APK

```bash
# Build release APK
flutter build apk --release

# Build App Bundle (preferred for Play Store)
flutter build appbundle --release
```

The APK is output to `build/app/outputs/flutter-apk/app-release.apk`.

### Android Permissions

`android/app/src/main/AndroidManifest.xml` includes:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Required for network image loading from `randomuser.me` and `unsplash.com`.

---

### TestFlight Distribution

1. Increment the build number in `pubspec.yaml` (`version: 1.0.0+2`)
2. Build the IPA: `flutter build ipa --release`
3. Upload to App Store Connect via Xcode Organizer
4. In App Store Connect → TestFlight → add internal/external testers
5. Testers receive an email invite and install via the TestFlight app

---

## Tradeoffs & What I'd Improve With More Time

### Tradeoffs Made

- **In-memory filtering** — filters are applied client-side after loading the full list. A real API would support server-side query params.
- **No pagination** — the full artisan list loads at once. With more time, I'd implement cursor-based pagination or infinite scroll with a `ScrollController`.
- **Admin screen is read-only** — the period selector (7 Days / 30 Days / etc.) is UI-only and doesn't re-filter data. Real implementation would pass the period as a query parameter.

### What I'd Add With More Time

- **Pagination / infinite scroll** with a `ScrollController` listener
- **Real HTTP layer** using `http` with interceptors for auth, logging, and retry
- **Image caching** with `cached_network_image` and placeholder shimmer
- **More tests** — widget tests for form validation, integration test for the full artisan → request flow

---
