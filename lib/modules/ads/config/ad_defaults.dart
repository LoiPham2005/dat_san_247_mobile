import 'ad_config_models.dart';

// ─────────────────────────────────────────────────────────────────
// DEFAULT CONFIGS
// Dev  → Google official test IDs
// Prod → Actual AdMob IDs
// ─────────────────────────────────────────────────────────────────

const _kInterstitial = 'ca-app-pub-3940256099942544/1033173712'; // interstitial
const _kAppOpen = 'ca-app-pub-3940256099942544/9257395921'; // app open
const _kNative = 'ca-app-pub-3940256099942544/2247696110'; // native
const _kBanner = 'ca-app-pub-3940256099942544/6300978111'; // banner
const _kRewarded = 'ca-app-pub-3940256099942544/5224354917'; // rewarded

/// Dev config — Google test IDs.
final kAdsDevConfig = AdsRemoteConfig(
  units: AdUnitsConfig.allWith(
    inter: _kInterstitial,
    appOpen: _kAppOpen,
    native: _kNative,
    banner: _kBanner,
    rewarded: _kRewarded,
  ),
);

/// Prod config — placeholders for real IDs.
final kAdsProdConfig = AdsRemoteConfig(
  units: AdUnitsConfig.allWith(
    inter: 'YOUR_INTER_ID',
    appOpen: 'YOUR_APP_OPEN_ID',
    native: 'YOUR_NATIVE_ID',
    banner: 'YOUR_BANNER_ID',
    rewarded: 'YOUR_REWARDED_ID',
  ),
);
