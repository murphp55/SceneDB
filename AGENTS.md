# SceneDB — Agent Reference

Cross-platform Flutter app for tracking movies and TV shows. Uses TMDB for content data and a local SQLite database for the user's library.

---

## Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code (Drift DB + Riverpod providers) — MUST run before building
dart run build_runner build --delete-conflicting-outputs

# 3. Get a TMDB API key from https://www.themoviedb.org/settings/api
#    Either paste it into the Settings screen on first launch (persisted via
#    flutter_secure_storage, preferred for end users) OR bake it in at build
#    time via --dart-define. The stored key wins if both are present.

# 4. Run
flutter run                                          # then enter key in Settings
flutter run --dart-define=TMDB_API_KEY=your_key_here # or bake it in
```

> **Note:** `database.g.dart`, `api_key_provider.g.dart`, `library_provider.g.dart`, and `tmdb_provider.g.dart` are generated. They are currently checked into source control (no `.g.dart` entry in `.gitignore`), but they must still be regenerated with `build_runner` whenever you change a `@riverpod` annotation or a Drift table — the committed copies will be stale otherwise.

---

## Tech Stack

| Concern        | Package                        | Version  |
|----------------|--------------------------------|----------|
| State          | flutter_riverpod + riverpod_annotation | ^2.5.1 / ^2.3.5 |
| Local DB       | drift + drift_flutter          | ^2.20.3 / ^0.2.2 |
| HTTP           | dio                            | ^5.7.0   |
| Navigation     | go_router                      | ^14.2.0  |
| Image caching  | cached_network_image           | ^3.4.1   |
| Code gen       | build_runner + drift_dev + riverpod_generator | dev |

Dart SDK: `^3.5.0`

---

## Directory Structure

```
lib/
├── main.dart                      # Entry point; opens DB, wraps app in ProviderScope
├── app.dart                       # MaterialApp.router + GoRouter config
├── constants/
│   ├── app_constants.dart         # App-wide constants (colors, spacing, etc.)
│   └── tmdb_constants.dart        # TMDB base URLs, endpoints, API key placeholder
├── models/
│   ├── enums.dart                 # WatchStatus, LetterRating enums
│   ├── tmdb_genre.dart            # TmdbGenre model (id, name)
│   ├── tmdb_movie.dart            # TmdbMovie model (TMDB API response)
│   └── tmdb_tv.dart               # TmdbTv model (TMDB API response)
├── database/
│   ├── database.dart              # Drift tables (TrackedMovies, TrackedShows) + DAOs
│   ├── database.g.dart            # GENERATED — do not edit
│   └── converters.dart            # TypeConverter: WatchStatus, LetterRating, List<String>
├── services/
│   ├── tmdb_service.dart          # All TMDB API calls via Dio
│   ├── tmdb_error.dart            # Sealed TmdbError hierarchy + DioException → TmdbError mapping
│   └── api_key_service.dart       # flutter_secure_storage wrapper for the TMDB key
├── providers/
│   ├── api_key_provider.dart      # ApiKey notifier: stored vs --dart-define vs none
│   ├── api_key_provider.g.dart    # GENERATED
│   ├── library_provider.dart      # Library streams, filters, CRUD notifiers
│   ├── library_provider.g.dart    # GENERATED
│   ├── tmdb_provider.dart         # TMDB data providers + search query notifiers + genres
│   └── tmdb_provider.g.dart       # GENERATED
├── screens/
│   ├── shell_screen.dart          # Bottom NavigationBar shell (Browse / Library / Settings)
│   ├── browse/
│   │   ├── browse_screen.dart     # Top TabBar wrapper (Movies / TV)
│   │   ├── movies_browse_tab.dart # Trending + Top Rated rows + search
│   │   └── tv_browse_tab.dart     # Same structure for TV
│   ├── library/
│   │   ├── library_screen.dart    # Top TabBar wrapper (Movies / TV) + filter button
│   │   ├── movies_library_tab.dart
│   │   └── tv_library_tab.dart
│   ├── settings/
│   │   └── settings_screen.dart   # TMDB API key entry + key-source readout
│   └── detail/
│       ├── movie_detail_screen.dart  # Poster, metadata, add/edit library entry
│       └── show_detail_screen.dart   # Same + season/episode progress
├── utils/
│   └── genre_colors.dart          # Genre id → chip background/foreground palette
└── widgets/
    ├── title_card.dart            # Poster card used in all grid/row views
    ├── status_chip.dart           # Colored chip for WatchStatus
    ├── rating_chip.dart           # Chip for LetterRating (A–F)
    ├── genre_chip.dart            # Single-genre selectable chip (used in filter sheet)
    ├── genre_chip_row.dart        # Resolves genre IDs → names + colors (browse/search cards)
    ├── search_bar_widget.dart     # Debounced search field (500ms — see AppConstants.searchDebounce)
    ├── trending_row.dart          # Horizontal scrolling row of TitleCards
    ├── filter_sheet.dart          # Bottom sheet: filter by status/rating/genre
    ├── add_to_library_sheet.dart  # Bottom sheet: add/edit a library entry
    ├── empty_state.dart           # Shared empty-state placeholder
    └── error_view.dart            # Renders TmdbError with Retry / Open Settings CTAs
