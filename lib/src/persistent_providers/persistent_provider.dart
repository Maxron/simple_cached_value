import 'dart:async';

abstract class PersistentProvider {
  void ensureInitialized();

  Future<bool> containsKey(String key);

  Future<bool> setString(String key, String value);

  Future<String?> getString(String key);

  Future<bool> setInt(String key, int value);

  Future<int?> getInt(String key);

  Future<bool> remove(String key);
}
