import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_cached_value/simple_cached_value.dart';

// FakePersistenceProvider: In-memory implementation of PersistenceProvider
class FakePersistenceProvider implements PersistentProvider {
  final Map<String, Object?> _store = HashMap();

  @override
  void ensureInitialized() {}

  @override
  bool containsKey(String key) => _store.containsKey(key);

  @override
  String? getString(String key) => _store[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }

  @override
  int? getInt(String key) => _store[key] as int?;

  @override
  Future<bool> setInt(String key, int value) async {
    _store[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    return _store.remove(key) != null;
  }
}

void main() {
  group('Test Simple Persistence Cache', () {
    late FakePersistenceProvider provider;

    setUp(() {
      provider = FakePersistenceProvider();
    });

    test('should initialize and cache value correctly', () async {
      final cache = PersistentCachedValue<String>(
        cacheKeyPrefix: 'test_cache',
        ttl: Duration(minutes: 5),
        persistentProvider: provider,
        fromString: (s) => s,
        toString: (s) => s,
        valueProvider: () async => 'cached_value',
      );

      final value = await cache.getValue();
      expect(value, equals('cached_value'));

      expect(provider.getString('test_cache_value'), 'cached_value');
    });

    test('should return cached value if not expired', () async {
      final ttl = Duration(minutes: 5);
      final expirationTime = DateTime.now().add(ttl);
      await provider.setString('test_cache2_value', 'saved');
      await provider.setInt(
          'test_cache2_timestamp', expirationTime.millisecondsSinceEpoch);

      final cache = PersistentCachedValue<String>(
        cacheKeyPrefix: 'test_cache2',
        ttl: ttl,
        persistentProvider: provider,
        fromString: (s) => s,
        toString: (s) => s,
        valueProvider: () async => 'new_value',
      );

      final value = await cache.getValue();
      expect(value, equals('saved'));
    });

    test('should fetch new value if expired', () async {
      final old = DateTime.now().subtract(Duration(minutes: 10));
      await provider.setString('test_cache3_value', 'old');
      await provider.setInt(
          'test_cache3_timestamp', old.millisecondsSinceEpoch);

      final cache = PersistentCachedValue<String>(
        cacheKeyPrefix: 'test_cache3',
        ttl: Duration(minutes: 5),
        persistentProvider: provider,
        fromString: (s) => s,
        toString: (s) => s,
        valueProvider: () async => 'new_value',
      );

      final value = await cache.getValue();
      expect(value, equals('new_value'));
    });

    test('should return old value if provider fails', () async {
      final old = DateTime.now().subtract(Duration(minutes: 10));
      await provider.setString('test_cache4_value', 'cached');
      await provider.setInt(
          'test_cache4_timestamp', old.millisecondsSinceEpoch);

      final cache = PersistentCachedValue<String>(
        cacheKeyPrefix: 'test_cache4',
        ttl: Duration(minutes: 5),
        persistentProvider: provider,
        fromString: (s) => s,
        toString: (s) => s,
        valueProvider: () async => throw Exception('fail'),
      );

      final value = await cache.getValue();
      expect(value, equals('cached'));
    });

    test('should clear cache correctly', () async {
      final now = DateTime.now();
      await provider.setString('test_cache5_value', 'x');
      await provider.setInt(
          'test_cache5_timestamp', now.millisecondsSinceEpoch);

      final cache = PersistentCachedValue<String>(
        cacheKeyPrefix: 'test_cache5',
        ttl: Duration(minutes: 5),
        persistentProvider: provider,
        fromString: (s) => s,
        toString: (s) => s,
        valueProvider: () async => 'data',
      );

      expect(await cache.hasStoredData(), isTrue);
      await cache.clear();
      expect(await cache.hasStoredData(), isFalse);
    });
  });
}
