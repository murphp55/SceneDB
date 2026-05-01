import 'package:dio/dio.dart';

/// Typed errors thrown by [TmdbService]. UI code should pattern-match on the
/// concrete subtype (or read [userMessage]) instead of dealing with raw
/// `DioException` strings.
sealed class TmdbError implements Exception {
  const TmdbError();

  /// Short, user-facing message safe to render in the UI.
  String get userMessage;

  /// Whether retrying the same request is reasonable. Configuration
  /// problems (missing key, 404) return false; network/server hiccups
  /// return true.
  bool get isRetryable;

  /// Translate a [DioException] into the most specific [TmdbError] we can.
  factory TmdbError.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TmdbTimeoutError();
      case DioExceptionType.connectionError:
        return const TmdbNoNetworkError();
      case DioExceptionType.cancel:
        return const TmdbCancelledError();
      case DioExceptionType.badCertificate:
        return const TmdbUnknownError('TLS certificate error.');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        if (status == 401 || status == 403) {
          return const TmdbInvalidKeyError();
        }
        if (status == 404) return const TmdbNotFoundError();
        if (status == 429) return const TmdbRateLimitError();
        if (status >= 500 && status < 600) return TmdbServerError(status);
        return TmdbUnknownError('Unexpected response: $status');
      case DioExceptionType.unknown:
        return TmdbUnknownError(e.message ?? 'Unknown network error.');
    }
  }

  @override
  String toString() => 'TmdbError: $userMessage';
}

class TmdbMissingKeyError extends TmdbError {
  const TmdbMissingKeyError();
  @override
  String get userMessage =>
      'No TMDB API key configured. Open Settings to add one.';
  @override
  bool get isRetryable => false;
}

class TmdbInvalidKeyError extends TmdbError {
  const TmdbInvalidKeyError();
  @override
  String get userMessage =>
      'Your TMDB API key was rejected. Open Settings to update it.';
  @override
  bool get isRetryable => false;
}

class TmdbNoNetworkError extends TmdbError {
  const TmdbNoNetworkError();
  @override
  String get userMessage =>
      'No internet connection. Check your network and try again.';
  @override
  bool get isRetryable => true;
}

class TmdbTimeoutError extends TmdbError {
  const TmdbTimeoutError();
  @override
  String get userMessage => 'The request timed out. Try again.';
  @override
  bool get isRetryable => true;
}

class TmdbNotFoundError extends TmdbError {
  const TmdbNotFoundError();
  @override
  String get userMessage => 'We couldn\'t find this title on TMDB.';
  @override
  bool get isRetryable => false;
}

class TmdbRateLimitError extends TmdbError {
  const TmdbRateLimitError();
  @override
  String get userMessage =>
      'Too many requests. Please wait a moment and try again.';
  @override
  bool get isRetryable => true;
}

class TmdbServerError extends TmdbError {
  const TmdbServerError(this.statusCode);
  final int statusCode;
  @override
  String get userMessage =>
      'TMDB is having trouble (server error $statusCode). Try again shortly.';
  @override
  bool get isRetryable => true;
}

class TmdbMalformedResponseError extends TmdbError {
  const TmdbMalformedResponseError();
  @override
  String get userMessage =>
      'TMDB returned an unexpected response. Please try again.';
  @override
  bool get isRetryable => true;
}

class TmdbCancelledError extends TmdbError {
  const TmdbCancelledError();
  @override
  String get userMessage => 'Request cancelled.';
  @override
  bool get isRetryable => true;
}

class TmdbUnknownError extends TmdbError {
  const TmdbUnknownError(this.detail);
  final String detail;
  @override
  String get userMessage => 'Something went wrong. Please try again.';
  @override
  bool get isRetryable => true;
}
