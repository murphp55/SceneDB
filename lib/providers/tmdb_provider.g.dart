// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tmdbServiceHash() => r'f17e985dabeee0948b696a4c3b6e9916f9d1eb91';

/// Rebuilds whenever the resolved API key changes. Dependent providers
/// (trending, search, detail, etc.) automatically invalidate and refetch.
///
/// Copied from [tmdbService].
@ProviderFor(tmdbService)
final tmdbServiceProvider = AutoDisposeProvider<TmdbService>.internal(
  tmdbService,
  name: r'tmdbServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tmdbServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TmdbServiceRef = AutoDisposeProviderRef<TmdbService>;
String _$trendingMoviesHash() => r'4ccf190a6f33ae5889bfaaa931c2c18e5946d72e';

/// See also [trendingMovies].
@ProviderFor(trendingMovies)
final trendingMoviesProvider =
    AutoDisposeFutureProvider<List<TmdbMovie>>.internal(
  trendingMovies,
  name: r'trendingMoviesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trendingMoviesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrendingMoviesRef = AutoDisposeFutureProviderRef<List<TmdbMovie>>;
String _$topRatedMoviesHash() => r'b61899faba36412ae46b615900c7525aadc88cdf';

/// See also [topRatedMovies].
@ProviderFor(topRatedMovies)
final topRatedMoviesProvider =
    AutoDisposeFutureProvider<List<TmdbMovie>>.internal(
  topRatedMovies,
  name: r'topRatedMoviesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$topRatedMoviesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TopRatedMoviesRef = AutoDisposeFutureProviderRef<List<TmdbMovie>>;
String _$movieDetailHash() => r'2c7ffad8dd889587bded710cc44805880973e0f1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [movieDetail].
@ProviderFor(movieDetail)
const movieDetailProvider = MovieDetailFamily();

/// See also [movieDetail].
class MovieDetailFamily extends Family<AsyncValue<TmdbMovie>> {
  /// See also [movieDetail].
  const MovieDetailFamily();

  /// See also [movieDetail].
  MovieDetailProvider call(
    int id,
  ) {
    return MovieDetailProvider(
      id,
    );
  }

  @override
  MovieDetailProvider getProviderOverride(
    covariant MovieDetailProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'movieDetailProvider';
}

/// See also [movieDetail].
class MovieDetailProvider extends AutoDisposeFutureProvider<TmdbMovie> {
  /// See also [movieDetail].
  MovieDetailProvider(
    int id,
  ) : this._internal(
          (ref) => movieDetail(
            ref as MovieDetailRef,
            id,
          ),
          from: movieDetailProvider,
          name: r'movieDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$movieDetailHash,
          dependencies: MovieDetailFamily._dependencies,
          allTransitiveDependencies:
              MovieDetailFamily._allTransitiveDependencies,
          id: id,
        );

  MovieDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<TmdbMovie> Function(MovieDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MovieDetailProvider._internal(
        (ref) => create(ref as MovieDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TmdbMovie> createElement() {
    return _MovieDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MovieDetailRef on AutoDisposeFutureProviderRef<TmdbMovie> {
  /// The parameter `id` of this provider.
  int get id;
}

class _MovieDetailProviderElement
    extends AutoDisposeFutureProviderElement<TmdbMovie> with MovieDetailRef {
  _MovieDetailProviderElement(super.provider);

  @override
  int get id => (origin as MovieDetailProvider).id;
}

String _$movieGenresHash() => r'1aaff504c5e817052577376eacfbf4091b901b52';

/// See also [movieGenres].
@ProviderFor(movieGenres)
final movieGenresProvider = AutoDisposeFutureProvider<List<TmdbGenre>>.internal(
  movieGenres,
  name: r'movieGenresProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$movieGenresHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MovieGenresRef = AutoDisposeFutureProviderRef<List<TmdbGenre>>;
String _$trendingTvHash() => r'189abf2e48c5c70c7bedbbfd99603656025462d8';

/// See also [trendingTv].
@ProviderFor(trendingTv)
final trendingTvProvider = AutoDisposeFutureProvider<List<TmdbTv>>.internal(
  trendingTv,
  name: r'trendingTvProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$trendingTvHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrendingTvRef = AutoDisposeFutureProviderRef<List<TmdbTv>>;
String _$topRatedTvHash() => r'7dcbbb8f60384609e8373a78e6e5f654167ca2e3';

/// See also [topRatedTv].
@ProviderFor(topRatedTv)
final topRatedTvProvider = AutoDisposeFutureProvider<List<TmdbTv>>.internal(
  topRatedTv,
  name: r'topRatedTvProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$topRatedTvHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TopRatedTvRef = AutoDisposeFutureProviderRef<List<TmdbTv>>;
String _$tvDetailHash() => r'6b721c79c511e4175feb04258ed1c94f338c6912';

/// See also [tvDetail].
@ProviderFor(tvDetail)
const tvDetailProvider = TvDetailFamily();

/// See also [tvDetail].
class TvDetailFamily extends Family<AsyncValue<TmdbTv>> {
  /// See also [tvDetail].
  const TvDetailFamily();

  /// See also [tvDetail].
  TvDetailProvider call(
    int id,
  ) {
    return TvDetailProvider(
      id,
    );
  }

  @override
  TvDetailProvider getProviderOverride(
    covariant TvDetailProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tvDetailProvider';
}

/// See also [tvDetail].
class TvDetailProvider extends AutoDisposeFutureProvider<TmdbTv> {
  /// See also [tvDetail].
  TvDetailProvider(
    int id,
  ) : this._internal(
          (ref) => tvDetail(
            ref as TvDetailRef,
            id,
          ),
          from: tvDetailProvider,
          name: r'tvDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tvDetailHash,
          dependencies: TvDetailFamily._dependencies,
          allTransitiveDependencies: TvDetailFamily._allTransitiveDependencies,
          id: id,
        );

  TvDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<TmdbTv> Function(TvDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TvDetailProvider._internal(
        (ref) => create(ref as TvDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TmdbTv> createElement() {
    return _TvDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TvDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TvDetailRef on AutoDisposeFutureProviderRef<TmdbTv> {
  /// The parameter `id` of this provider.
  int get id;
}

class _TvDetailProviderElement extends AutoDisposeFutureProviderElement<TmdbTv>
    with TvDetailRef {
  _TvDetailProviderElement(super.provider);

  @override
  int get id => (origin as TvDetailProvider).id;
}

String _$tvGenresHash() => r'd77f265c4f741e9c261796238f678240ec8b3d1b';

/// See also [tvGenres].
@ProviderFor(tvGenres)
final tvGenresProvider = AutoDisposeFutureProvider<List<TmdbGenre>>.internal(
  tvGenres,
  name: r'tvGenresProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tvGenresHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TvGenresRef = AutoDisposeFutureProviderRef<List<TmdbGenre>>;
String _$movieSearchResultsHash() =>
    r'd0753592ce2314df2b872d8dce49f32e0a7764bf';

/// See also [movieSearchResults].
@ProviderFor(movieSearchResults)
final movieSearchResultsProvider =
    AutoDisposeFutureProvider<List<TmdbMovie>>.internal(
  movieSearchResults,
  name: r'movieSearchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$movieSearchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MovieSearchResultsRef = AutoDisposeFutureProviderRef<List<TmdbMovie>>;
String _$tvSearchResultsHash() => r'b23fe0479c89be809266cfa5391c3e3c12ab8272';

/// See also [tvSearchResults].
@ProviderFor(tvSearchResults)
final tvSearchResultsProvider =
    AutoDisposeFutureProvider<List<TmdbTv>>.internal(
  tvSearchResults,
  name: r'tvSearchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tvSearchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TvSearchResultsRef = AutoDisposeFutureProviderRef<List<TmdbTv>>;
String _$movieSearchQueryHash() => r'0eaf2288b28c8fefc7ffba55ff94a21ba191b8ea';

/// See also [MovieSearchQuery].
@ProviderFor(MovieSearchQuery)
final movieSearchQueryProvider =
    AutoDisposeNotifierProvider<MovieSearchQuery, String>.internal(
  MovieSearchQuery.new,
  name: r'movieSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$movieSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MovieSearchQuery = AutoDisposeNotifier<String>;
String _$tvSearchQueryHash() => r'fbd71fff8e8c35ce9da5bebdf343f44ae7d5e5d1';

/// See also [TvSearchQuery].
@ProviderFor(TvSearchQuery)
final tvSearchQueryProvider =
    AutoDisposeNotifierProvider<TvSearchQuery, String>.internal(
  TvSearchQuery.new,
  name: r'tvSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tvSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TvSearchQuery = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
                                                                                                                                                                                                                                                                                                                                 