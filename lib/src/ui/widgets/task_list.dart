import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../core/models/task_model.dart';
import '../../core/providers/task_provider.dart';
import '../global/widgets/snack_bars.dart';
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
                  // onWillDismiss: (actionType) {
                  //   return showDialog<bool>(
                  //     context: context,
                  //     builder: (context) {
                  //       return AlertDialog(
                  //         title: Text('Delete'),
                  //         content: Text('Item will be deleted'),
                  //         actions: <Widget>[
                  //           FlatButton(
                  //             child: Text('Cancel'),
                  //             onPressed: () => Navigator.of(context).pop(false),
                  //           ),
                  //           FlatButton(
                  //             child: Text('Ok'),
                  //             onPressed: () => Navigator.of(context).pop(true),
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   );
                  // },
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
                  // onTap: () => taskProvider.toggleDone(task),
                  child: TaskTile(
                    task: task,
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Edit',
                    color: Theme.of(context).accentColor,
                    icon: Icons.edit,
                    onTap: () {},
                  ),
                  IconSlideAction(
                    caption: 'Delete',
                    color: Theme.of(context).accentColor,
                    icon: Icons.delete,
                    onTap: () {
                      taskProvider.removeTask(task);
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBars.baseSnackBar(
                              context, '\"${task.title}\" was removed'),
                        );
                    },
                  ),
                ],
              );
              // return Dismissible(
              //   key: Key(UniqueKey().toString()),
              //   direction: DismissDirection.endToStart,
              //   onDismissed: (direction) {
              //     // taskProvider.removeTask(task);
              //     // Scaffold.of(context).showSnackBar(
              //     //   SnackBar(
              //     //     backgroundColor: Theme.of(context).accentColor,
              //     //     content: Text(
              //     //       "\"${task.title}\" was removed",
              //     //       textAlign: TextAlign.center,
              //     //       style: TextStyle(
              //     //         fontSize: 20.0,
              //     //         color: Colors.white,
              //     //       ),
              //     //     ),
              //     //   ),
              //     // );
              //   },
              //   background: Container(
              //     padding: const EdgeInsets.only(right: 20.0),
              //     alignment: AlignmentDirectional.centerEnd,
              //     color: Theme.of(context).accentColor,
              //     child: Icon(
              //       Icons.delete,
              //       size: 24.0,
              //       color: Colors.white,
              //     ),
              //   ),
              //   child: GestureDetector(
              //     onTap: () {
              //       // taskProvider.toggleDone(task);
              //     },
              //     onDoubleTap: () {
              //       // taskProvider.checkCategory(task.category);
              //       // Navigator.pushNamed(
              //       //   context,
              //       //   WriteTask.url,
              //       //   arguments: task,
              //       // );
              //     },
              //     child: TaskTile(
              //       task: task,
              //     ),
              //   ),
              // );
            },
          ),
        )
      ],
    );
  }
}
