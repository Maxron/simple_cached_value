#ifndef FLUTTER_PLUGIN_SIMPLE_CACHED_VALUE_PLUGIN_H_
#define FLUTTER_PLUGIN_SIMPLE_CACHED_VALUE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace simple_cached_value {

class SimpleCachedValuePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SimpleCachedValuePlugin();

  virtual ~SimpleCachedValuePlugin();

  // Disallow copy and assign.
  SimpleCachedValuePlugin(const SimpleCachedValuePlugin&) = delete;
  SimpleCachedValuePlugin& operator=(const SimpleCachedValuePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace simple_cached_value

#endif  // FLUTTER_PLUGIN_SIMPLE_CACHED_VALUE_PLUGIN_H_
