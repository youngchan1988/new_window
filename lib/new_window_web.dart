// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:ui';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'new_window_platform_interface.dart';

/// A web implementation of the NewWindowPlatform of the NewWindow plugin.
class NewWindowWeb extends NewWindowPlatform {
  /// Constructs a NewWindowWeb
  NewWindowWeb();

  static void registerWith(Registrar registrar) {
    NewWindowPlatform.instance = NewWindowWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  Future closeWindow(int windowId) {
    // TODO: implement closeWindow
    throw UnimplementedError();
  }

  @override
  Future<int> createWindow({Rect? rect, bool closable = true}) {
    // TODO: implement createWindow
    throw UnimplementedError();
  }

  @override
  Future showWindow(
      {required int windowId,
      String? route,
      Map<String, dynamic>? windowArgs}) {
    // TODO: implement showWindow
    throw UnimplementedError();
  }
}
