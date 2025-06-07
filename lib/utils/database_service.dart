import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskodoro/models/priority.dart';
import 'package:taskodoro/models/task.dart';
import 'package:taskodoro/utils/priority_service.dart';

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
    final Directory databasePath = await getDatabasePath();
    final String path = join(databasePath.path, 'taskodoro.db');

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      sqfliteFfiInit();

      return databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
        ),
      );
    } else {
      return openDatabase(
        path,
        onCreate: _onCreate,
        version: 1,
      );
    }
  }

  Future<Directory> getDatabasePath() {
    final String platform = Platform.operatingSystem;

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
    final List<Map<String, Object?>> priorities = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='priorities'");

    await db.execute('CREATE TABLE IF NOT EXISTS priorities( '
        'id INTEGER PRIMARY KEY, '
        'level INTEGER, '
        'name TEXT, '
        'isCreatedByUser INTEGER '
        ')'
    );

    await db.execute('CREATE TABLE IF NOT EXISTS tasks( '
        'id INTEGER PRIMARY KEY, '
        'name TEXT, '
        'isDone INTEGER, '
        'timeAdded TEXT, '
        'timeStart TEXT, '
        'timeDue TEXT, '
        'priority INTEGER, '
        'description TEXT, '
        'FOREIGN KEY (priority) REFERENCES priorities (id) ON DELETE SET NULL '
        ')'
    );

    if (priorities.isEmpty) {
      final PriorityService priorityService = PriorityService();
      final List<Priority> defaultPriorities = priorityService.getDefaultPriorities();

      for (final Priority priority in defaultPriorities) {
        await _insertPriorityWithDb(priority, db);
      }
    }
  }

  Future<List<Task>> getTasks() async {
    final Database db = await _databaseService.database;
    final List<Map<String, dynamic>> tasks = await db.query('tasks');

    final PriorityService priorityService = PriorityService();
    await priorityService.loadPriorities();

    return List<Task>.generate(tasks.length, (int index) => Task.fromDatabaseMap(tasks[index]));
  }

  Future<void> insertTask(Task task) async {
    final Database db = await _databaseService.database;

    final Map<String, dynamic> taskMap = task.toDatabaseMap();
    taskMap['id'] = null;

    await db.insert('tasks', taskMap);
  }

  Future<void> updateTask(Task task) async {
    final Database db = await _databaseService.database;

    await db.update(
      'tasks',
      task.toDatabaseMap(),
      where: 'id = ?',
      whereArgs: <int>[task.id!],
    );
  }

  Future<void> deleteTask(int id) async {
    final Database db = await _databaseService.database;

    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: <int>[id],
    );
  }

  Future<List<Priority>> getPriorities() async {
    final Database db = await _databaseService.database;
    final List<Map<String, dynamic>> priorities = await db.query('priorities');

    return List<Priority>.generate(priorities.length, (int index) => Priority.fromDatabaseMap(priorities[index]));
  }

  Future<void> insertPriority(Priority priority) async {
    final Database db = await _databaseService.database;

    _insertPriorityWithDb(priority, db);
  }

  Future<void> _insertPriorityWithDb(Priority priority, Database db) async {
    await db.insert('priorities', priority.toDatabaseMap());
  }
}
