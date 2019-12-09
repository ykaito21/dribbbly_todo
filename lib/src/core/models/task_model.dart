import 'package:flutter/foundation.dart';

class TaskModel {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final bool isDone;

  TaskModel({
    @required this.id,
    @required this.title,
    @required this.category,
    @required this.date,
    this.isDone: false,
  })  : assert(id != null),
        assert(title != null),
        assert(category != null),
        assert(date != null),
        assert(isDone != null);

  @override
  String toString() {
    return 'id: $id title: $title category: $category date: $date isDone: $isDone';
  }

  // if isDone is not final
  // void toggleDone() {
  //   isDone = !isDone;
  // }
}
