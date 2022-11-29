import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'new_window_method_channel.dart';

abstract class NewWindowPlatform extends PlatformInterface {
  /// Constructs a NewWindowPlatform.
  NewWindowPlatform() : super(token: _token);

  static final Object _token = Object();

  static NewWindowPlatform _instance = MethodChannelNewWindow();

  /// The default instance of [NewWindowPlatform] to use.
  ///
  /// Defaults to [MethodChannelNewWindow].
  static NewWindowPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NewWindowPlatform] when
  /// they register themselves.
  static set instance(NewWindowPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
