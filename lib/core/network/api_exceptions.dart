class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Session expired. Please log in again.'])
      : super(message, statusCode: 401);
}

class ValidationException extends ApiException {
  final Map<String, dynamic> errors;

  ValidationException(this.errors, [String message = 'Validation failed.'])
      : super(message, statusCode: 400, data: errors);

  String get firstError {
    if (errors.isEmpty) return message;
    final firstEntry = errors.entries.first;
    final value = firstEntry.value;
    // 'detail' is a top-level Django error — return without field prefix
    if (firstEntry.key == 'detail') {
      if (value is List && value.isNotEmpty) return value.first.toString();
      if (value is String) return value;
      return message;
    }
    if (value is List && value.isNotEmpty) {
      return '${firstEntry.key}: ${value.first}';
    } else if (value is String) {
      return '${firstEntry.key}: $value';
    }
    return message;
  }
}

class NetworkException extends ApiException {
  NetworkException([String message = 'No internet connection or server unreachable.'])
      : super(message, statusCode: null);
}

class NotFoundException extends ApiException {
  NotFoundException([String message = 'The requested resource was not found.'])
      : super(message, statusCode: 404);
}
