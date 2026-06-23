import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/theme.dart';

class TeamScribeApp extends StatelessWidget {
  const TeamScribeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:            'TeamScribe',
      debugShowCheckedModeBanner: false,
      theme:            AppTheme.dark,   // dark-only app
      initialRoute:     AppRoutes.splash,
      onGenerateRoute:  AppRoutes.generateRoute,
    );
  }
}
