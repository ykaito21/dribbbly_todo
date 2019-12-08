import 'package:dribbbly_todo/src/core/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({
    Key key,
    @required this.task,
  })  : assert(task != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: 18.0,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: task.isDone
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 15.0),
          ],
        ),
        SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                '${task.title}',
                style: TextStyle(
                  fontSize: 20.0,
                  color:
                      task.isDone ? Theme.of(context).primaryColorDark : null,
                ),
              ),
              Text(
                '${task.category}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
