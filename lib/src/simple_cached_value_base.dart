import 'dart:async';

typedef SimpleCacheValueProvider<T> = FutureOr<T?> Function();

/// ------------------------------------------- //
/// 簡單的快取物件基類
/// 這個類別用於實現簡單的快取邏輯，支持 TTL（存活時間）
/// 使用時需要提供一個值提供者（SimpleCacheValueProvider），
/// 當快取過期或無效時，會調用這個提供者來獲取新的值
/// ------------------------------------------- //
abstract class SimpleCacheObject<T> {
  Duration get ttl;
  bool get isValid;
  bool get isExpired;

  FutureOr<T?> getValue();
  void invalidate();
}

// ------------------------------------------- //
/// 簡單的序列化函數類型
/// 用於將物件轉換為字串和從字串轉換回物件
/// 這些函數可以用於簡單的類型，如 String、int、bool 等
/// ------------------------------------------- //
typedef SimpleSerializationFromString<T> = T? Function(String value);
typedef SimpleSerializationFormatString<T> = String Function(T value);

// ------------------------------------------- //
/// 簡單的序列化委託，用於將物件轉換為字串和從字串轉換回物件
/// 這個委託可以用於簡單的類型，如 String、int、bool 等
/// ------------------------------------------- //
abstract class SimpleSerializationDelegate<T> {
  T? fromString(String value);
  String formatString(T value);
}

// ------------------------------------------- //
/// 持久化快取物件的基類
/// 這個類別用於實現需要持久化存儲的快取物件，例如使用 SharedPreferences
/// 這個類別需要實現 ensureInitialized 方法來確保快取物件已經初始化
/// ------------------------------------------- //
abstract class PersistentCacheObject<T> extends SimpleCacheObject<T> {
  void ensureInitialized();
}
