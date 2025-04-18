import 'package:fluent_picacg/data/constants.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

class WindowManagerHandler with WindowListener {
  static final WindowManagerHandler _instance =
      WindowManagerHandler._internal();

  factory WindowManagerHandler() => _instance;

  WindowManagerHandler._internal();

  static const WindowOptions windowManagerOptions = WindowOptions(
    title: AppConstants.appName,
    minimumSize: Size(540, 540),
    titleBarStyle: TitleBarStyle.hidden,
    center: true,
  );

  Future<void> init() async {
    try {
      await windowManager.ensureInitialized();

      await windowManager.waitUntilReadyToShow(windowManagerOptions, () async {
        await windowManager.show();
      });

      await windowManager.setPreventClose(true);

      windowManager.addListener(this);

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
