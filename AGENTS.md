# SceneDB — Agent Notes

## One-liner
Cross-platform Flutter (Dart 3.5+) app for tracking movies/TV via TMDB + a local Drift/SQLite library.

## Run it
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows                                  # paste key in Settings on first launch
# or bake the key in:
flutter run -d windows --dart-define=TMDB_API_KEY=your_key_here
```

## Where we are right now
- Last touched: 2026-05-10 (commit `4675c8e` "Build verified on Windows + color-coded genre chips")
- Working on: Color-coded genre chips on browse/search cards. README's *Pick Up Here* block is the authoritative status — it lists the manual smoke-test as the only remaining 1.0 blocker.
- Known broken: Uncommitted edits on `lib/widgets/title_card.dart`, `lib/widgets/trending_row.dart`, and both `browse/*_browse_tab.dart` tabs — the genre-chip wiring into browse cards is mid-change. `git status` is dirty; tighten types and finish the chip plumbing before committing.

*This section goes stale fast. Check `git log -5` and `git status` before trusting it. README.md's "Pick Up Here" block is canonical.*

## Gotchas
- `.g.dart` files (`database.g.dart`, `*_provider.g.dart`) are checked in but go stale — always re-run `build_runner` after touching a `@riverpod` annotation or a Drift table.
- TMDB errors are translated into the `TmdbError` sealed hierarchy in `lib/services/tmdb_error.dart`. UI matches on subtypes / reads `userMessage` + `isRetryable` — never catch raw `DioException`.
- API key resolution order in `apiKeyProvider`: secure_storage wins over `--dart-define`; both absent → `TmdbMissingKeyError` and `ErrorView` shows an "Open Settings" CTA. `tmdbServiceProvider` watches it, so saving/clearing the key invalidates every downstream TMDB provider.
- Drift schema migrations: bump `schemaVersion`, add an `onUpgrade` step, then `dart run drift_dev schema dump lib/database/database.dart drift_schemas/` + regenerate `test/generated_migrations/`. v1 baseline lives in `drift_schemas/drift_schema_v1.json`.
- Windows `flutter.bat.lock` can strand if a `flutter` command is killed mid-flight (Defender, OneDrive, Ctrl+C). Reboot, delete `<flutter-sdk>\bin\cache\flutter.bat.lock`, add Defender exclusions. See README *Common Issues* for the full recovery (including the `update_dart_sdk.ps1` curl/tar workaround).
- AGP 8.11.1 requires Java 17–24 for Android builds.

## Non-obvious conventions
- All providers use `@riverpod` codegen **except** `databaseProvider`, which is a plain `Provider<AppDatabase>` overridden in `main.dart` after `AppDatabase` is opened.
- Poster/backdrop paths are stored as path-only (no base URL) — base URLs live in `lib/constants/tmdb_constants.dart`.
- DB enums serialize via `.name` strings through converters in `lib/database/converters.dart`; don't store the enum index.
- Search inputs are debounced 500 ms (`AppConstants.searchDebounce`).

See README.md for project description, tech stack, architecture, schema, full feature list, and the *Pick Up Here* status block.
