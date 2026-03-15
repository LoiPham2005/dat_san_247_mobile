import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

import '../../domain/ad_placements.dart';

enum AdLoadState { idle, loading, loaded, failed }

class AdCacheEntry<T> {
  AdCacheEntry(this.ad, {required this.expiry}) : _loadedAt = DateTime.now();

  final T ad;
  final Duration expiry;
  final DateTime _loadedAt;

  bool get isExpired => DateTime.now().difference(_loadedAt) >= expiry;
  bool get isValid => !isExpired;
}

@LazySingleton()
class AdStore {
  static const _bannerTTL = Duration(hours: 1);
  static const _interTTL = Duration(minutes: 45);
  static const _rewardTTL = Duration(minutes: 45);
  static const _nativeTTL = Duration(hours: 1);
  static const _appOpenTTL = Duration(hours: 4);

  final banners = <String, AdCacheEntry<BannerAd>>{};
  final interstitials = <String, AdCacheEntry<InterstitialAd>>{};
  final rewarded = <String, AdCacheEntry<RewardedAd>>{};
  final natives = <String, AdCacheEntry<NativeAd>>{};
  final appOpens = <String, AdCacheEntry<AppOpenAd>>{};
  final states = <String, AdLoadState>{};

  DateTime? lastInterShow;
  bool isBackground = false;

  void cacheBanner(String k, BannerAd ad) => banners[k] = AdCacheEntry(ad, expiry: _bannerTTL);
  void cacheInter(String k, InterstitialAd ad) =>
      interstitials[k] = AdCacheEntry(ad, expiry: _interTTL);
  void cacheRewarded(String k, RewardedAd ad) => rewarded[k] = AdCacheEntry(ad, expiry: _rewardTTL);
  void cacheNative(String k, NativeAd ad) => natives[k] = AdCacheEntry(ad, expiry: _nativeTTL);
  void cacheAppOpen(String k, AppOpenAd ad) => appOpens[k] = AdCacheEntry(ad, expiry: _appOpenTTL);

  bool isReady(AdPlacement p) => switch (p.type) {
    AdType.interstitial => interstitials[p.name]?.isValid == true,
    AdType.rewarded => rewarded[p.name]?.isValid == true,
    AdType.appOpen => appOpens[p.name]?.isValid == true,
    AdType.native => natives[p.name]?.isValid == true,
    AdType.banner => banners[p.name]?.isValid == true,
  };

  int disposeExpired() =>
      _sweep(banners) +
      _sweep(interstitials) +
      _sweep(rewarded) +
      _sweep(natives) +
      _sweep(appOpens);

  int _sweep<T>(Map<String, AdCacheEntry<T>> map) {
    int n = 0;
    map.removeWhere((_, e) {
      if (e.isValid) return false;
      (e.ad as dynamic).dispose();
      n++;
      return true;
    });
    return n;
  }
}
