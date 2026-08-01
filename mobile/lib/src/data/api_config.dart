import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl => _envBaseUrl.isNotEmpty ? _envBaseUrl : _defaultBaseUrl;

  static List<String> get candidateBaseUrls {
    final configured = baseUrl.trim();
    final defaults = defaultTargetPlatform == TargetPlatform.android
        ? const ['http://10.0.2.2:8000/api/v1', 'http://localhost:8000/api/v1']
        : const ['http://localhost:8000/api/v1', 'http://10.0.2.2:8000/api/v1'];

    return [
      if (configured.isNotEmpty) configured,
      ...defaults.where((candidate) => candidate != configured),
    ];
  }

  static String get _defaultBaseUrl {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000/api/v1';
      default:
        return 'http://localhost:8000/api/v1';
    }
  }
}
