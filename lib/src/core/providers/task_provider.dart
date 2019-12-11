// import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';
import '../services/sqflite_database.dart';

import '../providers/base_provider.dart';

class TaskProvider extends BaseProvider {
  final SqfliteDatabase _sqfliteDatabase = SqfliteDatabase();
  // final Uuid _uuid = Uuid();
  // Uuid get uuid => _uuid;

  TaskProvider() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    // clear database
    // await _sqfliteDatabase.clearDb();
    try {
      setViewState(ViewState.Busy);
      final List<TaskModel> tasksFromDb =
          await _sqfliteDatabase.fetchTasksFromDb();
      if (tasksFromDb != null) {
        _tasks = tasksFromDb;
        // print(_tasks);
      }
      setViewState(ViewState.Retrieved);
    } catch (e) {
      setViewState(ViewState.Error);
      print(e);
    }
  }

  List<TaskModel> _tasks = [];
  List<TaskModel> get taskList => [..._tasks];
  int get taskCount => _tasks.length;
  List<DateTime> get taskDateList => getTaskDateList();

  List<DateTime> getTaskDateList() {
    // sort tasks
    final sortedTasks = _tasks..sort((a, b) => a.date.compareTo(b.date));
    return sortedTasks
        // change format and set to get unique date list
        .map((task) => DateFormat('yyyy-MM-dd').format(task.date))
        .toSet()
        // make it datetime again
        .map((date) => DateTime.parse(date))
        .toList();
  }

  List<TaskModel> getTasks(DateTime date) {
    return _tasks
        .where((task) =>
            DateFormat('yyyy-MM-dd').format(task.date) ==
            DateFormat('yyyy-MM-dd').format(date))
        .toList();
    // to avoid weired move with toggleDone, don't need anymore
    // ..sort((a, b) => a.title.compareTo(b.title));
  }

  int countDoneTasks(DateTime date) {
    return _tasks
        .where((task) => task.date == date && task.isDone == true)
        .length;
  }

  // int countDoneTasks(List<TaskModel> tasks) {
  //   return tasks.where((task) {
  //     return task.isDone == true;
  //   }).length;
  // }

  Future<void> toggleDone(TaskModel task) async {
    try {
      await _sqfliteDatabase.updateTaskToDb(task);
      // simpler way without final
      task.toggleDone();
      // with final
      // _tasks.remove(task);
      // final newTask = TaskModel(
      //   id: task.id,
      //   title: task.title,
      //   category: task.category,
      //   date: task.date,
      //   isDone: !task.isDone,
      // );
      // _tasks.add(newTask);
      // final res = await _sqfliteDatabase.updateTaskToDb(newTask);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      final res = await _sqfliteDatabase.addTaskToDb(task);
      task.id = res;
      print(task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> removeTask(TaskModel task) async {
    try {
      await _sqfliteDatabase.removeTaskFromDb(task.id);
      _tasks.remove(task);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _sqfliteDatabase.updateTaskToDb(task);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // with final and string id
  // void updateTask(TaskModel preveTask, TaskModel newTask) {
  //   _tasks.remove(preveTask);
  //   _tasks.add(newTask);
  //   notifyListeners();
  // }

  // test data
  //  List<TaskModel> _tasks = [
  // TaskModel(
  //   id: 'test1',
  //   title: 'research about the client',
  //   category: 'job',
  //   date: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day + 8,
  //   ),
  //   isDone: false,
  // ),
  // TaskModel(
  //   id: 'test2',
  //   title: 'talk to my project team',
  //   category: 'job',
  //   date: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day + 7,
  //   ),
  //   isDone: true,
  // ),
  // TaskModel(
  //   id: 'test3',
  //   title: 'buy ticket',
  //   category: 'travel',
  //   date: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day + 6,
  //   ),
  //   isDone: false,
  // ),
  // TaskModel(
  //   id: 'test4',
  //   title: 'reserve restaurant',
  //   category: 'home',
  //   date: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day + 7,
  //   ),
  //   isDone: true,
  // ),
  // TaskModel(
  //   id: 'test5',
  //   title: 'get data',
  //   category: 'job',
  //   date: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day + 7,
  //   ),
  //   isDone: false,
  // ),
  // TaskModel(
  //   id: 'test6',
  //   title: 'writing code',
  //   category: 'development',
  //   date: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day + 3,
  //   ),
  //   isDone: false,
  // ),
  // TaskModel(
  //   id: 'test7',
  //   title: 'build ui',
  //   category: 'development',
  //   date: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day + 1,
  //   ),
  //   isDone: true,
  // ),
  // TaskModel(
  //   id: 'test8',
  //   title: 'clean up my room',
  //   category: 'home',
  //   date: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day + 2,
  //   ),
  //   isDone: false,
  // ),
  // TaskModel(
  //   id: 'test9',
  //   title: 'complete this project',
  //   category: 'developement',
  //   date: DateTime.now(),
  //   isDone: false,
  // ),
  // ];
}
