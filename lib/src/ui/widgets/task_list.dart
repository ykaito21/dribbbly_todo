import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../core/models/task_model.dart';
import '../../core/providers/task_provider.dart';
import '../global/widgets/snack_bars.dart';
import '../global/route/route_path.dart';
import 'task_list_title.dart';
import 'task_tile.dart';

class TaskList extends StatelessWidget {
  final DateTime taskDate;

  const TaskList({
    Key key,
    @required this.taskDate,
  })  : assert(taskDate != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: true);
    final List<TaskModel> tasks = taskProvider.getTasks(taskDate);
    return Column(
      children: <Widget>[
        TaskListTitle(
          taskDate: taskDate,
        ),
        SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Slidable(
                key: Key(UniqueKey().toString()),
                dismissal: SlidableDismissal(
                  onWillDismiss: (actionType) {
                    return showDialog<bool>(
                      context: context,
                      builder: (context) {
                        final Color _appliedColor =
                            Theme.of(context).primaryColor == Colors.white
                                ? Colors.black
                                : Colors.white;
                        return Theme(
                          data: ThemeData(
                            // for only alertdialog
                            accentColor: Theme.of(context).accentColor,
                            dialogBackgroundColor:
                                Theme.of(context).primaryColor,
                            textTheme: TextTheme(
                              title: TextStyle(
                                color: _appliedColor,
                              ),
                              subhead: TextStyle(
                                color: _appliedColor,
                              ),
                            ),
                          ),
                          child: AlertDialog(
                            title: Text('Delete'),
                            content: Text('\"${task.title}\" will be deleted'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('CANCEL'),
                              ),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: SlidableDrawerDismissal(),
                  onDismissed: (actionType) {
                    taskProvider.removeTask(task);
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBars.baseSnackBar(
                            context, '\"${task.title}\" was removed'),
                      );
                  },
                ),
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: GestureDetector(
                  onTap: () => taskProvider.toggleDone(task),
                  child: TaskTile(
                    task: task,
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    onTap: () => Navigator.pushNamed(
                      context,
                      RoutePath.writeTaskScreen,
                      arguments: task,
                    ),
                    caption: 'Edit',
                    color: Theme.of(context).accentColor,
                    icon: Icons.edit,
                  ),
                  IconSlideAction(
                    onTap: () {
                      taskProvider.removeTask(task);
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBars.baseSnackBar(
                              context, '\"${task.title}\" was removed'),
                        );
                    },
                    caption: 'Delete',
                    color: Theme.of(context).accentColor,
                    icon: Icons.delete,
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
