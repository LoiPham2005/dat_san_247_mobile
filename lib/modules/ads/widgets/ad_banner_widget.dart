import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/base/di/injection.dart';
import '../domain/ad_placements.dart';
import '../services/ad_manager.dart';
import '../services/core/ad_store.dart';
import 'ad_skeletons.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({
    super.key,
    required this.placement,
    this.size,
    this.preset,
    this.isSticky = false,
    this.showCloseButton = false,
    this.backgroundColor = Colors.white,
    this.onLoaded,
    this.onFailed,
  });

  final AdPlacement placement;
  final AdSize? size;
  final AdSizePreset? preset;
  final bool isSticky;
  final bool showCloseButton;
  final Color backgroundColor;
  final VoidCallback? onLoaded;
  final VoidCallback? onFailed;

  AdSize get _effectiveSize => size ?? preset?.size ?? AdSize.banner;

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  final _mgr = getIt<AdManager>();
  BannerAd? _ad;
  AdLoadState _state = AdLoadState.idle;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _state = AdLoadState.loading);
    final ad = await _mgr.loadBanner(widget.placement, size: widget.size, preset: widget.preset);
    if (!mounted) return;
    setState(() {
      _ad = ad;
      _state = ad != null ? AdLoadState.loaded : AdLoadState.failed;
    });
    ad != null ? widget.onLoaded?.call() : widget.onFailed?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_closed) return const SizedBox.shrink();
    return switch (_state) {
      AdLoadState.loading || AdLoadState.idle => BannerSkeleton(
        Size(widget._effectiveSize.width.toDouble(), widget._effectiveSize.height.toDouble()),
        widget.isSticky,
      ),
      AdLoadState.failed => const SizedBox.shrink(),
      _ when _ad != null => _buildAd(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildAd() {
    final adW = widget.isSticky ? double.infinity : _ad!.size.width.toDouble();
    final content = Container(
      alignment: Alignment.center,
      width: adW,
      height: _ad!.size.height.toDouble(),
      color: widget.backgroundColor,
      child: AdWidget(ad: _ad!),
    );
    if (!widget.isSticky) return content;
    return SafeArea(
      child: Stack(
        children: [
          content,
          if (widget.showCloseButton)
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.close, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() => _closed = true);
                  _mgr.disposeBanner(widget.placement);
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mgr.disposeBanner(widget.placement);
    super.dispose();
  }
}
