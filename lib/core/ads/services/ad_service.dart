// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/services/ad_service.dart (OPTIMIZED)
// ════════════════════════════════════════════════════════════════

// ignore_for_file: unawaited_futures

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/ads/config/ad_config.dart';
import 'package:dat_san_247_mobile/core/ads/domain/ad_placement.dart';
import 'package:dat_san_247_mobile/core/ads/services/ad_analytics_tracker.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

/// Ad loading state for UI feedback
enum AdLoadState { idle, loading, loaded, failed }

/// Ad cache entry with expiration
class _AdCacheEntry<T> {
  _AdCacheEntry(this.ad, this.loadedAt);

  final T ad;
  final DateTime loadedAt;

  bool get isExpired {
    final age = DateTime.now().difference(loadedAt);
    return age.inHours >= 1; // Ads expire after 1 hour
  }
}

/// Low-level ad service - handles loading and showing ads (OPTIMIZED)
@LazySingleton()
class AdService {
  AdService(this._config, this._analyticsTracker);

  final AdConfig _config;
  final AdAnalyticsTracker _analyticsTracker;

  // Ad storage with cache entries
  final Map<String, _AdCacheEntry<BannerAd>?> _banners = {};
  final Map<String, _AdCacheEntry<InterstitialAd>?> _interstitials = {};
  final Map<String, _AdCacheEntry<RewardedAd>?> _rewarded = {};
  final Map<String, _AdCacheEntry<NativeAd>?> _natives = {};
  final Map<String, _AdCacheEntry<AppOpenAd>?> _appOpens = {};

  // Loading states
  final Map<String, AdLoadState> _loadStates = {};
  final Map<String, Completer<void>> _loadingCompleters = {};

  // Retry configuration with exponential backoff
  static const int _maxRetries = 3;
  static const Duration _baseRetryDelay = Duration(seconds: 2);

  // Tracking
  DateTime? _lastInterstitialShow;
  bool _isInitialized = false;
  bool _isInBackground = false;

