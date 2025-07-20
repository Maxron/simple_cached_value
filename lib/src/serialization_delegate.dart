import 'package:simple_cached_value/simple_cached_value.dart';

// ------------------------------------------- //
// 常用的序列化委託實作
// ------------------------------------------- //

// 字串序列化委託
class StringSerializationDelegate extends SimpleSerializationDelegate<String> {
  @override
  String? fromString(String value) => value;

  @override
  String formatString(String value) => value;
}

// 整數序列化委託
class IntSerializationDelegate extends SimpleSerializationDelegate<int> {
  @override
  int? fromString(String value) => int.tryParse(value);

  @override
  String formatString(int value) => value.toString();
}

// 布林值序列化委託
class BoolSerializationDelegate extends SimpleSerializationDelegate<bool> {
  @override
  bool? fromString(String value) => value.toLowerCase() == 'true';

  @override
  String formatString(bool value) => value.toString();
}

// 浮點數序列化委託
class DoubleSerializationDelegate extends SimpleSerializationDelegate<double> {
  @override
  double? fromString(String value) => double.tryParse(value);

  @override
  String formatString(double value) => value.toString();
}
