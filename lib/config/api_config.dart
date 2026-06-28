class ApiConfig {
  // iOS simulator → localhost; Android emulator → 10.0.2.2
  static const String baseUrl     = 'http://localhost:8000/api/v1';
  static const String broadcastAuthUrl = 'http://localhost:8000/broadcasting/auth';
  static const Duration timeout   = Duration(seconds: 30);

  // Reverb (WebSocket) — same host/port as `php artisan reverb:start`
  static const String reverbHost   = 'localhost'; // use 10.0.2.2 for Android emulator
  static const int    reverbPort   = 8080;
  static const String reverbAppKey = 'smzeyiilxs1w3rx8gtdp';

  static const String authEndpoint        = '/auth';
  static const String profileEndpoint     = '/profile';
  static const String deviceTokenEndpoint = '/device-tokens';
  static const String groupsEndpoint      = '/groups';
  static const String joinGroupEndpoint   = '/groups/join';
  static const String sectionsEndpoint    = '/sections';
  static const String uploadsEndpoint     = '/uploads';
  static const String chatEndpoint        = '/chat';
}
