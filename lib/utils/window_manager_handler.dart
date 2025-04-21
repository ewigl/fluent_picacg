import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

import 'package:fluent_picacg/data/constants.dart';
import 'package:fluent_picacg/data/states.dart';

class WindowManagerHandler with WindowListener {
  static final WindowManagerHandler _instance =
      WindowManagerHandler._internal();

  factory WindowManagerHandler() => _instance;

  WindowManagerHandler._internal();

  AppSettingsState? _appSettingsState;
  Timer? _debounce;

  static const WindowOptions windowManagerOptions = WindowOptions(
    title: AppConstants.appName,
    titleBarStyle: TitleBarStyle.hidden,
    minimumSize: Size(540, 540),
  );

  Future<void> init({AppSettingsState? appSettingsState}) async {
    try {
      // 保存 AppSettingsState 实例
      _appSettingsState = appSettingsState;

      await windowManager.ensureInitialized();

      await windowManager.waitUntilReadyToShow(windowManagerOptions, () async {
        if (_appSettingsState != null) {
          // 应用保存的窗口大小和位置
          await windowManager.setSize(
            Size(
              _appSettingsState!.windowWidth,
              _appSettingsState!.windowHeight,
            ),
          );
          await windowManager.setPosition(
            Offset(_appSettingsState!.windowX, _appSettingsState!.windowY),
          );
        }

        await windowManager.show();
      });

      await windowManager.setPreventClose(true);

      windowManager.addListener(this);

      // Future.delayed(const Duration(milliseconds: 100), () async {
      //   await windowManager.focus();
      // });
    } catch (e) {
      debugPrint('Error initializing window manager: $e');
    }
  }

  void dispose() {
    windowManager.removeListener(this);
    _debounce?.cancel();
  }

  @override
  void onWindowMoved() async {
    if (_appSettingsState == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final position = await windowManager.getPosition();
      final size = await windowManager.getSize();
      _appSettingsState!.updateWindowPosition(position.dx, position.dy);
      _appSettingsState!.updateWindowSize(size.width, size.height);
    });
  }

  @override
  void onWindowResized() async {
    if (_appSettingsState == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final size = await windowManager.getSize();
      _appSettingsState!.updateWindowSize(size.width, size.height);
    });
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

  // onWindowEvent,debugPrint('Window event: $event');
  // @override
  // void onWindowEvent(String eventName) {
  //   debugPrint('Window Event: $eventName');
  // }
}
