import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys
  static const _accessTokenKey = 'access_token';
  static const _roleKey = 'role';

  Future<String?> get accessToken async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> get role async {
    return await _storage.read(key: _roleKey);
  }

  Future<void> setAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> setRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _roleKey);
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsKey(String key) async {
    final allKeys = await _storage.readAll();
    return allKeys.containsKey(key);
  }
}
