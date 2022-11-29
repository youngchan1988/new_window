#include "include/new_window/new_window_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "new_window_plugin.h"

void NewWindowPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  new_window::NewWindowPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
