import 'dart:async';

abstract class PersistenceProvider {
  void ensureInitialized();

  bool containsKey(String key);

  Future<bool> setString(String key, String value);

  String? getString(String key);

  Future<bool> setInt(String key, int value);

  int? getInt(String key);

  Future<bool> remove(String key);
}
