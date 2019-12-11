import 'package:flutter/material.dart';
import '../models/task_model.dart';

class CategoryProvider with ChangeNotifier {
  List<TaskModel> _tasks;
  List<String> _categories = [];
  List<String> get taskCategoryList => [..._categories.reversed];
  int get categoryCount => _categories.length;

  set tasks(List<TaskModel> value) {
    if (_tasks != value) {
      _tasks = value;
      getTaskCategoryList();
    }
  }

  void getTaskCategoryList() {
    final categories = _tasks.map((task) => task.category).toSet().toList()
      ..sort((a, b) => a.compareTo(b));
    _categories = categories;
    notifyListeners();
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
}
