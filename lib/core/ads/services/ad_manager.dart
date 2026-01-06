// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/ad_manager.dart
// // ════════════════════════════════════════════════════════════════
//
// import 'package:dat_san_247_mobile/core/ads/config/ad_config.dart';
// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart';
//
// import '../domain/ad_frequency.dart';
// import '../domain/ad_placement.dart';
// import 'ad_service.dart';
//
// @LazySingleton()
// class AdManager {
//   AdManager(this._service, this._config);
//
//   final AdService _service;
//   final AdConfig _config;
//   final _frequency = AdFrequency();
//
//   int _navCount = 0;
//
//   // ═══════════════════════════════════════════════════════════════
//   // INITIALIZATION
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<void> initialize() async {
//     await _service.initialize();
//
//     // Preload critical ads
//     await Future.wait([
//       _service.loadInterstitial(AdPlacement.interSplash),
//       _service.loadAppOpen(AdPlacement.openSplash),
//       _service.loadInterstitial(AdPlacement.interHome),
//     ]);
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // SPLASH
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<bool> showSplashAppOpen() async {
//     if (!_canShow(AdPlacement.openSplash)) return false;
//
//     final shown = await _service.showAppOpen(AdPlacement.openSplash);
//     if (shown) _frequency.markShown(AdPlacement.openSplash);
//
//     return shown;
//   }
//
//   Future<bool> showSplashInterstitial() async {
//     if (!_canShow(AdPlacement.interSplash)) return false;
//
//     final shown = await _service.showInterstitial(AdPlacement.interSplash);
//     if (shown) _frequency.markShown(AdPlacement.interSplash);
//
//     return shown;
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // NAVIGATION
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<void> showNavigationAd() async {
//     _navCount++;
//
//     if (_navCount < _config.interInterval) return;
//
//     if (!_frequency.canShow(
//       AdPlacement.interHome,
//       minInterval: Duration(seconds: _config.interInterval),
//       maxPerSession: 10,
//     )) {
//       return;
//     }
//
//     final shown = await _service.showInterstitial(AdPlacement.interHome);
//
//     if (shown) {
//       _navCount = 0;
//       _frequency.markShown(AdPlacement.interHome);
//     }
//   }
//
//   Future<void> showBackAd() async {
//     if (!_frequency.canShow(AdPlacement.interBack, minInterval: const Duration(seconds: 30))) {
//       return;
//     }
//
//     final shown = await _service.showInterstitial(AdPlacement.interBack);
//     if (shown) _frequency.markShown(AdPlacement.interBack);
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // REWARDED
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<bool> showRewardedAd({required String placement, required VoidCallback onRewarded}) async {
//     // Ensure loaded
//     await _service.loadRewarded(placement);
//
//     var earned = false;
//
//     final shown = await _service.showRewarded(
//       placement,
//       onReward: (ad, reward) {
//         earned = true;
//         onRewarded();
//       },
//     );
//
//     if (shown) _frequency.markShown(placement);
//
//     return earned;
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // APP LIFECYCLE
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<void> showOnResumeAd() async {
//     if (!_frequency.canShow(
//       AdPlacement.openOnResume,
//       minInterval: const Duration(minutes: 5),
//       maxPerSession: 3,
//     )) {
//       return;
//     }
//
//     final shown = await _service.showAppOpen(AdPlacement.openOnResume);
//     if (shown) _frequency.markShown(AdPlacement.openOnResume);
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // PRELOADING
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<void> preloadForScreen(String screen) async {
//     switch (screen) {
//       case 'intro':
//         await Future.wait([
//           _service.loadNative(AdPlacement.nativeIntro1),
//           _service.loadInterstitial(AdPlacement.interIntro),
//         ]);
//         break;
//       case 'language':
//         await _service.loadNative(AdPlacement.nativeLanguageSelect);
//         break;
//       case 'password':
//         await _service.loadRewarded(AdPlacement.rewardPasswordShow);
//         break;
//     }
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // UTILITIES
//   // ═══════════════════════════════════════════════════════════════
//
//   bool _canShow(String placement) {
//     return _config.isEnabled(placement);
//   }
//
//   void resetNavigationCount() => _navCount = 0;
//
//   void dispose() {
//     _service.disposeAll();
//     _frequency.reset();
//   }
// }
