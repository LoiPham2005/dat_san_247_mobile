// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/config/ad_remote_config.dart (OPTIMIZED)
// ════════════════════════════════════════════════════════════════

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:dat_san_247_mobile/core/ads/config/ad_default_config.dart';
import 'package:dat_san_247_mobile/core/constants/app_constants.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:injectable/injectable.dart';

import 'ad_config.dart';

/// Manages Remote Config for ads with robust error handling
@LazySingleton()
class AdRemoteConfig {
  late final FirebaseRemoteConfig _remote;
  AdConfig _config = AdConfig.fromJson(adDefaultConfig);
  bool _isInitialized = false;
  DateTime? _lastFetch;

  AdConfig get config => _config;
  bool get isInitialized => _isInitialized;
  DateTime? get lastFetch => _lastFetch;

  /// Initialize with timeout and fallback
  Future<void> initialize({Duration timeout = const Duration(seconds: 15)}) async {
    if (_isInitialized) return;

    try {
      _remote = FirebaseRemoteConfig.instance;

      // Configure settings
      await _remote.setConfigSettings(
        RemoteConfigSettings(fetchTimeout: timeout, minimumFetchInterval: const Duration(hours: 1)),
      );

      // Set defaults
      await _remote.setDefaults({AppConstants.adConfigKey: jsonEncode(adDefaultConfig)});

      // Fetch with timeout
      try {
        await _remote.fetchAndActivate().timeout(
          timeout,
          onTimeout: () {
            Logger.warning('⏱️ Remote Config fetch timeout, using defaults', tag: 'ADS');
            return false;
          },
        );
        _lastFetch = DateTime.now();
      } on FirebaseException catch (e) {
        Logger.error('❌ Firebase fetch failed: ${e.code} - ${e.message}', tag: 'ADS');
        // Continue with defaults
      }

      // Parse config
      _parse();

      _isInitialized = true;
      Logger.success('✅ Remote Config initialized', tag: 'ADS');
    } catch (e, stack) {
      Logger.error('❌ Remote Config failed', error: e, stackTrace: stack, tag: 'ADS');

      // Use defaults on any error
      _config = AdConfig.fromJson(adDefaultConfig);
      _isInitialized = true;
    }
  }

  /// Parse config with detailed error logging
  void _parse() {
    try {
      final json = _remote.getString(AppConstants.adConfigKey);

      if (json.isEmpty) {
        Logger.warning('⚠️ Remote Config empty, using defaults', tag: 'ADS');
        _config = AdConfig.fromJson(adDefaultConfig);
        return;
      }

      // Try to parse JSON
      Map<String, dynamic> configData;
      try {
        configData = jsonDecode(json) as Map<String, dynamic>;
      } catch (e) {
        Logger.error('❌ Invalid JSON in remote config', error: e, tag: 'ADS');
        _config = AdConfig.fromJson(adDefaultConfig);
        return;
      }

      // Validate config structure
      if (!_validateConfig(configData)) {
        Logger.error('❌ Invalid config structure, using defaults', tag: 'ADS');
        _config = AdConfig.fromJson(adDefaultConfig);
        return;
      }

      // Parse to AdConfig
      try {
        _config = AdConfig.fromJson(configData);
        Logger.success(
          '✅ Config parsed: showAllAds=${_config.showAllAds}, '
          'interInterval=${_config.interInterval}s, '
          'placements=${_config.adUnits.length}',
          tag: 'ADS',
        );
      } catch (e, stack) {
        Logger.error('❌ Failed to create AdConfig', error: e, stackTrace: stack, tag: 'ADS');
        _config = AdConfig.fromJson(adDefaultConfig);
      }
    } catch (e, stack) {
      Logger.error('❌ Parse failed', error: e, stackTrace: stack, tag: 'ADS');
      _config = AdConfig.fromJson(adDefaultConfig);
    }
  }

  /// Validate config structure before parsing
  bool _validateConfig(Map<String, dynamic> data) {
    // Check required fields
    if (!data.containsKey('showAllAds')) {
      Logger.error('❌ Missing required field: showAllAds', tag: 'ADS');
      return false;
    }

    if (!data.containsKey('interInterval')) {
      Logger.error('❌ Missing required field: interInterval', tag: 'ADS');
      return false;
    }

    if (!data.containsKey('adUnitsConfig')) {
      Logger.error('❌ Missing required field: adUnitsConfig', tag: 'ADS');
      return false;
    }

    // Validate types
    if (data['showAllAds'] is! bool) {
      Logger.error('❌ Invalid type for showAllAds', tag: 'ADS');
      return false;
    }

    if (data['interInterval'] is! int) {
      Logger.error('❌ Invalid type for interInterval', tag: 'ADS');
      return false;
    }

    if (data['adUnitsConfig'] is! Map) {
      Logger.error('❌ Invalid type for adUnitsConfig', tag: 'ADS');
      return false;
    }

    // Validate ad units
    final adUnits = data['adUnitsConfig'] as Map<String, dynamic>;
    if (adUnits.isEmpty) {
      Logger.warning('⚠️ No ad units configured', tag: 'ADS');
    }

    return true;
  }

  /// Refresh config from server
  Future<bool> refresh() async {
    try {
      final activated = await _remote.fetchAndActivate().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          Logger.warning('⏱️ Refresh timeout', tag: 'ADS');
          return false;
        },
      );

      if (activated) {
        _lastFetch = DateTime.now();
        _parse();
        Logger.success('✅ Config refreshed', tag: 'ADS');
        return true;
      } else {
        Logger.info('ℹ️ Config not updated (no changes)', tag: 'ADS');
        return false;
      }
    } catch (e, stack) {
      Logger.error('❌ Refresh failed', error: e, stackTrace: stack, tag: 'ADS');
      return false;
    }
  }

  /// Force fetch with zero minimum interval
  Future<bool> forceFetch() async {
    try {
      await _remote.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      final success = await refresh();

      // Restore normal fetch interval
      await _remote.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      return success;
    } catch (e, stack) {
      Logger.error('❌ Force fetch failed', error: e, stackTrace: stack, tag: 'ADS');
      return false;
    }
  }

  /// Get time since last fetch
  Duration? getTimeSinceLastFetch() {
    if (_lastFetch == null) return null;
    return DateTime.now().difference(_lastFetch!);
  }

  /// Check if config is stale (older than 24 hours)
  bool isStale() {
    if (_lastFetch == null) return true;
    final age = DateTime.now().difference(_lastFetch!);
    return age.inHours >= 24;
  }

  /// Get config as JSON for debugging
  Map<String, dynamic> toJson() => _config.toJson();

  /// Reset to defaults
  void resetToDefaults() {
    _config = AdConfig.fromJson(adDefaultConfig);
    Logger.info('🔄 Config reset to defaults', tag: 'ADS');
  }
}
