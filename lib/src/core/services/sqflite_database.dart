import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/models/task_model.dart';

class SqfliteDatabase {
  static final SqfliteDatabase _instance = SqfliteDatabase._();
  static Database _database;
  SqfliteDatabase._();
  factory SqfliteDatabase() {
    return _instance;
  }
  Future<Database> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'database.db');
    Database database = await openDatabase(dbPath,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
    // close database
    // await database.close();
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
            CREATE TABLE task (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              category TEXT NOT NULL,
              date TEXT NOT NULL,
              is_done INTEGER NOT NULL
            )
            """);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  // create
  Future<int> addTaskToDb(TaskModel task) async {
    try {
      final Database db = await _db;
      return await db.insert(
        'task',
        task.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // using rawquery //? how to handle id
      // final id = task.id;
      // final title = task.title;
      // final category = task.category;
      // final date = task.date;
      // final isDone = task.isDone;
      // return await db.rawInsert(
      //     'INSERT INTO task(id, title, category, date, is_done) VALUES(?, ?, ?, ?, ?)',
      //     [id, title, category, date, isDone]);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // read
  // Future<TaskModel> fetchTaskFromDb(int id) async {
  //   try {
  //     final Database db = await _db;
  //     final List<Map<String, dynamic>> res =
  //         await db.query('task', where: 'id = ?', whereArgs: [id]);
  //     // using rawquery
  //     // final List<Map<String, dynamic>> res =
  //     //     await db.rawQuery('SELECT * FROM task WHERE id = ?', [id]);
  //     if (res.length != 0) {
  //       return TaskModel.fromDb(res.first);
  //     }
  //     return null;
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  // read all
  Future<List<TaskModel>> fetchTasksFromDb() async {
    try {
      final Database db = await _db;
      final List<Map<String, dynamic>> res = await db.query('task');
      // using rawquery
      // final List<Map<String, dynamic>> res =
      //     await db.rawQuery('SELECT * FROM task');

      if (res.length != 0) {
        return res
            .map(
              (map) => TaskModel.fromDb(map),
            )
            .toList();
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // update
  Future<int> updateTaskToDb(TaskModel newTask) async {
    try {
      final Database db = await _db;
      return await db.update(
        'task',
        newTask.toMapForDb(),
        where: 'id = ?',
        whereArgs: [newTask.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // using rawquery
      // return await db.rawUpdate(
      //     'UPDATE task SET title = ${newTask.title} category = ${newTask.category} date = ${newTask.date} is_done = ${newTask.isDone} WHERE id = ${newTask.id}');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // delete
  Future<int> removeTaskFromDb(int id) async {
    try {
      final Database db = await _db;
      return await db.delete(
        'task',
        where: 'id = ?',
        whereArgs: [id],
      );
      // using rawquery
      // return await db.rawDelete('DELETE FROM task WHERE id = $id');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // delete all
  Future<int> clearDb() async {
    final Database db = await _db;
    return db.delete('task');
  }
}
