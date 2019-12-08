import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/task_provider.dart';
import 'task_date_separator.dart';
import 'task_list.dart';

class TaskDateList extends StatelessWidget {
  const TaskDateList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DateTime> _taskDateList = Provider.of<TaskProvider>(
      context,
    ).taskDateList;
    return ListView.separated(
      separatorBuilder: (context, index) {
        return TaskDateSeparator();
      },
      itemCount: _taskDateList.length,
      itemBuilder: (context, index) {
        final taskDate = _taskDateList[index];
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 25.0,
          ),
          height: 300.0,
          child: TaskList(taskDate: taskDate),
        );
      },
    );
  }
}
