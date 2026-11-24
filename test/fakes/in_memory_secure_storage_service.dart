import 'package:shelf_plus/core/storage/secure_storage_service.dart';

/// In-memory [SecureStorageService] for unit and widget tests.
class InMemorySecureStorageService implements SecureStorageService {
  final Map<String, String> _values = <String, String>{};

  /// Exposes a read-only view of stored keys and values for assertions.
  Map<String, String> get snapshot => Map<String, String>.unmodifiable(_values);

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _values.clear();
  }
}
