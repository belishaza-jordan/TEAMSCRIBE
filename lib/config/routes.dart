import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/main_screen.dart';
import '../screens/group/create_group_screen.dart';
import '../screens/group/group_detail_screen.dart';
import '../screens/task/task_detail_screen.dart';
import '../screens/merge/merge_export_screen.dart';

class AppRoutes {
  static const String splash      = '/';
  static const String onboarding  = '/onboarding';
  static const String login       = '/login';
  static const String signup      = '/signup';
  static const String home        = '/home';    // → MainScreen (4 tabs)
  static const String createGroup = '/group/create';
  static const String groupDetail = '/group/detail';
  static const String taskDetail  = '/task/detail';
  static const String mergeExport = '/merge';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case createGroup:
        return MaterialPageRoute(builder: (_) => const CreateGroupScreen());
      case groupDetail:
        return MaterialPageRoute(builder: (_) => const GroupDetailScreen());
      case taskDetail:
        return MaterialPageRoute(builder: (_) => const TaskDetailScreen());
      case mergeExport:
        return MaterialPageRoute(builder: (_) => const MergeExportScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
