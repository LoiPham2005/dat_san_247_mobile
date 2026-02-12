// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/services/ad_analytics_tracker.dart
// ════════════════════════════════════════════════════════════════

import 'package:injectable/injectable.dart';

import '../../services/analytics_service.dart';
import '../../utils/logger.dart';
import '../domain/ad_placement.dart';

/// 📊 Ad Analytics Tracker - Specialized tracking for ad events
@LazySingleton()
class AdAnalyticsTracker {
  AdAnalyticsTracker(this._analytics);

  final AnalyticsService _analytics;

  // Track loading attempts and durations
  final Map<String, DateTime> _loadStartTimes = {};
  final Map<String, int> _loadAttempts = {};
  final Map<String, int> _loadFailures = {};

  // Track show history
  final Map<String, int> _impressionCounts = {};
  final Map<String, int> _clickCounts = {};
  final Map<String, int> _dismissCounts = {};

  // Track revenue (for rewarded ads)
  final Map<String, double> _revenueEstimates = {};

  // ═══════════════════════════════════════════════════════════════
  // AD LOADING EVENTS
  // ═══════════════════════════════════════════════════════════════

  /// Track ad load start
  void trackAdLoadStart(AdPlacement placement) {
    _loadStartTimes[placement.key] = DateTime.now();
    _loadAttempts[placement.key] = (_loadAttempts[placement.key] ?? 0) + 1;

    Logger.info('📥 Ad load started: ${placement.key}', tag: 'AD_ANALYTICS');
  }

  /// Track ad load success
  Future<void> trackAdLoadSuccess(
    AdPlacement placement, {
    Map<String, dynamic>? additionalParams,
  }) async {
    final startTime = _loadStartTimes[placement.key];
    final loadDuration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;

    await _analytics.logEvent(
      name: 'ad_load_success',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'placement_id': placement.key,
        if (loadDuration != null) 'load_duration_ms': loadDuration,
        'load_attempts': _loadAttempts[placement.key] ?? 1,
        'total_failures': _loadFailures[placement.key] ?? 0,
        ...?additionalParams,
      },
    );

    // Reset counters
    _loadAttempts[placement.key] = 0;
    _loadStartTimes.remove(placement.key);

