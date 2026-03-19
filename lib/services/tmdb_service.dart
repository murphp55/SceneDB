import 'package:dio/dio.dart';

import '../constants/tmdb_constants.dart';
import '../models/tmdb_genre.dart';
import '../models/tmdb_movie.dart';
import '../models/tmdb_tv.dart';

class TmdbService {
  TmdbService() : _dio = _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: TmdbConfig.baseUrl,
        queryParameters: {'api_key': TmdbConfig.apiKey},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    return dio;
  }

  // --- Movies ---

  Future<List<TmdbMovie>> getTrendingMovies() async {
    final response = await _dio.get(TmdbEndpoints.trendingMovies);
    return TmdbMoviePage.fromJson(response.data as Map<String, dynamic>)
        .results;
  }

  Future<List<TmdbMovie>> getTopRatedMovies() async {
    final response = await _dio.get(TmdbEndpoints.topRatedMovies);
    return TmdbMoviePage.fromJson(response.data as Map<String, dynamic>)
        .results;
  }

  Future<List<TmdbMovie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];
    final response = await _dio.get(
      TmdbEndpoints.searchMovies,
      queryParameters: {'query': query},
    );
    return TmdbMoviePage.fromJson(response.data as Map<String, dynamic>)
        .results;
  }

  Future<TmdbMovie> getMovieDetail(int id) async {
    final response = await _dio.get(TmdbEndpoints.movieDetail(id));
    return TmdbMovie.fromJson(response.data as Map<String, dynamic>);
  }

  // --- TV Shows ---

  Future<List<TmdbTv>> getTrendingTv() async {
    final response = await _dio.get(TmdbEndpoints.trendingTv);
    return TmdbTvPage.fromJson(response.data as Map<String, dynamic>).results;
  }

  Future<List<TmdbTv>> getTopRatedTv() async {
    final response = await _dio.get(TmdbEndpoints.topRatedTv);
    return TmdbTvPage.fromJson(response.data as Map<String, dynamic>).results;
  }

  Future<List<TmdbTv>> searchTv(String query) async {
    if (query.trim().isEmpty) return [];
    final response = await _dio.get(
      TmdbEndpoints.searchTv,
      queryParameters: {'query': query},
    );
    return TmdbTvPage.fromJson(response.data as Map<String, dynamic>).results;
  }

  Future<TmdbTv> getTvDetail(int id) async {
    final response = await _dio.get(TmdbEndpoints.tvDetail(id));
    return TmdbTv.fromJson(response.data as Map<String, dynamic>);
  }

  // --- Genres ---

  Future<List<TmdbGenre>> getMovieGenres() async {
    final response = await _dio.get(TmdbEndpoints.movieGenres);
    final data = response.data as Map<String, dynamic>;
    return (data['genres'] as List<dynamic>)
        .map((g) => TmdbGenre.fromJson(g as Map<String, dynamic>))
        .toList();
  }

  Future<List<TmdbGenre>> getTvGenres() async {
    final response = await _dio.get(TmdbEndpoints.tvGenres);
    final data = response.data as Map<String, dynamic>;
    return (data['genres'] as List<dynamic>)
        .map((g) => TmdbGenre.fromJson(g as Map<String, dynamic>))
        .toList();
  }
}
