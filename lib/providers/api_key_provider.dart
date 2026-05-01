import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/tmdb_constants.dart';
import '../services/api_key_service.dart';

part 'api_key_provider.g.dart';

/// Source of the currently-resolved TMDB API key. Used by the Settings screen
/// so the user knows where the active key is coming from.
enum ApiKeySource {
  /// User-entered, persisted in secure storage.
  stored,

  /// Build-time fallback supplied via `--dart-define=TMDB_API_KEY=...`.
  dartDefine,

  /// No key available from either source. The app cannot make TMDB calls.
  none,
}

class ApiKeyState {
  const ApiKeyState({required this.key, required this.source});

  final String key;
  final ApiKeySource source;

  bool get isConfigured => key.isNotEmpty;
}

/// Resolves the active TMDB API key. Stored key wins; falls back to the
/// dart-define; returns an empty key with `source == none` if neither exists.
///
/// Mutating via `save()` / `clear()` rebuilds the state, which in turn
/// invalidates `tmdbServiceProvider` and refetches every dependent provider.
@riverpod
class ApiKey extends _$ApiKey {
  @override
  Future<ApiKeyState> build() async {
    final stored = await ApiKeyService.read();
    if (stored != null && stored.isNotEmpty) {
      return ApiKeyState(key: stored, source: ApiKeySource.stored);
    }
    final fallback = TmdbConfig.dartDefineApiKey;
    if (fallback.isNotEmpty) {
      return ApiKeyState(key: fallback, source: ApiKeySource.dartDefine);
    }
    return const ApiKeyState(key: '', source: ApiKeySource.none);
  }

  /// Persists [key] and updates state. Empty strings clear the stored key.
  Future<void> save(String key) async {
    final trimmed = key.trim();
    await ApiKeyService.write(trimmed);
    if (trimmed.isNotEmpty) {
      state = AsyncData(
        ApiKeyState(key: trimmed, source: ApiKeySource.stored),
      );
    } else {
      // Treat empty save as a clear and fall back to dart-define if available.
      state = AsyncData(_resolveFallback());
    }
  }

  /// Removes the stored key and falls back to dart-define if available.
  Future<void> clear() async {
    await ApiKeyService.clear();
    state = AsyncData(_resolveFallback());
  }

  ApiKeyState _resolveFallback() {
    final fallback = TmdbConfig.dartDefineApiKey;
    if (fallback.isNotEmpty) {
      return ApiKeyState(key: fallback, source: ApiKeySource.dartDefine);
    }
    return const ApiKeyState(key: '', source: ApiKeySource.none);
  }
}
