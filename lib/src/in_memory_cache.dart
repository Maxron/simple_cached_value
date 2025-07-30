import 'dart:async';

import 'package:simple_cached_value/simple_cached_value.dart';

/// ------------------------------------------- //
/// 記憶體中的簡單快取物件
/// 這個類別實現了 SimpleCacheObject 介面，並使用記憶體來存儲快取值
/// 這個快取物件支持 TTL（存活時間）和無效化邏輯
/// 當快取過期或無效時，會調用提供的值提供者（SimpleCacheValueProvider）來獲取新的值
/// 注意：這個快取物件不會持久化存儲，僅在應用運行期間有效
/// 預設快取存活時間為 5 分鐘，可以通過 ttl 參數來修改
/// ------------------------------------------- //
class InMemoryCacheObject<T> implements SimpleCacheObject<T> {
  T? _value;
  final SimpleCacheValueProvider<T> _valueProvider;
  DateTime? _expirationTime;
  final Duration _ttl;
  bool _isInvalidated;

  InMemoryCacheObject({
    T? value,
    required SimpleCacheValueProvider<T> valueProvider,
    Duration? ttl,
  })  : _value = value,
        _valueProvider = valueProvider,
        _ttl = ttl ?? const Duration(minutes: 5),
        _isInvalidated = false {
    _init();
  }

  void _init() {
    if (_value != null) {
      _expirationTime = _getExpirationTime();
    }
  }

  @override
  Duration get ttl => _ttl;

  @override
  bool get isValid => !_isInvalidated && !isExpired;

  @override
  bool get isExpired {
    if (_expirationTime == null) return true;
    return DateTime.now().isAfter(_expirationTime!);
  }

  @override
  FutureOr<T?> getValue() async {
    if (isValid) return _value;

    final newValue = await _valueProvider();
    if (newValue != null) {
      _value = newValue;
      _expirationTime = _getExpirationTime();
      _isInvalidated = false;
    } else {
      _value = null;
      _expirationTime = null;
    }
    return _value;
  }

  DateTime _getExpirationTime() => DateTime.now().add(_ttl);

  @override
  void invalidate() {
    _isInvalidated = true;
    _value = null;
    _expirationTime = null;
  }
}
