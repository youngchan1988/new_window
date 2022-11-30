import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'new_window_platform_interface.dart';

/// An implementation of [NewWindowPlatform] that uses method channels.
class MethodChannelNewWindow extends NewWindowPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('new_window');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int> createWindow({Rect? rect, bool closable = true}) async {
    final windowId = await methodChannel.invokeMethod<int>('createWindow');
    if (windowId == null) {
      return Future.error(
          FlutterError('Create window failed with null window id'));
    }
    return Future.value(windowId);
  }

  @override
  Future closeWindow(int windowId) =>
      methodChannel.invokeMethod('closeWindow', windowId);

  @override
  Future showWindow(
      {required int windowId,
      String? route,
      Map<String, dynamic>? windowArgs}) {
    var arguments = {
      'windowId': windowId,
      'route': route,
      'args': windowArgs == null ? '' : jsonEncode(windowArgs),
    };

    return methodChannel.invokeMethod('showWindow', arguments);
  }
}
