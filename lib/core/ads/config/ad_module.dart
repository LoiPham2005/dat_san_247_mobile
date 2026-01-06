// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/ad_module.dart (Dependency Injection)
// // ════════════════════════════════════════════════════════════════
//
// import 'package:injectable/injectable.dart';
// import 'ad_config.dart';
// import 'ad_remote_config.dart';
//
// @module
// abstract class AdModule {
//   @lazySingleton
//   Future<AdConfig> provideAdConfig(AdRemoteConfig remoteConfig) async {
//     await remoteConfig.initialize();
//     return remoteConfig.config;
//   }
// }
