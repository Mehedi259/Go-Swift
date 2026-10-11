import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../storage/local_storage.dart';
import 'api_endpoints.dart';
import 'api_exceptions.dart';

class ApiClient {
  static final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 25);

  // Singleton instance
  static final ApiClient instance = ApiClient._internal();
  ApiClient._internal();

  Map<String, String> _buildHeaders({Map<String, String>? extraHeaders, bool isJson = true}) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }

    final token = LocalStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  // --- GET ---
  Future<dynamic> get(String url, {Map<String, String>? queryParams, Map<String, String>? headers}) async {
    final uri = _buildUri(url, queryParams);
    try {
      final response = await _client.get(uri, headers: _buildHeaders(extraHeaders: headers)).timeout(_timeout);
      return await _handleResponse(response, () => get(url, queryParams: queryParams, headers: headers));
    } on SocketException {
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }
  }

  // --- POST ---
  Future<dynamic> post(String url, {dynamic body, Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    try {
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return await _handleResponse(response, () => post(url, body: body, headers: headers));
    } on SocketException {
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }
  }

  // --- PATCH ---
  Future<dynamic> patch(String url, {dynamic body, Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    try {
      final response = await _client
          .patch(
            uri,
            headers: _buildHeaders(extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return await _handleResponse(response, () => patch(url, body: body, headers: headers));
    } on SocketException {
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }
  }

  // --- PUT ---
  Future<dynamic> put(String url, {dynamic body, Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    try {
      final response = await _client
          .put(
            uri,
            headers: _buildHeaders(extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return await _handleResponse(response, () => put(url, body: body, headers: headers));
    } on SocketException {
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }
  }

  // --- DELETE ---
  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    try {
      final response = await _client.delete(uri, headers: _buildHeaders(extraHeaders: headers)).timeout(_timeout);
      return await _handleResponse(response, () => delete(url, headers: headers));
    } on SocketException {
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }
  }

  // --- MULTIPART (Upload files/photos) ---
  Future<dynamic> multipartRequest(
    String method,
    String url, {
    Map<String, String>? fields,
    Map<String, File>? files,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    try {
      final request = http.MultipartRequest(method, uri);
      request.headers.addAll(_buildHeaders(extraHeaders: headers, isJson: false));

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (files != null) {
        for (final entry in files.entries) {
          final file = entry.value;
          if (await file.exists()) {
            request.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
          }
        }
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      return await _handleResponse(response, null);
    } on SocketException {
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }
  }

  // --- RESPONSE HANDLER & TOKEN REFRESH ---
  Future<dynamic> _handleResponse(http.Response response, Future<dynamic> Function()? retryCall) async {
    final statusCode = response.statusCode;
    dynamic decoded;

    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(utf8.decode(response.bodyBytes));
      } catch (_) {
        decoded = response.body;
      }
    }

    // Success: 200..299
    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    }

    // 401 Unauthorized -> Attempt Token Refresh
    if (statusCode == 401) {
      final refreshed = await _tryRefreshToken();
      if (refreshed && retryCall != null) {
        return await retryCall();
      }
      await LocalStorage.clearAuth();
      final msg = _extractErrorMessage(decoded) ?? 'Session expired. Please log in again.';
      throw UnauthorizedException(msg);
    }

    // 400 Bad Request -> Validation Errors
    if (statusCode == 400) {
      if (decoded is Map<String, dynamic>) {
        throw ValidationException(decoded, _extractErrorMessage(decoded) ?? 'Validation error.');
      }
      throw ApiException(decoded?.toString() ?? 'Bad request.', statusCode: 400);
    }

    // 404 Not Found
    if (statusCode == 404) {
      throw NotFoundException(_extractErrorMessage(decoded) ?? 'Resource not found.');
    }

    // Other Server Errors
    final message = _extractErrorMessage(decoded) ?? 'An error occurred with status code $statusCode.';
    throw ApiException(message, statusCode: statusCode, data: decoded);
  }

  Future<bool> _tryRefreshToken() async {
    final refresh = LocalStorage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final res = await _client.post(
        Uri.parse(ApiEndpoints.refreshToken),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final newAccess = data['access']?.toString();
        if (newAccess != null && newAccess.isNotEmpty) {
          await LocalStorage.saveTokens(access: newAccess);
          return true;
        }
      }
    } catch (_) {
      // Ignore refresh network error, let caller handle logout
    }
    return false;
  }

  String? _extractErrorMessage(dynamic body) {
    if (body == null) return null;
    if (body is Map) {
      if (body['detail'] != null) return body['detail'].toString();
      if (body['message'] != null) return body['message'].toString();
      if (body['error'] != null) return body['error'].toString();
      // Look at first entry
      for (final value in body.values) {
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String) return value;
      }
    }
    if (body is String) return body;
    return null;
  }

  Uri _buildUri(String url, Map<String, String>? queryParams) {
    final uri = Uri.parse(url);
    if (queryParams == null || queryParams.isEmpty) return uri;
    return uri.replace(queryParameters: {...uri.queryParameters, ...queryParams});
  }
}
