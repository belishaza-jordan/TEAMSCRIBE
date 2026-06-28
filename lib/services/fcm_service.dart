import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

// Top-level background handler — must be outside any class
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialised by main() before this is called
  if (kDebugMode) {
    debugPrint('[FCM] background: ${message.notification?.title}');
  }
}

class FcmService {
  FcmService(this._authService);

  final AuthService _authService;

  static const _tokenKey = 'fcm_token';

  // Android notification channel used for all TeamScribe push notifications
  static const _channel = AndroidNotificationChannel(
    'teamscribe_default',
    'TeamScribe Notifications',
    description: 'Group messages, task updates and deadline reminders.',
    importance: Importance.high,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // ── 1. Local notifications setup ──────────────────────────────────
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotifications.initialize(
      settings: const InitializationSettings(android: androidSettings),
    );

    // Create the high-importance channel on Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // ── 2. FCM permission ──────────────────────────────────────────────
    final messaging = FirebaseMessaging.instance;
    final settings  = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    // Tell FCM to deliver foreground messages with full priority
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ── 3. Token registration ──────────────────────────────────────────
    final token = await messaging.getToken();
    if (token != null) await _saveAndRegister(token);
    messaging.onTokenRefresh.listen(_saveAndRegister);

    // ── 4. Foreground message → show local notification ───────────────
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final android      = message.notification?.android;
      if (notification == null) return;

      _localNotifications.show(
        id:                  notification.hashCode,
        title:               notification.title,
        body:                notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.high,
            priority:   Priority.high,
          ),
        ),
      );
    });
  }

  Future<void> _saveAndRegister(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_tokenKey);
    if (saved == token) return;

    try {
      await _authService.registerDeviceToken(token);
      await prefs.setString(_tokenKey, token);
    } catch (_) {
      // Non-fatal — retries on next launch
    }
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null) return;

    try {
      await _authService.removeDeviceToken(token);
    } catch (_) {}
    await prefs.remove(_tokenKey);
  }
}
