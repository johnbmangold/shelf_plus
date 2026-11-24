import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstraction over encrypted key-value storage for tokens and custom headers.
abstract interface class SecureStorageService {
  /// Reads the value associated with [key], or `null` if absent.
  Future<String?> read(String key);

  /// Persists [value] under [key].
  Future<void> write(String key, String value);

  /// Removes the entry for [key].
  Future<void> delete(String key);

  /// Removes all entries managed by this secure storage service.
  Future<void> deleteAll();
}

/// Platform-backed [SecureStorageService] using Keychain on iOS and
/// encrypted storage on Android.
class FlutterSecureStorageService implements SecureStorageService {
  /// Creates a [FlutterSecureStorageService].
  const new({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
