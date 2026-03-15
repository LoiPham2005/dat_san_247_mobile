// 📁 lib/modules/ads/ads.dart
// Single import cho toàn bộ ads module:
//   import 'package:your_app/modules/ads/ads.dart';
//
// ══════════════════════════════════════════════════════════════════
// SETUP (làm 1 lần)
// ══════════════════════════════════════════════════════════════════
//
// 1️⃣  main.dart — khởi tạo trước khi runApp:
//
//      // Không dùng Adjust
//      await getIt<AdManager>().initialize();
//
//      // Có dùng Adjust (khuyến nghị)
//      await getIt<AdManager>().initialize(
//        adjustToken: AdjustToken(
//          androidToken: 'YOUR_ANDROID_TOKEN',
//          iosToken:     'YOUR_IOS_TOKEN',
//        ),
//        fullAdsOption: const FullAdsOption(
//          useNull:         true,   // user không có attribution → ẩn ads
//          useUnAttributed: true,
//        ),
//        iapOptions: IapOptions(
//          androidOptions: AndroidIapOptions(
//            totalRevenueToken: 'YOUR_TOKEN',
//            productRevenueTokens: {'com.app.weekly': 'abc123'},
//          ),
//          iosOptions: IOSIapOptions(totalRevenueToken: 'YOUR_TOKEN'),
//        ),
//        // Callback khi Adjust xác định user đã premium → tắt ads
//        adOptions: AdOptions(
//          androidAdOptions: AndroidAdOptions(
//            fullAdCallback: (isFullAd, network, fromCache, fromLib, fromApi) {
//              if (isFullAd) { /* ẩn ads UI */ }
//            },
//          ),
//        ),
//      );
//
//      AdScreenTracker.init(getIt<AdAnalyticsTracker>());
//
// 2️⃣  MaterialApp:
//      navigatorObservers: [AdScreenTracker.observer]
//
// 3️⃣  Root widget:
//      late final _adObs = AdLifecycleObserver(getIt<AdManager>());
//      @override void dispose() { _adObs.dispose(); super.dispose(); }
//
// ══════════════════════════════════════════════════════════════════
// CHECK USER STATE (Adjust full ads)
// ══════════════════════════════════════════════════════════════════
//
//   AdsUserState.instance.isFullAds          // null=unknown, true=premium, false=free
//   AdsUserState.instance.shouldShowAds(cfg) // kết hợp config + Adjust
//
//   // isEnabled đã tự check — không cần gọi thủ công
//   AdPlacement.interHome.isEnabled(cfg)     // false nếu user premium
//
// ══════════════════════════════════════════════════════════════════
// USAGE CHEATSHEET
// ══════════════════════════════════════════════════════════════════
//
// ── SPLASH ───────────────────────────────────────────────────────
//   await getIt<AdManager>().showSplashSequence(context);
//   // Tự thử: App Open → interSplash → interFullSplash theo thứ tự
//
// ── NAVIGATION ───────────────────────────────────────────────────
//   adMgr.showNavigationAd(context);   // mỗi 3 lần navigate tự show inter
//   adMgr.showBackAd(context);         // khi back trong app
//   adMgr.showBackHomeAd(context);     // khi back về home
//
// ── INTERSTITIAL THỦ CÔNG ────────────────────────────────────────
//   adMgr.showInterstitial(context, AdPlacement.interHome);
//
// ── BANNER ───────────────────────────────────────────────────────
//   // Inline
//   AdBannerWidget(placement: AdPlacement.bannerHome)
//
//   // Sticky footer + nút đóng
//   AdBannerWidget(
//     placement: AdPlacement.bannerHome,
//     isSticky: true,
//     showCloseButton: true,
//   )
//
// ── NATIVE ───────────────────────────────────────────────────────
//   // Medium (default)
//   AdNativeWidget(placement: AdPlacement.nativeHome)
//
//   // Small (intro, language)
//   AdNativeWidget(
//     placement: AdPlacement.nativeIntro1,
//     template: NativeAdTemplate.small,
//   )
//
//   // Full (overlay sau inter)
//   AdNativeWidget(
//     placement: AdPlacement.nativeFull,
//     template: NativeAdTemplate.full,
//     autoDispose: false,
//   )
//
// ── NATIVE TRONG LISTVIEW (pool-based) ───────────────────────────
//   // Khởi tạo pool (1 lần trong State)
//   late final _pool = CachedNativeAdPool(
//     placement: AdPlacement.nativeAll,
//     config: getIt<AdsRemoteConfig>(),
//   )..preload();
//
//   // Trong ListView.builder
//   if (i % 5 == 4) return NativeAdListTile(pool: _pool);
//
//   // Dispose cùng widget
//   @override void dispose() { _pool.dispose(); super.dispose(); }
//
// ── REWARDED ─────────────────────────────────────────────────────
//   final earned = await AdRewardedDialog.show(
//     context: context,
//     placement: AdPlacement.rewardVideoUnlock,
//     onRewarded: () { /* unlock feature */ },
//     title: 'Unlock Feature',
//     description: 'Watch a short video to unlock.',
//   );
//
// ── SCREEN TRACKING (auto) ────────────────────────────────────────
//   // Cách 1: StatefulWidget mixin
//   class _HomeState extends State<Home> with LoggableRoute {
//     @override String get screenName => 'HomeScreen';
//   }
//
//   // Cách 2: Stateless / GoRouter wrapper
//   LoggableWidget(screenName: 'HomeScreen', child: Scaffold(...))
//
//   // Cách 3: Thủ công
//   AdScreenTracker.observer.track('CustomScreen');
//
// ── CHECK TRẠNG THÁI ─────────────────────────────────────────────
//   adMgr.config.isEnabled(AdPlacement.interHome.unit(adMgr.config))
//   adMgr.config.showAllAds
//   AdPlacement.nativeHome.isEnabled(adMgr.config)
//   AdPlacement.bannerHome.resolveId(adMgr.config)   // adUnitId thực tế
//
// ══════════════════════════════════════════════════════════════════
// FILE STRUCTURE (6 files + barrel)
// ══════════════════════════════════════════════════════════════════
//
//  ads/
//  ├── ads.dart             ← import này là đủ
//  ├── ad_config.dart       AdUnitConfig, AdUnitsConfig, AdsRemoteConfig,
//  │                        kAdsDevConfig, kAdsProdConfig, AdRemoteConfig, AdModule
//  ├── ad_placement.dart    AdType, AdPlacement (+typed accessor), NativeAdTemplate,
//  │                        AdSizePreset, NativeAdSizeConfig
//  ├── ad_core.dart         AdLoadState, AdCacheEntry, AdStore,
//  │                        AdFrequency, AdLoaderService
//  ├── ad_manager.dart      AdAnalyticsTracker, AdManager
//  ├── ad_observers.dart    AdLifecycleObserver, AdScreenTracker,
//  │                        LoggableRoute, LoggableWidget
//  └── ad_widgets.dart      AdBannerWidget, AdNativeWidget, AdRewardedDialog,
//                           AdAppOpenLoader, AdNativeFullDialog,
//                           CachedNativeAdPool, NativeAdListTile
//
// ══════════════════════════════════════════════════════════════════

export 'config/ad_config_models.dart';
export 'config/ad_remote_config.dart';
export 'config/ad_state.dart';
export 'domain/ad_dimensions.dart';
export 'domain/ad_placements.dart';
export 'observers/ad_lifecycle_observer.dart';
export 'observers/ad_screen_tracker.dart';
export 'services/ad_manager.dart';
export 'services/ad_analytics_tracker.dart';
export 'services/core/ad_frequency.dart' show AdFrequency;
export 'services/core/ad_loader_service.dart' show AdLoaderService;
export 'services/core/ad_store.dart' show AdLoadState, AdCacheEntry, AdStore;
export 'widgets/ad_banner_widget.dart';
export 'widgets/ad_dialog_widgets.dart';
export 'widgets/ad_native_pool_widgets.dart';
export 'widgets/ad_native_widget.dart';
export 'widgets/ad_skeletons.dart';
