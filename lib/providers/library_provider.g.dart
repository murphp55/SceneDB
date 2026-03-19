// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackedMoviesStreamHash() =>
    r'7360f3de3d626f9809fb95fcdfef4fbc5d82793c';

/// See also [trackedMoviesStream].
@ProviderFor(trackedMoviesStream)
final trackedMoviesStreamProvider =
    AutoDisposeStreamProvider<List<TrackedMovy>>.internal(
  trackedMoviesStream,
  name: r'trackedMoviesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trackedMoviesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrackedMoviesStreamRef
    = AutoDisposeStreamProviderRef<List<TrackedMovy>>;
String _$filteredMoviesHash() => r'f4f312a68c48f632f7c1573f3edd893e2248bd27';

/// See also [filteredMovies].
@ProviderFor(filteredMovies)
final filteredMoviesProvider =
    AutoDisposeFutureProvider<List<TrackedMovy>>.internal(
  filteredMovies,
  name: r'filteredMoviesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredMoviesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredMoviesRef = AutoDisposeFutureProviderRef<List<TrackedMovy>>;
String _$trackedShowsStreamHash() =>
    r'45fa614ec8dbe5cb0556e2938a2a2511175b85fb';

/// See also [trackedShowsStream].
@ProviderFor(trackedShowsStream)
final trackedShowsStreamProvider =
    AutoDisposeStreamProvider<List<TrackedShow>>.internal(
  trackedShowsStream,
  name: r'trackedShowsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trackedShowsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrackedShowsStreamRef = AutoDisposeStreamProviderRef<List<TrackedShow>>;
String _$filteredShowsHash() => r'f624a81d32c278e6b16e625502ee7ea7a4da47a3';

/// See also [filteredShows].
@ProviderFor(filteredShows)
final filteredShowsProvider =
    AutoDisposeFutureProvider<List<TrackedShow>>.internal(
  filteredShows,
  name: r'filteredShowsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredShowsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredShowsRef = AutoDisposeFutureProviderRef<List<TrackedShow>>;
String _$trackedMovieHash() => r'ada15399e3856a3c965500f5a4724fe6ce87f3e2';

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

/// See also [trackedMovie].
@ProviderFor(trackedMovie)
const trackedMovieProvider = TrackedMovieFamily();

/// See also [trackedMovie].
class TrackedMovieFamily extends Family<AsyncValue<TrackedMovy?>> {
  /// See also [trackedMovie].
  const TrackedMovieFamily();

  /// See also [trackedMovie].
  TrackedMovieProvider call(
    int tmdbId,
  ) {
    return TrackedMovieProvider(
      tmdbId,
    );
  }

  @override
  TrackedMovieProvider getProviderOverride(
    covariant TrackedMovieProvider provider,
  ) {
    return call(
      provider.tmdbId,
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
  String? get name => r'trackedMovieProvider';
}

/// See also [trackedMovie].
class TrackedMovieProvider extends AutoDisposeFutureProvider<TrackedMovy?> {
  /// See also [trackedMovie].
  TrackedMovieProvider(
    int tmdbId,
  ) : this._internal(
          (ref) => trackedMovie(
            ref as TrackedMovieRef,
            tmdbId,
          ),
          from: trackedMovieProvider,
          name: r'trackedMovieProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trackedMovieHash,
          dependencies: TrackedMovieFamily._dependencies,
          allTransitiveDependencies:
              TrackedMovieFamily._allTransitiveDependencies,
          tmdbId: tmdbId,
        );

  TrackedMovieProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tmdbId,
  }) : super.internal();

  final int tmdbId;

  @override
  Override overrideWith(
    FutureOr<TrackedMovy?> Function(TrackedMovieRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrackedMovieProvider._internal(
        (ref) => create(ref as TrackedMovieRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tmdbId: tmdbId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TrackedMovy?> createElement() {
    return _TrackedMovieProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackedMovieProvider && other.tmdbId == tmdbId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tmdbId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrackedMovieRef on AutoDisposeFutureProviderRef<TrackedMovy?> {
  /// The parameter `tmdbId` of this provider.
  int get tmdbId;
}

class _TrackedMovieProviderElement
    extends AutoDisposeFutureProviderElement<TrackedMovy?>
    with TrackedMovieRef {
  _TrackedMovieProviderElement(super.provider);

  @override
  int get tmdbId => (origin as TrackedMovieProvider).tmdbId;
}

String _$trackedShowHash() => r'20afae4fa50d68554ee584cb0b4f577243ffbb83';

/// See also [trackedShow].
@ProviderFor(trackedShow)
const trackedShowProvider = TrackedShowFamily();

/// See also [trackedShow].
class TrackedShowFamily extends Family<AsyncValue<TrackedShow?>> {
  /// See also [trackedShow].
  const TrackedShowFamily();

  /// See also [trackedShow].
  TrackedShowProvider call(
    int tmdbId,
  ) {
    return TrackedShowProvider(
      tmdbId,
    );
  }

  @override
  TrackedShowProvider getProviderOverride(
    covariant TrackedShowProvider provider,
  ) {
    return call(
      provider.tmdbId,
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
  String? get name => r'trackedShowProvider';
}

/// See also [trackedShow].
class TrackedShowProvider extends AutoDisposeFutureProvider<TrackedShow?> {
  /// See also [trackedShow].
  TrackedShowProvider(
    int tmdbId,
  ) : this._internal(
          (ref) => trackedShow(
            ref as TrackedShowRef,
            tmdbId,
          ),
          from: trackedShowProvider,
          name: r'trackedShowProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trackedShowHash,
          dependencies: TrackedShowFamily._dependencies,
          allTransitiveDependencies:
              TrackedShowFamily._allTransitiveDependencies,
          tmdbId: tmdbId,
        );

  TrackedShowProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tmdbId,
  }) : super.internal();

  final int tmdbId;

  @override
  Override overrideWith(
    FutureOr<TrackedShow?> Function(TrackedShowRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrackedShowProvider._internal(
        (ref) => create(ref as TrackedShowRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tmdbId: tmdbId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TrackedShow?> createElement() {
    return _TrackedShowProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackedShowProvider && other.tmdbId == tmdbId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tmdbId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrackedShowRef on AutoDisposeFutureProviderRef<TrackedShow?> {
  /// The parameter `tmdbId` of this provider.
  int get tmdbId;
}

class _TrackedShowProviderElement
    extends AutoDisposeFutureProviderElement<TrackedShow?> with TrackedShowRef {
  _TrackedShowProviderElement(super.provider);

  @override
  int get tmdbId => (origin as TrackedShowProvider).tmdbId;
}

String _$movieLibraryFilterHash() =>
    r'51114730446d31f1db53863f72fc4f0dd9bdf667';

/// See also [MovieLibraryFilter].
@ProviderFor(MovieLibraryFilter)
final movieLibraryFilterProvider =
    AutoDisposeNotifierProvider<MovieLibraryFilter, LibraryFilter>.internal(
  MovieLibraryFilter.new,
  name: r'movieLibraryFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$movieLibraryFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MovieLibraryFilter = AutoDisposeNotifier<LibraryFilter>;
String _$showLibraryFilterHash() => r'ee85e3dd5806e1e6836e2baa40d6ed1f330d1987';

/// See also [ShowLibraryFilter].
@ProviderFor(ShowLibraryFilter)
final showLibraryFilterProvider =
    AutoDisposeNotifierProvider<ShowLibraryFilter, LibraryFilter>.internal(
  ShowLibraryFilter.new,
  name: r'showLibraryFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showLibraryFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShowLibraryFilter = AutoDisposeNotifier<LibraryFilter>;
String _$movieLibraryNotifierHash() =>
    r'4caf1f284b50b23a49e4f385456d6d7607afea25';

/// See also [MovieLibraryNotifier].
@ProviderFor(MovieLibraryNotifier)
final movieLibraryNotifierProvider =
    AutoDisposeNotifierProvider<MovieLibraryNotifier, void>.internal(
  MovieLibraryNotifier.new,
  name: r'movieLibraryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$movieLibraryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MovieLibraryNotifier = AutoDisposeNotifier<void>;
String _$showLibraryNotifierHash() =>
    r'b83e6b36fa1e58c57a1c9a98e04cfb921b6188f8';

/// See also [ShowLibraryNotifier].
@ProviderFor(ShowLibraryNotifier)
final showLibraryNotifierProvider =
    AutoDisposeNotifierProvider<ShowLibraryNotifier, void>.internal(
  ShowLibraryNotifier.new,
  name: r'showLibraryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showLibraryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShowLibraryNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
