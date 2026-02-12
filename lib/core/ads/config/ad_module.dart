// ════════════════════════════════════════════════════════════════
// 📁 DI Module (previously in ad_module.dart)
// ════════════════════════════════════════════════════════════════

import 'package:dat_san_247_mobile/core/ads/config/ad_config.dart';
import 'package:dat_san_247_mobile/core/ads/config/ad_remote_config.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AdModule {
  @lazySingleton
  Future<AdConfig> provideAdConfig(AdRemoteConfig remoteConfig) async {
    await remoteConfig.initialize();
    return remoteConfig.config;
  }
}
