// // ════════════════════════════════════════════════════════════════
// // 📱 1. Remote Config Model (Type-safe)
// // ════════════════════════════════════════════════════════════════
// // lib/core/ads/models/ad_remote_config.dart

// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'ad_remote_config.freezed.dart';
// part 'ad_remote_config.g.dart';

// @freezed
// abstract class AdRemoteConfig with _$AdRemoteConfig {
//   const factory AdRemoteConfig({
//     // Kill switches
//     @Default(true) bool adsEnabled,
//     @Default(true) bool bannerEnabled,
//     @Default(true) bool interstitialEnabled,
//     @Default(true) bool rewardedEnabled,

//     // Ad Unit IDs (Dynamic)
//     @Default('ca-app-pub-3940256099942544/6300978111') String androidBannerId,
//     @Default('ca-app-pub-3940256099942544/1033173712') String androidInterstitialId,
//     @Default('ca-app-pub-3940256099942544/5224354917') String androidRewardedId,
//     @Default('ca-app-pub-3940256099942544/2934735716') String iosBannerId,
//     @Default('ca-app-pub-3940256099942544/4411468910') String iosInterstitialId,
//     @Default('ca-app-pub-3940256099942544/1712485313') String iosRewardedId,

//     // Behavior control
//     @Default(3) int interstitialFrequency,
//     @Default(300) int interstitialCooldownSeconds,
//     @Default(true) bool showBannerOnHome,
//     @Default(true) bool showInterstitialOnNavigation,

//     // A/B Testing
//     @Default('default') String adStrategy,
//     @Default(false) bool testMode,
//   }) = _AdRemoteConfig;

//   factory AdRemoteConfig.fromJson(Map<String, dynamic> json) =>
//       _$AdRemoteConfigFromJson(json);
// }
