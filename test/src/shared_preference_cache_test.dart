import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_cached_value/simple_cached_value.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesCacheObject', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('should store and retrieve cached value correctly', () async {
      final cache = SharedPreferencesCacheObject<int>(
        cacheKeyPrefix: 'test_int',
        ttl: Duration(minutes: 5),
        fromString: (s) => int.tryParse(s),
        toString: (v) => v.toString(),
        valueProvider: () async => 123,
      );

      final value = await cache.getValue();
      expect(value, equals(123));

      final stored = prefs.getString('test_int_value');
      expect(stored, equals('123'));
    });

    test('should return cached value if not expired', () async {
      final cache = SharedPreferencesCacheObject<String>(
        cacheKeyPrefix: 'test_str',
        ttl: Duration(minutes: 5),
        fromString: (s) => s,
        toString: (s) => s,
        valueProvider: () async => 'fetched',
      );

      await cache.setValue('cached');
      final value = await cache.getValue();
      expect(value, equals('cached'));
    });

    test('should fetch new value if expired', () async {
      final now = DateTime.now().subtract(Duration(minutes: 10));
      final cache = SharedPreferencesCacheObject<String>(
        cacheKeyPrefix: 'test_expired',
        ttl: Duration(seconds: 1),
        fromString: (s) => s,
        toString: (s) => s,
        valueProvider: () async => 'new_value',
      );

      await prefs.setString('test_expired_value', 'old_value');
      await prefs.setInt('test_expired_timestamp', now.millisecondsSinceEpoch);

      final value = await cache.getValue();
      expect(value, equals('new_value'));
    });

    test('should return old value if provider fails', () async {
      final now = DateTime.now().subtract(Duration(minutes: 10));
      final cache = SharedPreferencesCacheObject<String>(
        cacheKeyPrefix: 'test_fail',
        ttl: Duration(seconds: 1),
        fromString: (s) => s,
        toString: (s) => s,
        valueProvider: () async => throw Exception('fetch error'),
      );

      await prefs.setString('test_fail_value', 'fallback');
      await prefs.setInt('test_fail_timestamp', now.millisecondsSinceEpoch);

      final value = await cache.getValue();
      expect(value, equals('fallback'));
    });

    test('should clear cache correctly', () async {
      final cache = SharedPreferencesCacheObject<String>(
        cacheKeyPrefix: 'test_clear',
        ttl: Duration(minutes: 5),
        fromString: (s) => s,
        toString: (s) => s,
        valueProvider: () async => 'data',
      );

      await cache.setValue('to_be_cleared');
      expect(await cache.hasStoredData(), isTrue);

      await cache.clear();
      expect(await cache.hasStoredData(), isFalse);
    });
  });
}
