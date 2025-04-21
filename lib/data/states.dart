import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_picacg/utils/sembast_database.dart';

// 图片质量
enum ImageQuality { low, medium, high, original }

class AppSettingsState with ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;
  ImageQuality _imageQuality = ImageQuality.original;

  final SembastDatabase _db = SembastDatabase();

  AppSettingsState() {
    // 在构造时加载所有设置
    _loadSettings();
  }

  // 主题
  ThemeMode get theme => _theme;
  set theme(ThemeMode value) {
    _theme = value;
    _saveSettings();
    notifyListeners();
  }

  // 图片质量
  ImageQuality get imageQuality => _imageQuality;
  set imageQuality(ImageQuality value) {
    _imageQuality = value;
    _saveSettings();
    notifyListeners();
  }

  // 从数据库加载所有设置
  Future<void> _loadSettings() async {
    try {
      final settings = await _db.getSettings();
      if (settings != null) {
        // 加载主题
        switch (settings['theme']) {
          case 'light':
            _theme = ThemeMode.light;
            break;
          case 'dark':
            _theme = ThemeMode.dark;
            break;
          case 'system':
          default:
            _theme = ThemeMode.system;
            break;
        }

        // 加载图片质量
        switch (settings['imageQuality']) {
          case 'low':
            _imageQuality = ImageQuality.low;
            break;
          case 'high':
            _imageQuality = ImageQuality.high;
            break;
          case 'medium':
            _imageQuality = ImageQuality.medium;
            break;
          case 'original':
          default:
            _imageQuality = ImageQuality.original;
            break;
        }

        notifyListeners();
      } else {
        debugPrint('No settings found in database, using defaults');
      }
    } catch (e) {
      debugPrint('Failed to load settings: $e');
    }
  }

  // 保存所有设置到数据库
  Future<void> _saveSettings() async {
    try {
      final settings = {
        'theme': _theme.toString().split('.').last,
        'imageQuality': _imageQuality.toString().split('.').last,
      };
      await _db.saveSettings(settings);
      debugPrint('Settings saved: $settings');
    } catch (e) {
      debugPrint('Failed to save settings: $e');
    }
  }
}
