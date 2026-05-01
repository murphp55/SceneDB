import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/tmdb_genre.dart';
import '../models/tmdb_movie.dart';
import '../models/tmdb_tv.dart';
import '../services/tmdb_service.dart';
import 'api_key_provider.dart';

part 'tmdb_provider.g.dart';

// ---------------------------------------------------------------------------
// Service provider
// ---------------------------------------------------------------------------

/// Rebuilds whenever the resolved API key changes. Dependent providers
/// (trending, search, detail, etc.) automatically invalidate and refetch.
@riverpod
TmdbService tmdbService(Ref ref) {
  final keyState = ref.watch(apiKeyProvider).valueOrNull;
  return TmdbService(apiKey: keyState?.key ?? '');
}

// ---------------------------------------------------------------------------
// Movie providers
// ---------------------------------------------------------------------------

@riverpod
Future<List<TmdbMovie>> trendingMovies(Ref ref) {
  return ref.watch(tmdbServiceProvider).getTrendingMovies();
}

@riverpod
Future<List<TmdbMovie>> topRatedMovies(Ref ref) {
  return ref.watch(tmdbServiceProvider).getTopRatedMovies();
}

@riverpod
Future<TmdbMovie> movieDetail(Ref ref, int id) {
  return ref.watch(tmdbServiceProvider).getMovieDetail(id);
}

@riverpod
Future<List<TmdbGenre>> movieGenres(Ref ref) {
  return ref.watch(tmdbServiceProvider).getMovieGenres();
}

// ---------------------------------------------------------------------------
// TV providers
// ---------------------------------------------------------------------------

@riverpod
Future<List<TmdbTv>> trendingTv(Ref ref) {
  return ref.watch(tmdbServiceProvider).getTrendingTv();
}

@riverpod
Future<List<TmdbTv>> topRatedTv(Ref ref) {
  return ref.watch(tmdbServiceProvider).getTopRatedTv();
}

@riverpod
Future<TmdbTv> tvDetail(Ref ref, int id) {
  return ref.watch(tmdbServiceProvider).getTvDetail(id);
}

@riverpod
Future<List<TmdbGenre>> tvGenres(Ref ref) {
  return ref.watch(tmdbServiceProvider).getTvGenres();
}

// ---------------------------------------------------------------------------
// Search providers (driven by a separate query notifier)
// ---------------------------------------------------------------------------

@riverpod
class MovieSearchQuery extends _$MovieSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
class TvSearchQuery extends _$TvSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
Future<List<TmdbMovie>> movieSearchResults(Ref ref) {
  final query = ref.watch(movieSearchQueryProvider);
  if (query.trim().isEmpty) return Future.value([]);
  return ref.watch(tmdbServiceProvider).searchMovies(query);
}

@riverpod
Future<List<TmdbTv>> tvSearchResults(Ref ref) {
  final query = ref.watch(tvSearchQueryProvider);
  if (query.trim().isEmpty) return Future.value([]);
  return ref.watch(tmdbServiceProvider).searchTv(query);
}
