import 'package:dribbbly_todo/src/ui/shared/platform/platform_exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../core/models/task_model.dart';
import '../../core/providers/task_provider.dart';
import '../global/widgets/snack_bars.dart';
import '../global/route/route_path.dart';
// import '../shared/platform/platform_alert_dialog.dart';
import 'task_list_title.dart';
import 'task_tile.dart';

class TaskList extends StatelessWidget {
  final DateTime taskDate;

  const TaskList({
    Key key,
    @required this.taskDate,
  })  : assert(taskDate != null),
        super(key: key);

  Future<void> _toggleDone(BuildContext context, TaskModel task) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).toggleDone(task);
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'ERROR',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _removeTask(BuildContext context, TaskModel task) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).removeTask(task);
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBars.baseSnackBar(context, '\"${task.title}\" was removed'),
        );
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'ERROR',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TaskListTitle(
          taskDate: taskDate,
        ),
        SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final List<TaskModel> tasks = taskProvider.getTasks(taskDate);
              return ListView.builder(
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
                                colorScheme: ColorScheme(
                                  background: Colors.black,
                                  brightness: Brightness.light,
                                  error: Colors.black,
                                  onBackground: Colors.black87,
                                  onError: Colors.white,
                                  onSurface: Colors.black87,
                                  onSecondary: Colors.black87,
                                  onPrimary: Colors.black,
                                  primary: Theme.of(context)
                                      .accentColor, //  need this for flat button color
                                  primaryVariant: Theme.of(context).accentColor,
                                  secondary: Colors.black,
                                  secondaryVariant: Colors.black,
                                  surface: Colors.white,
                                ),
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
                                content:
                                    Text('\"${task.title}\" will be deleted'),
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
                              // platform aware dialog
                              // child: PlatformAlertDialog(
                              //   title: 'Delete',
                              //   content: '\"${task.title}\" will be deleted',
                              //   defaultActionText: 'OK',
                              //   cancelActionText: 'CANCEL',
                              // ),
                            );
                          },
                        );
                      },
                      child: SlidableDrawerDismissal(),
                      onDismissed: (actionType) async =>
                          await _removeTask(context, task),
                    ),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: GestureDetector(
                      onTap: () async => await _toggleDone(context, task),
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
                        onTap: () async => await _removeTask(context, task),
                        caption: 'Delete',
                        color: Theme.of(context).accentColor,
                        icon: Icons.delete,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
