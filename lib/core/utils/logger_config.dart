// ════════════════════════════════════════════════════════════════
// 📁 lib/core/config/logger_config.dart
// ════════════════════════════════════════════════════════════════

import 'package:dat_san_247_mobile/core/config/environment_config.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';

class LoggerConfig {
  static void configure() {
    if (EnvironmentConfig.isDev) {
      _dev();
    } else if (EnvironmentConfig.isStaging) {
      _staging();
    } else {
      _production();
    }
  }

  static void _dev() {
    LogConfig.enabled = true;
    LogConfig.showHttp = true;
    LogConfig.showBloc = true;
    LogConfig.maskSensitive = false;
    LogConfig.crashReporting = false;
  }

  static void _staging() {
    LogConfig.enabled = true;
    LogConfig.showHttp = true;
    LogConfig.showBloc = false;
    LogConfig.maskSensitive = true;
    LogConfig.crashReporting = true;
  }

  static void _production() {
    LogConfig.enabled = false;
    LogConfig.showHttp = false;
    LogConfig.showBloc = false;
    LogConfig.maskSensitive = true;
    LogConfig.crashReporting = true;
  }
}

// ════════════════════════════════════════════════════════════════
// 📘 USAGE EXAMPLES
// ════════════════════════════════════════════════════════════════

/*

void main() {
  // Configure logger theo environment
  LoggerConfig.configure();

  runApp(MyApp());
}

// Basic logs
Logger.info('App started');
Logger.success('Login successful');
Logger.warning('Token expiring soon');
Logger.debug('Cache hit: user_123');

// Error log
Logger.error(
  'Failed to load users',
  error: exception,
  stackTrace: stackTrace,
);

// HTTP logs (tự động gọi từ Dio interceptor)
Logger.httpRequest('POST', '/api/login', data: {'email': 'user@test.com'});
Logger.httpResponse('POST', '/api/login', 200, duration: Duration(milliseconds: 234));

// BLoC logs (tự động gọi từ BlocObserver)
Logger.blocEvent('AuthBloc', LoginEvent());
Logger.blocState('AuthBloc', prevState, nextState);
Logger.blocError('AuthBloc', error, stackTrace);

*/
