import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_single_instance/flutter_single_instance.dart';
import 'package:provider/provider.dart';

import 'package:fluent_picacg/data/constants.dart';
import 'package:fluent_picacg/data/routes.dart';
import 'package:fluent_picacg/data/states.dart';
import 'package:fluent_picacg/utils/system_tray_manager.dart';
import 'package:fluent_picacg/utils/window_manager_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!await FlutterSingleInstance().isFirstInstance()) {
    final err = await FlutterSingleInstance().focus();

    if (err != null) {
      debugPrint('Error focusing the first instance: $err');
    }

    exit(0);
  }

  // 创建 AppSettingsState 实例
  final appSettingsState = AppSettingsState();

  final windowManagerHandler = WindowManagerHandler();
  await windowManagerHandler.init(appSettingsState: appSettingsState);

  final systemTrayManager = SystemTrayManager();
  await systemTrayManager.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => appSettingsState)],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettingsState = context.watch<AppSettingsState>();

    return FluentApp.router(
      title: AppConstants.appName,
      theme: FluentThemeData(
        brightness: Brightness.light,
        accentColor: AppConstants.picACGAccentColor,
      ),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: AppConstants.picACGAccentColor,
      ),
      themeMode: appSettingsState.theme,
      routerConfig: globalRouter,
    );
  }
}
