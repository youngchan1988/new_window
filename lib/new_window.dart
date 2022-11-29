
import 'new_window_platform_interface.dart';

class NewWindow {
  Future<String?> getPlatformVersion() {
    return NewWindowPlatform.instance.getPlatformVersion();
  }
}
