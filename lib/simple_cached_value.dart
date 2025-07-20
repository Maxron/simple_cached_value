
import 'simple_cached_value_platform_interface.dart';

class SimpleCachedValue {
  Future<String?> getPlatformVersion() {
    return SimpleCachedValuePlatform.instance.getPlatformVersion();
  }
}
