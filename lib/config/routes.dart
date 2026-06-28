import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/otp_verify_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/main_screen.dart';
import '../screens/group/create_group_screen.dart';
import '../screens/group/group_detail_screen.dart';
import '../screens/task/task_detail_screen.dart';
import '../screens/merge/merge_export_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/notifications_settings_screen.dart';
import '../screens/profile/account_security_screen.dart';
import '../screens/profile/help_support_screen.dart';
import '../screens/group/join_group_screen.dart';
import '../screens/group/edit_group_screen.dart';

class AppRoutes {
  static const String splash          = '/';
  static const String onboarding      = '/onboarding';
  static const String login           = '/login';
  static const String signup          = '/signup';
  static const String emailVerification = '/email-verification';
  static const String forgotPassword    = '/forgot-password';
  static const String otpVerify       = '/otp-verify';
  static const String resetPassword   = '/reset-password';
  static const String home            = '/home';
  static const String createGroup     = '/group/create';
  static const String editGroup       = '/group/edit';
  static const String joinGroup       = '/group/join';
  static const String groupDetail     = '/group/detail';
  static const String taskDetail      = '/task/detail';
  static const String mergeExport     = '/merge';
  static const String notifications         = '/notifications';
  static const String search                = '/search';
  static const String editProfile           = '/profile/edit';
  static const String notificationsSettings = '/profile/notifications';
  static const String accountSecurity       = '/profile/security';
  static const String helpSupport           = '/profile/help';

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
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case otpVerify:
        return MaterialPageRoute(
          builder: (_) => const OtpVerifyScreen(),
          settings: settings,
        );
      case resetPassword:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
          settings: settings,
        );
      case emailVerification:
        return MaterialPageRoute(
            builder: (_) => const EmailVerificationScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case createGroup:
        return MaterialPageRoute(builder: (_) => const CreateGroupScreen());
      case editGroup:
        return MaterialPageRoute(
          builder:  (_) => const EditGroupScreen(),
          settings: settings,
        );
      case joinGroup:
        return MaterialPageRoute(
          builder:  (_) => const JoinGroupScreen(),
          settings: settings,
        );
      case groupDetail:
        return MaterialPageRoute(builder: (_) => const GroupDetailScreen());
      case taskDetail:
        return MaterialPageRoute(builder: (_) => const TaskDetailScreen());
      case mergeExport:
        return MaterialPageRoute(builder: (_) => const MergeExportScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case notificationsSettings:
        return MaterialPageRoute(
            builder: (_) => const NotificationsSettingsScreen());
      case accountSecurity:
        return MaterialPageRoute(
            builder: (_) => const AccountSecurityScreen());
      case helpSupport:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
