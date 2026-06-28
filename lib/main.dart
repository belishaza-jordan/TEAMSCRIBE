import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/group_provider.dart';
import 'providers/section_provider.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/chat_service.dart';
import 'services/fcm_service.dart';
import 'services/group_service.dart';
import 'providers/progress_provider.dart';
import 'services/progress_service.dart';
import 'services/section_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase — wrapped in try/catch so a configuration issue
  // never prevents the app from starting on device.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    // FCM will be unavailable but the rest of the app works normally.
    debugPrint('[Firebase] init failed: $e');
  }

  // Wire up services
  final apiService     = ApiService();
  final storageService = StorageService();
  final authService    = AuthService(apiService, storageService);
  final fcmService     = FcmService(authService);
  final groupService   = GroupService(apiService);
  final sectionService = SectionService(apiService);
  final chatService     = ChatService(apiService);
  final progressService = ProgressService(apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider(authService, fcmService)),
        ChangeNotifierProvider(create: (_) => GroupProvider(groupService)),
        ChangeNotifierProvider(
            create: (_) => SectionProvider(sectionService)),
        ChangeNotifierProvider(create: (_) => ChatProvider(chatService)),
        ChangeNotifierProvider(
            create: (_) => ProgressProvider(progressService)),
      ],
      child: const TeamScribeApp(),
    ),
  );
}
