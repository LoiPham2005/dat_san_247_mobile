// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/domain/ad_frequency.dart (OPTIMIZED WITH PERSISTENCE)
// ════════════════════════════════════════════════════════════════

import 'dart:convert';

import 'package:dat_san_247_mobile/core/storage/local/local_storage_keys.dart';
import 'package:dat_san_247_mobile/core/storage/secure/secure_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_placement.dart';

/// Manages ad frequency with persistence to prevent spam
class AdFrequency {
  AdFrequency() {
    _loadFromStorage();
  }

  // Remove local constants

  final Map<String, DateTime> _lastShown = {};
  final Map<String, int> _showCount = {};
  final Map<String, int> _sessionImpressions = {};
  final Map<String, int> _dailyImpressions = {};
  DateTime? _sessionStart;
  DateTime? _lastDayReset;

  bool _isLoaded = false;

  // ═══════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ═══════════════════════════════════════════════════════════════

  Future<void> _loadFromStorage() async {
    if (_isLoaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(LocalStorageKeys.adFrequencyData);
      final sessionStartStr = prefs.getString(LocalStorageKeys.adSessionStart);

      if (json != null) {
        final data = jsonDecode(json) as Map<String, dynamic>;

        // Load last shown times
        if (data['lastShown'] != null) {
          (data['lastShown'] as Map<String, dynamic>).forEach((key, value) {
            _lastShown[key] = DateTime.parse(value as String);
          });
        }

        // Load show counts
        if (data['showCount'] != null) {
          _showCount.addAll(Map<String, int>.from(data['showCount'] as Map));
        }

        // Load daily impressions
        if (data['dailyImpressions'] != null) {
          _dailyImpressions.addAll(Map<String, int>.from(data['dailyImpressions'] as Map));
        }

        // Load last day reset
        if (data['lastDayReset'] != null) {
          _lastDayReset = DateTime.parse(data['lastDayReset'] as String);
        }
      }

      // Check if new session
      if (sessionStartStr != null) {
        _sessionStart = DateTime.parse(sessionStartStr);
        final elapsed = DateTime.now().difference(_sessionStart!);

        // Reset session if more than 30 minutes ago
        if (elapsed.inMinutes > 30) {
          _sessionImpressions.clear();
          _sessionStart = DateTime.now();
          await _saveSessionStart();
        }
      } else {
        _sessionStart = DateTime.now();
        await _saveSessionStart();
      }

      // Check if new day
      if (_lastDayReset != null) {
        final now = DateTime.now();
        final lastReset = _lastDayReset!;

        if (now.year != lastReset.year ||
            now.month != lastReset.month ||
            now.day != lastReset.day) {
          _dailyImpressions.clear();
          _lastDayReset = now;
          await _saveToStorage();
        }
      } else {
        _lastDayReset = DateTime.now();
        await _saveToStorage();
      }

      _isLoaded = true;
    } catch (e) {
      // Ignore errors, start fresh
      _isLoaded = true;
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final data = {
        'lastShown': _lastShown.map((key, value) => MapEntry(key, value.toIso8601String())),
        'showCount': _showCount,
        'dailyImpressions': _dailyImpressions,
        'lastDayReset': _lastDayReset?.toIso8601String(),
      };

      await prefs.setString(LocalStorageKeys.adFrequencyData, jsonEncode(data));
    } catch (e) {
      // Ignore save errors
    }
  }

