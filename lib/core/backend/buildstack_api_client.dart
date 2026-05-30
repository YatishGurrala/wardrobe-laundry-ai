import 'dart:convert';

import 'package:http/http.dart' as http;

import 'buildstack_config.dart';

class BuildstackApiException implements Exception {
  BuildstackApiException({
    required this.message,
    this.statusCode,
    this.details,
  });

  final String message;
  final int? statusCode;
  final Object? details;

  @override
  String toString() {
    return 'BuildstackApiException(statusCode: $statusCode, message: $message, details: $details)';
  }
}

class BuildstackApiClient {
  BuildstackApiClient(this._config, {http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final BuildstackConfig _config;
  final http.Client _http;

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    final payload = await _requestJson(
      method: 'POST',
      path: '/auth/register',
      body: {
        'email': email,
        'password': password,
        ...?metadata == null ? null : {'metadata': metadata},
      },
    );
    return _asMap(payload);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final payload = await _requestJson(
      method: 'POST',
      path: '/auth/login',
      body: {'email': email, 'password': password},
    );
    return _asMap(payload);
  }

  Future<void> logout(String userToken) async {
    await _requestJson(
      method: 'POST',
      path: '/auth/logout',
      additionalHeaders: {'x-user-token': userToken},
    );
  }

  Future<List<Map<String, dynamic>>> listRecords({
    required String collection,
    String? ownerId,
  }) async {
    final payload = await _requestJson(
      method: 'GET',
      path: '/records',
      queryParameters: {
        'collection': collection,
        ...?ownerId == null ? null : {'ownerId': ownerId},
      },
    );

    if (payload is List) {
      return payload.whereType<Map>().map(_asMap).toList();
    }

    final mapPayload = _asMap(payload);
    final data = mapPayload['data'];
    if (data is List) {
      return data.whereType<Map>().map(_asMap).toList();
    }

    return const [];
  }

  Future<Map<String, dynamic>> createRecord({
    required String collection,
    required String ownerId,
    required Map<String, dynamic> data,
  }) async {
    final payload = await _requestJson(
      method: 'POST',
      path: '/records',
      body: {'collection': collection, 'ownerId': ownerId, 'data': data},
    );
    return _asMap(payload);
  }

  Future<Map<String, dynamic>> updateRecord({
    required String recordId,
    required Map<String, dynamic> data,
    String? collection,
    String? ownerId,
  }) async {
    final payload = await _requestJson(
      method: 'PUT',
      path: '/records/$recordId',
      body: {
        'data': data,
        ...?collection == null ? null : {'collection': collection},
        ...?ownerId == null ? null : {'ownerId': ownerId},
      },
    );
    return _asMap(payload);
  }

  Future<dynamic> _requestJson({
    required String method,
    required String path,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    final uri = Uri.parse(
      '${_config.baseUrl}/api/v1/${_config.projectKey}$path',
    ).replace(queryParameters: queryParameters);

    final request = http.Request(method, uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'x-api-key': _config.apiKey,
        ...?additionalHeaders,
      });

    if (body != null) {
      request.body = jsonEncode(body);
    }

    final streamed = await _http.send(request);
    final response = await http.Response.fromStream(streamed);

    final decoded = _decodeResponseBody(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final payload = decoded is Map ? decoded['error'] ?? decoded : decoded;
      throw BuildstackApiException(
        message: _extractErrorMessage(payload) ?? 'Buildstack request failed',
        statusCode: response.statusCode,
        details: payload,
      );
    }

    return decoded;
  }

  dynamic _decodeResponseBody(String body) {
    if (body.trim().isEmpty) {
      return const <String, dynamic>{};
    }

    try {
      return jsonDecode(body);
    } catch (_) {
      return <String, dynamic>{'raw': body};
    }
  }

  String? _extractErrorMessage(Object? payload) {
    if (payload is Map) {
      final mapPayload = _asMap(payload);
      final direct = mapPayload['message'];
      if (direct is String && direct.isNotEmpty) {
        return direct;
      }

      final nested = mapPayload['error'];
      if (nested is Map) {
        final nestedMessage = nested['message'];
        if (nestedMessage is String && nestedMessage.isNotEmpty) {
          return nestedMessage;
        }
      }
    }
    return null;
  }

  Map<String, dynamic> _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return const <String, dynamic>{};
  }
}
