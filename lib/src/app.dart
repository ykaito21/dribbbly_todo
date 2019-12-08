import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/task_provider.dart';
import 'core/providers/theme_provider.dart';
import 'ui/global/app_theme.dart';
import 'ui/global/route/route_generator.dart';
import 'ui/global/route/route_path.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<TaskProvider>(
          create: (context) => TaskProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dribbbly',
            theme: appThemes[AppTheme.DribbblyLight],
            darkTheme: appThemes[AppTheme.DribbblyDark],
            themeMode: themeProvider.currentTheme == 'light'
                ? ThemeMode.light
                : ThemeMode.dark,
            initialRoute: RoutePath.homeScreen,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
