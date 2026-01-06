// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/ad_placement.dart
// ════════════════════════════════════════════════════════════════

/// Ad placement constants
class AdPlacement {
  AdPlacement._();

  // Splash & App Open
  static const String interSplash = 'interSplash';
  static const String openSplash = 'openSplash';
  static const String openOnResume = 'openOnResume';
  static const String nativeFullSplash = 'nativeFullSplash';
  static const String interSplashUninstall = 'interSplashUninstall';

  // Language
  static const String nativeLanguage = 'nativeLanguage';
  static const String nativeLanguageSelect = 'nativeLanguageSelect';

  // Intro/Onboarding
  static const String nativeIntro1 = 'nativeIntro1';
  static const String nativeIntro2 = 'nativeIntro2';
  static const String nativeIntro3 = 'nativeIntro3';
  static const String nativeIntro4 = 'nativeIntro4';
  static const String nativeFullIntro2 = 'nativeFullIntro2';
  static const String nativeFullIntro3 = 'nativeFullIntro3';
  static const String nativeIntroFull2 = 'nativeIntroFull2';
  static const String nativeIntroFull3 = 'nativeIntroFull3';
  static const String interIntro = 'interIntro';

  // Permission
  static const String nativePermission = 'nativePermission';

  // Home
  static const String bannerHome = 'bannerHome';
  static const String interHome = 'interHome';
  static const String nativeHome = 'nativeHome';

  // General
  static const String nativeAll = 'nativeAll';
  static const String nativeFull = 'nativeFull';

  // Password
  static const String interPasswordShow = 'interPasswordShow';
  static const String rewardPasswordShow = 'rewardPasswordShow';

  // Disconnect
  static const String rewardDisconnect = 'rewardDisconnect';

  // Uninstall
  static const String nativeUninstall = 'nativeUninstall';
  static const String interUninstall = 'interUninstall';

  // Navigation
  static const String interBack = 'interBack';

  // Helpers
  static bool isInterstitial(String placement) => placement.startsWith('inter');
  static bool isNative(String placement) => placement.startsWith('native');
  static bool isRewarded(String placement) => placement.startsWith('reward');
  static bool isBanner(String placement) => placement.startsWith('banner');
  static bool isAppOpen(String placement) => placement.startsWith('open');
}
