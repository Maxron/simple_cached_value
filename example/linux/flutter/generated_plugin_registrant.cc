//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <simple_cached_value/simple_cached_value_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) simple_cached_value_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SimpleCachedValuePlugin");
  simple_cached_value_plugin_register_with_registrar(simple_cached_value_registrar);
}
