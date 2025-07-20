#include "include/simple_cached_value/simple_cached_value_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "simple_cached_value_plugin.h"

void SimpleCachedValuePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  simple_cached_value::SimpleCachedValuePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
