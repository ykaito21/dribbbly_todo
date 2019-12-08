import 'package:flutter/material.dart';

class TaskDateSeparator extends StatelessWidget {
  const TaskDateSeparator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Container(
          width: 40.0,
          child: Divider(
            color: Theme.of(context).primaryColorDark,
            thickness: 2.0,
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}
