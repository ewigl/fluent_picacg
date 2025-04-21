import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_picacg/utils/sembast_database.dart';

// 图片质量
enum ImageQuality { low, medium, high, original }

class AppSettingsState with ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;
  ImageQuality _imageQuality = ImageQuality.original;

  double _windowX = 100.0; // 窗口 X 坐标
  double _windowY = 100.0; // 窗口 Y 坐标
  double _windowWidth = 600.0; // 窗口宽度
  double _windowHeight = 800.0; // 窗口高度

  final SembastDatabase _db = SembastDatabase();

  AppSettingsState() {
    _loadSettings();
  }

  // 窗口位置和大小
  double get windowX => _windowX;
  double get windowY => _windowY;
  double get windowWidth => _windowWidth;
  double get windowHeight => _windowHeight;

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

  void updateWindowPosition(double x, double y) {
    _windowX = x;
    _windowY = y;
    _saveSettings();
    notifyListeners();
  }

  void updateWindowSize(double width, double height) {
    _windowWidth = width;
    _windowHeight = height;
    _saveSettings();
    notifyListeners();
  }

  // 从数据库加载所有设置
  Future<void> _loadSettings() async {
    final settings = await _db.getSettings();
    if (settings != null) {
      // 加载窗口位置和大小
      _windowX = (settings['windowX'] as num?)?.toDouble() ?? 100.0;
      _windowY = (settings['windowY'] as num?)?.toDouble() ?? 100.0;
      _windowWidth = (settings['windowWidth'] as num?)?.toDouble() ?? 600.0;
      _windowHeight = (settings['windowHeight'] as num?)?.toDouble() ?? 800.0;

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
        case 'medium':
          _imageQuality = ImageQuality.medium;
          break;
        case 'high':
          _imageQuality = ImageQuality.high;
          break;
        case 'original':
        default:
          _imageQuality = ImageQuality.original;
          break;
      }

      notifyListeners();
    }
  }

  // 保存所有设置到数据库
  Future<void> _saveSettings() async {
    final settings = {
      'windowX': _windowX,
      'windowY': _windowY,
      'windowWidth': _windowWidth,
      'windowHeight': _windowHeight,
      'theme': _theme.toString().split('.').last,
      'imageQuality': _imageQuality.toString().split('.').last,
    };
    await _db.saveSettings(settings);
  }
}
