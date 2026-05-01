import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper around `flutter_secure_storage` for the TMDB API key.
///
/// On Android this uses the Keystore-backed `EncryptedSharedPreferences`; on
/// iOS the keychain; on web it falls back to a JS-side encrypted store. We
/// only need read/write/clear for a single value.
class ApiKeyService {
  ApiKeyService._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyName = 'tmdb_api_key';

  /// Returns the stored key, or `null` if no key has been saved.
  static Future<String?> read() => _storage.read(key: _keyName);

  /// Persists [key]. Empty strings are treated as a clear.
  static Future<void> write(String key) {
    if (key.isEmpty) return clear();
    return _storage.write(key: _keyName, value: key);
  }

  /// Removes the stored key. Subsequent reads return `null`.
  static Future<void> clear() => _storage.delete(key: _keyName);
}
