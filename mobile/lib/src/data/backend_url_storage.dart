import 'package:flutter/services.dart';

class BackendUrlStorage {
  BackendUrlStorage._();

  static const MethodChannel _channel = MethodChannel('examverse/backend_url');

  static Future<String?> load() async {
    try {
      final value = await _channel.invokeMethod<String>('load');
      return _clean(value);
    } catch (_) {
      return null;
    }
  }

  static Future<void> save(String value) async {
    try {
      await _channel.invokeMethod<void>('save', {'value': value});
    } catch (_) {
      // Non-mobile platforms may not support persistence; ignore safely.
    }
  }

  static Future<void> clear() async {
    try {
      await _channel.invokeMethod<void>('clear');
    } catch (_) {
      // Ignore when persistence is unavailable.
    }
  }

  static String? _clean(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
