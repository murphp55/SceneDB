# SceneDB

A cross-platform Flutter application for tracking movies and TV shows. Browse trending content from TMDB, build your personal library, track watch status, and filter by rating, status, and genre.

## Project Overview

SceneDB is an early-stage MVP that combines TMDB API integration with a local SQLite database via Drift ORM. It provides a clean, Material Design 3 interface for movie and TV enthusiasts to discover and organize their viewing experience.

**Current Status:** 1.0 ship-blockers and polish items complete in source, Windows build verified end-to-end with the v1 Drift schema baseline captured. Recent work: in-app TMDB API key entry (secure storage), typed `TmdbError` hierarchy + retry UX, Drift `MigrationStrategy` scaffolding, empty states, `url_launcher` wiring, color-coded genre chips on browse and search cards, plus bug fixes (Drift `TrackedMovy` typo, browse-tab `AsyncValue<dynamic>` type cast crash, unnecessary Riverpod import, `dynamic tracked` casts).

> ## Pick Up Here — Next Session
>
> Everything builds and runs on Windows. What's left is **manual smoke-testing** with a real TMDB API key:
>
> 1. Open the running app, go to Settings, paste a TMDB v3 API key. Confirm the source row reads "secure storage".
> 2. Browse → Movies and Browse → TV Shows: confirm trending/top-rated load with posters and colored genre chips. Tap into a detail screen.
> 3. Search both tabs — type a title, confirm results show, tap into one.
> 4. Add a few items to the Library, restart the app, confirm they persist.
> 5. Library tab: filter by status / rating / genre. Edit watch status and rating on an item. Remove an item.
> 6. Negative paths: clear the API key in Settings, return to a detail screen, confirm the `ErrorView` shows with an "Open Settings" CTA. Set an obviously-bad key and confirm the same.
>
> Once that's all green, this section can be deleted.

## Tech Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Framework** | Flutter | 3.5.0+ |
| **Language** | Dart | 3.5.0+ |
| **State Management** | Riverpod | 2.5.1 (code-gen) |
| **Database** | Drift (SQLite ORM) | 2.20.3 |
| **HTTP Client** | Dio | 5.7.0 |
| **Routing** | Go Router | 14.2.0 |
| **Image Caching** | cached_network_image | 3.4.1 |
| **Secure Storage** | flutter_secure_storage | 9.2.2 |
| **URL Launcher** | url_launcher | 6.3.0 |
| **Design System** | Material Design 3 | Built-in |
| **Build System** | Build Runner | 2.4.12 |

## Project Structure

```
lib/
├── main.dart                 # Entry point, database initialization
├── app.dart                  # Root app widget with routing
├── constants/
│   ├── app_constants.dart   # App-wide constants
│   └── tmdb_constants.dart  # TMDB API key and base URLs
├── models/
│   ├── enums.dart           # WatchStatus, Rating enums
│   ├── tmdb_movie.dart      # TMDB movie data model
│   ├── tmdb_tv.dart         # TMDB TV data model
│   └── tmdb_genre.dart      # Genre data model
├── database/
│   ├── database.dart        # Drift database setup
│   ├── database.g.dart      # Generated Drift code (do not edit)
│   └── converters.dart      # Type converters for enums
├── services/
│   └── tmdb_service.dart    # TMDB API communication
├── providers/               # Riverpod providers (code-gen)
│   ├── tmdb_provider.dart   # Movie/TV browse data providers
│   ├── tmdb_provider.g.dart # Generated code
│   ├── library_provider.dart # User library state
│   └── library_provider.g.dart
├── screens/
│   ├── browse/
│   │   ├── browse_screen.dart      # Main browse screen with tabs
│   │   ├── movies_browse_tab.dart  # Movie browse & search
│   │   └── tv_browse_tab.dart      # TV show browse & search
│   ├── library/
│   │   ├── library_screen.dart     # Main library view
│   │   ├── library_filter.dart     # Filter controls
│   │   └── detail_screen.dart      # Movie/TV detail view
│   └── settings/
│       └── settings_screen.dart    # App settings
├── utils/
│   └── genre_colors.dart   # TMDB genre ID → chip background/foreground palette
└── widgets/
    ├── title_card.dart       # Poster + title + optional genre chips (used in browse/search)
    ├── trending_row.dart     # Horizontal row of TitleCards
    ├── genre_chip_row.dart   # Resolves genre IDs → names + colors via Riverpod
    ├── empty_state.dart      # Shared empty-state widget
    ├── error_view.dart       # Renders TmdbError with Retry / Open Settings
    ├── add_to_library_sheet.dart
    ├── filter_sheet.dart
    ├── genre_chip.dart       # Single-genre selectable chip (filters)
    ├── rating_chip.dart
    ├── search_bar_widget.dart
    └── status_chip.dart
```

