import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

import '../../../core/common/utils/logger.dart';
import '../../analytics/analytics_service.dart';
import '../domain/ad_placements.dart';

// ─────────────────────────────────────────────────────────────────
// AD ANALYTICS TRACKER
// Delegate mỏng — giữ logic ad event ở đây, raw Firebase ở AnalyticsService
// ─────────────────────────────────────────────────────────────────

@LazySingleton()
class AdAnalyticsTracker {
  AdAnalyticsTracker(this._analytics);
  final AnalyticsService _analytics;

  void onLoadStart(AdPlacement p) => _dbg('📡 Load: ${p.name}');
  void onLoadOk(AdPlacement p) {
    _dbg('✅ Loaded: ${p.name}');
    _event('ad_load_success', p);
  }

  void onLoadFail(AdPlacement p, {String? code, int retry = 0}) {
    _dbg('❌ Load fail: ${p.name} err=$code retry=$retry');
    _event('ad_load_failure', p, extra: {'error_code': code ?? '', 'retry_count': retry});
  }

  void onImpression(AdPlacement p) {
    _dbg('👁 Imp: ${p.name}');
    _event('ad_impression', p);
  }

  void onDismissed(AdPlacement p) {
    _dbg('👋 Dis: ${p.name}');
    _event('ad_dismissed', p);
  }

  void onShowFail(AdPlacement p, {String? code}) {
    _dbg('❌ Show fail: ${p.name} err=$code');
    _event('ad_show_failure', p, extra: {'error_code': code ?? ''});
  }

  void onClicked(AdPlacement p) {
    _dbg('🖱️ Click: ${p.name}');
    _event('ad_clicked', p);
  }

  void onRevenue(
    AdPlacement p, {
    required double micros,
    required String currency,
    required Ad ad,
    required String format,
  }) {
    final usd = micros / 1_000_000;
    _dbg('💰 Rev: ${p.name} \$$usd $currency');

    // 1️⃣ Firebase Analytics
    _analytics.logAdRevenuePaid(
      value: usd,
      currency: currency,
      adPlatform: 'Google AdMob',
      adSource: ad.responseInfo?.mediationAdapterClassName ?? 'direct',
      adUnitName: p.name,
      adFormat: format,
    );

    // 2️⃣ Adjust — track ad revenue cho attribution / ROAS
    // AdjustUtil.instance.trackAdRevenue(value: usd, currencyCode: currency);
  }

  void onScreen(String name) => _analytics.logScreenView(screenName: name);

  void _event(String name, AdPlacement p, {Map<String, dynamic>? extra}) => _analytics.logEvent(
    name: name,
    parameters: {'ad_placement': p.name, 'ad_type': p.type.name, ...?extra},
  );

  void _dbg(String msg) {
    if (kDebugMode) Logger.info(msg, tag: 'ADS');
  }
}
