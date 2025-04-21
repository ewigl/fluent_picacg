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
        const SizedBox(height: 8.0),
        Card(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              const Text('图片质量', style: TextStyle(fontSize: 16)),
              ComboBox<ImageQuality>(
                value: appSettingsState.imageQuality,
                items: const [
                  ComboBoxItem(value: ImageQuality.original, child: Text('原图')),
                  ComboBoxItem(value: ImageQuality.high, child: Text('清晰')),
                  ComboBoxItem(value: ImageQuality.medium, child: Text('中等')),
                  ComboBoxItem(value: ImageQuality.low, child: Text('模糊')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    appSettingsState.imageQuality = value;
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
