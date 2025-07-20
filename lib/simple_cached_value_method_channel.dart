import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'simple_cached_value_platform_interface.dart';

/// An implementation of [SimpleCachedValuePlatform] that uses method channels.
class MethodChannelSimpleCachedValue extends SimpleCachedValuePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('simple_cached_value');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
