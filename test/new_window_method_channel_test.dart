import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_window/new_window_method_channel.dart';

void main() {
  MethodChannelNewWindow platform = MethodChannelNewWindow();
  const MethodChannel channel = MethodChannel('new_window');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
