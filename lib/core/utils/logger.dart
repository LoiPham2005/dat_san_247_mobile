// ════════════════════════════════════════════════════════════════
// 📁 lib/core/utils/logger.dart (ENHANCED)
// ════════════════════════════════════════════════════════════════
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Global configuration for logging behavior
class LogConfig {
  // ═══════════════════════════════════════════════════════════════
  // HTTP LOGGING
  // ═══════════════════════════════════════════════════════════════
  
  /// Enable HTTP request/response logging
  static bool enableHttpLogs = kDebugMode;
  
  /// Only log failed HTTP requests (4xx, 5xx)
  static bool logOnlyFailedRequests = !kDebugMode;
  
  /// Log HTTP request body
  static bool logRequestBody = kDebugMode;
  
  /// Log HTTP response body
  static bool logResponseBody = kDebugMode;
  
  /// Maximum body length to log (prevent huge logs)
  static int maxBodyLength = 1000;

  // ═══════════════════════════════════════════════════════════════
  // BLOC LOGGING
  // ═══════════════════════════════════════════════════════════════
  
  /// Enable BLoC event/state logging
  static bool enableBlocLogs = kDebugMode;
  
  /// Log all state changes (false = only log status changes)
  static bool logAllStateChanges = false;

  // ═══════════════════════════════════════════════════════════════
  // ERROR LOGGING
  // ═══════════════════════════════════════════════════════════════
  
  /// Enable error logging (should always be true)
  static bool enableErrorLogs = true;
  
  /// Show detailed stack traces
  static bool enableDetailedErrors = kDebugMode;
  
  /// Maximum stack trace lines to show
  static int maxStackTraceLines = 5;
  
  /// Send errors to crash reporting (Firebase, Sentry, etc.)
  static bool sendErrorsToCrashReporting = kReleaseMode;

  // ═══════════════════════════════════════════════════════════════
  // GENERAL LOGGING
  // ═══════════════════════════════════════════════════════════════
  
  /// Enable success logs (✅)
  static bool enableSuccessLogs = false;
  
  /// Enable info logs (ℹ️)
  static bool enableInfoLogs = kDebugMode;
  
  /// Enable debug logs (🐛)
  static bool enableDebugLogs = kDebugMode;
  
  /// Enable warning logs (⚠️)
  static bool enableWarningLogs = true;

  // ═══════════════════════════════════════════════════════════════
  // SECURITY
  // ═══════════════════════════════════════════════════════════════
  
  /// Mask sensitive fields in logs (password, token, etc.)
  static bool maskSensitiveData = !kDebugMode;
  
  /// List of sensitive field names to mask
  static final Set<String> sensitiveFields = {
    'password',
    'token',
    'access_token',
    'refresh_token',
    'secret',
    'api_key',
    'apikey',
    'authorization',
    'auth',
    'pin',
    'otp',
    'cvv',
    'card_number',
  };
}

/// Centralized logger with clean formatting
class Logger {
  Logger._();
  
  static const _prefix = '[APP]';
  static const _defaultWidth = 60;

  // Box drawing characters
  static const _horizontalLine = '═';
  static const _horizontalDivider = '─';
  static const _topLeft = '╔';
  static const _topRight = '╗';
  static const _bottomLeft = '╚';
  static const _bottomRight = '╝';
  static const _middleLeft = '╠';
  static const _middleRight = '╣';
  static const _vertical = '║';

  // Border helpers
  static String get _borderLine => _horizontalLine * _defaultWidth;
  static String get _dividerLine => _horizontalDivider * _defaultWidth;
  static String get _topBorder => '$_topLeft$_borderLine$_topRight';
  static String get _middleBorder => '$_middleLeft$_borderLine$_middleRight';
  static String get _bottomBorder => '$_bottomLeft$_borderLine$_bottomRight';
  static String get _sectionDivider => '$_middleLeft$_dividerLine$_middleRight';

  // ═══════════════════════════════════════════════════════════════
  // GENERAL LOGS
  // ═══════════════════════════════════════════════════════════════

  static void info(String message, {String? tag}) {
    if (!LogConfig.enableInfoLogs) return;
    final tagStr = tag != null ? '[$tag] ' : '';
    developer.log('ℹ️ $tagStr$message', name: _prefix);
  }

  static void warning(String message, {String? tag}) {
    if (!LogConfig.enableWarningLogs) return;
    final tagStr = tag != null ? '[$tag] ' : '';
    developer.log('⚠️ $tagStr$message', name: _prefix);
  }

  static void success(String message, {String? tag}) {
    if (!LogConfig.enableSuccessLogs) return;
    final tagStr = tag != null ? '[$tag] ' : '';
    developer.log('✅ $tagStr$message', name: _prefix);
  }

  static void debug(String message, {String? tag}) {
    if (!LogConfig.enableDebugLogs) return;
    final tagStr = tag != null ? '[$tag] ' : '';
    developer.log('🐛 $tagStr$message', name: _prefix);
  }

