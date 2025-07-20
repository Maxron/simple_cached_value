import 'package:flutter_test/flutter_test.dart';
import 'package:simple_cached_value/simple_cached_value.dart';

void main() {
  group('StringSerializationDelegate', () {
    final delegate = StringSerializationDelegate();

    test('fromString should return the same string', () {
      expect(delegate.fromString('abc'), 'abc');
    });

    test('formatString should return the same string', () {
      expect(delegate.formatString('xyz'), 'xyz');
    });
  });

  group('IntSerializationDelegate', () {
    final delegate = IntSerializationDelegate();

    test('fromString should parse int correctly', () {
      expect(delegate.fromString('123'), 123);
      expect(delegate.fromString('abc'), isNull);
    });

    test('formatString should convert int to string', () {
      expect(delegate.formatString(456), '456');
    });
  });

  group('BoolSerializationDelegate', () {
    final delegate = BoolSerializationDelegate();

    test('fromString should parse boolean correctly', () {
      expect(delegate.fromString('true'), true);
      expect(delegate.fromString('TRUE'), true);
      expect(delegate.fromString('false'), false);
      expect(delegate.fromString('something'), false);
    });

    test('formatString should convert boolean to string', () {
      expect(delegate.formatString(true), 'true');
      expect(delegate.formatString(false), 'false');
    });
  });

  group('DoubleSerializationDelegate', () {
    final delegate = DoubleSerializationDelegate();

    test('fromString should parse double correctly', () {
      expect(delegate.fromString('3.14'), 3.14);
      expect(delegate.fromString('abc'), isNull);
    });

    test('formatString should convert double to string', () {
      expect(delegate.formatString(2.718), '2.718');
    });
  });
}
