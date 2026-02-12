import 'package:dat_san_247_mobile/config/env/env_dev.dart';
import 'package:dat_san_247_mobile/config/env/env_prod.dart';
import 'package:dat_san_247_mobile/config/env/env_stg.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';

/// 🌍 Các môi trường hỗ trợ
enum Environment { development, staging, production }

/// 🔧 Quản lý cấu hình môi trường (Singleton Pattern)
///
/// Sử dụng:
/// ```dart
/// // Trong main_dev.dart
/// void main() => mainCommon(Environment.development);
///
/// // Trong app
/// if (EnvironmentConfig.isDev) { ... }
/// final url = EnvironmentConfig.apiBaseUrl;
/// ```
class EnvironmentConfig {
  EnvironmentConfig._();

  static Environment? _current;
  static bool _isLocked = false;

  /// ✅ Thiết lập môi trường (chỉ gọi 1 lần trong main)
  static void setEnvironment(Environment env) {
    assert(!_isLocked, '⛔ Environment đã được set rồi, không thể thay đổi!');
    _current = env;
    _isLocked = true;
  }

  /// 🌍 Lấy môi trường hiện tại
  static Environment get environment {
    assert(_current != null, '⛔ Chưa gọi setEnvironment()!');
    return _current!;
  }

  // ════════════════════════════════════════════════════════════════
  // ENVIRONMENT CHECKS
  // ════════════════════════════════════════════════════════════════
  static bool get isDev => _current == Environment.development;
  static bool get isStaging => _current == Environment.staging;
  static bool get isProduction => _current == Environment.production;
  static bool get enableCrashReporting => isProduction || isStaging;

  // ════════════════════════════════════════════════════════════════
  // API CONFIGURATION (Từ Envied - Obfuscated & Compile-time safe)
  // ════════════════════════════════════════════════════════════════
  static String get apiBaseUrl => switch (_current!) {
    Environment.development => EnvDev.apiBaseUrl,
    Environment.staging => EnvStg.apiBaseUrl,
    Environment.production => EnvProd.apiBaseUrl,
  };

  static String get webSocketUrl => switch (_current!) {
    Environment.development => EnvDev.wsUrl,
    Environment.staging => EnvStg.wsUrl,
    Environment.production => EnvProd.wsUrl,
  };

  // ════════════════════════════════════════════════════════════════
  // FEATURE FLAGS
  // ════════════════════════════════════════════════════════════════
  static bool get enableLogging => switch (_current!) {
    Environment.development => EnvDev.enableLogging,
    Environment.staging => EnvStg.enableLogging,
    Environment.production => EnvProd.enableLogging,
  };

  static bool get enableDebugTools => switch (_current!) {
    Environment.development => EnvDev.enableDebugTools,
    Environment.staging => EnvStg.enableDebugTools,
    Environment.production => EnvProd.enableDebugTools,
  };

  static bool get enableAnalytics => switch (_current!) {
    Environment.development => EnvDev.enableAnalytics,
    Environment.staging => EnvStg.enableAnalytics,
    Environment.production => EnvProd.enableAnalytics,
  };

  // ════════════════════════════════════════════════════════════════
  // TIMEOUTS
  // ════════════════════════════════════════════════════════════════
  static Duration get connectTimeout => Duration(
    seconds: switch (_current!) {
      Environment.development => EnvDev.connectTimeout,
      Environment.staging => EnvStg.connectTimeout,
      Environment.production => EnvProd.connectTimeout,
    },
  );

  static Duration get receiveTimeout => Duration(
    seconds: switch (_current!) {
      Environment.development => EnvDev.receiveTimeout,
      Environment.staging => EnvStg.receiveTimeout,
      Environment.production => EnvProd.receiveTimeout,
    },
  );

  // ════════════════════════════════════════════════════════════════
  // API KEYS (Obfuscated by Envied)
  // ════════════════════════════════════════════════════════════════
  static String get googleMapsApiKey => switch (_current!) {
    Environment.development => EnvDev.googleMapsApiKey,
    Environment.staging => EnvStg.googleMapsApiKey,
    Environment.production => EnvProd.googleMapsApiKey,
  };

  static String get stripePublicKey => switch (_current!) {
    Environment.development => EnvDev.stripePublicKey,
    Environment.staging => EnvStg.stripePublicKey,
    Environment.production => EnvProd.stripePublicKey,
  };

  // ════════════════════════════════════════════════════════════════
  // DEBUG INFO
  // ════════════════════════════════════════════════════════════════
  static void printInfo() {
    if (_current == null) {
      Logger.warning('Environment chưa được set!', tag: 'ENV');
      return;
    }

    const borderWidth = 55;
    String pad(String text) => text.padRight(borderWidth - 4);

    final info = [
      '🌍 ENVIRONMENT INFO',
      'Environment: ${_current!.name.toUpperCase()}',
      'API Base URL: $apiBaseUrl',
      'WebSocket URL: $webSocketUrl',
      'Logging: ${enableLogging ? "✅" : "❌"}',
      'Debug Tools: ${enableDebugTools ? "✅" : "❌"}',
      'Analytics: ${enableAnalytics ? "✅" : "❌"}',
      'Crash Reporting: ${enableCrashReporting ? "✅" : "❌"}',
    ];

    final buffer = StringBuffer()..writeln('╔${'═' * (borderWidth - 1)}╗');

    for (int i = 0; i < info.length; i++) {
      final line = info[i];
      buffer.writeln('║ ${pad(line)} ║');
      if (i == 0) {
        buffer.writeln('╠${'═' * (borderWidth - 1)}╣');
      }
    }

    buffer.writeln('╚${'═' * (borderWidth - 1)}╝');

    Logger.info('\n${buffer.toString()}', tag: 'ENV');
  }
}
