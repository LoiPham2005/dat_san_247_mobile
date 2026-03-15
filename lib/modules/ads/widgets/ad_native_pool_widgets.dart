import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/common/utils/logger.dart';
import '../config/ad_remote_config.dart';
import '../domain/ad_placements.dart';
import 'ad_skeletons.dart';

// ─────────────────────────────────────────────────────────────────
// CACHED NATIVE AD POOL
// ─────────────────────────────────────────────────────────────────

class PoolEntry {
  PoolEntry(this.ad);
  final NativeAd ad;
  bool impressed = false;
  bool disposed = false;
}

class CachedNativeAdPool {
  CachedNativeAdPool({
    required this.placement,
    required AdsRemoteConfig config,
    this.maxSize = 3,
    NativeTemplateStyle? style,
  }) : _cfg = config,
       _style =
           style ??
           NativeTemplateStyle(
             templateType: TemplateType.medium,
             mainBackgroundColor: const Color(0xFFFFFFFF),
             cornerRadius: 10,
           );

  final AdPlacement placement;
  final int maxSize;
  final AdsRemoteConfig _cfg;
  final NativeTemplateStyle _style;
  final _pool = <PoolEntry>[];
  final _inUse = <PoolEntry>[];
  bool _disposed = false;

  int get poolSize => _pool.length;
  int get inUseCount => _inUse.length;

  void preload({int count = 2}) {
    if (!_on) return;
    for (int i = 0; i < count - _pool.length; i++) {
      _load();
    }
  }

  NativeAd? acquire() {
    if (!_on) return null;
    final idx = _pool.indexWhere((e) => !e.impressed && !e.disposed);
    if (idx == -1) {
      _load();
      return null;
    }
    final e = _pool.removeAt(idx);
    _inUse.add(e);
    Logger.debug('🟢 Acquired ${placement.name} (pool=${_pool.length})', tag: 'POOL');
    return e.ad;
  }

  void release(NativeAd? ad) {
    if (ad == null) return;
    final e = _inUse.firstWhere((x) => x.ad == ad, orElse: () => PoolEntry(ad));
    _inUse.remove(e);
    if (e.impressed || e.disposed) {
      e.ad.dispose();
      e.disposed = true;
      Logger.debug('♻️ Disposed ${placement.name}', tag: 'POOL');
      _load();
    } else if (_pool.length < maxSize) {
      _pool.add(e);
    } else {
      e.ad.dispose();
    }
  }

  void markImpressed(NativeAd ad) {
    _inUse.where((e) => e.ad == ad).forEach((e) => e.impressed = true);
    _load();
  }

  void dispose() {
    _disposed = true;
    for (final e in [..._pool, ..._inUse]) {
      e.ad.dispose();
      e.disposed = true;
    }
    _pool.clear();
    _inUse.clear();
    Logger.info('🗑️ Pool disposed ${placement.name}', tag: 'POOL');
  }

  bool get _on => !_disposed && placement.isEnabled(_cfg);

  void _load() {
    if (!_on || _pool.length >= maxSize) return;
    final adId = placement.resolveId(_cfg);
    if (adId.isEmpty) return;

    late PoolEntry entry;
    final ad = NativeAd(
      adUnitId: adId,
      request: const AdRequest(),
      nativeTemplateStyle: _style,
      listener: NativeAdListener(
        onAdLoaded: (_) {
          if (_disposed) {
            entry.ad.dispose();
            return;
          }
          _pool.add(entry);
          Logger.debug('📥 Pool loaded ${placement.name} (pool=${_pool.length})', tag: 'POOL');
        },
        onAdImpression: (_) => entry.impressed = true,
        onAdFailedToLoad: (ad, err) {
          Logger.warning('⚠️ Pool fail: ${err.message}', tag: 'POOL');
          entry.disposed = true;
          ad.dispose();
        },
      ),
    );
    entry = PoolEntry(ad);
    ad.load();
  }
}

// ─────────────────────────────────────────────────────────────────
// NATIVE AD LIST TILE
// ─────────────────────────────────────────────────────────────────

class NativeAdListTile extends StatefulWidget {
  const NativeAdListTile({
    super.key,
    required this.pool,
    this.height = 100,
    this.backgroundColor = Colors.white,
    this.borderRadius = 12.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  final CachedNativeAdPool pool;
  final double height;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets margin;

  @override
  State<NativeAdListTile> createState() => _NativeAdListTileState();
}

class _NativeAdListTileState extends State<NativeAdListTile> {
  NativeAd? _ad;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final ad = widget.pool.acquire();
    if (ad != null) {
      _ad = ad;
      _loading = false;
    } else {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _ad = widget.pool.acquire();
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    widget.pool.release(_ad);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return AdListSkeleton(
        height: widget.height,
        margin: widget.margin,
        radius: widget.borderRadius,
        bg: widget.backgroundColor,
      );
    }
    if (_ad == null) return const SizedBox.shrink();
    return Container(
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}
