import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'new_window_platform_interface.dart';

/// An implementation of [NewWindowPlatform] that uses method channels.
class MethodChannelNewWindow extends NewWindowPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('new_window');

  @visibleForTesting
  final eventChannel = const EventChannel('new_window_event');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int> createWindow({Rect? rect, bool closable = true}) async {
    var arguments = <String, dynamic>{
      'closable': closable,
    };
    if (rect != null) {
      arguments['px'] = rect.left;
      arguments['py'] = rect.top;
      arguments['width'] = rect.size.width;
      arguments['height'] = rect.size.height;
    }
    final windowId =
        await methodChannel.invokeMethod<int>('createWindow', arguments);
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

  @override
  Stream receiver() => eventChannel.receiveBroadcastStream();

  @override
  Future<bool?> sendMessage(
      {required int fromWindowId,
      required int toWindwoId,
      required String message}) {
    return methodChannel.invokeMethod<bool>(
      'sendMessage',
      {
        'fromWindowId': fromWindowId,
        'toWindowId': toWindwoId,
        'message': message,
      },
    );
  }
}
