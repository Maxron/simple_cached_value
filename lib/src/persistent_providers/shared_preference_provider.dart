import 'package:shared_preferences/shared_preferences.dart';

import 'persistent_provider.dart';

class SharedPreferenceProvider implements PersistentProvider {
  late final SharedPreferences _sharedPreference;

  final SharedPreferences Function() getSharedPreference;

  SharedPreferenceProvider({required this.getSharedPreference});

  @override
  void ensureInitialized() async {
    _sharedPreference = getSharedPreference();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _sharedPreference.containsKey(key);
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPreference.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) {
    return _sharedPreference.setString(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _sharedPreference.getInt(key);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return _sharedPreference.setInt(key, value);
  }

  @override
  Future<bool> remove(String key) {
    return _sharedPreference.remove(key);
  }
}
