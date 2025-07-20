import 'package:shared_preferences/shared_preferences.dart';

import 'persistance_provider.dart';

class SharedPreferenceProvider implements PersistenceProvider {
  final SharedPreferences _sharedPreference;

  SharedPreferenceProvider({
    required SharedPreferences sharedPreference,
  }) : _sharedPreference = sharedPreference;

  static Future<SharedPreferenceProvider> instance() async {
    return SharedPreferenceProvider(
      sharedPreference: await SharedPreferences.getInstance(),
    );
  }

  @override
  void ensureInitialized() {
    SharedPreferences.getInstance();
  }

  @override
  bool containsKey(String key) {
    return _sharedPreference.containsKey(key);
  }

  @override
  String? getString(String key) {
    return _sharedPreference.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) {
    return _sharedPreference.setString(key, value);
  }

  @override
  int? getInt(String key) {
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
