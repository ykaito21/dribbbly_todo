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
  });
}
