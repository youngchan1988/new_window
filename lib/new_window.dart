import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'new_window_platform_interface.dart';

typedef WindowWidgetBuilder = Widget Function(BuildContext context,
    NewWindow window, String route, Map<String, dynamic>? arguments);

class NewWindow extends Equatable {
  NewWindow._(this.id);
  factory NewWindow.of(int id) => NewWindow._(id);

  static Future<NewWindow> show(
      {Rect? rect,
      String route = '/',
      Map<String, dynamic>? arguments,
      bool closable = true}) async {
    final windowId = await NewWindowPlatform.instance
        .createWindow(rect: rect, closable: closable);
    await NewWindowPlatform.instance
        .showWindow(windowId: windowId, route: route, windowArgs: arguments);
    return NewWindow._(windowId);
  }

  final int id;

  ///Close the window
  Future close() {
    return NewWindowPlatform.instance.closeWindow(id);
  }

  ///Listen messages from other windows
  void receiver(
      {VoidCallback? onClose,
      VoidCallback? shouldClose,
      ValueChanged<NewWindowMessage>? onMessage}) {
    NewWindowPlatform.instance
        .receiver()
        .map<NewWindowEvent>(
          (event) => event is Map
              ? NewWindowEvent.fromJson(Map.from(event))
              : const NewWindowEvent(state: NewWindowState.none),
        )
        .listen((event) {
      switch (event.state) {
        case NewWindowState.none:
          break;
        case NewWindowState.shouldClose:
          shouldClose?.call();
          break;
        case NewWindowState.onClose:
          onClose?.call();
          break;
        case NewWindowState.onMessage:
          onMessage?.call(NewWindowMessage.fromJson(Map.from(event.userData)));
          break;
      }
    });
  }

  ///Send message to the other window
  Future sendMessageTo({required int toWindowId, required String message}) =>
      NewWindowPlatform.instance.sendMessage(
          fromWindowId: id, toWindwoId: toWindowId, message: message);

  @override
  List<Object?> get props => [id];
}

enum NewWindowState {
  none,
  shouldClose,
  onClose,
  onMessage;

  static NewWindowState fromValue(String value) {
    switch (value) {
      case 'shouldClose':
        return NewWindowState.shouldClose;
      case 'onClose':
        return NewWindowState.onClose;
      case 'onMessage':
        return NewWindowState.onMessage;
      default:
        return NewWindowState.none;
    }
  }
}

class NewWindowEvent {
  const NewWindowEvent({required this.state, this.userData});

  factory NewWindowEvent.fromJson(Map<String, dynamic> json) => NewWindowEvent(
      state: NewWindowState.fromValue(json['state']),
      userData: json['userData']);

  final NewWindowState state;

  final dynamic userData;
}

class NewWindowMessage {
  const NewWindowMessage({required this.fromWindowId, required this.message});

  factory NewWindowMessage.fromJson(Map<String, dynamic> json) =>
      NewWindowMessage(
          fromWindowId: json['fromWindowId'] as int,
          message: json['message'] as String);

  Map<String, dynamic> toJson() => {
        'fromWindowId': fromWindowId,
        'message': message,
      };

  final int fromWindowId;
  final String message;
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
      return builder(context, NewWindow.of(windowId),
          uri.queryParameters['route'] ?? '', args);
    } else {
      return home;
    }
  }
}
