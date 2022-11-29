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
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