  Future<void> _saveSessionStart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LocalStorageKeys.adSessionStart, _sessionStart!.toIso8601String());
    } catch (e) {
      // Ignore save errors
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // FREQUENCY CONTROL (ENHANCED)
  // ═══════════════════════════════════════════════════════════════

  /// Check if ad can be shown with enhanced controls
  Future<bool> canShowPlacement(
    AdPlacement placement, {
    Duration? minInterval,
    int? maxPerSession,
    int? maxPerDay,
    int? maxPerHour,
  }) async {
    await _loadFromStorage();
    return _canShow(
      placement.key,
      minInterval: minInterval,
      maxPerSession: maxPerSession,
      maxPerDay: maxPerDay,
      maxPerHour: maxPerHour,
    );
  }

  /// Check if ad can be shown by string key
  bool _canShow(
    String placement, {
    Duration? minInterval,
    int? maxPerSession,
    int? maxPerDay,
    int? maxPerHour,
  }) {
    // Check minimum interval
    if (minInterval != null) {
      final lastShown = _lastShown[placement];
      if (lastShown != null) {
        final elapsed = DateTime.now().difference(lastShown);
        if (elapsed < minInterval) {
          return false;
        }
      }
    }

    // Check max per session
    if (maxPerSession != null) {
      final count = _sessionImpressions[placement] ?? 0;
      if (count >= maxPerSession) {
        return false;
      }
    }

    // Check max per day
    if (maxPerDay != null) {
      final count = _dailyImpressions[placement] ?? 0;
      if (count >= maxPerDay) {
        return false;
      }
    }

    // Check max per hour
    if (maxPerHour != null) {
      final lastShown = _lastShown[placement];
      if (lastShown != null) {
        final elapsed = DateTime.now().difference(lastShown);
        if (elapsed.inHours < 1) {
          // Within same hour, check count
          final hourKey = '${placement}_hour_${lastShown.hour}';
          final hourCount = _showCount[hourKey] ?? 0;
          if (hourCount >= maxPerHour) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Mark ad as shown with persistence
  Future<void> markPlacementShown(AdPlacement placement) async {
    await _loadFromStorage();
    await _markShown(placement.key);
  }

  Future<void> _markShown(String placement) async {
    final now = DateTime.now();

    _lastShown[placement] = now;
    _showCount[placement] = (_showCount[placement] ?? 0) + 1;
    _sessionImpressions[placement] = (_sessionImpressions[placement] ?? 0) + 1;
    _dailyImpressions[placement] = (_dailyImpressions[placement] ?? 0) + 1;

    // Track hourly count
    final hourKey = '${placement}_hour_${now.hour}';
    _showCount[hourKey] = (_showCount[hourKey] ?? 0) + 1;

    await _saveToStorage();
  }

  // ═══════════════════════════════════════════════════════════════
  // ANALYTICS & QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get time since last shown
  Duration? getTimeSinceLastShown(String placement) {
    final lastShown = _lastShown[placement];
    if (lastShown == null) return null;
    return DateTime.now().difference(lastShown);
  }

  /// Get total show count for placement
  int getShowCount(String placement) => _showCount[placement] ?? 0;

  /// Get session impressions
  int getSessionImpressions(String placement) => _sessionImpressions[placement] ?? 0;

  /// Get daily impressions
  int getDailyImpressions(String placement) => _dailyImpressions[placement] ?? 0;

  /// Get session duration
  Duration? getSessionDuration() {
    if (_sessionStart == null) return null;
    return DateTime.now().difference(_sessionStart!);
  }

  /// Reset all tracking
  Future<void> reset() async {
    _lastShown.clear();
    _showCount.clear();
    _sessionImpressions.clear();
    _dailyImpressions.clear();
    _sessionStart = DateTime.now();
    _lastDayReset = DateTime.now();
    await _saveToStorage();
    await _saveSessionStart();
  }

  /// Reset tracking for specific placement
  Future<void> resetForPlacement(AdPlacement placement) async {
    await resetPlacement(placement.key);
  }

  Future<void> resetPlacement(String placement) async {
    _lastShown.remove(placement);
    _showCount.remove(placement);
    _sessionImpressions.remove(placement);
    _dailyImpressions.remove(placement);
    await _saveToStorage();
  }

  /// Get comprehensive analytics data
  Map<String, Map<String, dynamic>> getAnalyticsData() {
    final result = <String, Map<String, dynamic>>{};

    final allPlacements = {..._sessionImpressions.keys, ..._lastShown.keys, ..._showCount.keys};

    for (final key in allPlacements) {
      result[key] = {
        'sessionImpressions': _sessionImpressions[key] ?? 0,
        'dailyImpressions': _dailyImpressions[key] ?? 0,
        'totalShowCount': _showCount[key] ?? 0,
        'lastShown': _lastShown[key]?.toIso8601String(),
        'timeSinceLastShown': getTimeSinceLastShown(key)?.inSeconds,
      };
    }

    return result;
  }

  /// Check if placement is being shown too frequently (spam detection)
  bool isSpamming(
    String placement, {
    Duration window = const Duration(minutes: 5),
    int threshold = 3,
  }) {
    final lastShown = _lastShown[placement];
    if (lastShown == null) return false;

    final elapsed = DateTime.now().difference(lastShown);
    if (elapsed > window) return false;

    // Check if shown too many times in window
    final count = _sessionImpressions[placement] ?? 0;
    return count >= threshold;
  }

  /// Get recommended wait time before next show
  Duration? getRecommendedWaitTime(
    String placement, {
    Duration minInterval = const Duration(seconds: 30),
  }) {
    final lastShown = _lastShown[placement];
    if (lastShown == null) return Duration.zero;

    final elapsed = DateTime.now().difference(lastShown);
    if (elapsed >= minInterval) return Duration.zero;

    return minInterval - elapsed;
  }
}
