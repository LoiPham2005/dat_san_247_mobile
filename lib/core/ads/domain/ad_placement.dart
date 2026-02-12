// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/domain/ad_placement.dart
// ════════════════════════════════════════════════════════════════

/// Ad placement enum - Type-safe, autocomplete-friendly
enum AdPlacement {
  // Splash & App Open
  interSplash('interSplash', AdType.interstitial),
  openSplash('openSplash', AdType.appOpen),
  openOnResume('openOnResume', AdType.appOpen),
  nativeFullSplash('nativeFullSplash', AdType.native),
  interSplashUninstall('interSplashUninstall', AdType.interstitial),

  // Language
  nativeLanguage('nativeLanguage', AdType.native),
  nativeLanguageSelect('nativeLanguageSelect', AdType.native),

  // Intro/Onboarding
  nativeIntro1('nativeIntro1', AdType.native),
  nativeIntro2('nativeIntro2', AdType.native),
  nativeIntro3('nativeIntro3', AdType.native),
  nativeIntro4('nativeIntro4', AdType.native),
  nativeFullIntro2('nativeFullIntro2', AdType.native),
  nativeFullIntro3('nativeFullIntro3', AdType.native),
  nativeIntroFull2('nativeIntroFull2', AdType.native),
  nativeIntroFull3('nativeIntroFull3', AdType.native),
  interIntro('interIntro', AdType.interstitial),

  // Permission
  nativePermission('nativePermission', AdType.native),

  // Home
  bannerHome('bannerHome', AdType.banner),
  interHome('interHome', AdType.interstitial),
  nativeHome('nativeHome', AdType.native),

  // General
  nativeAll('nativeAll', AdType.native),
  nativeFull('nativeFull', AdType.native),

  // Password
  interPasswordShow('interPasswordShow', AdType.interstitial),
  rewardPasswordShow('rewardPasswordShow', AdType.rewarded),

  // Disconnect
  rewardDisconnect('rewardDisconnect', AdType.rewarded),

  // Uninstall
  nativeUninstall('nativeUninstall', AdType.native),
  interUninstall('interUninstall', AdType.interstitial),

  // Navigation
  interBack('interBack', AdType.interstitial);

  const AdPlacement(this.key, this.type);

  /// Key used in RemoteConfig and analytics
  final String key;

  /// Type of ad for this placement
  final AdType type;

  /// Check if this placement is of a specific type
  bool get isInterstitial => type == AdType.interstitial;
  bool get isNative => type == AdType.native;
  bool get isRewarded => type == AdType.rewarded;
  bool get isBanner => type == AdType.banner;
  bool get isAppOpen => type == AdType.appOpen;

  /// Get placement from key string (for backwards compatibility)
  static AdPlacement? fromKey(String key) {
    try {
      return AdPlacement.values.firstWhere((p) => p.key == key);
    } catch (_) {
      return null;
    }
  }
}

/// Ad types supported
enum AdType { banner, interstitial, rewarded, native, appOpen }