  // ═══════════════════════════════════════════════════════════════
  // ERROR LOGS
  // ═══════════════════════════════════════════════════════════════

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extras,
  }) {
    if (!LogConfig.enableErrorLogs) return;

    final buffer = StringBuffer();
    final tagStr = tag != null ? '[$tag] ' : '';

    buffer.writeln(_topBorder);
    buffer.writeln('$_vertical ❌ ERROR $tagStr');
    buffer.writeln(_middleBorder);
    buffer.writeln('$_vertical $message');

    if (error != null) {
      buffer.writeln(_sectionDivider);
      buffer.writeln('$_vertical Details: ${error.toString()}');
    }

    if (extras != null && extras.isNotEmpty) {
      buffer.writeln(_sectionDivider);
      buffer.writeln('$_vertical Context:');
      extras.forEach((key, value) {
        buffer.writeln('$_vertical   $key: $value');
      });
    }

    if (LogConfig.enableDetailedErrors && stackTrace != null) {
      buffer.writeln(_sectionDivider);
      buffer.writeln('$_vertical Stack Trace:');
      final lines = stackTrace
          .toString()
          .split('\n')
          .take(LogConfig.maxStackTraceLines);
      for (final line in lines) {
        buffer.writeln('$_vertical   $line');
      }
    }

    buffer.writeln(_bottomBorder);
    developer.log(buffer.toString(), name: _prefix, level: 1000);

    // Send to crash reporting in production
    if (LogConfig.sendErrorsToCrashReporting) {
      _sendToCrashReporting(message, error, stackTrace, extras);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // HTTP LOGS
  // ═══════════════════════════════════════════════════════════════

  static void httpRequest(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    dynamic data,
  }) {
    if (!LogConfig.enableHttpLogs) return;

    final buffer = StringBuffer();
    final uri = Uri.parse(url);

    buffer.writeln(_topBorder);
    buffer.writeln('$_vertical 🚀 REQUEST: $method');
    buffer.writeln(_middleBorder);
    buffer.writeln('$_vertical Domain: ${uri.host}');
    buffer.writeln('$_vertical Endpoint: ${uri.path}');

    if (uri.queryParameters.isNotEmpty) {
      buffer.writeln('$_vertical Query: ${uri.queryParameters}');
    }

    if (headers != null && headers.isNotEmpty && kDebugMode) {
      buffer.writeln(_sectionDivider);
      buffer.writeln('$_vertical 📋 Headers:');
      headers.forEach((key, value) {
        final maskedValue = _maskIfSensitive(key, value?.toString() ?? '');
        buffer.writeln('$_vertical   $key: $maskedValue');
      });
    }

    if (data != null && 
        LogConfig.logRequestBody && 
        ['POST', 'PUT', 'PATCH'].contains(method)) {
      buffer.writeln(_sectionDivider);
      buffer.writeln('$_vertical 📦 Body:');
      final bodyStr = _formatRequestBody(data);
      for (final line in bodyStr.split('\n')) {
        buffer.writeln('$_vertical   $line');
      }
    }

    buffer.writeln(_bottomBorder);
    developer.log(buffer.toString(), name: _prefix);
  }

  static void httpResponse(
    String method,
    String url,
    int statusCode, {
    dynamic data,
    Duration? duration,
  }) {
    // Only log if enabled and not filtering failed requests
    if (!LogConfig.enableHttpLogs) return;
    
    final isSuccess = statusCode >= 200 && statusCode < 300;
    if (LogConfig.logOnlyFailedRequests && isSuccess) return;

    final buffer = StringBuffer();
    final uri = Uri.parse(url);
    final statusEmoji = isSuccess ? '✅' : '⚠️';
    final durationStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';

    buffer.writeln(_topBorder);
    buffer.writeln('$_vertical $statusEmoji RESPONSE: $statusCode$durationStr');
    buffer.writeln(_middleBorder);
    buffer.writeln('$_vertical $method ${uri.path}');

    if (data != null && LogConfig.logResponseBody) {
      buffer.writeln(_sectionDivider);
      buffer.writeln('$_vertical 📥 Response Data:');

      final formattedData = _formatResponseData(data);
      for (final line in formattedData.split('\n')) {
        buffer.writeln('$_vertical   $line');
      }
    }

    buffer.writeln(_bottomBorder);
    developer.log(buffer.toString(), name: _prefix);
  }

  static void httpError(
    String method,
    String url,
    int? statusCode,
    dynamic errorData, {
    Duration? duration,
  }) {
    final buffer = StringBuffer();
    final durationStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';

    buffer.writeln(_topBorder);
    buffer.writeln('$_vertical ❌ HTTP ERROR [$statusCode]$durationStr');
    buffer.writeln(_middleBorder);
    buffer.writeln('$_vertical $method $url');

    if (errorData != null) {
      buffer.writeln(_sectionDivider);
      buffer.writeln('$_vertical Response: ${_formatJson(errorData)}');
    }

    buffer.writeln(_bottomBorder);
    developer.log(buffer.toString(), name: _prefix, level: 900);

    // Send to crash reporting
    if (LogConfig.sendErrorsToCrashReporting && statusCode != null && statusCode >= 500) {
      _sendToCrashReporting(
        'HTTP Error $statusCode: $method $url',
        errorData,
        null,
        {'statusCode': statusCode, 'method': method, 'url': url},
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // BLOC LOGS
  // ═══════════════════════════════════════════════════════════════

  static void blocEvent(String blocName, Object event) {
    if (!LogConfig.enableBlocLogs) return;
    developer.log('📤 [$blocName] ${event.runtimeType}', name: _prefix);
  }

  static void blocState(
    String blocName,
    dynamic currentState,
    dynamic nextState,
  ) {
    if (!LogConfig.enableBlocLogs) return;

    if (LogConfig.logAllStateChanges) {
      developer.log(
        '📥 [$blocName] ${currentState.runtimeType} → ${nextState.runtimeType}',
        name: _prefix,
      );
    } else {
      // Only log status changes
      final current = _extractStatus(currentState);
      final next = _extractStatus(nextState);
      if (current != next) {
        developer.log('📥 [$blocName] $current → $next', name: _prefix);
      }
    }
  }

  static void blocError(String blocName, Object error, StackTrace stackTrace) {
    final buffer = StringBuffer();

    buffer.writeln(_topBorder);
    buffer.writeln('$_vertical ❌ BLOC ERROR [$blocName]');
    buffer.writeln(_middleBorder);
    buffer.writeln('$_vertical ${error.toString()}');

    if (LogConfig.enableDetailedErrors) {
      buffer.writeln(_sectionDivider);
      final lines = stackTrace
          .toString()
          .split('\n')
          .take(LogConfig.maxStackTraceLines);
      for (final line in lines) {
        buffer.writeln('$_vertical $line');
      }
    }

    buffer.writeln(_bottomBorder);
    developer.log(buffer.toString(), name: _prefix, level: 1000);

    // Send to crash reporting
    if (LogConfig.sendErrorsToCrashReporting) {
      _sendToCrashReporting(
        'BLoC Error in $blocName',
        error,
        stackTrace,
        {'bloc': blocName},
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  static String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String _formatJson(dynamic data) {
    if (data is Map) {
      final message = data['message'] ?? data['error'] ?? '';
      if (message.isNotEmpty) return message.toString();
    }
    return _truncate(data.toString(), 200);
  }

  static String _formatRequestBody(dynamic data) {
    if (data == null) return 'null';

    if (data is Map) {
      final buffer = StringBuffer();
      data.forEach((key, value) {
        final maskedValue = _maskIfSensitive(
          key.toString(),
          value?.toString() ?? 'null',
        );
        buffer.writeln('$key: $maskedValue');
      });
      return buffer.toString().trim();
    }

    return _truncate(data.toString(), LogConfig.maxBodyLength);
  }

  static String _formatResponseData(dynamic data) {
    if (data == null) return 'null';

    try {
      const encoder = JsonEncoder.withIndent('  ');
      var jsonStr = encoder.convert(data);
      
      // Truncate if too long
      if (jsonStr.length > LogConfig.maxBodyLength) {
        jsonStr = '${jsonStr.substring(0, LogConfig.maxBodyLength)}\n... (truncated)';
      }
      
      return jsonStr;
    } catch (e) {
      return _truncate(data.toString(), LogConfig.maxBodyLength);
    }
  }

  static String _maskIfSensitive(String key, String value) {
    if (!LogConfig.maskSensitiveData) return value;
    
    final lowerKey = key.toLowerCase();
    final isSensitive = LogConfig.sensitiveFields.any(
      (field) => lowerKey.contains(field),
    );
    
    return isSensitive ? '******' : value;
  }

  static String _extractStatus(dynamic state) {
    if (state == null) return 'null';
    final str = state.toString();

    final statusMatch = RegExp(r'status:\s*BlocStatus\.(\w+)').firstMatch(str);
    if (statusMatch != null) {
      return statusMatch.group(1) ?? 'unknown';
    }

    return state.runtimeType.toString();
  }

  static void _sendToCrashReporting(
    String message,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extras,
  ) {
    // TODO: Implement crash reporting integration
    // Examples:
    // - Firebase Crashlytics: FirebaseCrashlytics.instance.recordError(error, stackTrace)
    // - Sentry: Sentry.captureException(error, stackTrace: stackTrace)
    
    if (kDebugMode) {
      developer.log(
        '📡 Would send to crash reporting: $message',
        name: _prefix,
      );
    }
  }
}