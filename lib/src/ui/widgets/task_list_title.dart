import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/models/task_model.dart';
import '../../core/providers/task_provider.dart';

class TaskListTitle extends StatelessWidget {
  final DateTime taskDate;
  const TaskListTitle({
    Key key,
    @required this.taskDate,
  })  : assert(taskDate != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          DateFormat.MMMEd().format(taskDate),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor,
          ),
        ),
        Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final List<TaskModel> tasks = taskProvider.getTasks(taskDate);
            final int countDoneTasks = taskProvider.countDoneTasks(taskDate);
            // final int countDoneTasks = taskProvider.countDoneTasks(tasks);
            return Text(
              '$countDoneTasks of ${tasks.length} done',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColorDark,
              ),
            );
          },
        ),
      ],
    );
  }
}
