import 'package:flutter/cupertino.dart';
import 'package:simple_cached_value/simple_cached_value.dart';

// ------------------------------------------- //
/// 持久化快取物件的實作基類
// ------------------------------------------- //

/// 使用持久化提供者實現的簡單快取物件
class PersistentCachedValue<T> extends PersistentCacheObject<T> {
  final Duration _ttl;
  final SimpleCacheValueProvider<T>? _valueProvider;
  final PersistentProvider _persistenceProvider;
  T? _cachedValue;
  DateTime? _lastUpdated;
  bool _isInitialized = false;

  // 序列化相關的委託
  // 用於將物件轉換為字串和從字串轉換回物件
  // 如果提供了 serializer，則使用它；否則使用 fromString 和 toString
  // 注意：如果使用 serializer，則 fromString 和 toString 參數將被忽略
  final SimpleSerializationDelegate<T>? _serializer;
  final SimpleSerializationFromString<T>? _fromString;
  final SimpleSerializationFormatString<T>? _formatString;

  final String _cacheValueKey;
  final String _cacheTimestampKey;

  PersistentCachedValue({
    required String cacheKeyPrefix,
    required Duration ttl,
    required PersistentProvider persistentProvider,
    SimpleSerializationDelegate<T>? serializer,
    SimpleSerializationFromString<T>? fromString,
    SimpleSerializationFormatString<T>? toString,
    required SimpleCacheValueProvider<T>? valueProvider,
  })  : assert(serializer != null || (fromString != null && toString != null),
            'Either serializer or fromString and toString must be provided.'),
        _cacheValueKey = '${cacheKeyPrefix}_value',
        _cacheTimestampKey = '${cacheKeyPrefix}_timestamp',
        _ttl = ttl,
        _persistenceProvider = persistentProvider,
        _serializer = serializer,
        _fromString = fromString,
        _formatString = toString,
        _valueProvider = valueProvider;

  @override
  Duration get ttl => _ttl;

  @override
  bool get isValid => _isInitialized && _cachedValue != null && !isExpired;

  @override
  bool get isExpired {
    if (_lastUpdated == null) return true;
    return DateTime.now().difference(_lastUpdated!) > _ttl;
  }

  @override
  void ensureInitialized() {
    if (!_isInitialized) {
      _initializeSync();
    }
  }

  void _initializeSync() {
    _persistenceProvider.ensureInitialized();
    _loadFromPersistent();
    _isInitialized = true;
  }

  Future<void> _ensureInitializedAsync() async {
    if (!_isInitialized) {
      _persistenceProvider.ensureInitialized();
      _loadFromPersistent();
      _isInitialized = true;
    }
  }

  void _loadFromPersistent() {
    debugPrint('[[PersistentCachedValue._loadFromPersistent]] ');
    try {
      // 讀取儲存的值
      debugPrint('[[PersistentCachedValue._loadFromPersistent]] key: $_cacheValueKey');
      final storedValue = _persistenceProvider.getString(_cacheValueKey);
      if (storedValue != null) {
        // 使用序列化委託將字串轉換為物件
        if (_serializer != null) {
          _cachedValue = _serializer.fromString(storedValue);
        } else if (_fromString != null && _formatString != null) {
          _cachedValue = _fromString(storedValue);
        }
      }

      // 讀取最後更新時間
      final lastUpdatedMs = _persistenceProvider.getInt(_cacheTimestampKey);
      if (lastUpdatedMs != null) {
        _lastUpdated = DateTime.fromMillisecondsSinceEpoch(lastUpdatedMs);
      }
    } catch (e) {
      // 如果讀取失敗，清除相關資料
      _clearPreferences();
    }
  }

  Future<void> _saveToPreferences(T value) async {
    try {
      String? serializedValue;
      if (_serializer != null) {
        // 使用序列化委託將物件轉換為字串
        serializedValue = _serializer.formatString(value);
      } else if (_fromString != null && _formatString != null) {
        // 使用 fromString 和 toString 進行序列化
        serializedValue = _formatString(value);
      }
      debugPrint('[[PersistentCachedValue._saveToPreferences]] ');
      debugPrint('key: $_cacheValueKey');
      debugPrint('key: $_cacheTimestampKey');
      await _persistenceProvider.setString(_cacheValueKey, serializedValue ?? '');

      final now = DateTime.now();
      await _persistenceProvider.setInt(_cacheTimestampKey, now.millisecondsSinceEpoch);

      _cachedValue = value;
      _lastUpdated = now;
    } catch (e) {
      // 序列化失敗時清除快取
      _clearPreferences();
      rethrow;
    }
  }

  void _clearPreferences() {
    _persistenceProvider.remove(_cacheValueKey);
    _persistenceProvider.remove(_cacheTimestampKey);
    _cachedValue = null;
    _lastUpdated = null;
  }

  @override
  Future<T?> getValue() async {
    await _ensureInitializedAsync();

    // 如果快取有效，直接返回
    if (isValid) {
      return _cachedValue;
    }

    try {
      // 從 valueProvider 獲取新值
      final newValue = await _valueProvider!();

      if (newValue != null) {
        await _saveToPreferences(newValue);
      }

      return newValue;
    } catch (e) {
      // 如果獲取失敗，返回過期的快取值（如果有的話）
      return _cachedValue;
    }
  }

  @override
  void invalidate() {
    _clearPreferences();
  }

  /// 手動設定快取值
  Future<void> setValue(T value) async {
    await _ensureInitializedAsync();
    await _saveToPreferences(value);
  }

  /// 清除所有資料
  Future<void> clear() async {
    await _ensureInitializedAsync();
    _clearPreferences();
  }

  /// 檢查是否有儲存的資料
  Future<bool> hasStoredData() async {
    await _ensureInitializedAsync();
    return _persistenceProvider.containsKey(_cacheValueKey);
  }
}
