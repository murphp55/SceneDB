/// TMDB API configuration.
/// Replace [apiKey] with your actual TMDB API key from https://www.themoviedb.org/settings/api
class TmdbConfig {
  TmdbConfig._();

  // TODO: Replace this placeholder with your real TMDB API key.
  // Sign up at https://www.themoviedb.org/settings/api to get one for free.
  static const String apiKey = 'YOUR_TMDB_API_KEY';

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