## Key Features

### Browse
- **Trending Movies & TV**: View popular and top-rated content from TMDB
- **Full-Text Search**: Search movies and TV shows with 500ms debounce
- **Detail Screens**: View backdrop/poster images, overview, vote average, and genres
- **Color-Coded Genre Chips**: Each card shows up to three genre chips, color-coded by genre family (red → action/thriller, teal → sci-fi, blue → drama/documentary, etc.). Names are looked up from `movieGenresProvider` / `tvGenresProvider`; the palette lives in `lib/utils/genre_colors.dart` and can be tweaked in one place.

### Library Management
- **Add/Remove**: Track content in your personal library
- **Watch Status**: Mark items as "Yet to Watch", "In Progress", or "Watched"
- **Letter Rating**: Rate content from A-F
- **TV Episode Tracking**: Track seasons and episodes for TV shows

### Filtering & Discovery
- **Status Filter**: Filter by watch status
- **Rating Filter**: Filter by letter grade
- **Genre Filter**: Filter by genre with AND logic (multiple selections narrow results)

### UI/UX
- **Material Design 3**: Modern, responsive interface
- **Bottom Navigation**: Easy access to Browse, Library, and Settings
- **GoRouter Shell**: Persistent navigation with nested routing
- **Cached Images**: Efficient image loading and caching

## Dependencies

**Core:**
- `flutter_riverpod` (2.5.1) - Reactive state management with code generation
- `drift` (2.20.3) - SQLite ORM with type-safe queries
- `go_router` (14.2.0) - Router with nested navigation support
- `dio` (5.7.0) - HTTP client for TMDB API

**UI:**
- `cached_network_image` (3.4.1) - Image caching and loading
- Material Design 3 (built-in to Flutter)

**Development:**
- `build_runner` (2.4.12) - Code generation tool
- `drift_dev` (2.20.3) - Drift code generation
- `riverpod_generator` (2.4.3) - Riverpod code generation
- `riverpod_lint` (2.3.13) - Linting for Riverpod

## Database Schema

Two main Drift tables with type converters for enums:

**TrackedMovies**
- `id` (INTEGER PRIMARY KEY)
- `tmdbId` (INTEGER)
- `title` (TEXT)
- `posterPath` (TEXT)
- `backdropPath` (TEXT)
- `watchStatus` (TEXT - enum: YET_TO_WATCH, IN_PROGRESS, WATCHED)
- `rating` (TEXT - enum: A-F)
- `dateAdded` (DATETIME)

**TrackedShows**
- `id` (INTEGER PRIMARY KEY)
- `tmdbId` (INTEGER)
- `title` (TEXT)
- `posterPath` (TEXT)
- `backdropPath` (TEXT)
- `watchStatus` (TEXT - enum)
- `rating` (TEXT - enum)
- `currentSeason` (INTEGER)
- `currentEpisode` (INTEGER)
- `dateAdded` (DATETIME)

## TMDB API Integration

SceneDB requires a TMDB API key to function. The app uses Dio to fetch:
- `/trending/movie/week` - Trending movies
- `/movie/top_rated` - Top-rated movies
- `/trending/tv/week` - Trending TV shows
- `/tv/top_rated` - Top-rated TV shows
- `/search/movie` - Movie search
- `/search/tv` - TV search

## How to Build & Run

### Prerequisites
- Flutter 3.5.0 or later
- Dart 3.5.0 or later
- Android SDK (for Android builds)
- Xcode (for iOS builds)

### Setup Steps

1. **Clone and install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate code (Drift + Riverpod):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Get a TMDB API Key:**
   - Sign up at [TMDB](https://www.themoviedb.org/settings/api) (it's free)
   - You can either paste the key into the app's Settings screen (preferred — it's persisted via `flutter_secure_storage`) or supply it at build time via `--dart-define`. The stored key wins if both are present.

4. **Run the app:**
   ```bash
   # Option A — run without a key, then paste it in Settings on first launch
   flutter run

   # Option B — bake in a build-time key (useful for CI / dev)
   flutter run --dart-define=TMDB_API_KEY=your_key_here
   ```

### Build for Production

Pass the same `--dart-define` flag to any build command:

```bash
# Android
flutter build apk --dart-define=TMDB_API_KEY=your_key_here

# iOS
flutter build ios --dart-define=TMDB_API_KEY=your_key_here

# Web
flutter build web --dart-define=TMDB_API_KEY=your_key_here
```

Tip: save your key to an environment variable and reference it, e.g.
`flutter run --dart-define=TMDB_API_KEY=$TMDB_API_KEY`.

## Development Notes

### Code Generation
This project uses Riverpod code generation and Drift code generation. After modifying any Riverpod providers or Drift database files, regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Schema Migrations

