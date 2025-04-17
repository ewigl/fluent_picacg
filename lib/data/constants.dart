import 'package:fluent_ui/fluent_ui.dart';
import 'package:system_theme/system_theme.dart';

class GlobalConstants {
  // app name
  static const String appName = 'Fluent PicACG';

  // theme colors
  static final AccentColor picACGAccentColor =
      Color(0XFFDB547C).toAccentColor();

  static final AccentColor systemAccentColor =
      SystemTheme.accentColor.accent.toAccentColor();
}
