import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/enums.dart';
import 'converters.dart';

part 'database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

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

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'scenedb');
  }

  // --- Movies ---

  Stream<List<TrackedMovy>> watchAllMovies() =>
      select(trackedMovies).watch();

  Future<List<TrackedMovy>> getAllMovies() =>
      select(trackedMovies).get();

  Future<TrackedMovy?> getMovieByTmdbId(int tmdbId) {
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