```

---

## Navigation (go_router)

Routes are defined in `lib/app.dart`. The bottom nav uses a `ShellRoute`.

| Route               | Screen                    |
|---------------------|---------------------------|
| `/browse/movies`    | Browse → Movies tab       |
| `/browse/tv`        | Browse → TV tab           |
| `/library/movies`   | Library → Movies tab      |
| `/library/tv`       | Library → TV tab          |
| `/settings`         | Settings                  |
| `/movie/:id`        | Movie detail screen       |
| `/show/:id`         | Show detail screen        |

---

## Data Models

### Enums (`lib/models/enums.dart`)

```dart
enum WatchStatus { yetToWatch, inProgress, watched }
enum LetterRating { a, b, c, d, f }
```

Both have `.displayName` getters and static `fromString()` methods. They are serialized as their `.name` string in the SQLite database via type converters in `lib/database/converters.dart`.

### TMDB Models

- `TmdbMovie` — id, title, overview, posterPath, backdropPath, genreIds, releaseDate, voteAverage
- `TmdbTv` — id, name, overview, posterPath, backdropPath, genreIds, firstAirDate, voteAverage
- `TmdbGenre` — id, name

These are read-only response objects from the TMDB API and are never persisted directly.

### Database Tables (Drift)

**TrackedMovies**
| Column         | Type             | Notes                          |
|----------------|------------------|--------------------------------|
| id             | int PK autoincr  |                                |
| tmdbId         | int unique       | TMDB movie ID                  |
| title          | text             |                                |
| posterPath     | text?            | Path portion only (no base URL)|
| genres         | text (JSON list) | e.g. `["Action","Drama"]`      |
| status         | text             | WatchStatus enum name          |
| rating         | text?            | LetterRating enum name or null |
| watchedOn      | DateTime?        |                                |
| addedAt        | DateTime         | defaults to now                |

**TrackedShows** — same as above, plus:
| Column         | Type   | Notes                      |
|----------------|--------|----------------------------|
| currentSeason  | int?   | "In Progress" tracking     |
| currentEpisode | int?   | "In Progress" tracking     |

---

## State Management

All providers use `@riverpod` annotation (code-gen style). Generated files end in `.g.dart`.

### Key Providers

| Provider                     | Type                        | Source              |
|------------------------------|-----------------------------|---------------------|
| `databaseProvider`           | `Provider<AppDatabase>`     | Overridden in main  |
| `apiKeyProvider`             | `AsyncNotifier<ApiKeyState>`| `secure_storage` → `--dart-define` → none |
| `tmdbServiceProvider`        | `Provider<TmdbService>`     | Rebuilds when `apiKeyProvider` changes; all downstream providers re-fetch |
| `trendingMoviesProvider`     | `FutureProvider<List<TmdbMovie>>` | TMDB API      |
| `topRatedMoviesProvider`     | `FutureProvider<List<TmdbMovie>>` | TMDB API      |
| `trendingTvProvider`         | `FutureProvider<List<TmdbTv>>`    | TMDB API      |
| `topRatedTvProvider`         | `FutureProvider<List<TmdbTv>>`    | TMDB API      |
| `movieDetailProvider(id)`    | `FutureProvider<TmdbMovie>` | TMDB API            |
| `tvDetailProvider(id)`       | `FutureProvider<TmdbTv>`    | TMDB API            |
| `movieGenresProvider`        | `FutureProvider<List<TmdbGenre>>` | TMDB API — cached genre list used to render chips |
| `tvGenresProvider`           | `FutureProvider<List<TmdbGenre>>` | TMDB API — same for TV |
| `movieSearchQueryProvider`   | `Notifier<String>`          | UI-driven           |
| `tvSearchQueryProvider`      | `Notifier<String>`          | UI-driven           |
| `movieSearchResultsProvider` | `FutureProvider<List<TmdbMovie>>` | TMDB API      |
| `tvSearchResultsProvider`    | `FutureProvider<List<TmdbTv>>`    | TMDB API      |
| `trackedMoviesStreamProvider`| `StreamProvider<List<TrackedMovie>>` | Drift DB   |
| `trackedShowsStreamProvider` | `StreamProvider<List<TrackedShow>>` | Drift DB    |
| `filteredMoviesProvider`     | `FutureProvider<List<TrackedMovie>>` | DB + filter |
| `filteredShowsProvider`      | `FutureProvider<List<TrackedShow>>` | DB + filter |
| `movieLibraryFilterProvider` | `Notifier<LibraryFilter>`   | UI-driven           |
| `showLibraryFilterProvider`  | `Notifier<LibraryFilter>`   | UI-driven           |
| `movieLibraryNotifierProvider` | `Notifier<void>`          | CRUD to DB          |
| `showLibraryNotifierProvider`  | `Notifier<void>`          | CRUD to DB          |
| `trackedMovieProvider(id)`   | `FutureProvider<TrackedMovie?>` | Single DB lookup |
| `trackedShowProvider(id)`    | `FutureProvider<TrackedShow?>` | Single DB lookup |

### Adding/Editing a Library Entry

Call the CRUD notifier from any widget:

```dart
// Add or update a movie
ref.read(movieLibraryNotifierProvider.notifier).addOrUpdate(
  tmdbId: movie.id,
  title: movie.title,
  posterPath: movie.posterPath,
  genres: genreNames,       // List<String>
  status: WatchStatus.watched,
  rating: LetterRating.a,
  watchedOn: DateTime.now(),
);

