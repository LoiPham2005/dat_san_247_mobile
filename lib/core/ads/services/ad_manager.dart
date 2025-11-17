// // ════════════════════════════════════════════════════════════════
// // 🎯 4. Ad Manager (Business Logic with Remote Config)
// // ════════════════════════════════════════════════════════════════
// // lib/core/ads/services/ad_manager.dart

// import 'package:injectable/injectable.dart';
// import 'ad_service.dart';
// import 'remote_config_service.dart';

// @LazySingleton()
// class AdManager {
//   AdManager(this._adService, this._remoteConfigService);
//   final AdService _adService;
//   final RemoteConfigService _remoteConfigService;

//   int _actionCount = 0;

//   Future<void> initialize() async {
//     await _remoteConfigService.initialize(); // ✅ Load config first
//     await _adService.initialize();
//     await _adService.loadInterstitialAd();
//   }

//   // ✅ Smart frequency from Remote Config
//   Future<void> maybeShowInterstitial() async {
//     final config = _remoteConfigService.adConfig;
//     if (!config.interstitialEnabled) return;

//     _actionCount++;

//     // ✅ Dynamic frequency
//     if (_actionCount >= config.interstitialFrequency) {
//       await _adService.showInterstitialAd();
//       _actionCount = 0;
//     }
//   }

//   // ✅ Placement control
//   bool shouldShowBanner(String screenName) {
//     final config = _remoteConfigService.adConfig;
//     return screenName == 'home' ? config.showBannerOnHome : true;
//   }
// }
