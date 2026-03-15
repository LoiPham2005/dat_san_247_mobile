// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

import '../../../core/common/constants/app_constants.dart';
import '../../../core/common/utils/logger.dart';
import 'ad_config_models.dart';
import 'ad_defaults.dart';

export 'ad_config_models.dart';
export 'ad_state.dart';

// ─────────────────────────────────────────────────────────────────
// AD REMOTE CONFIG SERVICE — fetch Firebase RC, fallback về local
// ─────────────────────────────────────────────────────────────────

@LazySingleton()
class AdRemoteConfig {
  static const _isDev = String.fromEnvironment('FLAVOR', defaultValue: 'prod') == 'dev';

  AdsRemoteConfig _cfg = _isDev ? kAdsDevConfig : kAdsProdConfig;
  bool _ready = false;
  DateTime? _lastFetch;
  late FirebaseRemoteConfig _rc;

  AdsRemoteConfig get config => _cfg;
  bool get isReady => _ready;
  bool get isStale => _lastFetch == null || DateTime.now().difference(_lastFetch!).inHours >= 24;

  Future<void> initialize({Duration timeout = const Duration(seconds: 15)}) async {
    if (_ready) return;
    try {
      _rc = FirebaseRemoteConfig.instance;
      await _rc.setConfigSettings(
        RemoteConfigSettings(fetchTimeout: timeout, minimumFetchInterval: const Duration(hours: 1)),
      );
      final defaultJson = jsonEncode((_isDev ? kAdsDevConfig : kAdsProdConfig).toJson());
      await _rc.setDefaults({AppConstants.adConfigKey: defaultJson});
      Logger.info('🎛️ Ads flavor: ${_isDev ? "DEV" : "PROD"}', tag: 'ADS');
      try {
        if (await _rc.fetchAndActivate().timeout(timeout, onTimeout: () => false)) {
          _lastFetch = DateTime.now();
        }
      } on FirebaseException catch (e) {
        Logger.warning('⏱️ RC fetch failed: ${e.code}', tag: 'ADS');
      }
      _parse();
    } catch (e, s) {
      Logger.error('❌ RC init failed', error: e, stackTrace: s, tag: 'ADS');
    } finally {
      _ready = true;
    }
  }

  Future<bool> refresh() async {
    try {
      final ok = await _rc.fetchAndActivate().timeout(
        const Duration(seconds: 10),
        onTimeout: () => false,
      );
      if (ok) {
        _lastFetch = DateTime.now();
        _parse();
      }
      return ok;
    } catch (e) {
      Logger.error('❌ RC refresh failed', error: e, tag: 'ADS');
      return false;
    }
  }

  void _parse() {
    try {
      final raw = _rc.getString(AppConstants.adConfigKey);
      if (raw.isEmpty) return;
      _cfg = AdsRemoteConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      Logger.success('✅ Ads config loaded', tag: 'ADS');
    } catch (e) {
      Logger.error('❌ RC parse failed — using default', error: e, tag: 'ADS');
    }
  }
}