// Remove
ref.read(movieLibraryNotifierProvider.notifier).remove(tmdbId);
```

Shows have the same API plus `currentSeason` and `currentEpisode`.

### Filtering

`LibraryFilter` holds three `Set<>` fields: `statuses`, `ratings`, `genres`. All are empty by default (no filter active). Update via:

```dart
ref.read(movieLibraryFilterProvider.notifier).update(
  filter.copyWith(statuses: {WatchStatus.watched}),
);
```

---

## TMDB API

Base URL: `https://api.themoviedb.org/3`
Image URL: `https://image.tmdb.org/t/p/w500{posterPath}`
Backdrop URL: `https://image.tmdb.org/t/p/w1280{backdropPath}`

The API key is resolved at runtime by `apiKeyProvider`:

1. **Stored key** (preferred) — entered via the Settings screen, persisted with `flutter_secure_storage` under the `tmdb_api_key` entry. See `lib/services/api_key_service.dart`.
2. **`--dart-define=TMDB_API_KEY=...`** (fallback) — surfaced through `TmdbConfig.dartDefineApiKey` in `lib/constants/tmdb_constants.dart`. Useful for dev/CI.
3. **None** — `ApiKeyState.source == ApiKeySource.none`. Every TMDB call will throw `TmdbMissingKeyError`; the `ErrorView` renders an "Open Settings" CTA.

`tmdbServiceProvider` watches `apiKeyProvider`, so saving or clearing the stored key automatically invalidates every TMDB-dependent provider and triggers a refetch with the new (or empty) key. `TmdbService` sends the key as the `api_key` query parameter on every request.

All HTTP calls are in `lib/services/tmdb_service.dart` (using `Dio`). Errors are translated into the typed `TmdbError` hierarchy in `lib/services/tmdb_error.dart` — UI code should match on subtypes or read `userMessage` / `isRetryable` instead of catching raw `DioException`s.

---

## Common Tasks

### Add a new screen
1. Create the file under `lib/screens/`
2. Add a route in `lib/app.dart`
3. Add a navigation entry in `lib/screens/shell_screen.dart` if it needs a bottom nav tab

### Add a new library field
1. Add the column to the appropriate table in `lib/database/database.dart`
2. Increment `schemaVersion` and add a migration in `AppDatabase.migration`
3. Re-run `build_runner`
4. Update `MovieLibraryNotifier.addOrUpdate` / `ShowLibraryNotifier.addOrUpdate` in `lib/providers/library_provider.dart`
5. Update `AddToLibrarySheet` widget to expose the new field in the UI

### Re-run code generation
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run on a specific platform
```bash
flutter run -d windows
flutter run -d macos
flutter run -d chrome
flutter run -d android
flutter run -d ios
```

---

## Known Setup Requirements

- **TMDB API key** must be set before any Browse or Detail screen will work. The app will show errors for all network calls until it is configured.
- **build_runner** must be run before the first build. The app will not compile without the generated `.g.dart` files.
- Java 17–24 is required for Android builds (AGP 8.11.1 constraint).
