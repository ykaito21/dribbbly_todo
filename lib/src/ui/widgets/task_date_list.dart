import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/base_provider.dart';
import '../../core/providers/task_provider.dart';
import '../global/widgets/view_state_widget.dart';
import 'task_date_separator.dart';
import 'task_list.dart';

class TaskDateList extends StatelessWidget {
  const TaskDateList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskProvider _taskProvider = Provider.of<TaskProvider>(context);
    List<DateTime> _taskDateList = _taskProvider.taskDateList;
    if (_taskProvider.viewState == ViewState.Busy)
      return ViewStateWidget.loadingViewState();
    if (_taskProvider.viewState == ViewState.Error)
      return ViewStateWidget.errorViewState('ERROR');
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
