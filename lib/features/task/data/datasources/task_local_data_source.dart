import 'dart:async';
import '../../domain/entities/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskLocalDataSource {
  static final TaskLocalDataSource _instance = TaskLocalDataSource._internal();
  factory TaskLocalDataSource() => _instance;
  TaskLocalDataSource._internal();

  Database? _database;
  static const String _tableName = 'tasks';
  static const String _dbName = 'tasks_database.db';

  // Database initialization
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY, 
        title TEXT, 
        description TEXT, 
        done INTEGER, 
        priority INTEGER,
        dueDate TEXT,
        timeSelected INTEGER,
        dateSelected INTEGER,
        position INTEGER
      )
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $_tableName ADD COLUMN priority INTEGER DEFAULT 1');
    }
  }

  // CRUD Operations
  Future<Task> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'done': task.done ? 1 : 0,
        'priority': task.priority,
        'dueDate': task.dueDate?.toString(),
        'timeSelected': task.timeSelected ? 1 : 0,
        'dateSelected': task.dateSelected ? 1 : 0,
        'position': task.position,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return task;
  }

  Future<void> insertTasks(List<Task> tasks) async {
    final db = await database;
    final batch = db.batch();

    for (var task in tasks) {
      batch.insert(
        _tableName,
        {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'done': task.done ? 1 : 0,
          'priority': task.priority,
          'dueDate': task.dueDate?.toString(),
          'timeSelected': task.timeSelected ? 1 : 0,
          'dateSelected': task.dateSelected ? 1 : 0,
          'position': task.position,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return maps.map((map) => _mapToTask(map)).toList();
  }

  Future<Task?> getTaskById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty ? _mapToTask(maps.first) : null;
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      _tableName,
      {
        'title': task.title,
        'description': task.description,
        'done': task.done ? 1 : 0,
        'priority': task.priority,
        'dueDate': task.dueDate?.toString(),
        'timeSelected': task.timeSelected ? 1 : 0,
        'dateSelected': task.dateSelected ? 1 : 0,
        'position': task.position,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllTasks() async {
    final db = await database;
    await db.delete(_tableName);
  }

  // Task Status Operations
  Future<void> toggleTaskStatus(String taskId) async {
    final task = await getTaskById(taskId);
    if (task != null) {
      task.toggleTask();
      await updateTask(task);
    }
  }

  Future<Map<String, List<Task>>> getTasksByStatus() async {
    final tasks = await getAllTasks();
    return {
      'completed': tasks.where((task) => task.done).toList(),
      'pending': tasks.where((task) => !task.done).toList(),
    };
  }

  // Priority-Related Methods
  Future<List<Task>> getTasksSortedByPriority() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'priority DESC, done ASC',
    );

    return maps.map((map) => _mapToTask(map)).toList();
  }

  Future<List<Task>> getTasksByPriority(int priority) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'priority = ?',
      whereArgs: [priority],
    );

    return maps.map((map) => _mapToTask(map)).toList();
  }

  // Utility Methods for Last Active Task
  Future<void> saveLastActiveTaskId(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_active_task_id', taskId);
  }

  Future<String?> getLastActiveTaskId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_active_task_id');
  }

  Task _mapToTask(Map<String, dynamic> map) {
    DateTime? parsedDueDate;

    if (map['dueDate'] != null && map['dueDate'] is String) {
      try {
        parsedDueDate = DateTime.tryParse(map['dueDate']);
      } catch (e) {
        print('Data parsing error: ${map['dueDate']}');
      }
    }

    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      done: map['done'] == 1,
      priority: map['priority'] ?? 1,
      dueDate: parsedDueDate,
      timeSelected: map['timeSelected'] == 1,
      dateSelected: map['dateSelected'] == 1,
      position: map['position'] ?? 0,
    );
  }
}