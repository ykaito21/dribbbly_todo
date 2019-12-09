import 'package:flutter/material.dart';

import '../../../core/models/task_model.dart';
import '../../screens/home_screen.dart';
import '../../screens/write_task_screen.dart';
import 'route_path.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RoutePath.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case RoutePath.writeTaskScreen:
        if (args is TaskModel) {
          return MaterialPageRoute(
            builder: (context) => WriteTaskScreen(task: args),
          );
        }

        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text(
              'ERROR',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
