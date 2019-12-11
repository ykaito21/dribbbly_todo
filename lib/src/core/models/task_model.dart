import 'package:flutter/foundation.dart';

class TaskModel {
  int id;
  String title;
  String category;
  DateTime date;
  bool isDone;

  TaskModel({
    this.id,
    @required this.title,
    @required this.category,
    @required this.date,
    this.isDone: false,
  })  : assert(title != null),
        assert(category != null),
        assert(date != null),
        assert(isDone != null);

  TaskModel.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'] ?? '',
        category = map['category'] ?? '',
        date = map['date'] != null
            ? DateTime.parse(map['date']).toLocal()
            : DateTime.now(),
        isDone = map['isdone'] == 1;

  Map<String, dynamic> toMapForDb() {
    Map<String, dynamic> map = {
      "title": title,
      "category": category,
      "date": date.toUtc().toIso8601String(),
      "is_done": isDone ? 1 : 0,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  void toggleDone() {
    isDone = !isDone;
  }

  @override
  String toString() {
    return 'id: $id title: $title category: $category date: $date isDone: $isDone';
  }
}

// class TaskModel {
//   final String id;
//   final String title;
//   final String category;
//   final DateTime date;
//   final bool isDone;

//   TaskModel({
//     @required this.id,
//     @required this.title,
//     @required this.category,
//     @required this.date,
//     this.isDone: false,
//   })  : assert(id != null),
//         assert(title != null),
//         assert(category != null),
//         assert(date != null),
//         assert(isDone != null);

//   TaskModel.fromDb(Map<String, dynamic> map)
//       : id = map['id'] ?? '',
//         title = map['title'] ?? '',
//         category = map['category'] ?? '',
//         // from int
//         // date = map['date'] != null
//         //     ? DateTime.fromMicrosecondsSinceEpoch(map['date']).toLocal()
//         //     : DateTime.now(),
//         date = map['date'] != null
//             ? DateTime.parse(map['date']).toLocal()
//             : DateTime.now(),
//         isDone = map['isdone'] == 1;

//   Map<String, dynamic> toMapForDb() {
//     return <String, dynamic>{
//       "id": id,
//       "title": title,
//       "category": category,
//       // to int
//       // "date": date.toUtc().millisecondsSinceEpoch
//       "date": date.toUtc().toIso8601String(),
//       "is_done": isDone ? 1 : 0,
//     };
//   }

//   @override
//   String toString() {
//     return 'id: $id title: $title category: $category date: $date isDone: $isDone';
//   }
// }