Whenever a `Table` in `lib/database/database.dart` changes, the database has to migrate existing user data to the new shape. The workflow:

1. Bump `schemaVersion` in `AppDatabase`.
2. Add an upgrade step in `MigrationStrategy.onUpgrade`, keyed on `from` so multi-version upgrades chain correctly.
3. Capture a snapshot of the new schema:
   ```bash
   dart run drift_dev schema dump lib/database/database.dart drift_schemas/
   ```
4. Regenerate the test helpers:
   ```bash
   dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
   ```
5. Add a test in `test/migration_test.dart` verifying the v(n) → v(n+1) upgrade.

If you're cloning this repo for the first time and `drift_schemas/` doesn't yet contain a `drift_schema_v1.json`, run the dump command above to create the v1 baseline.

See `drift_schemas/README.md` for more detail.

### Adding New Features
- **New API endpoints**: Add to `tmdb_service.dart` and create Riverpod providers
- **Database tables**: Modify `database.dart`, then run build_runner
- **New filters**: Add enum to `models/enums.dart` and update filter logic in screens
- **New screens**: Create under `screens/` and add routing in `app.dart`

### Testing
Currently, the project has no automated tests. Consider adding:
- Unit tests for TMDB service using `mockito`
- Widget tests for screens and components
- Database tests for Drift operations

## Key Files to Know

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point, database initialization |
| `lib/app.dart` | Root widget, routing configuration |
| `lib/database/database.dart` | Drift database schema and initialization |
| `lib/services/tmdb_service.dart` | TMDB API communication layer |
| `lib/providers/library_provider.dart` | Core state management for library |
| `lib/screens/browse/browse_screen.dart` | Main browse interface |
| `lib/screens/library/library_screen.dart` | Main library interface |
| `lib/constants/tmdb_constants.dart` | API key and configuration (update required) |

## Common Issues

**Issue:** Code generation fails or generated files are missing
- **Solution:** Run `dart run build_runner clean && dart run build_runner build`

**Issue:** TMDB API returns 401 Unauthorized
- **Solution:** Open Settings → TMDB API Key and confirm a key is configured. The status row shows whether the active key came from secure storage or `--dart-define`. Save a fresh key from themoviedb.org/settings/api if needed.

**Issue:** Images fail to load
- **Solution:** Ensure device has internet connectivity; check TMDB CDN is accessible

