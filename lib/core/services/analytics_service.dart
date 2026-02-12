// ════════════════════════════════════════════════════════════════
// 📁 lib/core/services/analytics_service.dart
// ════════════════════════════════════════════════════════════════

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:dat_san_247_mobile/config/environment_config.dart';
import 'package:injectable/injectable.dart';

import '../utils/logger.dart';

/// 📊 Firebase Analytics Service - Tracks all app events
@LazySingleton()
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver? _observer;

  /// Get analytics observer for navigation tracking
  FirebaseAnalyticsObserver get observer {
    _observer ??= FirebaseAnalyticsObserver(analytics: _analytics);
    return _observer!;
  }

  // ═══════════════════════════════════════════════════════════════
  // USER PROPERTIES
  // ═══════════════════════════════════════════════════════════════

  /// Set user ID for tracking
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      Logger.info('👤 User ID set: $userId', tag: 'ANALYTICS');
    } catch (e) {
      Logger.error('Failed to set user ID', error: e, tag: 'ANALYTICS');
    }
  }

  /// Set user properties
  Future<void> setUserProperty({required String name, required String? value}) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      Logger.info('👤 User property set: $name = $value', tag: 'ANALYTICS');
    } catch (e) {
      Logger.error('Failed to set user property', error: e, tag: 'ANALYTICS');
    }
  }

  /// Set user demographics
  Future<void> setUserDemographics({
    String? age,
    String? gender,
    String? country,
    String? language,
  }) async {
    if (age != null) await setUserProperty(name: 'age', value: age);
    if (gender != null) await setUserProperty(name: 'gender', value: gender);
    if (country != null) await setUserProperty(name: 'country', value: country);
    if (language != null) await setUserProperty(name: 'language', value: language);
  }

  // ═══════════════════════════════════════════════════════════════
  // SCREEN TRACKING
  // ═══════════════════════════════════════════════════════════════

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );

      if (parameters != null && parameters.isNotEmpty) {
        await logEvent(
          name: 'screen_view_detailed',
          parameters: {
            'screen_name': screenName,
            'screen_class': screenClass ?? screenName,
            ...parameters,
          },
        );
      }

      if (kDebugMode) {
        Logger.info('📱 Screen: $screenName', tag: 'ANALYTICS');
      }
    } catch (e) {
      Logger.error('Failed to log screen view', error: e, tag: 'ANALYTICS');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CUSTOM EVENTS
  // ═══════════════════════════════════════════════════════════════

  /// Log custom event
  Future<void> logEvent({required String name, Map<String, dynamic>? parameters}) async {
    try {
      // Sanitize event name (Firebase requirements)
      final sanitizedName = _sanitizeEventName(name);

      // Sanitize parameters
      final sanitizedParams = _sanitizeParameters(parameters);

      await _analytics.logEvent(name: sanitizedName, parameters: sanitizedParams);

      if (kDebugMode) {
        Logger.info(
          '📊 Event: $sanitizedName ${sanitizedParams != null ? sanitizedParams.toString() : ""}',
          tag: 'ANALYTICS',
        );
      }
    } catch (e) {
      Logger.error('Failed to log event: $name', error: e, tag: 'ANALYTICS');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // APP LIFECYCLE EVENTS
  // ═══════════════════════════════════════════════════════════════

  /// Log app open
  Future<void> logAppOpen() async {
    await logEvent(
      name: 'app_open',
      parameters: {
        'environment': EnvironmentConfig.environment.name,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Log app background
  Future<void> logAppBackground() async {
    await logEvent(name: 'app_background');
  }

  /// Log app resume
  Future<void> logAppResume() async {
    await logEvent(name: 'app_resume');
  }

  // ═══════════════════════════════════════════════════════════════
  // BUSINESS EVENTS
  // ═══════════════════════════════════════════════════════════════

  /// Log purchase event
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    String? itemName,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logPurchase(
      currency: currency,
      value: value,
      transactionId: transactionId,
      parameters: {if (itemName != null) 'item_name': itemName, ...?parameters},
    );
  }

  /// Log in-app purchase
  Future<void> logInAppPurchase({
    required String productId,
    required String productName,
    required double price,
    required String currency,
  }) async {
    await logEvent(
      name: 'in_app_purchase',
      parameters: {
        'product_id': productId,
        'product_name': productName,
        'price': price,
        'currency': currency,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // USER ENGAGEMENT
  // ═══════════════════════════════════════════════════════════════

  /// Log button click
  Future<void> logButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? parameters,
  }) async {
    await logEvent(
      name: 'button_click',
      parameters: {
        'button_name': buttonName,
        if (screenName != null) 'screen_name': screenName,
        ...?parameters,
      },
    );
  }

  /// Log feature usage
  Future<void> logFeatureUsage({
    required String featureName,
    Map<String, dynamic>? parameters,
  }) async {
    await logEvent(
      name: 'feature_usage',
      parameters: {'feature_name': featureName, ...?parameters},
    );
  }

  /// Log search
  Future<void> logSearch({required String searchTerm, String? category}) async {
    await _analytics.logSearch(
      searchTerm: searchTerm,
      parameters: category != null ? {'category': category} : null,
    );
  }

  /// Log share
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    await _analytics.logShare(contentType: contentType, itemId: itemId, method: method ?? '');
  }

  // ═══════════════════════════════════════════════════════════════
  // ERRORS & EXCEPTIONS
  // ═══════════════════════════════════════════════════════════════

  /// Log error event
  Future<void> logError({
    required String errorName,
    String? errorMessage,
    String? stackTrace,
    Map<String, dynamic>? parameters,
  }) async {
    await logEvent(
      name: 'app_error',
      parameters: {
        'error_name': errorName,
        if (errorMessage != null) 'error_message': errorMessage,
        if (stackTrace != null && stackTrace.isNotEmpty)
          'stack_trace': stackTrace.length > 100 ? stackTrace.substring(0, 100) : stackTrace,
        ...?parameters,
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════════

  /// Sanitize event name to meet Firebase requirements
  /// - Must be <= 40 characters
  /// - Can only contain alphanumeric and underscores
  /// - Must start with a letter
  String _sanitizeEventName(String name) {
    // Convert to lowercase and replace spaces/special chars with underscores
    var sanitized = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');

    // Ensure starts with a letter
    if (!RegExp(r'^[a-z]').hasMatch(sanitized)) {
      sanitized = 'event_$sanitized';
    }

    // Trim to 40 characters
    if (sanitized.length > 40) {
      sanitized = sanitized.substring(0, 40);
    }

    return sanitized;
  }

  /// Sanitize parameters to meet Firebase requirements
  /// - Max 25 parameters
  /// - Parameter names must be <= 40 characters
  /// - String values must be <= 100 characters
  Map<String, Object>? _sanitizeParameters(Map<String, dynamic>? parameters) {
    if (parameters == null || parameters.isEmpty) return null;

    final sanitized = <String, Object>{};

    var count = 0;
    for (var entry in parameters.entries) {
      if (count >= 25) break; // Max 25 parameters

      // Sanitize key
      var key = entry.key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
      if (key.length > 40) key = key.substring(0, 40);

      // Sanitize value
      final value = entry.value;
      if (value == null) continue;

      Object sanitizedValue;
      if (value is String) {
        sanitizedValue = value.length > 100 ? value.substring(0, 100) : value;
      } else if (value is num || value is bool) {
        sanitizedValue = value;
      } else {
        final stringValue = value.toString();
        sanitizedValue = stringValue.length > 100 ? stringValue.substring(0, 100) : stringValue;
      }

      sanitized[key] = sanitizedValue;
      count++;
    }

    return sanitized.isEmpty ? null : sanitized;
  }

  /// Reset analytics data (useful for testing)
  Future<void> resetAnalyticsData() async {
    try {
      await _analytics.resetAnalyticsData();
      Logger.info('🔄 Analytics data reset', tag: 'ANALYTICS');
    } catch (e) {
      Logger.error('Failed to reset analytics', error: e, tag: 'ANALYTICS');
    }
  }

  /// Set analytics collection enabled/disabled
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
      Logger.info('📊 Analytics collection ${enabled ? "enabled" : "disabled"}', tag: 'ANALYTICS');
    } catch (e) {
      Logger.error('Failed to set analytics collection', error: e, tag: 'ANALYTICS');
    }
  }
}
