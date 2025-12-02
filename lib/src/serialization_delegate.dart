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
  // 將字串轉換為整數
  @override
  int? fromString(String value) => int.tryParse(value);

  // 格式化整數為字串
  @override
  String formatString(int value) => value.toString();
}

// 布林值序列化委託
class BoolSerializationDelegate extends SimpleSerializationDelegate<bool> {
  // 注意：這裡簡單地將 "true" 視為 true，其他皆為 false
  @override
  bool? fromString(String value) => value.toLowerCase() == 'true';

  // 格式化布林值為字串
  @override
  String formatString(bool value) => value.toString();
}

// 浮點數序列化委託
class DoubleSerializationDelegate extends SimpleSerializationDelegate<double> {
  // 將字串轉換為浮點數
  @override
  double? fromString(String value) => double.tryParse(value);

  // 格式化浮點數為字串
  @override
  String formatString(double value) => value.toString();
}
