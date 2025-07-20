import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'simple_cached_value_method_channel.dart';

abstract class SimpleCachedValuePlatform extends PlatformInterface {
  /// Constructs a SimpleCachedValuePlatform.
  SimpleCachedValuePlatform() : super(token: _token);

  static final Object _token = Object();

  static SimpleCachedValuePlatform _instance = MethodChannelSimpleCachedValue();

  /// The default instance of [SimpleCachedValuePlatform] to use.
  ///
  /// Defaults to [MethodChannelSimpleCachedValue].
  static SimpleCachedValuePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SimpleCachedValuePlatform] when
  /// they register themselves.
  static set instance(SimpleCachedValuePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
