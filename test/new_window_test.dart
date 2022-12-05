import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:new_window/new_window.dart';
import 'package:new_window/new_window_platform_interface.dart';
import 'package:new_window/new_window_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNewWindowPlatform
    with MockPlatformInterfaceMixin
    implements NewWindowPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future closeWindow(int windowId) => Future.value();

  @override
  Future showWindow(
      {required int windowId,
      String? route,
      Map<String, dynamic>? windowArgs}) {
    // TODO: implement showWindow
    throw UnimplementedError();
  }

  @override
  Stream receiver() {
    // TODO: implement receiver
    throw UnimplementedError();
  }

  @override
  Future sendMessage(
      {required int fromWindowId,
      required int toWindwoId,
      required String message}) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future setTitle({required int windowId, required String title}) {
    // TODO: implement setTitle
    throw UnimplementedError();
  }

  @override
  Future<int> createWindow(
      {Rect? rect, bool closable = true, bool showTitleBar = true}) {
    // TODO: implement createWindow
    throw UnimplementedError();
  }
}

void main() {
  final NewWindowPlatform initialPlatform = NewWindowPlatform.instance;

  test('$MethodChannelNewWindow is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNewWindow>());
  });
}
