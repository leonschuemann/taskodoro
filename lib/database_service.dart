import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskodoro/priority.dart';
import 'package:taskodoro/task.dart';

// Inspired by https://github.com/thisissandipp/flutter-sqflite-example/blob/main/lib/services/database_service.dart
class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  static Database? _database;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasePath();
    final path = join(databasePath.path, 'taskodoro.db');

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      sqfliteFfiInit();

      return await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
        )
      );
    } else {
      return await openDatabase(
        path,
        onCreate: _onCreate,
        version: 1,
      );
    }
  }

  Future<Directory> getDatabasePath() {
    String platform = Platform.operatingSystem;

    switch (platform) {
      case 'android':
        return getApplicationSupportDirectory();
      case 'ios':
        return getLibraryDirectory();
      case 'windows':
        return getApplicationSupportDirectory();
      case 'macos':
        return getApplicationSupportDirectory();
      case 'linux':
        return getApplicationSupportDirectory();
      default:
        return getApplicationSupportDirectory();
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    List<Map<String, Object?>> priorities = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='priorities'");

    await db.execute('CREATE TABLE IF NOT EXISTS priorities('
        'id INTEGER PRIMARY KEY,'
        'level INTEGER,'
        'name TEXT,'
        'isCreatedByUser INTEGER'
        ')'
    );

    await db.execute('CREATE TABLE IF NOT EXISTS tasks('
        'id INTEGER PRIMARY KEY,'
        'name TEXT,'
        'isDone INTEGER,'
        'timeAdded TEXT,'
        'timeStart TEXT,'
        'timeDue TEXT,'
        'priority INTEGER,'
        'description TEXT,'
        'FOREIGN KEY (priority) REFERENCES priorities (id) ON DELETE SET NULL'
        ')'
    );

    if (priorities.isEmpty) {
      PriorityManager priorityManager = PriorityManager();
      List<Priority> defaultPriorities = priorityManager.getDefaultPriorities();

      for (Priority priority in defaultPriorities) {
        insertPriority(priority);
      }
    }
  }

  Future<List<Task>> getTasks() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> tasks = await db.query('tasks');

    PriorityManager priorityManager = PriorityManager();
    await priorityManager.loadPriorities();

    return List.generate(tasks.length, (index) => Task.fromDatabaseMap(tasks[index]));
  }

  Future<void> insertTask(Task task) async {
    final db = await _databaseService.database;

    Map<String, dynamic> taskMap = task.toDatabaseMap();
    taskMap['id'] = null;

    await db.insert('tasks', taskMap);
  }

  Future<void> updateTask(Task task) async {
    final db = await _databaseService.database;

    await db.update(
      'tasks',
      task.toDatabaseMap(),
      where: 'id = ?',
      whereArgs: [task.id]
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await _databaseService.database;

    await db.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [id]
    );
  }

  Future<List<Priority>> getPriorities() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> priorities = await db.query('priorities');

    return List.generate(priorities.length, (index) => Priority.fromDatabaseMap(priorities[index]));
  }

  Future<void> insertPriority(Priority priority) async {
    final db = await _databaseService.database;
    final priorityMap = priority.toDatabaseMap();
    priorityMap['id'] = null;

    await db.insert('priorities', priority.toDatabaseMap());
  }
}