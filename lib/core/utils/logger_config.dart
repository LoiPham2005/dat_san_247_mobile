import 'package:flutter_base_template/core/config/environment_config.dart';
import 'package:flutter_base_template/core/utils/logger.dart';

class LoggerConfig {
  static void configure() {
    if (EnvironmentConfig.isDev) {
      _configureDevelopment();
    } else if (EnvironmentConfig.isStaging) {
      _configureStaging();
    } else {
      _configureProduction();
    }
  }

  static void _configureDevelopment() {
    // HTTP
    LogConfig.enableHttpLogs = true;
    LogConfig.logOnlyFailedRequests = false;
    LogConfig.logRequestBody = true;
    LogConfig.logResponseBody = true;
    LogConfig.maxBodyLength = 2000;

    // BLoC
    LogConfig.enableBlocLogs = true;
    LogConfig.logAllStateChanges = false;

    // Errors
    LogConfig.enableErrorLogs = true;
    LogConfig.enableDetailedErrors = true;
    LogConfig.maxStackTraceLines = 5;
    LogConfig.sendErrorsToCrashReporting = false;

    // General
    LogConfig.enableSuccessLogs = true;
    LogConfig.enableInfoLogs = true;
    LogConfig.enableDebugLogs = true;
    LogConfig.enableWarningLogs = true;

    // Security
    LogConfig.maskSensitiveData = false;
  }

  static void _configureStaging() {
    // HTTP
    LogConfig.enableHttpLogs = true;
    LogConfig.logOnlyFailedRequests = true;
    LogConfig.logRequestBody = true;
    LogConfig.logResponseBody = true;
    LogConfig.maxBodyLength = 1000;

    // BLoC
    LogConfig.enableBlocLogs = false;
    LogConfig.logAllStateChanges = false;

    // Errors
    LogConfig.enableErrorLogs = true;
    LogConfig.enableDetailedErrors = true;
    LogConfig.maxStackTraceLines = 3;
    LogConfig.sendErrorsToCrashReporting = true;

    // General
    LogConfig.enableSuccessLogs = false;
    LogConfig.enableInfoLogs = false;
    LogConfig.enableDebugLogs = false;
    LogConfig.enableWarningLogs = true;

    // Security
    LogConfig.maskSensitiveData = true;
  }

  static void _configureProduction() {
    // HTTP
    LogConfig.enableHttpLogs = false;
    LogConfig.logOnlyFailedRequests = false;
    LogConfig.logRequestBody = false;
    LogConfig.logResponseBody = false;
    LogConfig.maxBodyLength = 500;

    // BLoC
    LogConfig.enableBlocLogs = false;
    LogConfig.logAllStateChanges = false;

    // Errors
    LogConfig.enableErrorLogs = true;
    LogConfig.enableDetailedErrors = false;
    LogConfig.maxStackTraceLines = 0;
    LogConfig.sendErrorsToCrashReporting = true;

    // General
    LogConfig.enableSuccessLogs = false;
    LogConfig.enableInfoLogs = false;
    LogConfig.enableDebugLogs = false;
    LogConfig.enableWarningLogs = false;

    // Security
    LogConfig.maskSensitiveData = true;
  }
}