//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <new_window/new_window_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) new_window_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "NewWindowPlugin");
  new_window_plugin_register_with_registrar(new_window_registrar);
}
