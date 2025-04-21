import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';

class SembastDatabase {
  // 数据库实例
  Database? _database;
  // 存储名称（类似表）
  final _settingsStore = intMapStoreFactory.store('settings_store');

  // 单例模式获取数据库实例
  Future<Database> get database async {
    if (_database != null) return _database!;

    // 获取可执行程序的根目录
    final exeDir = File(Platform.executable).parent.path;
    // user 子目录路径
    final userDir = join(exeDir, 'config');
    // 确保 user 目录存在
    await Directory(userDir).create(recursive: true);
    // 数据库文件路径
    final dbPath = join(userDir, 'picacg.db');

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

  // 保存通用数据
  Future<void> saveData(String key, Map<String, dynamic> data) async {
    final db = await database;
    await _settingsStore.record(key.hashCode).put(db, data);
  }

  // 读取通用数据
  Future<Map<String, dynamic>?> getData(String key) async {
    final db = await database;
    final record = await _settingsStore.record(key.hashCode).get(db);
    return record?.cast<String, dynamic>();
  }

  // 删除数据
  Future<void> deleteData(String key) async {
    final db = await database;
    await _settingsStore.record(key.hashCode).delete(db);
  }

  // 关闭数据库
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
