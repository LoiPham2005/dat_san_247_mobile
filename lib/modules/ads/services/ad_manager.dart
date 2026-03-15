import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/modules/ads/config/ad_remote_config.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

import '../../../core/common/utils/logger.dart';
import '../domain/ad_placements.dart';
import '../widgets/ad_dialog_widgets.dart';
import 'ad_analytics_tracker.dart';
import 'core/ad_frequency.dart';
import 'core/ad_loader_service.dart';
import 'core/ad_store.dart';

// ─────────────────────────────────────────────────────────────────
// AD MANAGER — facade duy nhất. Toàn bộ app chỉ gọi qua class này.
//
// ══ SETUP ══════════════════════════════════════════════════════
// await getIt<AdManager>().initialize();
//
// ══ SPLASH ═════════════════════════════════════════════════════
// await adManager.showSplashSequence(context);
//
// ══ NAVIGATION ═════════════════════════════════════════════════
// adManager.showNavigationAd(context);   // mỗi N lần navigate
// adManager.showBackAd(context);         // khi back trong app
// adManager.showBackHomeAd(context);     // khi back về home
//
// ══ THỦ CÔNG ═══════════════════════════════════════════════════
// adManager.showInterstitial(context, AdPlacement.interHome);
//
// ══ REWARDED ═══════════════════════════════════════════════════
// AdRewardedDialog.show(context: ctx, placement: ..., onRewarded: () {...});
// ─────────────────────────────────────────────────────────────────

@LazySingleton()
class AdManager {
  AdManager(this._loader, this._store, this._tracker, this._cfg);

  final AdLoaderService _loader;
  final AdStore _store;
  final AdAnalyticsTracker _tracker;
  final AdsRemoteConfig _cfg;
  final _freq = AdFrequency();

  bool _inited = false;
  int _navCount = 0;
  static const _navInterval = 3;

  AdsRemoteConfig get config => _cfg;

  // ── Init ──────────────────────────────────────────────────────

  Future<void> initialize({
    dynamic adjustToken,
    dynamic fullAdsOption,
    dynamic iapOptions,
    dynamic adOptions,
  }) async {
    if (_inited) return;
    await _loader.initialize();

    // Adjust: uncomment khi cần
    // if (adjustToken != null) {
    //   await AdjustUtil.instance.initialize(
    //     environment: kDebugMode ? AdjustEnvironment.sandbox : AdjustEnvironment.production,
    //     appToken: adjustToken,
    //     fullAdsOption: fullAdsOption ?? const FullAdsOption(),
    //     iapOptions: iapOptions,
    //     adOptions: AdOptions(
    //       androidAdOptions: AndroidAdOptions(
    //         impressionToken: adOptions?.impressionToken,
    //         fullAdCallback: (isFullAd, network, fromCache, fromLib, fromApi) {
    //           AdsUserState.instance
    //             ..isFullAds = isFullAd
    //             ..fullAdsNetwork = network
    //             ..fullAdsFromCache = fromCache;
    //           adOptions?.fullAdCallback?.call(isFullAd, network, fromCache, fromLib, fromApi);
    //         },
    //       ),
    //       iosAdOptions: IOSAdOptions(
    //         impressionToken: adOptions?.impressionToken,
    //         fullAdCallback: (isFullAd, network, fromCache, fromLib, fromApi) {
    //           AdsUserState.instance
    //             ..isFullAds = isFullAd
    //             ..fullAdsNetwork = network
    //             ..fullAdsFromCache = fromCache;
    //           adOptions?.fullAdCallback?.call(isFullAd, network, fromCache, fromLib, fromApi);
    //         },
    //       ),
    //     ),
    //   );
    // }

    _preloadCritical();
    _inited = true;
  }

  void _preloadCritical() {
    _loader.loadAppOpen(AdPlacement.openSplash);
    _loader.loadAppOpen(AdPlacement.openOnResume);
    _loader.loadInterstitial(AdPlacement.interSplash);
    _loader.loadInterstitial(AdPlacement.interFullSplash);
    _loader.loadInterstitial(AdPlacement.interHome);
    _loader.loadNative(AdPlacement.nativeLanguage);
    _loader.loadNative(AdPlacement.nativeLanguageSelect);
    _loader.loadNative(AdPlacement.nativeIntro1);
    _loader.loadNative(AdPlacement.nativeIntro2);
    _loader.loadInterstitial(AdPlacement.interIntro);
  }

  // ── Splash ────────────────────────────────────────────────────

