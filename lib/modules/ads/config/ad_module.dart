// ─────────────────────────────────────────────────────────────────
// DI MODULE
// ─────────────────────────────────────────────────────────────────

import 'package:injectable/injectable.dart';

import 'ad_remote_config.dart';

@module
abstract class AdModule {
  @lazySingleton
  Future<AdsRemoteConfig> adsConfig(AdRemoteConfig rc) async {
    await rc.initialize();
    return rc.config;
  }
}
