import 'package:fluent_ui/fluent_ui.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

class GlobalConstants {
  // app properties
  static const String appName = 'Fluent PicACG';

  static final Image appIcon = Image.asset('assets/images/logo.png');
  // static const String appIconPath = 'assets/images/logo.png';

  static final Image trayIcon = Image.asset('assets/images/logo.ico');
  static const String trayIconPath = 'assets/images/logo.ico';

  static final Image trayIconPng = Image.asset('assets/images/logo.png');
  static const String trayIconPngPath = 'assets/images/logo.png';

  // window properties
  static const WindowOptions windowManagerOptions = WindowOptions(
    title: appName,
    minimumSize: Size(540, 720),
    titleBarStyle: TitleBarStyle.hidden,
  );

  // theme colors
  static final AccentColor picACGAccentColor =
      Color(0XFFDB547C).toAccentColor();

  static final AccentColor systemAccentColor =
      SystemTheme.accentColor.accent.toAccentColor();
}
