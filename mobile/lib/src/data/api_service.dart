import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/backend_config.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> getJson(String path) async {
    final response = await _sendWithFallback(
      path,
      (uri) => _client.get(uri, headers: _headers()),
    );
    return _decodeMap(response);
  }

  Future<List<dynamic>> getList(String path) async {
    final response = await _sendWithFallback(
      path,
      (uri) => _client.get(uri, headers: _headers()),
    );
    final payload = _decodeJson(response);
    if (payload is List) {
      return payload;
    }
    if (payload is Map<String, dynamic>) {
      final data = payload['data'];
      if (data is List) {
        return data;
      }
    }
    throw const ApiException('Unexpected list response shape.');
  }

  Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final response = await _sendWithFallback(
      path,
      (uri) => _client.post(
        uri,
        headers: _headers(),
        body: jsonEncode(body),
      ),
    );
    return _decodeMap(response);
  }

  Future<http.Response> _sendWithFallback(
    String path,
    Future<http.Response> Function(Uri uri) send,
  ) async {
    Object? lastError;

    for (final baseUrl in BackendConfig.candidateBaseUrls) {
      final uri = Uri.parse('$baseUrl$path');
      try {
        final response = await send(uri);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        return response;
      } catch (error) {
        lastError = error;
      }
    }

    throw ApiException(
      'Unable to reach the backend API. Last error: $lastError',
    );
  }

  Map<String, String> _headers() => const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  dynamic _decodeJson(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(_errorMessage(response), statusCode: response.statusCode);
    }
    return jsonDecode(response.body);
  }

  Map<String, dynamic> _decodeMap(http.Response response) {
    final payload = _decodeJson(response);
    if (payload is Map<String, dynamic>) {
      return payload;
    }
    throw const ApiException('Unexpected object response shape.');
  }

  String _errorMessage(http.Response response) {
    try {
      final payload = jsonDecode(response.body);
      if (payload is Map<String, dynamic>) {
        return payload['message']?.toString() ?? 'Request failed.';
      }
    } catch (_) {
      // Fall through to raw body.
    }
    return response.body.isEmpty ? 'Request failed.' : response.body;
  }
}
