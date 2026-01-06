// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/ad_remote_config.dart
// // ════════════════════════════════════════════════════════════════
//
// import 'dart:convert';
//
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:dat_san_247_mobile/core/ads/config/ad_default_config.dart';
// import 'package:dat_san_247_mobile/core/utils/logger.dart';
// import 'package:injectable/injectable.dart';
//
// import 'ad_config.dart';
//
// @LazySingleton()
// class AdRemoteConfig {
//   late final FirebaseRemoteConfig _remote;
//   AdConfig _config = AdConfig.fromJson(adDefaultConfig);
//
//   AdConfig get config => _config;
//
//   Future<void> initialize() async {
//     try {
//       _remote = FirebaseRemoteConfig.instance;
//
//       await _remote.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(seconds: 10),
//           minimumFetchInterval: const Duration(hours: 1),
//         ),
//       );
//
//       await _remote.setDefaults({'ad_config': jsonEncode(adDefaultConfig)});
//
//       await _remote.fetchAndActivate();
//       _parse();
//
//       Logger.success('✅ Remote Config loaded', tag: 'ADS');
//     } catch (e) {
//       Logger.error('❌ Remote Config failed', error: e, tag: 'ADS');
//       _config = AdConfig.fromJson(adDefaultConfig);
//     }
//   }
//
//   void _parse() {
//     try {
//       final json = _remote.getString('ad_config');
//       if (json.isEmpty) {
//         Logger.warning('⚠️ Remote Config empty', tag: 'ADS');
//         return;
//       }
//
//       _config = AdConfig.fromJson(jsonDecode(json));
//       Logger.success('✅ Ad Config parsed: ${_config.showAllAds}', tag: 'ADS');
//     } catch (e) {
//       Logger.error('❌ Failed to parse config', error: e, tag: 'ADS');
//     }
//   }
//
//   Future<void> refresh() async {
//     try {
//       await _remote.fetchAndActivate();
//       _parse();
//       Logger.success('✅ Config refreshed', tag: 'ADS');
//     } catch (e) {
//       Logger.error('❌ Refresh failed', error: e, tag: 'ADS');
//     }
//   }
//
//   Future<void> forceFetch() async {
//     try {
//       await _remote.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(seconds: 10),
//           minimumFetchInterval: Duration.zero,
//         ),
//       );
//       await refresh();
//     } catch (e) {
//       Logger.error('❌ Force fetch failed', error: e, tag: 'ADS');
//     }
//   }
// }
