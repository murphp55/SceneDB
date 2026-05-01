// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiKeyHash() => r'c424956b781b5bb0fb8e1af31dbe7810b4519a63';

/// Resolves the active TMDB API key. Stored key wins; falls back to the
/// dart-define; returns an empty key with `source == none` if neither exists.
///
/// Mutating via `save()` / `clear()` rebuilds the state, which in turn
/// invalidates `tmdbServiceProvider` and refetches every dependent provider.
///
/// Copied from [ApiKey].
@ProviderFor(ApiKey)
final apiKeyProvider =
    AutoDisposeAsyncNotifierProvider<ApiKey, ApiKeyState>.internal(
  ApiKey.new,
  name: r'apiKeyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiKeyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ApiKey = AutoDisposeAsyncNotifier<ApiKeyState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
