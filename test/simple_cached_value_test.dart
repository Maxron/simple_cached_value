import 'package:flutter_test/flutter_test.dart';
import 'package:simple_cached_value/simple_cached_value.dart';
import 'package:simple_cached_value/simple_cached_value_platform_interface.dart';
import 'package:simple_cached_value/simple_cached_value_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSimpleCachedValuePlatform
    with MockPlatformInterfaceMixin
    implements SimpleCachedValuePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SimpleCachedValuePlatform initialPlatform = SimpleCachedValuePlatform.instance;

  test('$MethodChannelSimpleCachedValue is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSimpleCachedValue>());
  });

  test('getPlatformVersion', () async {
    SimpleCachedValue simpleCachedValuePlugin = SimpleCachedValue();
    MockSimpleCachedValuePlatform fakePlatform = MockSimpleCachedValuePlatform();
    SimpleCachedValuePlatform.instance = fakePlatform;

    expect(await simpleCachedValuePlugin.getPlatformVersion(), '42');
  });
}
