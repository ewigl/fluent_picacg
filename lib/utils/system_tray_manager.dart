import 'dart:io';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

import 'package:fluent_picacg/data/constants.dart';

class SystemTrayManager {
  final SystemTray _systemTray = SystemTray();
  final AppWindow _appWindow = AppWindow();
  static final Menu menu = Menu();

  Future<void> init() async {
    String path =
        Platform.isWindows
            ? AppConstants.trayIconPath
            : AppConstants.trayIconPngPath;

    await _systemTray.initSystemTray(
      iconPath: path,
      toolTip: AppConstants.appName,
    );

    await menu.buildFrom([
      MenuItemLabel(label: '显示窗口', onClicked: (_) => _appWindow.show()),
      MenuItemLabel(label: '隐藏窗口', onClicked: (_) => _appWindow.hide()),
      MenuSeparator(),
      MenuItemLabel(
        label: '退出程序',
        onClicked: (_) async {
          await windowManager.setPreventClose(false);
          _appWindow.close();
        },
      ),
    ]);

    await _systemTray.setContextMenu(menu);

    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? _appWindow.show() : _systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? _systemTray.popUpContextMenu() : _appWindow.show();
      }
    });
  }
}
