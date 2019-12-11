import 'package:dribbbly_todo/src/core/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/task_provider.dart';
import '../global/style_list.dart';
import '../global/route/route_path.dart';
import '../widgets/task_date_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: StyleList.basePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return Text(
                    taskProvider.taskCount == 0
                        ? 'No Task'
                        : '${taskProvider.taskCount} Tasks',
                    textAlign: TextAlign.start,
                    style: StyleList.titleTextStyle,
                  );
                },
              ),
            ),
            StyleList.baseVerticalSpace,
            Expanded(
              child: TaskDateList(),
            )
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onDoubleTap: () =>
            Provider.of<ThemeProvider>(context, listen: false).changeTheme(),
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(
            context,
            RoutePath.writeTaskScreen,
            arguments: TaskModel(
              title: '',
              category: '',
              date: DateTime.now(),
              // isDone: false
            ),
          ),
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
