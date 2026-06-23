class ApiConfig {
  static const String baseUrl = 'https://api.teamscribe.app/v1';
  static const Duration timeout = Duration(seconds: 30);

  static const String authEndpoint = '/auth';
  static const String groupsEndpoint = '/groups';
  static const String sectionsEndpoint = '/sections';
  static const String uploadsEndpoint = '/uploads';
  static const String chatEndpoint = '/chat';
}
