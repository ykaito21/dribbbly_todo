import 'package:flutter/material.dart';
import 'ui/global/app_theme.dart';
import 'ui/global/route/route_generator.dart';
import 'ui/global/route/route_path.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dribbbly',
      theme: appThemes[AppTheme.DribbblyLight],
      initialRoute: RoutePath.homeScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
