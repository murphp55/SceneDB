# SceneDB

A cross-platform Flutter application for tracking movies and TV shows. Browse trending content from TMDB, build your personal library, track watch status, and filter by rating, status, and genre.

## Project Overview

SceneDB is an early-stage MVP that combines TMDB API integration with a local SQLite database via Drift ORM. It provides a clean, Material Design 3 interface for movie and TV enthusiasts to discover and organize their viewing experience.

**Current Status:** Early-stage MVP — core flows (browse, search, library CRUD, filters, TV episode tracking, 500ms-debounced search) are wired end-to-end. Known gaps: no tests, no TMDB error handling, genre names on detail screens aren't hydrated from IDs, the Settings "Get API Key" link is stubbed (no `url_launcher`), theme is dark-only.

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
└── widgets/
    ├── movie_card.dart      # Movie display card
    ├── tv_card.dart         # TV show display card
    └── genre_filter.dart    # Genre filter widget
```

## Key Features

### Browse
- **Trending Movies & TV**: View popular and top-rated content from TMDB
- **Full-Text Search**: Search movies and TV shows with 500ms debounce
- **Detail Screens**: View backdrop/poster images, overview, vote average, and genres

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
   - The key is supplied at build/run time via `--dart-define` so it never lands in source control

4. **Run the app:**
   ```bash
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
- **Solution:** Confirm you're passing `--dart-define=TMDB_API_KEY=...` on the command line. The Settings screen's "API Key Status" row shows whether the key was picked up at build time.

**Issue:** Images fail to load
- **Solution:** Ensure device has internet connectivity; check TMDB CDN is accessible

## Roadmap to 1.0

Concrete punch list to reach a shippable v1 (ordered roughly by priority):

- [ ] Error handling on `TmdbService` calls — wrap Dio errors, surface retry UI on detail screens instead of crashing
- [ ] Hydrate genre names from IDs on movie/TV detail screens (currently `genreNames` returns empty unless TMDB sent full genre objects)
- [ ] Wire `url_launcher` so the Settings "Get a TMDB API Key" row actually opens the browser
- [ ] Add a light-mode option and a theme toggle in Settings
- [ ] Fix small bugs: `TrackedMovy` typo in Drift schema, `tv_browse_tab.dart` using `TrendingRowBuilder.movies` for TV rows, `dynamic tracked` casts on detail screens
- [ ] First pass of tests: unit tests for `TmdbService` (with mocked Dio), filter logic in `library_provider.dart`, and one widget test for the library grid

## Nice-to-have (beyond 1.0)

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
