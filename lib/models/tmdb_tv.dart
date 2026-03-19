import 'package:flutter/foundation.dart';

import 'tmdb_genre.dart';

@immutable
class TmdbTv {
  const TmdbTv({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.firstAirDate,
    this.voteAverage,
    this.genres,
    this.genreIds,
    this.numberOfSeasons,
    this.numberOfEpisodes,
  });

  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? firstAirDate;
  final double? voteAverage;
  final List<TmdbGenre>? genres;
  final List<int>? genreIds;
  final int? numberOfSeasons;
  final int? numberOfEpisodes;

  factory TmdbTv.fromJson(Map<String, dynamic> json) {
    return TmdbTv(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((g) => TmdbGenre.fromJson(g as Map<String, dynamic>))
          .toList(),
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((id) => id as int)
          .toList(),
      numberOfSeasons: json['number_of_seasons'] as int?,
      numberOfEpisodes: json['number_of_episodes'] as int?,
    );
  }

  List<String> get genreNames {
    if (genres != null) return genres!.map((g) => g.name).toList();
    return [];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TmdbTv && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class TmdbTvPage {
  const TmdbTvPage({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<TmdbTv> results;
  final int totalPages;
  final int totalResults;

  factory TmdbTvPage.fromJson(Map<String, dynamic> json) {
    return TmdbTvPage(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>? ?? [])
          .map((t) => TmdbTv.fromJson(t as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int? ?? 0,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
}
