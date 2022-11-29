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
}

void main() {
  final NewWindowPlatform initialPlatform = NewWindowPlatform.instance;

  test('$MethodChannelNewWindow is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNewWindow>());
  });

  test('getPlatformVersion', () async {
    NewWindow newWindowPlugin = NewWindow();
    MockNewWindowPlatform fakePlatform = MockNewWindowPlatform();
    NewWindowPlatform.instance = fakePlatform;

    expect(await newWindowPlugin.getPlatformVersion(), '42');
  });
}
