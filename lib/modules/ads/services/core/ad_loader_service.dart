import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/utils/logger.dart';
import '../../config/ad_remote_config.dart';
import '../../domain/ad_placements.dart';
import 'ad_store.dart';

@LazySingleton()
class AdLoaderService {
  AdLoaderService(this._cfg, this._store);

  final AdsRemoteConfig _cfg;
  final AdStore _store;

  static const _maxRetry = 3;
  static const _baseDelay = Duration(seconds: 2);

  final _pending = <String, Completer<void>>{};
  bool _inited = false;
  bool get isInitialized => _inited;

  Future<void> initialize() async {
    if (_inited) return;
    try {
      await MobileAds.instance.initialize();
      Logger.success('✅ AdMob SDK ready', tag: 'ADS');
    } catch (e) {
      Logger.error('❌ AdMob init failed', error: e, tag: 'ADS');
    }
    _inited = true;
  }

  Future<BannerAd?> loadBanner(
    AdPlacement p, {
    AdSize? size,
    AdSizePreset? preset,
    bool collapsible = false,
    int retry = 0,
  }) async {
    if (!_canLoad(p)) return null;
    final cached = _store.banners[p.name];
    if (cached?.isValid == true) return cached!.ad;
    if (await _join(p.name)) return _store.banners[p.name]?.ad;

    final adId = p.resolveId(_cfg);
    if (adId.isEmpty) return null;
    final sz = size ?? preset?.size ?? AdSize.banner;
    final c = _begin(p);

    BannerAd(
      adUnitId: adId,
      size: sz,
      request: AdRequest(extras: collapsible ? {'collapsible': 'bottom'} : null),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _store.cacheBanner(p.name, ad as BannerAd);
          _store.states[p.name] = AdLoadState.loaded;
          _end(p.name);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          _store.banners.remove(p.name);
          _store.states[p.name] = AdLoadState.failed;
          _retry(c, p.name, retry, () => loadBanner(p, size: sz, retry: retry + 1));
        },
      ),
    ).load();

    await c.future;
    return _store.banners[p.name]?.ad;
  }

  Future<bool> loadInterstitial(AdPlacement p, {bool force = false, int retry = 0}) async {
    if (!_canLoad(p)) return false;
    if (!force) {
      final last = _store.lastInterShow;
      if (last != null && DateTime.now().difference(last).inSeconds < _cfg.interInterval) {
        return false;
      }
    }
    final cached = _store.interstitials[p.name];
    if (cached?.isValid == true) return true;
    if (await _join(p.name)) return _store.interstitials[p.name] != null;

    final adId = p.resolveId(_cfg);
    if (adId.isEmpty) return false;
    final c = _begin(p);

    InterstitialAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _store.cacheInter(p.name, ad);
          _store.states[p.name] = AdLoadState.loaded;
          _end(p.name);
        },
        onAdFailedToLoad: (err) {
          _store.states[p.name] = AdLoadState.failed;
          _retry(c, p.name, retry, () => loadInterstitial(p, retry: retry + 1));
        },
      ),
    );

    await c.future;
    return _store.interstitials[p.name] != null;
  }

  Future<bool> loadRewarded(AdPlacement p, {int retry = 0}) async {
    if (!_canLoad(p)) return false;
    final cached = _store.rewarded[p.name];
    if (cached?.isValid == true) return true;
    if (await _join(p.name)) return _store.rewarded[p.name] != null;

    final adId = p.resolveId(_cfg);
    if (adId.isEmpty) return false;
    final c = _begin(p);

    RewardedAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _store.cacheRewarded(p.name, ad);
          _store.states[p.name] = AdLoadState.loaded;
          _end(p.name);
        },
        onAdFailedToLoad: (err) {
          _store.states[p.name] = AdLoadState.failed;
          _retry(c, p.name, retry, () => loadRewarded(p, retry: retry + 1));
        },
      ),
    );

    await c.future;
    return _store.rewarded[p.name] != null;
  }

  Future<NativeAd?> loadNative(AdPlacement p, {NativeTemplateStyle? style, int retry = 0}) async {
    if (!_canLoad(p)) return null;
    final cached = _store.natives[p.name];
    if (cached?.isValid == true) return cached!.ad;
    if (await _join(p.name)) return _store.natives[p.name]?.ad;

    final adId = p.resolveId(_cfg);
    if (adId.isEmpty) return null;
    final c = _begin(p);

    NativeAd(
      adUnitId: adId,
      request: const AdRequest(),
      nativeTemplateStyle: style ?? _defaultNativeStyle,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _store.cacheNative(p.name, ad as NativeAd);
          _store.states[p.name] = AdLoadState.loaded;
          _end(p.name);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          _store.natives.remove(p.name);
          _store.states[p.name] = AdLoadState.failed;
          _retry(c, p.name, retry, () => loadNative(p, style: style, retry: retry + 1));
        },
      ),
    ).load();

    await c.future;
    return _store.natives[p.name]?.ad;
  }

  Future<bool> loadAppOpen(AdPlacement p, {int retry = 0}) async {
    if (!_canLoad(p)) return false;
    final cached = _store.appOpens[p.name];
    if (cached?.isValid == true) return true;
    if (await _join(p.name)) return _store.appOpens[p.name] != null;

    final adId = p.resolveId(_cfg);
    if (adId.isEmpty) return false;
    final c = _begin(p);

    AppOpenAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _store.cacheAppOpen(p.name, ad);
          _store.states[p.name] = AdLoadState.loaded;
          _end(p.name);
        },
        onAdFailedToLoad: (err) {
          _store.states[p.name] = AdLoadState.failed;
          _retry(c, p.name, retry, () => loadAppOpen(p, retry: retry + 1));
        },
      ),
    );

    await c.future;
    return _store.appOpens[p.name] != null;
  }

  bool _canLoad(AdPlacement p) => _inited && !_store.isBackground && p.isEnabled(_cfg);

  Completer<void> _begin(AdPlacement p) {
    _store.states[p.name] = AdLoadState.loading;
    final c = Completer<void>();
    _pending[p.name] = c;
    return c;
  }

  void _end(String k) {
    if (_pending[k]?.isCompleted == false) _pending[k]!.complete();
    _pending.remove(k);
  }

  Future<bool> _join(String k) async {
    if (!_pending.containsKey(k)) return false;
    await _pending[k]!.future;
    return true;
  }

  void _retry(Completer<void> c, String k, int attempt, Future<void> Function() fn) {
    if (attempt >= _maxRetry) {
      if (!c.isCompleted) c.complete();
      return;
    }
    _pending[k] = c;
    Future.delayed(_baseDelay * math.pow(2, attempt).toInt()).then((_) {
      _pending.remove(k);
      fn();
    });
  }

  static final _defaultNativeStyle = NativeTemplateStyle(
    templateType: TemplateType.medium,
    mainBackgroundColor: const Color(0xFFFFFFFF),
    cornerRadius: 10,
  );
}