  /// Gọi ở splash screen. Thử App Open → Inter theo thứ tự priority.
  Future<void> showSplashSequence(BuildContext context) async {
    if (!_cfg.showAllAds || !context.mounted) return;
    if (AdPlacement.openSplash.isEnabled(_cfg)) {
      if (await _showAppOpenWithLoader(context, AdPlacement.openSplash)) return;
    }
    if (context.mounted && AdPlacement.interSplash.isEnabled(_cfg)) {
      if (await _showInterWithLoader(context, AdPlacement.interSplash)) return;
    }
    if (context.mounted && AdPlacement.interFullSplash.isEnabled(_cfg)) {
      await _showInterWithLoader(context, AdPlacement.interFullSplash);
    }
  }

  // ── Resume ────────────────────────────────────────────────────

  /// Gọi bởi AdLifecycleObserver khi app resume đủ interval.
  Future<void> showOnResumeAd() async {
    final ok = await _freq.canShow(
      AdPlacement.openOnResume,
      minInterval: Duration(seconds: _cfg.appOpenInterval),
      maxPerSession: 5,
    );
    if (!ok) return;
    if (await _showFullScreen(AdPlacement.openOnResume)) {
      await _freq.markShown(AdPlacement.openOnResume);
    }
  }

  // ── Interstitial ──────────────────────────────────────────────

  /// Show interstitial. Tự load nếu chưa sẵn sàng.
  Future<bool> showInterstitial(BuildContext context, AdPlacement p) async {
    if (!p.isEnabled(_cfg)) return false;
    if (_store.isReady(p)) return _showFullScreen(p);
    if (!context.mounted) return false;
    return _showInterWithLoader(context, p);
  }

  // ── Navigation helpers ────────────────────────────────────────

  /// Gọi mỗi khi navigate — tự show sau mỗi [_navInterval] lần.
  Future<void> showNavigationAd(BuildContext context) async {
    if (++_navCount < _navInterval) return;
    final ok = await _freq.canShow(
      AdPlacement.interHome,
      minInterval: Duration(seconds: _cfg.interInterval),
      maxPerSession: _cfg.maxInterPerSession,
    );
    if (!ok) return;
    if (await showInterstitial(context, AdPlacement.interHome)) {
      _navCount = 0;
      await _freq.markShown(AdPlacement.interHome);
    }
  }

  /// Gọi khi user back về home screen.
  Future<void> showBackHomeAd(BuildContext context) async {
    final p = AdPlacement.interBackHome.isEnabled(_cfg)
        ? AdPlacement.interBackHome
        : AdPlacement.interBack;
    final ok = await _freq.canShow(p, minInterval: const Duration(seconds: 30));
    if (!ok) return;
    if (await showInterstitial(context, p)) await _freq.markShown(p);
  }

  /// Gọi khi user back trong app.
  Future<void> showBackAd(BuildContext context) async {
    final ok = await _freq.canShow(AdPlacement.interBack, minInterval: const Duration(seconds: 45));
    if (!ok) return;
    if (await showInterstitial(context, AdPlacement.interBack)) {
      await _freq.markShown(AdPlacement.interBack);
    }
  }

  // ── Rewarded ──────────────────────────────────────────────────

  /// Load + show rewarded ad. Gọi từ AdRewardedDialog.
  Future<bool> showRewardedAd({required AdPlacement p, required VoidCallback onRewarded}) async {
    if (!_store.isReady(p)) await _loader.loadRewarded(p);
    if (!_store.isReady(p)) return false;
    final shown = await _showFullScreen(p, onReward: (_, __) => onRewarded());
    if (shown) await _freq.markShown(p);
    return shown;
  }

  // ── Native overlay ────────────────────────────────────────────

  Future<void> showNativeFullOverlay() async {
    if (!_store.isReady(AdPlacement.nativeFull)) {
      await _loader.loadNative(AdPlacement.nativeFull);
    }
    if (_store.isReady(AdPlacement.nativeFull)) {
      await SmartDialog.show(
        builder: (_) => const AdNativeFullDialog(placement: AdPlacement.nativeFull),
        backDismiss: true,
        clickMaskDismiss: false,
      );
    }
  }

  // ── Native & Banner ───────────────────────────────────────────

  Future<BannerAd?> loadBanner(AdPlacement p, {AdSize? size, AdSizePreset? preset}) =>
      _loader.loadBanner(p, size: size, preset: preset);

  Future<NativeAd?> loadNative(AdPlacement p, {NativeTemplateStyle? style}) =>
      _loader.loadNative(p, style: style);

  NativeAd? getNative(AdPlacement p) => _store.natives[p.name]?.ad;
  BannerAd? getBanner(AdPlacement p) => _store.banners[p.name]?.ad;

  void disposeNative(AdPlacement p) {
    _store.natives[p.name]?.ad.dispose();
    _store.natives.remove(p.name);
    _store.states.remove(p.name);
  }

