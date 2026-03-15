// 📁 lib/modules/ads/ad_placement.dart
// Chứa: AdType, AdPlacement (với typed accessor), NativeAdTemplate, AdSizePreset, NativeAdSizeConfig

import '../config/ad_remote_config.dart';

export 'ad_dimensions.dart';

// ─────────────────────────────────────────────────────────────────
// AD TYPE
// ─────────────────────────────────────────────────────────────────

enum AdType { banner, interstitial, rewarded, native, appOpen }

// ─────────────────────────────────────────────────────────────────
// AD PLACEMENT
//
// Mỗi value có:
//   .type        — loại ad
//   .unit(cfg)   — trả về AdUnitConfig typed từ AdUnitsConfig (type-safe)
//   .isEnabled(cfg) — check enable + showAllAds + loại ad
//   .resolveId(cfg) — trả về adUnitId thực tế (có A/B split)
//
// Dùng:
//   AdPlacement.nativeHome.unit(cfg)         → AdUnitConfig
//   AdPlacement.interHome.isEnabled(cfg)     → bool
//   AdPlacement.bannerHome.resolveId(cfg)    → String
// ─────────────────────────────────────────────────────────────────

enum AdPlacement {
  // ── App Open ──────────────────────────────────────────────────
  openSplash(AdType.appOpen),
  openOnResume(AdType.appOpen),
  // ── Interstitial ──────────────────────────────────────────────
  interSplash(AdType.interstitial),
  interFullSplash(AdType.interstitial),
  interHome(AdType.interstitial),
  interBack(AdType.interstitial),
  interBackHome(AdType.interstitial),
  interIntro(AdType.interstitial),
  interPasswordShow(AdType.interstitial),
  interUninstall(AdType.interstitial),
  // ── Banner ────────────────────────────────────────────────────
  bannerHome(AdType.banner),
  // ── Native ────────────────────────────────────────────────────
  nativeHome(AdType.native),
  nativeAll(AdType.native),
  nativeFull(AdType.native),
  nativeFullSplash(AdType.native),
  nativeIntro1(AdType.native),
  nativeIntro2(AdType.native),
  nativeIntro3(AdType.native),
  nativeIntro4(AdType.native),
  nativeLanguage(AdType.native),
  nativeLanguageSelect(AdType.native),
  nativePermission(AdType.native),
  nativePermissionNotification(AdType.native),
  nativeCurrency(AdType.native),
  nativeCurrencySelect(AdType.native),
  nativeExit(AdType.native),
  nativeUninstall(AdType.native),
  // ── Rewarded ──────────────────────────────────────────────────
  rewardPasswordShow(AdType.rewarded),
  rewardDisconnect(AdType.rewarded),
  rewardVideoUnlock(AdType.rewarded);

  const AdPlacement(this.type);
  final AdType type;

  bool get isAppOpen => type == AdType.appOpen;
  bool get isInterstitial => type == AdType.interstitial;
  bool get isNative => type == AdType.native;
  bool get isBanner => type == AdType.banner;
  bool get isRewarded => type == AdType.rewarded;

  // ── Typed accessor → AdUnitsConfig (type-safe, IDE autocomplete) ──

  /// Trả về AdUnitConfig của placement này từ config.
  AdUnitConfig unit(AdsRemoteConfig cfg) => switch (this) {
    openSplash => cfg.units.openSplash,
    openOnResume => cfg.units.openOnResume,
    interSplash => cfg.units.interSplash,
    interFullSplash => cfg.units.interFullSplash,
    interHome => cfg.units.interHome,
    interBack => cfg.units.interBack,
    interBackHome => cfg.units.interBackHome,
    interIntro => cfg.units.interIntro,
    interPasswordShow => cfg.units.interPasswordShow,
    interUninstall => cfg.units.interUninstall,
    bannerHome => cfg.units.bannerHome,
    nativeHome => cfg.units.nativeHome,
    nativeAll => cfg.units.nativeAll,
    nativeFull => cfg.units.nativeFull,
    nativeFullSplash => cfg.units.nativeFullSplash,
    nativeIntro1 => cfg.units.nativeIntro1,
    nativeIntro2 => cfg.units.nativeIntro2,
    nativeIntro3 => cfg.units.nativeIntro3,
    nativeIntro4 => cfg.units.nativeIntro4,
    nativeLanguage => cfg.units.nativeLanguage,
    nativeLanguageSelect => cfg.units.nativeLanguageSelect,
    nativePermission => cfg.units.nativePermission,
    nativePermissionNotification => cfg.units.nativePermissionNotification,
    nativeCurrency => cfg.units.nativeCurrency,
    nativeCurrencySelect => cfg.units.nativeCurrencySelect,
    nativeExit => cfg.units.nativeExit,
    nativeUninstall => cfg.units.nativeUninstall,
    rewardPasswordShow => cfg.units.rewardPasswordShow,
    rewardDisconnect => cfg.units.rewardDisconnect,
    rewardVideoUnlock => cfg.units.rewardVideoUnlock,
  };

  /// Check placement có được bật không (showAllAds + enableAppOpen + unit.enable + isFullAds).
  bool isEnabled(AdsRemoteConfig cfg) {
    if (!AdsUserState.instance.shouldShowAds(cfg)) return false;
    if (isAppOpen && !cfg.enableAppOpen) return false;
    return unit(cfg).enable;
  }

  /// Resolve ad unit ID thực tế (có A/B split nếu id2Rate > 0).
  String resolveId(AdsRemoteConfig cfg) => unit(cfg).resolveId();
}
