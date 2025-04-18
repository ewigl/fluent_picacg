import 'package:fluent_ui/fluent_ui.dart';

class AppSettingsState extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;
  ThemeMode get theme => _theme;

  set theme(ThemeMode value) {
    _theme = value;
    notifyListeners();
  }
}