  void disposeBanner(AdPlacement p) {
    _store.banners[p.name]?.ad.dispose();
    _store.banners.remove(p.name);
    _store.states.remove(p.name);
  }

  // ── Lifecycle ─────────────────────────────────────────────────

  void onLifecycle(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _store.isBackground = true;
      final n = _store.disposeExpired();
      if (n > 0) Logger.info('🧹 $n expired ads disposed', tag: 'ADS');
    } else if (state == AppLifecycleState.resumed) {
      _store.isBackground = false;
      _preloadCritical();
    }
  }

  Future<void> dispose() => _freq.reset();

  // ── Private: unified full-screen show ────────────────────────
  //
  // Gộp _showInter / _showAppOpen / _showRewarded thành 1 method.
  // Dart không có sealed ad base class nên dùng dynamic dispatch.
  // onReward chỉ dùng cho RewardedAd, các loại khác bỏ qua.

  Future<bool> _showFullScreen(
    AdPlacement p, {
    void Function(AdWithoutView, RewardItem)? onReward,
  }) async {
    final Ad? ad = switch (p.type) {
      AdType.interstitial =>
        _store.interstitials[p.name]?.isValid == true ? _store.interstitials[p.name]!.ad : null,
      AdType.appOpen =>
        _store.appOpens[p.name]?.isValid == true ? _store.appOpens[p.name]!.ad : null,
      AdType.rewarded =>
        _store.rewarded[p.name]?.isValid == true ? _store.rewarded[p.name]!.ad : null,
      _ => null,
    };
    if (ad == null) return false;

    final c = Completer<bool>();

    final cb = FullScreenContentCallback<Ad>(
      onAdShowedFullScreenContent: (_) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        _tracker.onImpression(p);
        if (!c.isCompleted) c.complete(true);
      },
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        _removeFromStore(p);
        _tracker.onDismissed(p);
        _onAfterDismiss(p);
      },
      onAdFailedToShowFullScreenContent: (shownAd, err) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        shownAd.dispose();
        _removeFromStore(p);
        _tracker.onShowFail(p, code: err.code.toString());
        if (!c.isCompleted) c.complete(false);
      },
      onAdClicked: (_) => _tracker.onClicked(p),
    );

    if (ad is InterstitialAd) {
      ad.fullScreenContentCallback = cb as FullScreenContentCallback<InterstitialAd>;
      await ad.show();
    } else if (ad is AppOpenAd) {
      ad.fullScreenContentCallback = cb as FullScreenContentCallback<AppOpenAd>;
      await ad.show();
    } else if (ad is RewardedAd) {
      ad.fullScreenContentCallback = cb as FullScreenContentCallback<RewardedAd>;
      await ad.show(onUserEarnedReward: onReward ?? (_, __) {});
    }

    return c.future;
  }

  void _removeFromStore(AdPlacement p) {
    switch (p.type) {
      case AdType.interstitial:
        _store.interstitials.remove(p.name);
        _store.lastInterShow = DateTime.now();
      case AdType.appOpen:
        _store.appOpens.remove(p.name);
      case AdType.rewarded:
        _store.rewarded.remove(p.name);
      default:
        break;
    }
  }

  void _onAfterDismiss(AdPlacement p) {
    switch (p.type) {
      case AdType.interstitial:
        if (_cfg.nativeFullAfterInter) showNativeFullOverlay();
        _loader.loadInterstitial(p);
      case AdType.rewarded:
        if (_cfg.nativeFullAfterInter) showNativeFullOverlay();
        _loader.loadRewarded(p);
      default:
        break;
    }
  }

  // ── Private: loaders với UI ───────────────────────────────────

  Future<bool> _showInterWithLoader(
    BuildContext context,
    AdPlacement p, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (_store.isReady(p)) return _showFullScreen(p);
    if (!context.mounted) return false;
    SmartDialog.showLoading();
    try {
      final ok = await _loader
          .loadInterstitial(p, force: true)
          .timeout(timeout, onTimeout: () => false);
      if (ok && context.mounted) return _showFullScreen(p);
      SmartDialog.dismiss(status: SmartStatus.loading);
      return false;
    } catch (_) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      return false;
    }
  }

  Future<bool> _showAppOpenWithLoader(
    BuildContext context,
    AdPlacement p, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (_store.isReady(p)) return _showFullScreen(p);
    if (!context.mounted) return false;
    unawaited(
      showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (_) => const AdAppOpenLoader(),
      ),
    );
    try {
      final ok = await _loader.loadAppOpen(p).timeout(timeout, onTimeout: () => false);
      if (ok && context.mounted) return _showFullScreen(p);
      return false;
    } catch (_) {
      return false;
    } finally {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