  // ═══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      Logger.success('✅ Ads initialized', tag: 'ADS');
    } catch (e) {
      Logger.error('❌ Ads init failed', error: e, tag: 'ADS');
    }
  }

  bool get isInitialized => _isInitialized;

  /// Get load state for a placement
  AdLoadState getLoadState(AdPlacement placement) {
    return _loadStates[placement.key] ?? AdLoadState.idle;
  }

  /// Handle app lifecycle changes
  void onAppLifecycleChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _isInBackground = true;
      _disposeExpiredAds();
    } else if (state == AppLifecycleState.resumed) {
      _isInBackground = false;
      _reloadExpiredAds();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // BANNER
  // ═══════════════════════════════════════════════════════════════

  Future<BannerAd?> loadBanner(AdPlacement placement, {AdSize? size, int retryCount = 0}) async {
    if (!_canLoad(placement)) return null;

    // Check cache
    final cached = _banners[placement.key];
    if (cached != null && !cached.isExpired) {
      Logger.info('📦 Using cached banner: ${placement.key}', tag: 'ADS');
      return cached.ad;
    }

    // Prevent duplicate loading
    if (_loadingCompleters.containsKey(placement.key)) {
      await _loadingCompleters[placement.key]!.future;
      return _banners[placement.key]?.ad;
    }

    final completer = Completer<void>();
    _loadingCompleters[placement.key] = completer;

    final adId = _config.getAdIdFor(placement);
    if (adId.isEmpty) {
      completer.complete();
      _loadingCompleters.remove(placement.key);
      return null;
    }

    _loadStates[placement.key] = AdLoadState.loading;

    try {
      final banner = BannerAd(
        adUnitId: adId,
        size: size ?? AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            Logger.success('✅ Banner loaded: ${placement.key}', tag: 'ADS');
            _banners[placement.key] = _AdCacheEntry(ad as BannerAd, DateTime.now());
            _loadStates[placement.key] = AdLoadState.loaded;
            completer.complete();
          },
          onAdFailedToLoad: (ad, error) async {
            Logger.error('❌ Banner failed: ${placement.key} - ${error.message}', tag: 'ADS');
            ad.dispose();
            _banners[placement.key] = null;
            _loadStates[placement.key] = AdLoadState.failed;

            // Exponential backoff retry
            if (retryCount < _maxRetries) {
              final delay = _getRetryDelay(retryCount);
              await Future.delayed(delay);
              await loadBanner(placement, size: size, retryCount: retryCount + 1);
            }
            completer.complete();
          },
          onAdClicked: (ad) => _logAdEvent(placement, 'click'),
          onAdImpression: (ad) => _logAdEvent(placement, 'impression'),
        ),
      );

      await banner.load();
      await completer.future;
    } finally {
      _loadingCompleters.remove(placement.key);
    }

    return _banners[placement.key]?.ad;
  }

  BannerAd? getBanner(AdPlacement placement) => _banners[placement.key]?.ad;

  void disposeBanner(AdPlacement placement) {
    _banners[placement.key]?.ad.dispose();
    _banners.remove(placement.key);
    _loadStates.remove(placement.key);
  }

  // ═══════════════════════════════════════════════════════════════
  // INTERSTITIAL (OPTIMIZED)
  // ═══════════════════════════════════════════════════════════════

  Future<bool> loadInterstitial(
    AdPlacement placement, {
    int retryCount = 0,
    bool force = false,
  }) async {
    if (!_canLoad(placement)) return false;
    if (!force && !_checkCooldown()) return false;

    // Check cache
    final cached = _interstitials[placement.key];
    if (cached != null && !cached.isExpired) {
      Logger.info('📦 Using cached interstitial: ${placement.key}', tag: 'ADS');
      return true;
    }

    // Prevent duplicate loading
    if (_loadingCompleters.containsKey(placement.key)) {
      await _loadingCompleters[placement.key]!.future;
      return _interstitials[placement.key] != null;
    }

    final completer = Completer<void>();
    _loadingCompleters[placement.key] = completer;

    final adId = _config.getAdIdFor(placement);
    if (adId.isEmpty) {
      completer.complete();
      _loadingCompleters.remove(placement.key);
      return false;
    }

    _loadStates[placement.key] = AdLoadState.loading;

    try {
      await InterstitialAd.load(
        adUnitId: adId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitials[placement.key] = _AdCacheEntry(ad, DateTime.now());
            _loadStates[placement.key] = AdLoadState.loaded;
            Logger.success('✅ Interstitial loaded: ${placement.key}', tag: 'ADS');

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                _lastInterstitialShow = DateTime.now();
                ad.dispose();
                _interstitials.remove(placement.key);
                _logAdEvent(placement, 'dismissed');
                // Preload next in background
                Future.delayed(Duration.zero, () => loadInterstitial(placement));
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                Logger.error('❌ Show failed: ${placement.key}', tag: 'ADS');
                ad.dispose();
                _interstitials.remove(placement.key);
                _logAdEvent(placement, 'show_failed');
              },
              onAdShowedFullScreenContent: (ad) => _logAdEvent(placement, 'impression'),
              onAdClicked: (ad) => _logAdEvent(placement, 'click'),
            );

            completer.complete();
          },
          onAdFailedToLoad: (error) async {
            Logger.error('❌ Interstitial failed: ${placement.key} - ${error.message}', tag: 'ADS');
            _loadStates[placement.key] = AdLoadState.failed;

            // Exponential backoff retry
            if (retryCount < _maxRetries) {
              final delay = _getRetryDelay(retryCount);
              await Future.delayed(delay);
              await loadInterstitial(placement, retryCount: retryCount + 1);
            }
            completer.complete();
          },
        ),
      );

      await completer.future;
    } finally {
      _loadingCompleters.remove(placement.key);
    }

    return _interstitials[placement.key] != null;
  }

  Future<bool> showInterstitial(AdPlacement placement) async {
    final cached = _interstitials[placement.key];
    if (cached == null || cached.isExpired) {
      Logger.warning('⚠️ Interstitial not loaded or expired: ${placement.key}', tag: 'ADS');

      // Try to load immediately
      final loaded = await loadInterstitial(placement, force: true);
      if (!loaded) return false;
    }

    final ad = _interstitials[placement.key]?.ad;
    if (ad == null) return false;

    await ad.show();
    return true;
  }

  bool isInterstitialLoaded(AdPlacement placement) {
    final cached = _interstitials[placement.key];
    return cached != null && !cached.isExpired;
  }

  bool _checkCooldown() {
    if (_lastInterstitialShow == null) return true;

    final elapsed = DateTime.now().difference(_lastInterstitialShow!);
    return elapsed.inSeconds >= _config.interInterval;
  }

  // ═══════════════════════════════════════════════════════════════
  // REWARDED (OPTIMIZED)
  // ═══════════════════════════════════════════════════════════════

  Future<bool> loadRewarded(AdPlacement placement, {int retryCount = 0}) async {
    if (!_canLoad(placement)) return false;

    // Check cache
    final cached = _rewarded[placement.key];
    if (cached != null && !cached.isExpired) {
      Logger.info('📦 Using cached rewarded: ${placement.key}', tag: 'ADS');
      return true;
    }

    // Prevent duplicate loading
    if (_loadingCompleters.containsKey(placement.key)) {
      await _loadingCompleters[placement.key]!.future;
      return _rewarded[placement.key] != null;
    }

    final completer = Completer<void>();
    _loadingCompleters[placement.key] = completer;

    final adId = _config.getAdIdFor(placement);
    if (adId.isEmpty) {
      completer.complete();
      _loadingCompleters.remove(placement.key);
      return false;
    }

    _loadStates[placement.key] = AdLoadState.loading;

    try {
      await RewardedAd.load(
        adUnitId: adId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewarded[placement.key] = _AdCacheEntry(ad, DateTime.now());
            _loadStates[placement.key] = AdLoadState.loaded;
            Logger.success('✅ Rewarded loaded: ${placement.key}', tag: 'ADS');
            completer.complete();
          },
          onAdFailedToLoad: (error) async {
            Logger.error('❌ Rewarded failed: ${placement.key} - ${error.message}', tag: 'ADS');
            _loadStates[placement.key] = AdLoadState.failed;

            // Exponential backoff retry
            if (retryCount < _maxRetries) {
              final delay = _getRetryDelay(retryCount);
              await Future.delayed(delay);
              await loadRewarded(placement, retryCount: retryCount + 1);
            }
            completer.complete();
          },
        ),
      );

      await completer.future;
    } finally {
      _loadingCompleters.remove(placement.key);
    }

    return _rewarded[placement.key] != null;
  }

  Future<bool> showRewarded(
    AdPlacement placement, {
    required Function(AdWithoutView, RewardItem) onReward,
  }) async {
    final cached = _rewarded[placement.key];
    if (cached == null || cached.isExpired) {
      Logger.warning('⚠️ Rewarded not loaded or expired: ${placement.key}', tag: 'ADS');
      return false;
    }

    final ad = cached.ad;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewarded.remove(placement.key);
        _logAdEvent(placement, 'dismissed');
        // Preload next in background
        Future.delayed(Duration.zero, () => loadRewarded(placement));
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewarded.remove(placement.key);
        _logAdEvent(placement, 'show_failed');
      },
      onAdShowedFullScreenContent: (ad) => _logAdEvent(placement, 'impression'),
      onAdClicked: (ad) => _logAdEvent(placement, 'click'),
    );

    await ad.show(onUserEarnedReward: onReward);
    _logAdEvent(placement, 'reward_earned');
    return true;
  }

  bool isRewardedLoaded(AdPlacement placement) {
    final cached = _rewarded[placement.key];
    return cached != null && !cached.isExpired;
  }

  // ═══════════════════════════════════════════════════════════════
  // NATIVE (OPTIMIZED)
  // ═══════════════════════════════════════════════════════════════

  Future<NativeAd?> loadNative(
    AdPlacement placement, {
    NativeTemplateStyle? templateStyle,
    int retryCount = 0,
  }) async {
    if (!_canLoad(placement)) return null;

    // Check cache
    final cached = _natives[placement.key];
    if (cached != null && !cached.isExpired) {
      Logger.info('📦 Using cached native: ${placement.key}', tag: 'ADS');
      return cached.ad;
    }

    // Prevent duplicate loading
    if (_loadingCompleters.containsKey(placement.key)) {
      await _loadingCompleters[placement.key]!.future;
      return _natives[placement.key]?.ad;
    }

    final completer = Completer<void>();
    _loadingCompleters[placement.key] = completer;

    final adId = _config.getAdIdFor(placement);
    if (adId.isEmpty) {
      completer.complete();
      _loadingCompleters.remove(placement.key);
      return null;
    }

    _loadStates[placement.key] = AdLoadState.loading;

    try {
      final native = NativeAd(
        adUnitId: adId,
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            Logger.success('✅ Native loaded: ${placement.key}', tag: 'ADS');
            _natives[placement.key] = _AdCacheEntry(ad as NativeAd, DateTime.now());
            _loadStates[placement.key] = AdLoadState.loaded;
            completer.complete();
          },
          onAdFailedToLoad: (ad, error) async {
            Logger.error('❌ Native failed: ${placement.key} - ${error.message}', tag: 'ADS');
            ad.dispose();
            _natives[placement.key] = null;
            _loadStates[placement.key] = AdLoadState.failed;

            // Exponential backoff retry
            if (retryCount < _maxRetries) {
              final delay = _getRetryDelay(retryCount);
              await Future.delayed(delay);
              await loadNative(placement, templateStyle: templateStyle, retryCount: retryCount + 1);
            }
            completer.complete();
          },
          onAdClicked: (ad) => _logAdEvent(placement, 'click'),
          onAdImpression: (ad) => _logAdEvent(placement, 'impression'),
        ),
        nativeTemplateStyle:
            templateStyle ??
            NativeTemplateStyle(
              templateType: TemplateType.medium,
              mainBackgroundColor: const Color(0xFFFFFFFF),
              cornerRadius: 10.0,
            ),
      );

      await native.load();
      await completer.future;
    } finally {
      _loadingCompleters.remove(placement.key);
    }

    return _natives[placement.key]?.ad;
  }

  NativeAd? getNative(AdPlacement placement) => _natives[placement.key]?.ad;

  void disposeNative(AdPlacement placement) {
    _natives[placement.key]?.ad.dispose();
    _natives.remove(placement.key);
    _loadStates.remove(placement.key);
  }

  // ═══════════════════════════════════════════════════════════════
  // APP OPEN (OPTIMIZED)
  // ═══════════════════════════════════════════════════════════════

  Future<bool> loadAppOpen(AdPlacement placement, {int retryCount = 0}) async {
    if (!_canLoad(placement)) return false;

    // Check cache
    final cached = _appOpens[placement.key];
    if (cached != null && !cached.isExpired) {
      Logger.info('📦 Using cached app open: ${placement.key}', tag: 'ADS');
      return true;
    }

    // Prevent duplicate loading
    if (_loadingCompleters.containsKey(placement.key)) {
      await _loadingCompleters[placement.key]!.future;
      return _appOpens[placement.key] != null;
    }

    final completer = Completer<void>();
    _loadingCompleters[placement.key] = completer;

    final adId = _config.getAdIdFor(placement);
    if (adId.isEmpty) {
      completer.complete();
      _loadingCompleters.remove(placement.key);
      return false;
    }

    _loadStates[placement.key] = AdLoadState.loading;

    try {
      await AppOpenAd.load(
        adUnitId: adId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpens[placement.key] = _AdCacheEntry(ad, DateTime.now());
            _loadStates[placement.key] = AdLoadState.loaded;
            Logger.success('✅ App Open loaded: ${placement.key}', tag: 'ADS');
            completer.complete();
          },
          onAdFailedToLoad: (error) async {
            Logger.error('❌ App Open failed: ${placement.key} - ${error.message}', tag: 'ADS');
            _loadStates[placement.key] = AdLoadState.failed;

            // Exponential backoff retry
            if (retryCount < _maxRetries) {
              final delay = _getRetryDelay(retryCount);
              await Future.delayed(delay);
              await loadAppOpen(placement, retryCount: retryCount + 1);
            }
            completer.complete();
          },
        ),
      );

      await completer.future;
    } finally {
      _loadingCompleters.remove(placement.key);
    }

    return _appOpens[placement.key] != null;
  }

  Future<bool> showAppOpen(AdPlacement placement) async {
    final cached = _appOpens[placement.key];
    if (cached == null || cached.isExpired) {
      Logger.warning('⚠️ App Open not loaded or expired: ${placement.key}', tag: 'ADS');
      return false;
    }

    final ad = cached.ad;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpens.remove(placement.key);
        _logAdEvent(placement, 'dismissed');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _appOpens.remove(placement.key);
        _logAdEvent(placement, 'show_failed');
      },
      onAdShowedFullScreenContent: (ad) => _logAdEvent(placement, 'impression'),
      onAdClicked: (ad) => _logAdEvent(placement, 'click'),
    );

    await ad.show();
    return true;
  }

  bool isAppOpenLoaded(AdPlacement placement) {
    final cached = _appOpens[placement.key];
    return cached != null && !cached.isExpired;
  }

  // ═══════════════════════════════════════════════════════════════
  // UTILITIES (OPTIMIZED)
  // ═══════════════════════════════════════════════════════════════

  bool _canLoad(AdPlacement placement) {
    if (!_isInitialized) {
      Logger.warning('⚠️ Ads not initialized', tag: 'ADS');
      return false;
    }

    if (_isInBackground) {
      Logger.warning('⚠️ App in background, skip loading', tag: 'ADS');
      return false;
    }

    if (!_config.isPlacementEnabled(placement)) {
      Logger.warning('⚠️ Placement disabled: ${placement.key}', tag: 'ADS');
      return false;
    }

    return true;
  }

  /// Get retry delay with exponential backoff
  Duration _getRetryDelay(int retryCount) {
    final multiplier = math.pow(2, retryCount).toInt();
    return _baseRetryDelay * multiplier;
  }

  /// Dispose expired ads to free memory
  void _disposeExpiredAds() {
    Logger.info('🧹 Cleaning expired ads', tag: 'ADS');

    _banners.removeWhere((key, entry) {
      if (entry != null && entry.isExpired) {
        entry.ad.dispose();
        return true;
      }
      return false;
    });

    _interstitials.removeWhere((key, entry) {
      if (entry != null && entry.isExpired) {
        entry.ad.dispose();
        return true;
      }
      return false;
    });

    _rewarded.removeWhere((key, entry) {
      if (entry != null && entry.isExpired) {
        entry.ad.dispose();
        return true;
      }
      return false;
    });

    _natives.removeWhere((key, entry) {
      if (entry != null && entry.isExpired) {
        entry.ad.dispose();
        return true;
      }
      return false;
    });

    _appOpens.removeWhere((key, entry) {
      if (entry != null && entry.isExpired) {
        entry.ad.dispose();
        return true;
      }
      return false;
    });
  }

  /// Reload expired ads when app resumes
  Future<void> _reloadExpiredAds() async {
    Logger.info('🔄 Reloading expired ads', tag: 'ADS');

    // Only reload critical ads
    final criticalPlacements = [
      AdPlacement.interSplash,
      AdPlacement.openSplash,
      AdPlacement.interHome,
    ];

    for (final placement in criticalPlacements) {
      switch (placement.type) {
        case AdType.interstitial:
          if (!isInterstitialLoaded(placement)) {
            loadInterstitial(placement);
          }
          break;
        case AdType.appOpen:
          if (!isAppOpenLoaded(placement)) {
            loadAppOpen(placement);
          }
          break;
        default:
          break;
      }
    }
  }

  void _logAdEvent(AdPlacement placement, String event) {
    Logger.info('📊 Ad event: ${placement.key} - $event', tag: 'ADS');
    // TODO: Add Firebase Analytics or other analytics here
    // FirebaseAnalytics.instance.logEvent(
    //   name: 'ad_$event',
    //   parameters: {'placement': placement.key, 'type': placement.type.name},
    // );
  }

  void disposeAll() {
    for (var entry in _banners.values) {
      entry?.ad.dispose();
    }
    for (var entry in _interstitials.values) {
      entry?.ad.dispose();
    }
    for (var entry in _rewarded.values) {
      entry?.ad.dispose();
    }
    for (var entry in _natives.values) {
      entry?.ad.dispose();
    }
    for (var entry in _appOpens.values) {
      entry?.ad.dispose();
    }

    _banners.clear();
    _interstitials.clear();
    _rewarded.clear();
    _natives.clear();
    _appOpens.clear();
    _loadStates.clear();
    _loadingCompleters.clear();
  }
}
