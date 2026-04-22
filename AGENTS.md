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
#    The key is passed at run/build time via --dart-define and never checked in.

# 4. Run
flutter run --dart-define=TMDB_API_KEY=your_key_here
```

> **Note:** `database.g.dart`, `library_provider.g.dart`, and `tmdb_provider.g.dart` are all generated files. They do not exist in source control. Always run `build_runner` before running or analyzing the app.

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
│   └── tmdb_service.dart          # All TMDB API calls via Dio
├── providers/
│   ├── library_provider.dart      # Library streams, filters, CRUD notifiers
│   ├── library_provider.g.dart    # GENERATED
│   ├── tmdb_provider.dart         # TMDB data providers + search query notifiers
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
│   │   └── settings_screen.dart
│   └── detail/
│       ├── movie_detail_screen.dart  # Poster, metadata, add/edit library entry
│       └── show_detail_screen.dart   # Same + season/episode progress
└── widgets/
    ├── title_card.dart            # Poster card used in all grid/row views
    ├── status_chip.dart           # Colored chip for WatchStatus
    ├── rating_chip.dart           # Chip for LetterRating (A–F)
    ├── genre_chip.dart            # Chip for a genre string
    ├── search_bar_widget.dart     # Debounced search field (300ms)
    ├── trending_row.dart          # Horizontal scrolling row of TitleCards
    ├── filter_sheet.dart          # Bottom sheet: filter by status/rating/genre
    └── add_to_library_sheet.dart  # Bottom sheet: add/edit a library entry
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
| `tmdbServiceProvider`        | `Provider<TmdbService>`     | Auto-created        |
| `trendingMoviesProvider`     | `FutureProvider<List<TmdbMovie>>` | TMDB API      |
| `topRatedMoviesProvider`     | `FutureProvider<List<TmdbMovie>>` | TMDB API      |
| `trendingTvProvider`         | `FutureProvider<List<TmdbTv>>`    | TMDB API      |
| `topRatedTvProvider`         | `FutureProvider<List<TmdbTv>>`    | TMDB API      |
| `movieDetailProvider(id)`    | `FutureProvider<TmdbMovie>` | TMDB API            |
| `tvDetailProvider(id)`       | `FutureProvider<TmdbTv>`    | TMDB API            |
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

API key is read from the `TMDB_API_KEY` Dart environment variable (via `String.fromEnvironment` in `TmdbConfig.apiKey`) and must be passed as `--dart-define=TMDB_API_KEY=...` at run/build time. `TmdbConfig.hasApiKey` returns whether it was supplied. `TmdbService` sends it as the `api_key` query parameter on every request.

All calls are in `lib/services/tmdb_service.dart` and use `Dio`. Responses are mapped to the model classes in `lib/models/`.

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
