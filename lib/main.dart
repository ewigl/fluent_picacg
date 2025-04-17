import 'package:fluent_ui/fluent_ui.dart';

import 'package:fluent_picacg/data/constants.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: GlobalConstants.appName,
      theme: FluentThemeData(
        brightness: Brightness.light,
        accentColor: GlobalConstants.systemAccentColor,
      ),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: GlobalConstants.systemAccentColor,
      ),
      home: ScaffoldPage(
        padding: EdgeInsets.zero,
        content: Center(child: Text(GlobalConstants.appName)),
      ),
    );
  }
}
