// // ════════════════════════════════════════════════════════════════
// // 🎮 3. Smart Ad Service (Integrated with Remote Config)
// // ════════════════════════════════════════════════════════════════
// // lib/core/ads/services/ad_service.dart

// import 'dart:io';

// import 'package:flutter_base_template/core/utils/logger.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:injectable/injectable.dart';

// import 'remote_config_service.dart';

// @LazySingleton()
// class AdService {
//   AdService(this._remoteConfigService);
//   final RemoteConfigService _remoteConfigService;

//   BannerAd? _bannerAd;
//   InterstitialAd? _interstitialAd;
//   bool _isInitialized = false;
//   DateTime? _lastInterstitialShow;

//   Future<void> initialize() async {
//     final config = _remoteConfigService.adConfig;

//     // ✅ Kill switch
//     if (!config.adsEnabled) {
//       Logger.warning('Ads disabled via Remote Config', tag: 'ADS');
//       return;
//     }

//     await MobileAds.instance.initialize();
//     _isInitialized = true;
//     Logger.success('Ads initialized (${config.adStrategy})', tag: 'ADS');
//   }

//   // ✅ Dynamic Ad Unit ID from Remote Config
//   String _getBannerId() {
//     final config = _remoteConfigService.adConfig;
//     return Platform.isAndroid ? config.androidBannerId : config.iosBannerId;
//   }

//   String _getInterstitialId() {
//     final config = _remoteConfigService.adConfig;
//     return Platform.isAndroid ? config.androidInterstitialId : config.iosInterstitialId;
//   }

//   Future<void> loadBannerAd({required Function(BannerAd) onAdLoaded}) async {
//     final config = _remoteConfigService.adConfig;
//     if (!config.bannerEnabled) return;

//     _bannerAd = BannerAd(
//       adUnitId: _getBannerId(), // ✅ Dynamic from Remote Config
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(onAdLoaded: (ad) => onAdLoaded(ad as BannerAd)),
//     );
//     await _bannerAd!.load();
//   }

//   Future<void> loadInterstitialAd() async {
//     final config = _remoteConfigService.adConfig;
//     if (!config.interstitialEnabled) return;

//     // ✅ Cooldown check
//     if (_lastInterstitialShow != null) {
//       final elapsed = DateTime.now().difference(_lastInterstitialShow!);
//       if (elapsed.inSeconds < config.interstitialCooldownSeconds) {
//         Logger.info('Cooldown active', tag: 'ADS');
//         return;
//       }
//     }

//     await InterstitialAd.load(
//       adUnitId: _getInterstitialId(), // ✅ Dynamic
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           _interstitialAd = ad;
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               _lastInterstitialShow = DateTime.now();
//               ad.dispose();
//               loadInterstitialAd(); // Preload next
//             },
//           );
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           Logger.error('InterstitialAd failed to load: ${error.message}', tag: 'ADS');
//           _interstitialAd = null;
//           // Có thể thử tải lại hoặc báo UI nếu cần
//         },
//       ),
//     );
//   }

//   Future<void> showInterstitialAd() async {
//     await _interstitialAd?.show();
//   }

//   void dispose() {
//     _bannerAd?.dispose();
//     _interstitialAd?.dispose();
//   }
// }