**Issue (Windows):** `flutter pub get`, `flutter doctor`, or any other `flutter` command hangs forever with no output, and Ctrl+C just shows `Terminate batch job (Y/N)?` immediately
- **Cause:** A stale `flutter.bat.lock` file in `<flutter-sdk>\bin\cache\`. Flutter creates this lock on every invocation and releases it on exit; if a previous Flutter command was killed mid-flight (Ctrl+C, crash, antivirus quarantine, OneDrive sync), the lock can survive even though the holding process is gone. Every subsequent `flutter` invocation then blocks waiting for the lock to release.
- **Solution:**
  1. Confirm no Dart/Flutter processes are still running:
     ```powershell
     Get-Process | Where-Object { $_.ProcessName -match "dart|flutter|pub" }
     ```
  2. If anything's listed, `Stop-Process -Force` them.
  3. Reboot Windows — fastest reliable fix; releases any stranded handle on the lock.
  4. After reboot, delete the lock file directly:
     ```powershell
     Remove-Item <flutter-sdk>\bin\cache\flutter.bat.lock
     ```
  5. Add Defender exclusions for the Flutter SDK folder, the project folder, and `%LOCALAPPDATA%\Pub\Cache` to prevent recurrence — Defender's real-time scan is the most common culprit for orphaning the lock on Windows.

**Issue (Windows):** `flutter pub get` hangs at `Downloading Dart SDK from Flutter engine ...` with no progress, even after rebooting and clearing the lock
- **Cause:** Flutter's first-run SDK bootstrap is `bin\internal\update_dart_sdk.ps1`, which downloads ~200 MB via PowerShell's `Invoke-WebRequest`. On many Windows configurations `Invoke-WebRequest` stalls indefinitely on large downloads (Defender stream-scanning, IPv6 routing quirks, the well-known `$ProgressPreference` slowdown). TCP to `storage.googleapis.com` succeeds, but no bytes flow.
- **Solution:** Bypass the script — pull the SDK manually with `curl.exe` (built into Windows 10/11) and tell Flutter the cache is already up-to-date.
  1. Read the engine version Flutter wants:
     ```powershell
     $ev = (Get-Content "<flutter-sdk>\bin\internal\engine.version").Trim()
     ```
  2. Download the SDK zip directly:
     ```powershell
     curl.exe -L --max-time 120 -o "$env:TEMP\dart-sdk.zip" "https://storage.googleapis.com/flutter_infra_release/flutter/$ev/dart-sdk-windows-x64.zip"
     ```
  3. Extract with `tar.exe` (also built in; far more reliable than `Expand-Archive` for large zips, which can leave files corrupt or empty especially when Defender is mid-scan):
     ```powershell
     Remove-Item "<flutter-sdk>\bin\cache\dart-sdk" -Recurse -Force -ErrorAction SilentlyContinue
     tar.exe -xf "$env:TEMP\dart-sdk.zip" -C "<flutter-sdk>\bin\cache"
     ```
  4. Mark the cache as fresh so `update_dart_sdk.ps1` hits its early-exit gate (line 38: compares `engine.stamp` vs. `engine-dart-sdk.stamp`):
     ```powershell
     $ev | Out-File "<flutter-sdk>\bin\cache\engine-dart-sdk.stamp" -Encoding ASCII
     ```
  5. Run `flutter pub get` — it should skip the SDK download entirely and proceed to "Building flutter tool... Resolving dependencies...".

  Add the Defender exclusions *before* downloading: exclusions don't retroactively unquarantine files Defender has already inspected, so a stream scan during the curl/extract can still empty out `dart-sdk\` afterwards. If you've already had the issue, redo the curl + tar steps after exclusions are confirmed in place.

## Roadmap to 1.0

"1.0" here means *shippable to a non-developer who isn't you* — they can install, enter their TMDB key, and use the app without seeing raw exceptions or breaking on update. Ordered by priority:

**Ship-blockers**

- [x] **In-app TMDB API key entry.** ~~Right now the key only flows in via `--dart-define`, which means a non-developer literally cannot use the app.~~ Done — Settings now persists a stored key via `flutter_secure_storage` and falls back to `--dart-define` if no key is stored.
- [x] **TMDB error handling.** ~~`TmdbService` doesn't wrap Dio. Riverpod catches the exception so the app doesn't crash, but detail/browse screens show raw `DioException [bad response]` strings.~~ Done — `TmdbService` now throws a sealed `TmdbError` hierarchy (missing/invalid key, no network, timeout, 404, 429, 5xx, malformed JSON). Detail screens use `ErrorView` with a Retry button (or "Open Settings" for key problems). Browse rows and search use the same widget.
- [x] **Schema migration strategy.** ~~`schemaVersion` is 1 with no `MigrationStrategy`. Adding any column will brick existing user data.~~ Done — `AppDatabase` now defines a `MigrationStrategy` (with `onCreate`, `onUpgrade`, and `beforeOpen` enabling FK enforcement). Schema dump workflow documented in `drift_schemas/README.md`. First-time baseline still needs `dart run drift_dev schema dump …` to capture v1 — see Development Notes.

**Polish**

- [x] Wire `url_launcher` so the Settings "Get a TMDB API Key" row actually opens the browser.
- [x] Empty states for the Library tabs and search results — done. Library tabs now distinguish "empty library" (with a "Browse" CTA) from "filters hide everything" (with a "Clear filters" CTA). Search shows a styled `EmptyState` instead of a bare `Text`.
- [x] ~~Verify whether the genre names on detail screens are actually missing.~~ Investigated — they are not. `genreNames` is only read on detail screens, which fetch `/movie/{id}` and `/tv/{id}`, both of which return full `genres` arrays. The original claim was incorrect; no fix needed.

**Tests**

Decision: 1.0 is a personal-use build. Manual smoke-testing the critical paths is enough — no automated test suite required. If the project later opens up to other users, revisit this and add coverage for `TmdbService` (mocked Dio across the error paths), filter logic in `library_provider.dart`, and at least one widget test for the library grid.

## Nice-to-have (beyond 1.0)

- [ ] Light-mode option and theme toggle (most media apps stay dark-only by design — defer unless requested)
- [ ] TV progress validation against the show's actual season/episode counts
- [ ] User authentication and cloud sync
- [ ] Watch list sharing with friends
- [ ] Personalized recommendations
- [ ] Offline support for cached content
- [ ] Analytics and insights
- [ ] IMDb integration

## For AI Assistants

When opening this project in a new session:
1. The database is Drift-based SQLite; schema in `lib/database/database.dart`
2. All state is managed via Riverpod; providers in `lib/providers/`
3. TMDB API key is provided via `--dart-define=TMDB_API_KEY=...`; read through `TmdbConfig.apiKey` / `TmdbConfig.hasApiKey`
4. Code generation is required; run `dart run build_runner build` if files are modified
5. Material Design 3 is the design system; check `lib/app.dart` for theme setup
6. The app uses GoRouter for navigation; check routing in `lib/app.dart`
7. Early MVP with no automated tests yet — see the "Roadmap to 1.0" section for the remaining punch list
