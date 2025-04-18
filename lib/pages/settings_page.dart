import 'package:fluent_picacg/data/states.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appSettingsState = context.watch<AppSettingsState>();

    return ScaffoldPage.scrollable(
      padding: const EdgeInsets.all(16),
      children: [
        Text('设置', style: FluentTheme.of(context).typography.title),
        const SizedBox(height: 8.0),
        Card(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text('应用主题', style: TextStyle(fontSize: 16)),
              ComboBox(
                value: appSettingsState.theme,
                items: [
                  ComboBoxItem(value: ThemeMode.system, child: Text('跟随系统')),
                  ComboBoxItem(value: ThemeMode.light, child: Text('浅色主题')),
                  ComboBoxItem(value: ThemeMode.dark, child: Text('深色主题')),
                ],
                onChanged: (value) => appSettingsState.theme = value!,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
