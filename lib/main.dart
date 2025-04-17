import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

import 'package:fluent_picacg/data/constants.dart';
import 'package:fluent_picacg/utils/system_tray_manager.dart';
import 'package:fluent_picacg/utils/window_manager_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final windowManagerHandler = WindowManagerHandler();
  await windowManagerHandler.init(GlobalConstants.windowManagerOptions);

  final systemTrayManager = SystemTrayManager();
  await systemTrayManager.init();

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
        header: SizedBox(
          height: 32,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GlobalConstants.appIcon,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: const Text(GlobalConstants.appName),
                    ),
                  ],
                ),
              ),
              const Expanded(child: WindowCaption()),
            ],
          ),
        ),
        content: Center(child: Text(GlobalConstants.appName)),
      ),
    );
  }
}
