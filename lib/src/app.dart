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
      darkTheme: appThemes[AppTheme.DribbblyDark],
      // themeMode: ThemeMode.system,
      initialRoute: RoutePath.homeScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
