import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [
    TaskModel(
      id: 'test1',
      title: 'research about the client',
      category: 'job',
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 8,
      ),
      isDone: false,
    ),
    TaskModel(
      id: 'test2',
      title: 'talk to my project team',
      category: 'job',
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 7,
      ),
      isDone: true,
    ),
    TaskModel(
      id: 'test3',
      title: 'buy ticket',
      category: 'travel',
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 6,
      ),
      isDone: false,
    ),
    TaskModel(
      id: 'test4',
      title: 'reserve restaurant',
      category: 'home',
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 7,
      ),
      isDone: true,
    ),
    TaskModel(
      id: 'test5',
      title: 'get data',
      category: 'job',
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 7,
      ),
      isDone: false,
    ),
    TaskModel(
      id: 'test6',
      title: 'writing code',
      category: 'development',
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 3,
      ),
      isDone: false,
    ),
    TaskModel(
      id: 'test7',
      title: 'build ui',
      category: 'development',
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 1,
      ),
      isDone: true,
    ),
    TaskModel(
      id: 'test8',
      title: 'clean up my room',
      category: 'home',
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 2,
      ),
      isDone: false,
    ),
    TaskModel(
      id: 'test9',
      title: 'complete this project',
      category: 'developement',
      date: DateTime.now(),
      isDone: false,
    ),
  ];

  final Uuid _uuid = Uuid();
  Uuid get uuid => _uuid;

  List<TaskModel> get taskList => [..._tasks];
  int get taskCount => _tasks.length;
  List<DateTime> get taskDateList => getTaskDateList();

  List<DateTime> getTaskDateList() {
    return _tasks.map((task) => task.date).toSet().toList()
      ..sort((a, b) => a.compareTo(b));
  }

  List<TaskModel> getTasks(DateTime date) {
    return _tasks.where((task) {
      return task.date == date;
    }).toList()
      // to avoid weired move with toggleDone
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  int countDoneTasks(DateTime date) {
    return _tasks.where((task) {
      return task.date == date && task.isDone == true;
    }).length;
  }

  // int countDoneTasks(List<TaskModel> tasks) {
  //   return tasks.where((task) {
  //     return task.isDone == true;
  //   }).length;
  // }

  void toggleDone(TaskModel task) {
    // simpler way without final
    // task.toggleDone();
    _tasks.remove(task);
    _tasks.add(
      TaskModel(
        id: task.id,
        title: task.title,
        category: task.category,
        date: task.date,
        isDone: !task.isDone,
      ),
    );
    notifyListeners();
  }

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(TaskModel task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTask(TaskModel preveTask, TaskModel newTask) {
    _tasks.remove(preveTask);
    _tasks.add(newTask);
    notifyListeners();
  }

  List<String> _categories = [
    'Job stuff',
    'Happiness',
    'Task',
    'Contact',
  ];
  List<String> get taskCategoryList => [..._categories.reversed];
  int get categoryCount => _categories.length;

  void getTaskCategoryList() {
    final categories = _tasks.map((task) => task.category).toSet().toList()
      ..sort((a, b) => a.compareTo(b));
    _categories = categories;
  }

  void checkCategory(String category) {
    if (category.isNotEmpty && !_categories.contains(category)) {
      _addCategory(category);
    }
  }

  void _addCategory(String category) {
    _categories.add(category);
    notifyListeners();
  }

  void addCategory(String category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(String category) {
    _categories.remove(category);
    notifyListeners();
  }
}
