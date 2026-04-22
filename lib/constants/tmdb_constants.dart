/// TMDB API configuration.
///
/// The API key is supplied at build/run time via `--dart-define`, so it is
/// never committed to source control. For example:
///
///     flutter run --dart-define=TMDB_API_KEY=your_key_here
///     flutter build apk --dart-define=TMDB_API_KEY=your_key_here
///
/// Get a free key at https://www.themoviedb.org/settings/api
class TmdbConfig {
  TmdbConfig._();

  /// Populated from `--dart-define=TMDB_API_KEY=...`. Empty string if not set.
  static const String apiKey = String.fromEnvironment('TMDB_API_KEY');

  /// Whether a TMDB API key has been supplied via `--dart-define`.
  static bool get hasApiKey => apiKey.isNotEmpty;

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/w1280';
}

class TmdbEndpoints {
  TmdbEndpoints._();

  static const String trendingMovies = '/trending/movie/week';
  static const String trendingTv = '/trending/tv/week';
  static const String topRatedMovies = '/movie/top_rated';
  static const String topRatedTv = '/tv/top_rated';
  static const String searchMovies = '/search/movie';
  static const String searchTv = '/search/tv';
  static const String movieGenres = '/genre/movie/list';
  static const String tvGenres = '/genre/tv/list';

  static String movieDetail(int id) => '/movie/$id';
  static String tvDetail(int id) => '/tv/$id';
}
