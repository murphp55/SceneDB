import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/database.dart';
import '../models/enums.dart';

part 'library_provider.g.dart';

// ---------------------------------------------------------------------------
// Database provider — overridden in main.dart with the real instance
// ---------------------------------------------------------------------------

final databaseProvider = Provider<AppDatabase>(
  (_) => throw UnimplementedError('databaseProvider must be overridden'),
);

// ---------------------------------------------------------------------------
// Filter state
// ---------------------------------------------------------------------------

class LibraryFilter {
  const LibraryFilter({
    this.statuses = const {},
    this.ratings = const {},
    this.genres = const {},
  });

  final Set<WatchStatus> statuses;
  final Set<LetterRating?> ratings;
  final Set<String> genres;

  bool get isActive =>
      statuses.isNotEmpty || ratings.isNotEmpty || genres.isNotEmpty;

  LibraryFilter copyWith({
    Set<WatchStatus>? statuses,
    Set<LetterRating?>? ratings,
    Set<String>? genres,
  }) {
    return LibraryFilter(
      statuses: statuses ?? this.statuses,
      ratings: ratings ?? this.ratings,
      genres: genres ?? this.genres,
    );
  }
}

@riverpod
class MovieLibraryFilter extends _$MovieLibraryFilter {
  @override
  LibraryFilter build() => const LibraryFilter();

  void update(LibraryFilter filter) => state = filter;
  void clear() => state = const LibraryFilter();
}

@riverpod
class ShowLibraryFilter extends _$ShowLibraryFilter {
  @override
  LibraryFilter build() => const LibraryFilter();

  void update(LibraryFilter filter) => state = filter;
  void clear() => state = const LibraryFilter();
}

// ---------------------------------------------------------------------------
// Movie library providers
// ---------------------------------------------------------------------------

@riverpod
Stream<List<TrackedMovy>> trackedMoviesStream(Ref ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllMovies();
}

@riverpod
Future<List<TrackedMovy>> filteredMovies(Ref ref) async {
  final all = await ref.watch(trackedMoviesStreamProvider.future);
  final filter = ref.watch(movieLibraryFilterProvider);

  if (!filter.isActive) return all;

  return all.where((m) {
    if (filter.statuses.isNotEmpty && !filter.statuses.contains(m.status)) {
      return false;
    }
    if (filter.ratings.isNotEmpty && !filter.ratings.contains(m.rating)) {
      return false;
    }
    if (filter.genres.isNotEmpty &&
        !filter.genres.any((g) => m.genres.contains(g))) {
      return false;
    }
    return true;
  }).toList();
}

// ---------------------------------------------------------------------------
// Show library providers
// ---------------------------------------------------------------------------

@riverpod
Stream<List<TrackedShow>> trackedShowsStream(Ref ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllShows();
}

@riverpod
Future<List<TrackedShow>> filteredShows(Ref ref) async {
  final all = await ref.watch(trackedShowsStreamProvider.future);
  final filter = ref.watch(showLibraryFilterProvider);

  if (!filter.isActive) return all;

  return all.where((s) {
    if (filter.statuses.isNotEmpty && !filter.statuses.contains(s.status)) {
      return false;
    }
    if (filter.ratings.isNotEmpty && !filter.ratings.contains(s.rating)) {
      return false;
    }
    if (filter.genres.isNotEmpty &&
        !filter.genres.any((g) => s.genres.contains(g))) {
      return false;
    }
    return true;
  }).toList();
}

// ---------------------------------------------------------------------------
// CRUD notifiers
// ---------------------------------------------------------------------------

@riverpod
class MovieLibraryNotifier extends _$MovieLibraryNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(databaseProvider);

  Future<void> addOrUpdate({
    required int tmdbId,
    required String title,
    String? posterPath,
    List<String> genres = const [],
    WatchStatus status = WatchStatus.yetToWatch,
    LetterRating? rating,
    DateTime? watchedOn,
  }) async {
    await _db.upsertMovie(
      TrackedMoviesCompanion.insert(
        tmdbId: tmdbId,
        title: title,
        posterPath: Value(posterPath),
        genres: Value(genres),
        status: Value(status),
        rating: Value(rating),
        watchedOn: Value(watchedOn),
      ),
    );
  }

  Future<void> remove(int tmdbId) => _db.deleteMovie(tmdbId);
}

@riverpod
class ShowLibraryNotifier extends _$ShowLibraryNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(databaseProvider);

  Future<void> addOrUpdate({
    required int tmdbId,
    required String title,
    String? posterPath,
    List<String> genres = const [],
    WatchStatus status = WatchStatus.yetToWatch,
    LetterRating? rating,
    DateTime? watchedOn,
    int? currentSeason,
    int? currentEpisode,
  }) async {
    await _db.upsertShow(
      TrackedShowsCompanion.insert(
        tmdbId: tmdbId,
        title: title,
        posterPath: Value(posterPath),
        genres: Value(genres),
        status: Value(status),
        rating: Value(rating),
        watchedOn: Value(watchedOn),
        currentSeason: Value(currentSeason),
        currentEpisode: Value(currentEpisode),
      ),
    );
  }

  Future<void> remove(int tmdbId) => _db.deleteShow(tmdbId);
}

// ---------------------------------------------------------------------------
// Convenience: watch a single entry by tmdbId
// ---------------------------------------------------------------------------

@riverpod
Future<TrackedMovy?> trackedMovie(Ref ref, int tmdbId) {
  final db = ref.watch(databaseProvider);
  return db.getMovieByTmdbId(tmdbId);
}

@riverpod
Future<TrackedShow?> trackedShow(Ref ref, int tmdbId) {
  final db = ref.watch(databaseProvider);
  return db.getShowByTmdbId(tmdbId);
}
