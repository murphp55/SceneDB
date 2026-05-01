import 'package:flutter/foundation.dart';

import 'tmdb_genre.dart';

@immutable
class TmdbMovie {
  const TmdbMovie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.genres,
    this.genreIds,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;
  final List<TmdbGenre>? genres;
  final List<int>? genreIds;

  factory TmdbMovie.fromJson(Map<String, dynamic> json) {
    return TmdbMovie(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((g) => TmdbGenre.fromJson(g as Map<String, dynamic>))
          .toList(),
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((id) => id as int)
          .toList(),
    );
  }

  List<String> get genreNames {
    if (genres != null) return genres!.map((g) => g.name).toList();
    return [];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TmdbMovie && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class TmdbMoviePage {
  const TmdbMoviePage({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<TmdbMovie> results;
  final int totalPages;
  final int totalResults;

  factory TmdbMoviePage.fromJson(Map<String, dynamic> json) {
    return TmdbMoviePage(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>? ?? [])
          .map((m) => TmdbMovie.fromJson(m as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int? ?? 0,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
}
