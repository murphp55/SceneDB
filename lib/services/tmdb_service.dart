import 'package:dio/dio.dart';

import '../constants/tmdb_constants.dart';
import '../models/tmdb_genre.dart';
import '../models/tmdb_movie.dart';
import '../models/tmdb_tv.dart';
import 'tmdb_error.dart';

class TmdbService {
  TmdbService({required String apiKey})
      : _apiKey = apiKey,
        _dio = _buildDio(apiKey);

  final String _apiKey;
  final Dio _dio;

  /// Whether this service was constructed with a non-empty key. Callers
  /// should branch on this before issuing requests; calling TMDB without a
  /// key returns 401 for every endpoint.
  bool get hasApiKey => _apiKey.isNotEmpty;

  static Dio _buildDio(String apiKey) {
    return Dio(
      BaseOptions(
        baseUrl: TmdbConfig.baseUrl,
        queryParameters: {'api_key': apiKey},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  /// Wraps every TMDB call so errors surface as typed [TmdbError]s rather
  /// than raw [DioException]s. Pre-flights the API key check, dispatches the
  /// request, then translates any exception (network/HTTP/parse) into the
  /// most specific [TmdbError] subtype.
  Future<T> _request<T>(
    Future<Response> Function() send,
    T Function(dynamic data) parse,
  ) async {
    if (!hasApiKey) throw const TmdbMissingKeyError();

    final Response response;
    try {
      response = await send();
    } on DioException catch (e) {
      throw TmdbError.fromDio(e);
    } on TmdbError {
      rethrow;
    } catch (e) {
      throw TmdbUnknownError(e.toString());
    }

    try {
      return parse(response.data);
    } catch (_) {
      throw const TmdbMalformedResponseError();
    }
  }

  // --- Movies ---

  Future<List<TmdbMovie>> getTrendingMovies() {
    return _request(
      () => _dio.get(TmdbEndpoints.trendingMovies),
      (data) =>
          TmdbMoviePage.fromJson(data as Map<String, dynamic>).results,
    );
  }

  Future<List<TmdbMovie>> getTopRatedMovies() {
    return _request(
      () => _dio.get(TmdbEndpoints.topRatedMovies),
      (data) =>
          TmdbMoviePage.fromJson(data as Map<String, dynamic>).results,
    );
  }

  Future<List<TmdbMovie>> searchMovies(String query) {
    if (query.trim().isEmpty) return Future.value(const []);
    return _request(
      () => _dio.get(
        TmdbEndpoints.searchMovies,
        queryParameters: {'query': query},
      ),
      (data) =>
          TmdbMoviePage.fromJson(data as Map<String, dynamic>).results,
    );
  }

  Future<TmdbMovie> getMovieDetail(int id) {
    return _request(
      () => _dio.get(TmdbEndpoints.movieDetail(id)),
      (data) => TmdbMovie.fromJson(data as Map<String, dynamic>),
    );
  }

  // --- TV Shows ---

  Future<List<TmdbTv>> getTrendingTv() {
    return _request(
      () => _dio.get(TmdbEndpoints.trendingTv),
      (data) =>
          TmdbTvPage.fromJson(data as Map<String, dynamic>).results,
    );
  }

  Future<List<TmdbTv>> getTopRatedTv() {
    return _request(
      () => _dio.get(TmdbEndpoints.topRatedTv),
      (data) =>
          TmdbTvPage.fromJson(data as Map<String, dynamic>).results,
    );
  }

  Future<List<TmdbTv>> searchTv(String query) {
    if (query.trim().isEmpty) return Future.value(const []);
    return _request(
      () => _dio.get(
        TmdbEndpoints.searchTv,
        queryParameters: {'query': query},
      ),
      (data) =>
          TmdbTvPage.fromJson(data as Map<String, dynamic>).results,
    );
  }

  Future<TmdbTv> getTvDetail(int id) {
    return _request(
      () => _dio.get(TmdbEndpoints.tvDetail(id)),
      (data) => TmdbTv.fromJson(data as Map<String, dynamic>),
    );
  }

  // --- Genres ---

  Future<List<TmdbGenre>> getMovieGenres() {
    return _request(
      () => _dio.get(TmdbEndpoints.movieGenres),
      (data) {
        final map = data as Map<String, dynamic>;
        return (map['genres'] as List<dynamic>)
            .map((g) => TmdbGenre.fromJson(g as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<List<TmdbGenre>> getTvGenres() {
    return _request(
      () => _dio.get(TmdbEndpoints.tvGenres),
      (data) {
        final map = data as Map<String, dynamic>;
        return (map['genres'] as List<dynamic>)
            .map((g) => TmdbGenre.fromJson(g as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
