import 'package:flutter/foundation.dart';

class BackendConfig {
  BackendConfig._();

  static const String androidBaseUrl = 'http://10.0.2.2:8000/api/v1';
  static const String iosBaseUrl = 'http://localhost:8000/api/v1';
  static const String webBaseUrl = 'http://localhost:8000/api/v1';

  static List<String> get candidateBaseUrls {
    final configured = baseUrl.trim();
    final defaults = <String>[
      androidBaseUrl,
      iosBaseUrl,
      webBaseUrl,
    ];

    return [
      if (configured.isNotEmpty) configured,
      ...defaults.where((candidate) => candidate != configured),
    ];
  }

  static String get baseUrl {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBaseUrl;
      case TargetPlatform.iOS:
        return iosBaseUrl;
      default:
        return webBaseUrl;
    }
  }
}
