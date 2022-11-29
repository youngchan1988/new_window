#ifndef FLUTTER_PLUGIN_NEW_WINDOW_PLUGIN_H_
#define FLUTTER_PLUGIN_NEW_WINDOW_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace new_window {

class NewWindowPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NewWindowPlugin();

  virtual ~NewWindowPlugin();

  // Disallow copy and assign.
  NewWindowPlugin(const NewWindowPlugin&) = delete;
  NewWindowPlugin& operator=(const NewWindowPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace new_window

#endif  // FLUTTER_PLUGIN_NEW_WINDOW_PLUGIN_H_
