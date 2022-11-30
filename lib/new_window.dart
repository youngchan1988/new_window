import 'dart:convert';

import 'package:flutter/material.dart';

import 'new_window_platform_interface.dart';

typedef WindowWidgetBuilder = Widget Function(BuildContext context,
    int windowId, String route, Map<String, dynamic>? arguments);

class NewWindow {
  static Future show(
      {Rect? rect,
      String route = '/',
      Map<String, dynamic>? arguments,
      bool closable = true}) async {
    final windowId = await NewWindowPlatform.instance
        .createWindow(rect: rect, closable: closable);
    return NewWindowPlatform.instance
        .showWindow(windowId: windowId, route: route, windowArgs: arguments);
  }

  static Future close(int windowId) {
    return NewWindowPlatform.instance.closeWindow(windowId!);
  }
}

class NewWindowApp extends StatelessWidget {
  const NewWindowApp(
      {super.key, this.runArgs, required this.home, required this.builder});

  final List<String>? runArgs;

  final Widget home;

  final WindowWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    if (runArgs?.isNotEmpty == true) {
      var uri = Uri.tryParse(runArgs!.first);
      if (uri == null || uri.scheme != 'context' || uri.host != 'new_window') {
        return home;
      }
      var windowId = int.tryParse(uri.pathSegments.last);
      if (windowId == null) {
        return home;
      }
      var windowArgs = uri.queryParameters['arguments'];
      Map<String, dynamic>? args;
      if (windowArgs?.isNotEmpty == true) {
        args = jsonDecode(windowArgs!);
      }
      return builder(
          context, windowId, uri.queryParameters['route'] ?? '', args);
    } else {
      return home;
    }
  }
}
