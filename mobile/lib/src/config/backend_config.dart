import 'package:flutter/foundation.dart';

import '../data/backend_url_storage.dart';

class BackendConfig {
  BackendConfig._();

  static const String _configuredBaseUrl =
      String.fromEnvironment('BACKEND_BASE_URL');
  static String? _runtimeBaseUrl;
  static const String androidBaseUrl = 'http://10.0.2.2:8000/api/v1';
  static const String iosBaseUrl = 'http://localhost:8000/api/v1';
  static const String webBaseUrl = 'http://localhost:8000/api/v1';

  static Future<void> initialize() async {
    _runtimeBaseUrl ??= await BackendUrlStorage.load();
  }

  static Future<void> setBaseUrl(String value) async {
    final normalized = _normalizeConfigured(value);
    _runtimeBaseUrl = normalized.isEmpty ? null : normalized;
    if (_runtimeBaseUrl == null) {
      await BackendUrlStorage.clear();
    } else {
      await BackendUrlStorage.save(_runtimeBaseUrl!);
    }
  }

  static Future<void> clearOverride() async {
    _runtimeBaseUrl = null;
    await BackendUrlStorage.clear();
  }

  static List<String> get candidateBaseUrls {
    final defaults = <String>[
      androidBaseUrl,
      iosBaseUrl,
      webBaseUrl,
    ];

    final configured = baseUrl.trim();
    final candidates = <String>[
      if (configured.isNotEmpty) configured,
      ...defaults,
    ];

    final unique = <String>[];
    for (final candidate in candidates) {
      final normalized = _normalizeConfigured(candidate);
      if (normalized.isEmpty || unique.contains(normalized)) {
        continue;
      }
      unique.add(normalized);
    }
    return unique;
  }

  static String get baseUrl {
    final configured = (_runtimeBaseUrl ?? _configuredBaseUrl).trim();
    if (configured.isNotEmpty) {
      return _normalizeConfigured(configured);
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBaseUrl;
      case TargetPlatform.iOS:
        return iosBaseUrl;
      default:
        return webBaseUrl;
    }
  }

  static String _normalizeConfigured(String url) {
    final trimmed = url.trim().replaceAll(RegExp(r'/+$'), '');
    if (trimmed.isEmpty) {
      return trimmed;
    }

    if (trimmed.endsWith('/api/v1')) {
      return trimmed;
    }

    if (trimmed.endsWith('/api')) {
      return '$trimmed/v1';
    }

    return '$trimmed/api/v1';
  }
}
