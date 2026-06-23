import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/group_provider.dart';
import 'providers/section_provider.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/chat_service.dart';
import 'services/group_service.dart';
import 'services/section_service.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  final storageService = StorageService();
  final authService = AuthService(apiService, storageService);
  final groupService = GroupService(apiService);
  final sectionService = SectionService(apiService);
  final chatService = ChatService(apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => GroupProvider(groupService)),
        ChangeNotifierProvider(create: (_) => SectionProvider(sectionService)),
        ChangeNotifierProvider(create: (_) => ChatProvider(chatService)),
      ],
      child: const TeamScribeApp(),
    ),
  );
}
