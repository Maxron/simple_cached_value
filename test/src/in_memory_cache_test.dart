import 'package:flutter_test/flutter_test.dart';
import 'package:simple_cached_value/simple_cached_value.dart';

void main() {
  group('InMemoryCacheObject', () {
    test('should return initial value if valid', () async {
      final cache = InMemoryCacheObject<int>(
        value: 42,
        valueProvider: () => Future.value(99),
      );

      expect(await cache.getValue(), equals(42));
      expect(cache.isValid, isTrue);
      expect(cache.isExpired, isFalse);
    });

    test('should fetch new value if expired', () async {
      final cache = InMemoryCacheObject<int>(
        value: 42,
        valueProvider: () => Future.value(100),
        ttl: Duration(milliseconds: 1),
      );

      await Future.delayed(Duration(milliseconds: 2));
      expect(cache.isExpired, isTrue);

      final value = await cache.getValue();
      expect(value, equals(100));
      expect(cache.isValid, isTrue);
    });

    test('should invalidate and then fetch new value', () async {
      var providerCallCount = 0;

      final cache = InMemoryCacheObject<int>(
        value: 1,
        valueProvider: () {
          providerCallCount++;
          return Future.value(2);
        },
      );

      expect(await cache.getValue(), equals(1));

      cache.invalidate();
      expect(cache.isValid, isFalse);

      final value = await cache.getValue();
      expect(value, equals(2));
      expect(providerCallCount, equals(1));
      expect(cache.isValid, isTrue);
    });

    test('should return null if provider returns null', () async {
      final cache = InMemoryCacheObject<String>(
        valueProvider: () => Future.value(null),
      );

      final value = await cache.getValue();
      expect(value, isNull);
      expect(cache.isValid, isFalse);
    });

    test('should respect custom ttl', () async {
      final cache = InMemoryCacheObject<int>(
        value: 5,
        valueProvider: () => Future.value(10),
        ttl: Duration(milliseconds: 100),
      );

      expect(cache.ttl, Duration(milliseconds: 100));
    });
  });
}
