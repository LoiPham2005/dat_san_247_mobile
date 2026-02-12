// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/services/ad_manager.dart (OPTIMIZED)
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/ads/config/ad_config.dart';
import 'package:injectable/injectable.dart';

import '../../utils/logger.dart';
import '../domain/ad_frequency.dart';
import '../domain/ad_placement.dart';
import 'ad_service.dart';

/// High-level ad manager with intelligent preloading and frequency control
@LazySingleton()
class AdManager {
  AdManager(this._service, this._config);

  final AdService _service;
  final AdConfig _config;
  final _frequency = AdFrequency();

  int _navCount = 0;
  bool _isInitialized = false;

  // ═══════════════════════════════════════════════════════════════
  // INITIALIZATION (OPTIMIZED)
  // ═══════════════════════════════════════════════════════════════

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _service.initialize();

    // Preload critical ads with priority queue (sequential to avoid overload)
    await _preloadCriticalAds();

    _isInitialized = true;
  }

  /// Preload critical ads sequentially with delay to prevent crashes
  Future<void> _preloadCriticalAds() async {
    // Priority 1: Splash ads (most important)
    await _service.loadAppOpen(AdPlacement.openSplash);
    await Future.delayed(const Duration(milliseconds: 300));

    await _service.loadInterstitial(AdPlacement.interSplash);
    await Future.delayed(const Duration(milliseconds: 300));

    // Priority 2: Home ads (load in background)
    _service.loadInterstitial(AdPlacement.interHome);
    await Future.delayed(const Duration(milliseconds: 300));

    // Priority 3: Resume ad
    _service.loadAppOpen(AdPlacement.openOnResume);
  }

  /// Get service for low-level operations
  AdService get service => _service;

  /// Get config for checking settings
  AdConfig get config => _config;

  /// Get frequency manager for external access
  AdFrequency get frequency => _frequency;

  // ═══════════════════════════════════════════════════════════════
  // SPLASH (OPTIMIZED)
  // ═══════════════════════════════════════════════════════════════

  Future<bool> showSplashAppOpen() async {
    if (!_canShow(AdPlacement.openSplash)) return false;

    // Check frequency with enhanced controls
    final canShow = await _frequency.canShowPlacement(
      AdPlacement.openSplash,
      maxPerSession: 1, // Only once per session
      maxPerDay: 3, // Max 3 times per day
    );

    if (!canShow) return false;

    final shown = await _service.showAppOpen(AdPlacement.openSplash);
    if (shown) await _frequency.markPlacementShown(AdPlacement.openSplash);

    return shown;
  }

  Future<bool> showSplashInterstitial() async {
    if (!_canShow(AdPlacement.interSplash)) return false;

    // Check frequency
    final canShow = await _frequency.canShowPlacement(
      AdPlacement.interSplash,
      maxPerSession: 1, // Only once per session
      maxPerDay: 3,
    );

    if (!canShow) return false;

    final shown = await _service.showInterstitial(AdPlacement.interSplash);
    if (shown) await _frequency.markPlacementShown(AdPlacement.interSplash);

    return shown;
  }

  // ═══════════════════════════════════════════════════════════════
  // NAVIGATION (OPTIMIZED WITH INTELLIGENT FREQUENCY)
  // ═══════════════════════════════════════════════════════════════

  Future<void> showNavigationAd() async {
    _navCount++;

    // Check basic interval
    if (_navCount < _config.interInterval) return;

    // Enhanced frequency control
    final canShow = await _frequency.canShowPlacement(
      AdPlacement.interHome,
      minInterval: Duration(seconds: _config.interInterval),
      maxPerSession: 10, // Max 10 per session
      maxPerHour: 6, // Max 6 per hour
      maxPerDay: 20, // Max 20 per day
    );

    if (!canShow) return;

    // Check for spam
    if (_frequency.isSpamming(AdPlacement.interHome.key)) {
      Logger.warning('⚠️ Ad spam detected, skipping', tag: 'ADS');
      return;
    }

    final shown = await _service.showInterstitial(AdPlacement.interHome);

    if (shown) {
      _navCount = 0;
      await _frequency.markPlacementShown(AdPlacement.interHome);
    }
  }

  Future<void> showBackAd() async {
    final canShow = await _frequency.canShowPlacement(
      AdPlacement.interBack,
      minInterval: const Duration(seconds: 45), // Increased from 30s
      maxPerSession: 5,
      maxPerHour: 3,
    );

    if (!canShow) return;

    final shown = await _service.showInterstitial(AdPlacement.interBack);
    if (shown) await _frequency.markPlacementShown(AdPlacement.interBack);
  }

  // ═══════════════════════════════════════════════════════════════
  // REWARDED (ENHANCED)
  // ═══════════════════════════════════════════════════════════════

  Future<bool> showRewardedAd({
    required AdPlacement placement,
    required VoidCallback onRewarded,
  }) async {
    // Ensure loaded
    final loaded = await _service.loadRewarded(placement);
    if (!loaded) {
      Logger.warning('⚠️ Rewarded ad not available: ${placement.key}', tag: 'ADS');
      return false;
    }

    var earned = false;

    final shown = await _service.showRewarded(
      placement,
      onReward: (ad, reward) {
        earned = true;
        onRewarded();
      },
    );

    if (shown) await _frequency.markPlacementShown(placement);

    return earned;
  }

  // ═══════════════════════════════════════════════════════════════
  // APP LIFECYCLE (OPTIMIZED)
  // ═══════════════════════════════════════════════════════════════

  Future<void> showOnResumeAd() async {
    final canShow = await _frequency.canShowPlacement(
      AdPlacement.openOnResume,
      minInterval: const Duration(minutes: 5),
      maxPerSession: 3,
      maxPerDay: 8,
    );

    if (!canShow) return;

    final shown = await _service.showAppOpen(AdPlacement.openOnResume);
    if (shown) await _frequency.markPlacementShown(AdPlacement.openOnResume);
  }

  /// Handle app lifecycle state changes
  void onAppLifecycleChanged(AppLifecycleState state) {
    _service.onAppLifecycleChanged(state);

    if (state == AppLifecycleState.resumed) {
      // Preload critical ads when app resumes
      _preloadCriticalAds();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PRELOADING (INTELLIGENT & OPTIMIZED)
  // ═══════════════════════════════════════════════════════════════

  Future<void> preloadForScreen(String screen) async {
    switch (screen) {
      case 'intro':
        // Preload sequentially with delays
        await _service.loadNative(AdPlacement.nativeIntro1);
        await Future.delayed(const Duration(milliseconds: 200));
        _service.loadInterstitial(AdPlacement.interIntro);
        break;

      case 'language':
        await _service.loadNative(AdPlacement.nativeLanguageSelect);
        break;

      case 'password':
        await _service.loadRewarded(AdPlacement.rewardPasswordShow);
        break;

      case 'home':
        // Preload home ads if not loaded
        if (!_service.isInterstitialLoaded(AdPlacement.interHome)) {
          _service.loadInterstitial(AdPlacement.interHome);
        }
        break;
    }
  }

  /// Preload ads for specific placements with intelligent sequencing
  Future<void> preloadPlacements(List<AdPlacement> placements) async {
    // Sort by priority (interstitial > rewarded > native > banner)
    final sorted = List<AdPlacement>.from(placements)
      ..sort((a, b) {
        const priority = {
          AdType.interstitial: 1,
          AdType.appOpen: 1,
          AdType.rewarded: 2,
          AdType.native: 3,
          AdType.banner: 4,
        };
        return (priority[a.type] ?? 5).compareTo(priority[b.type] ?? 5);
      });

    // Load sequentially with delays to prevent crashes
    for (final placement in sorted) {
      switch (placement.type) {
        case AdType.banner:
          await _service.loadBanner(placement);
          break;
        case AdType.interstitial:
          await _service.loadInterstitial(placement);
          break;
        case AdType.rewarded:
          await _service.loadRewarded(placement);
          break;
        case AdType.native:
          await _service.loadNative(placement);
          break;
        case AdType.appOpen:
          await _service.loadAppOpen(placement);
          break;
      }

      // Add delay between loads to prevent overload
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  /// Preload next ad in background (smart prefetch)
  Future<void> prefetchNextAd(AdPlacement currentPlacement) async {
    // Define common sequences
    final sequences = {
      AdPlacement.interSplash: [AdPlacement.interHome],
      AdPlacement.interHome: [AdPlacement.interBack],
      AdPlacement.nativeIntro1: [AdPlacement.nativeIntro2, AdPlacement.interIntro],
    };

    final nextPlacements = sequences[currentPlacement];
    if (nextPlacements == null) return;

    // Prefetch in background
    for (final placement in nextPlacements) {
      switch (placement.type) {
        case AdType.interstitial:
          if (!_service.isInterstitialLoaded(placement)) {
            _service.loadInterstitial(placement);
          }
          break;
        case AdType.native:
          _service.loadNative(placement);
          break;
        default:
          break;
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // UTILITIES (ENHANCED)
  // ═══════════════════════════════════════════════════════════════

  bool _canShow(AdPlacement placement) {
    return _config.isPlacementEnabled(placement);
  }

  /// Check if a placement is enabled
  bool isEnabled(AdPlacement placement) => _config.isPlacementEnabled(placement);

  /// Get load state for placement
  AdLoadState getLoadState(AdPlacement placement) => _service.getLoadState(placement);

  /// Check if ad is loaded and ready
  bool isAdReady(AdPlacement placement) {
    return switch (placement.type) {
      AdType.interstitial => _service.isInterstitialLoaded(placement),
      AdType.rewarded => _service.isRewardedLoaded(placement),
      AdType.appOpen => _service.isAppOpenLoaded(placement),
      AdType.native => _service.getNative(placement) != null,
      AdType.banner => _service.getBanner(placement) != null,
    };
  }

  /// Get recommended wait time before showing ad again
  Duration? getRecommendedWaitTime(AdPlacement placement) {
    return _frequency.getRecommendedWaitTime(
      placement.key,
      minInterval: Duration(seconds: _config.interInterval),
    );
  }

  void resetNavigationCount() => _navCount = 0;

  /// Get comprehensive analytics data
  Map<String, Map<String, dynamic>> getAnalyticsData() {
    final data = _frequency.getAnalyticsData();

    // Add load states
    for (final placement in AdPlacement.values) {
      final key = placement.key;
      data[key] = {
        ...?(data[key] ?? {}),
        'loadState': getLoadState(placement).name,
        'isReady': isAdReady(placement),
      };
    }

    return data;
  }

  Future<void> dispose() async {
    _service.disposeAll();
    await _frequency.reset();
  }
}