    Logger.success('✅ Ad loaded: ${placement.key} in ${loadDuration}ms', tag: 'AD_ANALYTICS');
  }

  /// Track ad load failure
  Future<void> trackAdLoadFailure(
    AdPlacement placement, {
    required String errorCode,
    String? errorMessage,
    int? retryCount,
    Map<String, dynamic>? additionalParams,
  }) async {
    _loadFailures[placement.key] = (_loadFailures[placement.key] ?? 0) + 1;

    final startTime = _loadStartTimes[placement.key];
    final loadDuration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;

    await _analytics.logEvent(
      name: 'ad_load_failure',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'placement_id': placement.key,
        'error_code': errorCode,
        if (errorMessage != null) 'error_message': errorMessage,
        if (loadDuration != null) 'load_duration_ms': loadDuration,
        'load_attempts': _loadAttempts[placement.key] ?? 1,
        'total_failures': _loadFailures[placement.key] ?? 1,
        if (retryCount != null) 'retry_count': retryCount,
        ...?additionalParams,
      },
    );

    Logger.error('❌ Ad load failed: ${placement.key} - $errorCode', tag: 'AD_ANALYTICS');
  }

  // ═══════════════════════════════════════════════════════════════
  // AD IMPRESSION EVENTS
  // ═══════════════════════════════════════════════════════════════

  /// Track ad impression (when ad is shown to user)
  Future<void> trackAdImpression(
    AdPlacement placement, {
    double? estimatedRevenue,
    String? currency,
    Map<String, dynamic>? additionalParams,
  }) async {
    _impressionCounts[placement.key] = (_impressionCounts[placement.key] ?? 0) + 1;

    if (estimatedRevenue != null) {
      _revenueEstimates[placement.key] =
          (_revenueEstimates[placement.key] ?? 0.0) + estimatedRevenue;
    }

    await _analytics.logEvent(
      name: 'ad_impression',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'placement_id': placement.key,
        'impression_count': _impressionCounts[placement.key],
        if (estimatedRevenue != null) 'estimated_revenue': estimatedRevenue,
        if (currency != null) 'currency': currency,
        'session_timestamp': DateTime.now().toIso8601String(),
        ...?additionalParams,
      },
    );

    // Log to Firebase as ad_impression (predefined event)
    await _analytics.logEvent(name: 'ad_exposure', parameters: {'firebase_screen': placement.key});

    Logger.info(
      '👁️ Ad impression: ${placement.key} (count: ${_impressionCounts[placement.key]})',
      tag: 'AD_ANALYTICS',
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // AD INTERACTION EVENTS
  // ═══════════════════════════════════════════════════════════════

  /// Track ad click
  Future<void> trackAdClick(AdPlacement placement, {Map<String, dynamic>? additionalParams}) async {
    _clickCounts[placement.key] = (_clickCounts[placement.key] ?? 0) + 1;

    await _analytics.logEvent(
      name: 'ad_click',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'placement_id': placement.key,
        'click_count': _clickCounts[placement.key],
        'impression_count': _impressionCounts[placement.key] ?? 0,
        'click_through_rate': _calculateCTR(placement.key),
        ...?additionalParams,
      },
    );

    Logger.info(
      '👆 Ad clicked: ${placement.key} (CTR: ${_calculateCTR(placement.key).toStringAsFixed(2)}%)',
      tag: 'AD_ANALYTICS',
    );
  }

  /// Track ad dismissed/closed
  Future<void> trackAdDismissed(
    AdPlacement placement, {
    int? viewDurationSeconds,
    Map<String, dynamic>? additionalParams,
  }) async {
    _dismissCounts[placement.key] = (_dismissCounts[placement.key] ?? 0) + 1;

    await _analytics.logEvent(
      name: 'ad_dismissed',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'placement_id': placement.key,
        'dismiss_count': _dismissCounts[placement.key],
        if (viewDurationSeconds != null) 'view_duration_seconds': viewDurationSeconds,
        ...?additionalParams,
      },
    );

    Logger.info('👋 Ad dismissed: ${placement.key}', tag: 'AD_ANALYTICS');
  }

  /// Track ad show failed
  Future<void> trackAdShowFailure(
    AdPlacement placement, {
    required String errorCode,
    String? errorMessage,
    Map<String, dynamic>? additionalParams,
  }) async {
    await _analytics.logEvent(
      name: 'ad_show_failure',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'placement_id': placement.key,
        'error_code': errorCode,
        if (errorMessage != null) 'error_message': errorMessage,
        ...?additionalParams,
      },
    );

    Logger.error('❌ Ad show failed: ${placement.key} - $errorCode', tag: 'AD_ANALYTICS');
  }

  // ═══════════════════════════════════════════════════════════════
  // REWARDED AD EVENTS
  // ═══════════════════════════════════════════════════════════════

  /// Track rewarded ad earned
  Future<void> trackRewardEarned(
    AdPlacement placement, {
    required String rewardType,
    required int rewardAmount,
    Map<String, dynamic>? additionalParams,
  }) async {
    await _analytics.logEvent(
      name: 'ad_reward_earned',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'placement_id': placement.key,
        'reward_type': rewardType,
        'reward_amount': rewardAmount,
        ...?additionalParams,
      },
    );

    // Log as earned_virtual_currency (predefined event)
    await _analytics.logEvent(
      name: 'earn_virtual_currency',
      parameters: {
        'virtual_currency_name': rewardType,
        'value': rewardAmount,
        'source': 'rewarded_ad',
      },
    );

    Logger.success(
      '🎁 Reward earned: ${placement.key} ($rewardType x$rewardAmount)',
      tag: 'AD_ANALYTICS',
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FREQUENCY & PERFORMANCE TRACKING
  // ═══════════════════════════════════════════════════════════════

  /// Track ad frequency cap hit
  Future<void> trackFrequencyCapHit(
    AdPlacement placement, {
    required String capType, // 'session', 'hour', 'day'
    required int maxAllowed,
    required int currentCount,
  }) async {
    await _analytics.logEvent(
      name: 'ad_frequency_cap_hit',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'cap_type': capType,
        'max_allowed': maxAllowed,
        'current_count': currentCount,
      },
    );

    Logger.warning(
      '⚠️ Frequency cap hit: ${placement.key} ($capType: $currentCount/$maxAllowed)',
      tag: 'AD_ANALYTICS',
    );
  }

  /// Track ad spam detection
  Future<void> trackAdSpamDetected(
    AdPlacement placement, {
    required int showsInTimeframe,
    required int timeframeSeconds,
  }) async {
    await _analytics.logEvent(
      name: 'ad_spam_detected',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'shows_in_timeframe': showsInTimeframe,
        'timeframe_seconds': timeframeSeconds,
      },
    );

    Logger.warning(
      '🚫 Ad spam detected: ${placement.key} ($showsInTimeframe shows in ${timeframeSeconds}s)',
      tag: 'AD_ANALYTICS',
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // REVENUE TRACKING
  // ═══════════════════════════════════════════════════════════════

  /// Track estimated ad revenue
  Future<void> trackAdRevenue(
    AdPlacement placement, {
    required double revenue,
    required String currency,
    String? adNetwork,
    Map<String, dynamic>? additionalParams,
  }) async {
    _revenueEstimates[placement.key] = (_revenueEstimates[placement.key] ?? 0.0) + revenue;

    await _analytics.logEvent(
      name: 'ad_revenue',
      parameters: {
        'ad_placement': placement.key,
        'ad_type': placement.type.name,
        'placement_id': placement.key,
        'revenue': revenue,
        'currency': currency,
        if (adNetwork != null) 'ad_network': adNetwork,
        'total_revenue': _revenueEstimates[placement.key],
        ...?additionalParams,
      },
    );

    Logger.info('💰 Ad revenue: ${placement.key} ($currency $revenue)', tag: 'AD_ANALYTICS');
  }

  // ═══════════════════════════════════════════════════════════════
  // ANALYTICS & REPORTING
  // ═══════════════════════════════════════════════════════════════

  /// Get analytics summary for a placement
  Map<String, dynamic> getPlacementSummary(String placementKey) {
    return {
      'impressions': _impressionCounts[placementKey] ?? 0,
      'clicks': _clickCounts[placementKey] ?? 0,
      'dismissals': _dismissCounts[placementKey] ?? 0,
      'ctr': _calculateCTR(placementKey),
      'load_attempts': _loadAttempts[placementKey] ?? 0,
      'load_failures': _loadFailures[placementKey] ?? 0,
      'estimated_revenue': _revenueEstimates[placementKey] ?? 0.0,
    };
  }

  /// Get all analytics data
  Map<String, Map<String, dynamic>> getAllAnalytics() {
    final allPlacements = {..._impressionCounts.keys, ..._clickCounts.keys, ..._loadAttempts.keys};

    return {for (var key in allPlacements) key: getPlacementSummary(key)};
  }

  /// Calculate Click-Through Rate (CTR)
  double _calculateCTR(String placementKey) {
    final impressions = _impressionCounts[placementKey] ?? 0;
    final clicks = _clickCounts[placementKey] ?? 0;

    if (impressions == 0) return 0.0;
    return (clicks / impressions) * 100;
  }

  /// Reset analytics for a placement
  void resetPlacementAnalytics(String placementKey) {
    _impressionCounts.remove(placementKey);
    _clickCounts.remove(placementKey);
    _dismissCounts.remove(placementKey);
    _loadAttempts.remove(placementKey);
    _loadFailures.remove(placementKey);
    _loadStartTimes.remove(placementKey);
    _revenueEstimates.remove(placementKey);

    Logger.info('🔄 Analytics reset for: $placementKey', tag: 'AD_ANALYTICS');
  }

  /// Reset all analytics
  void resetAllAnalytics() {
    _impressionCounts.clear();
    _clickCounts.clear();
    _dismissCounts.clear();
    _loadAttempts.clear();
    _loadFailures.clear();
    _loadStartTimes.clear();
    _revenueEstimates.clear();

    Logger.info('🔄 All ad analytics reset', tag: 'AD_ANALYTICS');
  }

  /// Log analytics summary to Firebase
  Future<void> logAnalyticsSummary() async {
    final summary = getAllAnalytics();

    await _analytics.logEvent(
      name: 'ad_analytics_summary',
      parameters: {
        'total_placements': summary.length,
        'total_impressions': summary.values.fold<int>(
          0,
          (sum, data) => sum + (data['impressions'] as int? ?? 0),
        ),
        'total_clicks': summary.values.fold<int>(
          0,
          (sum, data) => sum + (data['clicks'] as int? ?? 0),
        ),
        'total_revenue': summary.values.fold<double>(
          0.0,
          (sum, data) => sum + (data['estimated_revenue'] as double? ?? 0.0),
        ),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    Logger.info('📊 Analytics summary logged to Firebase', tag: 'AD_ANALYTICS');
  }
}
