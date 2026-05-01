import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/enums.dart';
import 'converters.dart';

part 'database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

@DataClassName('TrackedMovie')
class TrackedMovies extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tmdbId => integer().unique()();
  TextColumn get title => text()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get genres =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get status =>
      text().map(const WatchStatusConverter()).withDefault(const Constant('yetToWatch'))();
  TextColumn get rating =>
      text().map(const NullableLetterRatingConverter()).nullable()();
  DateTimeColumn get watchedOn => dateTime().nullable()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
}

class TrackedShows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tmdbId => integer().unique()();
  TextColumn get title => text()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get genres =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get status =>
      text().map(const WatchStatusConverter()).withDefault(const Constant('yetToWatch'))();
  TextColumn get rating =>
      text().map(const NullableLetterRatingConverter()).nullable()();
  DateTimeColumn get watchedOn => dateTime().nullable()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get currentSeason => integer().nullable()();
  IntColumn get currentEpisode => integer().nullable()();
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [TrackedMovies, TrackedShows])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Bump this AND add a step to [migration]'s `onUpgrade` whenever the
  /// schema changes. After bumping:
  ///
  ///   1. `dart run drift_dev schema dump lib/database/database.dart drift_schemas/`
  ///      to capture a snapshot of the new version.
  ///   2. `dart run drift_dev schema generate drift_schemas/ test/generated_migrations/`
  ///      to regenerate test helpers.
  ///   3. Update `test/migration_test.dart` with a test for the new step.
  ///
  /// See `drift_schemas/README.md` for the full workflow.
  @override
  int get schemaVersion => 1;

  /// Migration strategy. Pattern for adding a step:
  ///
  ///   if (from == 1) {
  ///     await m.addColumn(trackedMovies, trackedMovies.someNewColumn);
  ///   }
  ///   if (from == 2) {
  ///     await m.createTable(someNewTable);
  ///   }
  ///
  /// Use `from`-based ifs (not switch on `to`) so multi-step upgrades
  /// chain correctly when a user skips versions.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // No upgrade steps yet — schema is at v1.
          // Future migrations go here, ordered by `from` version.
        },
        beforeOpen: (details) async {
          // Enforce foreign keys. Drift defaults this off on SQLite; turning
          // it on now means future FK columns behave correctly.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'scenedb');
  }

  // --- Movies ---

  Stream<List<TrackedMovie>> watchAllMovies() =>
      select(trackedMovies).watch();

  Future<List<TrackedMovie>> getAllMovies() =>
      select(trackedMovies).get();

  Future<TrackedMovie?> getMovieByTmdbId(int tmdbId) {
    return (select(trackedMovies)
          ..where((t) => t.tmdbId.equals(tmdbId)))
        .getSingleOrNull();
  }

  Future<int> upsertMovie(TrackedMoviesCompanion entry) {
    return into(trackedMovies).insertOnConflictUpdate(entry);
  }

  Future<int> deleteMovie(int tmdbId) {
    return (delete(trackedMovies)
          ..where((t) => t.tmdbId.equals(tmdbId)))
        .go();
  }

  // --- Shows ---

  Stream<List<TrackedShow>> watchAllShows() =>
      select(trackedShows).watch();

  Future<List<TrackedShow>> getAllShows() =>
      select(trackedShows).get();

  Future<TrackedShow?> getShowByTmdbId(int tmdbId) {
    return (select(trackedShows)
          ..where((t) => t.tmdbId.equals(tmdbId)))
        .getSingleOrNull();
  }

  Future<int> upsertShow(TrackedShowsCompanion entry) {
    return into(trackedShows).insertOnConflictUpdate(entry);
  }

  Future<int> deleteShow(int tmdbId) {
    return (delete(trackedShows)
          ..where((t) => t.tmdbId.equals(tmdbId)))
        .go();
  }
}
