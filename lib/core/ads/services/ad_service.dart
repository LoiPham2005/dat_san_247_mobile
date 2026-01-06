// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/ad_service.dart
// // ════════════════════════════════════════════════════════════════
//
// import 'dart:async';
//
// import 'package:dat_san_247_mobile/core/ads/config/ad_config.dart';
// import 'package:dat_san_247_mobile/core/utils/logger.dart'; // Thêm dòng này
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:injectable/injectable.dart';
//
// @LazySingleton()
// class AdService {
//   AdService(this._config);
//
//   final AdConfig _config;
//
//   // Ad storage
//   final Map<String, BannerAd?> _banners = {};
//   final Map<String, InterstitialAd?> _interstitials = {};
//   final Map<String, RewardedAd?> _rewarded = {};
//   final Map<String, NativeAd?> _natives = {};
//   final Map<String, AppOpenAd?> _appOpens = {};
//
//   // Tracking
//   DateTime? _lastInterstitialShow;
//   bool _isInitialized = false;
//
//   // ═══════════════════════════════════════════════════════════════
//   // INITIALIZATION
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<void> initialize() async {
//     if (_isInitialized) return;
//
//     try {
//       await MobileAds.instance.initialize();
//       _isInitialized = true;
//       Logger.success('✅ Ads initialized', tag: 'ADS');
//     } catch (e) {
//       Logger.error('❌ Ads init failed', error: e, tag: 'ADS');
//     }
//   }
//
//   bool get isInitialized => _isInitialized;
//
//   // ═══════════════════════════════════════════════════════════════
//   // BANNER
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<BannerAd?> loadBanner(String placement, {AdSize? size}) async {
//     if (!_canLoad(placement)) return null;
//
//     final adId = _config.getAdId(placement);
//     if (adId.isEmpty) return null;
//
//     final completer = Completer<BannerAd?>();
//
//     _banners[placement] = BannerAd(
//       adUnitId: adId,
//       size: size ?? AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           Logger.success('✅ Banner loaded: $placement', tag: 'ADS');
//           completer.complete(ad as BannerAd);
//         },
//         onAdFailedToLoad: (ad, error) {
//           Logger.error('❌ Banner failed: $placement - ${error.message}', tag: 'ADS');
//           ad.dispose();
//           _banners[placement] = null;
//           completer.complete(null);
//         },
//       ),
//     );
//
//     await _banners[placement]!.load();
//     return completer.future;
//   }
//
//   void disposeBanner(String placement) {
//     _banners[placement]?.dispose();
//     _banners.remove(placement);
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // INTERSTITIAL
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<bool> loadInterstitial(String placement) async {
//     if (!_canLoad(placement)) return false;
//     if (!_checkCooldown()) return false;
//
//     final adId = _config.getAdId(placement);
//     if (adId.isEmpty) return false;
//
//     final completer = Completer<bool>();
//
//     await InterstitialAd.load(
//       adUnitId: adId,
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           _interstitials[placement] = ad;
//           Logger.success('✅ Interstitial loaded: $placement', tag: 'ADS');
//
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               _lastInterstitialShow = DateTime.now();
//               ad.dispose();
//               _interstitials.remove(placement);
//               loadInterstitial(placement); // Preload next
//             },
//             onAdFailedToShowFullScreenContent: (ad, error) {
//               ad.dispose();
//               _interstitials.remove(placement);
//             },
//           );
//
//           completer.complete(true);
//         },
//         onAdFailedToLoad: (error) {
//           Logger.error('❌ Interstitial failed: $placement - ${error.message}', tag: 'ADS');
//           completer.complete(false);
//         },
//       ),
//     );
//
//     return completer.future;
//   }
//
//   Future<bool> showInterstitial(String placement) async {
//     final ad = _interstitials[placement];
//     if (ad == null) {
//       Logger.warning('⚠️ Interstitial not loaded: $placement', tag: 'ADS');
//       return false;
//     }
//
//     await ad.show();
//     return true;
//   }
//
//   bool _checkCooldown() {
//     if (_lastInterstitialShow == null) return true;
//
//     final elapsed = DateTime.now().difference(_lastInterstitialShow!);
//     return elapsed.inSeconds >= _config.interInterval;
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // REWARDED
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<bool> loadRewarded(String placement) async {
//     if (!_canLoad(placement)) return false;
//
//     final adId = _config.getAdId(placement);
//     if (adId.isEmpty) return false;
//
//     final completer = Completer<bool>();
//
//     await RewardedAd.load(
//       adUnitId: adId,
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) {
//           _rewarded[placement] = ad;
//           Logger.success('✅ Rewarded loaded: $placement', tag: 'ADS');
//           completer.complete(true);
//         },
//         onAdFailedToLoad: (error) {
//           Logger.error('❌ Rewarded failed: $placement - ${error.message}', tag: 'ADS');
//           completer.complete(false);
//         },
//       ),
//     );
//
//     return completer.future;
//   }
//
//   Future<bool> showRewarded(
//     String placement, {
//     required Function(AdWithoutView, RewardItem) onReward,
//   }) async {
//     final ad = _rewarded[placement];
//     if (ad == null) {
//       Logger.warning('⚠️ Rewarded not loaded: $placement', tag: 'ADS');
//       return false;
//     }
//
//     ad.fullScreenContentCallback = FullScreenContentCallback(
//       onAdDismissedFullScreenContent: (ad) {
//         ad.dispose();
//         _rewarded.remove(placement);
//         loadRewarded(placement); // Preload next
//       },
//       onAdFailedToShowFullScreenContent: (ad, error) {
//         ad.dispose();
//         _rewarded.remove(placement);
//       },
//     );
//
//     await ad.show(onUserEarnedReward: onReward);
//     return true;
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // NATIVE
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<NativeAd?> loadNative(String placement, {NativeTemplateStyle? templateStyle}) async {
//     if (!_canLoad(placement)) return null;
//
//     final adId = _config.getAdId(placement);
//     if (adId.isEmpty) return null;
//
//     final completer = Completer<NativeAd?>();
//
//     _natives[placement] = NativeAd(
//       adUnitId: adId,
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           Logger.success('✅ Native loaded: $placement', tag: 'ADS');
//           completer.complete(ad as NativeAd);
//         },
//         onAdFailedToLoad: (ad, error) {
//           Logger.error('❌ Native failed: $placement - ${error.message}', tag: 'ADS');
//           ad.dispose();
//           _natives[placement] = null;
//           completer.complete(null);
//         },
//       ),
//       nativeTemplateStyle:
//           templateStyle ??
//           NativeTemplateStyle(
//             templateType: TemplateType.medium,
//             mainBackgroundColor: const Color(0xFFFFFFFF),
//             cornerRadius: 10.0,
//           ),
//     );
//
//     await _natives[placement]!.load();
//     return completer.future;
//   }
//
//   void disposeNative(String placement) {
//     _natives[placement]?.dispose();
//     _natives.remove(placement);
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // APP OPEN
//   // ═══════════════════════════════════════════════════════════════
//
//   Future<bool> loadAppOpen(String placement) async {
//     if (!_canLoad(placement)) return false;
//
//     final adId = _config.getAdId(placement);
//     if (adId.isEmpty) return false;
//
//     final completer = Completer<bool>();
//
//     await AppOpenAd.load(
//       adUnitId: adId,
//       request: const AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (ad) {
//           _appOpens[placement] = ad;
//           Logger.success('✅ App Open loaded: $placement', tag: 'ADS');
//           completer.complete(true);
//         },
//         onAdFailedToLoad: (error) {
//           Logger.error('❌ App Open failed: $placement - ${error.message}', tag: 'ADS');
//           completer.complete(false);
//         },
//       ),
//     );
//
//     return completer.future;
//   }
//
//   Future<bool> showAppOpen(String placement) async {
//     final ad = _appOpens[placement];
//     if (ad == null) {
//       Logger.warning('⚠️ App Open not loaded: $placement', tag: 'ADS');
//       return false;
//     }
//
//     ad.fullScreenContentCallback = FullScreenContentCallback(
//       onAdDismissedFullScreenContent: (ad) {
//         ad.dispose();
//         _appOpens.remove(placement);
//       },
//       onAdFailedToShowFullScreenContent: (ad, error) {
//         ad.dispose();
//         _appOpens.remove(placement);
//       },
//     );
//
//     await ad.show();
//     return true;
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // UTILITIES
//   // ═══════════════════════════════════════════════════════════════
//
//   bool _canLoad(String placement) {
//     if (!_isInitialized) {
//       Logger.warning('⚠️ Ads not initialized', tag: 'ADS');
//       return false;
//     }
//
//     if (!_config.isEnabled(placement)) {
//       Logger.warning('⚠️ Placement disabled: $placement', tag: 'ADS');
//       return false;
//     }
//
//     return true;
//   }
//
//   void disposeAll() {
//     for (var ad in _banners.values) {
//       ad?.dispose();
//     }
//     for (var ad in _interstitials.values) {
//       ad?.dispose();
//     }
//     for (var ad in _rewarded.values) {
//       ad?.dispose();
//     }
//     for (var ad in _natives.values) {
//       ad?.dispose();
//     }
//     for (var ad in _appOpens.values) {
//       ad?.dispose();
//     }
//
//     _banners.clear();
//     _interstitials.clear();
//     _rewarded.clear();
//     _natives.clear();
//     _appOpens.clear();
//   }
// }
