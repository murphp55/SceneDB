/// TMDB API configuration.
///
/// The API key can be supplied two ways:
///   1. Stored in-app via the Settings screen (persisted with
///      `flutter_secure_storage`). This is the preferred path for end users.
///   2. As a build-time fallback via `--dart-define=TMDB_API_KEY=...`. Useful
///      for development and CI.
///
/// At runtime, the stored key wins if present; otherwise the dart-define is
/// used. See `apiKeyProvider` for the resolved value.
///
/// Get a free key at https://www.themoviedb.org/settings/api
class TmdbConfig {
  TmdbConfig._();

  /// Build-time fallback key from `--dart-define=TMDB_API_KEY=...`. Empty
  /// string if not set. Prefer reading the resolved key via `apiKeyProvider`.
  static const String dartDefineApiKey =
      String.fromEnvironment('TMDB_API_KEY');

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
