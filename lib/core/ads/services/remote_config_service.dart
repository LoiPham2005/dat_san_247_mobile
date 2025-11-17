// // ════════════════════════════════════════════════════════════════
// // 🔥 2. Remote Config Service
// // ════════════════════════════════════════════════════════════════
// // lib/core/ads/services/remote_config_service.dart

// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:injectable/injectable.dart';
// import 'package:flutter_base_template/core/utils/logger.dart';
// import '../models/ad_remote_config.dart';

// @LazySingleton()
// class RemoteConfigService {
//   late final FirebaseRemoteConfig _remoteConfig;
//   AdRemoteConfig _adConfig = const AdRemoteConfig();

//   AdRemoteConfig get adConfig => _adConfig;

//   Future<void> initialize() async {
//     try {
//       _remoteConfig = FirebaseRemoteConfig.instance;

//       await _remoteConfig.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(seconds: 10),
//           minimumFetchInterval: const Duration(hours: 1),
//         ),
//       );

//       await _remoteConfig.setDefaults(const AdRemoteConfig().toJson());
//       await _remoteConfig.fetchAndActivate();
//       _parseConfig();

//       Logger.success('Remote Config loaded', tag: 'REMOTE_CONFIG');
//     } catch (e) {
//       Logger.error('Remote Config failed', error: e, tag: 'REMOTE_CONFIG');
//     }
//   }

//   void _parseConfig() {
//     _adConfig = AdRemoteConfig(
//       adsEnabled: _remoteConfig.getBool('ads_enabled'),
//       bannerEnabled: _remoteConfig.getBool('banner_enabled'),
//       interstitialEnabled: _remoteConfig.getBool('interstitial_enabled'),
//       rewardedEnabled: _remoteConfig.getBool('rewarded_enabled'),

//       androidBannerId: _remoteConfig.getString('android_banner_id'),
//       androidInterstitialId: _remoteConfig.getString('android_interstitial_id'),
//       androidRewardedId: _remoteConfig.getString('android_rewarded_id'),

//       iosBannerId: _remoteConfig.getString('ios_banner_id'),
//       iosInterstitialId: _remoteConfig.getString('ios_interstitial_id'),
//       iosRewardedId: _remoteConfig.getString('ios_rewarded_id'),

//       interstitialFrequency: _remoteConfig.getInt('interstitial_frequency'),
//       interstitialCooldownSeconds: _remoteConfig.getInt('interstitial_cooldown_seconds'),

//       showBannerOnHome: _remoteConfig.getBool('show_banner_on_home'),
//       showInterstitialOnNavigation: _remoteConfig.getBool('show_interstitial_on_navigation'),

//       adStrategy: _remoteConfig.getString('ad_strategy'),
//       testMode: _remoteConfig.getBool('test_mode'),
//     );
//   }

//   Future<void> refresh() async {
//     await _remoteConfig.fetchAndActivate();
//     _parseConfig();
//   }
// }
