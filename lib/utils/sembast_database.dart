import 'dart:io';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';

class SembastDatabase {
  // 数据库实例
  Database? _database;
  // 存储名称（类似表）
  // 应用设置
  final _settingsStore = intMapStoreFactory.store('settings_store');
  // 用户信息
  final _authStore = intMapStoreFactory.store('auth_store');
  // 历史记录
  // final _historyStore = intMapStoreFactory.store('history_store');

  // 单例模式获取数据库实例
  Future<Database> get database async {
    if (_database != null) return _database!;

    // 获取可执行程序的根目录
    final exeDir = File(Platform.executable).parent.path;
    // user 子目录路径
    final configDir = join(exeDir, 'config');
    // 确保 user 目录存在
    await Directory(configDir).create(recursive: true);
    // 数据库文件路径
    final dbPath = join(configDir, 'picacg.db');

    // 初始化数据库
    _database = await databaseFactoryIo.openDatabase(dbPath);
    return _database!;
  }

  // 保存所有设置
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final db = await database;
    await _settingsStore.record('settings'.hashCode).put(db, settings);
  }

  // 读取所有设置
  Future<Map<String, dynamic>?> getSettings() async {
    final db = await database;
    final record = await _settingsStore.record('settings'.hashCode).get(db);
    return record?.cast<String, dynamic>();
  }

  // 存储 Auth 信息
  Future<void> saveAuth(Map<String, dynamic> authData) async {
    final db = await database;
    await _authStore.record('auth'.hashCode).put(db, authData);
  }

  // 读取 Auth 信息
  Future<Map<String, dynamic>?> getAuth() async {
    final db = await database;
    final record = await _authStore.record('auth'.hashCode).get(db);
    return record?.cast<String, dynamic>();
  }

  // 删除 Auth 相关信息
  Future<void> deleteAuth() async {
    final db = await database;
    await _authStore.record('auth'.hashCode).delete(db);
  }

  // 关闭数据库
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
