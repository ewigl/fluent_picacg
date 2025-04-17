import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

class WindowManagerHandler with WindowListener {
  static final WindowManagerHandler _instance =
      WindowManagerHandler._internal();

  factory WindowManagerHandler() => _instance;

  WindowManagerHandler._internal();

  Future<void> init(WindowOptions windowOptions) async {
    try {
      await windowManager.ensureInitialized();

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
      });

      await windowManager.setPreventClose(true);

      windowManager.addListener(this);

      // 延迟 focus
      Future.delayed(const Duration(milliseconds: 100), () async {
        await windowManager.focus();
      });
    } catch (e) {
      debugPrint('Error initializing window manager: $e');
    }
  }

  void dispose() {
    windowManager.removeListener(this);
  }

  @override
  void onWindowClose() async {
    try {
      if (await windowManager.isPreventClose()) {
        await windowManager.hide();
      }
    } catch (e) {
      debugPrint('Error hiding window: $e');
    }
  }
}
