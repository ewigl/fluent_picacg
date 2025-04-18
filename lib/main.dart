import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'package:fluent_picacg/data/constants.dart';
import 'package:fluent_picacg/data/routes.dart';
import 'package:fluent_picacg/data/states.dart';
import 'package:fluent_picacg/utils/system_tray_manager.dart';
import 'package:fluent_picacg/utils/window_manager_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final windowManagerHandler = WindowManagerHandler();
  await windowManagerHandler.init();

  final systemTrayManager = SystemTrayManager();
  await systemTrayManager.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppSettingsState())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: GlobalConstants.appName,
      theme: FluentThemeData(
        brightness: Brightness.light,
        accentColor: GlobalConstants.picACGAccentColor,
      ),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: GlobalConstants.picACGAccentColor,
      ),
      themeMode: context.watch<AppSettingsState>().theme,
      routerConfig: globalRouter,
    );
  }
}
