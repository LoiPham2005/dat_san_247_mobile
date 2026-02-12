// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/widgets/ad_banner_widget.dart
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/ad_placement.dart';
import '../services/ad_service.dart';

/// Unified banner ad widget - replaces AdBanner and AdStickyBanner
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({
    super.key,
    required this.placement,
    this.size,
    this.isSticky = false,
    this.showCloseButton = false,
    this.loadingWidget,
    this.errorWidget,
    this.backgroundColor = Colors.white,
    this.onAdLoaded,
    this.onAdFailed,
  });

  /// The ad placement
  final AdPlacement placement;

  /// Banner size (default: AdSize.banner)
  final AdSize? size;

  /// Whether this is a sticky banner (full width, safe area aware)
  final bool isSticky;

  /// Show close button for sticky banners
  final bool showCloseButton;

  /// Widget to show while loading
  final Widget? loadingWidget;

  /// Widget to show on error
  final Widget? errorWidget;

  /// Background color
  final Color backgroundColor;

  /// Callback when ad is loaded
  final VoidCallback? onAdLoaded;

  /// Callback when ad fails to load
  final VoidCallback? onAdFailed;

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  final _service = getIt<AdService>();
  BannerAd? _ad;
  AdLoadState _state = AdLoadState.idle;
  bool _isClosed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;

    setState(() => _state = AdLoadState.loading);

    final ad = await _service.loadBanner(widget.placement, size: widget.size);

    if (!mounted) return;

    if (ad != null) {
      setState(() {
        _ad = ad;
        _state = AdLoadState.loaded;
      });
      widget.onAdLoaded?.call();
    } else {
      setState(() => _state = AdLoadState.failed);
      widget.onAdFailed?.call();
    }
  }

  void _close() {
    setState(() => _isClosed = true);
    _service.disposeBanner(widget.placement);
  }

  @override
  Widget build(BuildContext context) {
    if (_isClosed) return const SizedBox.shrink();

    return switch (_state) {
      AdLoadState.idle || AdLoadState.loading => widget.loadingWidget ?? _buildLoadingPlaceholder(),
      AdLoadState.failed => widget.errorWidget ?? const SizedBox.shrink(),
      AdLoadState.loaded when _ad != null => _buildAdWidget(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildLoadingPlaceholder() {
    final size = widget.size ?? AdSize.banner;
    return Container(
      width: widget.isSticky ? double.infinity : size.width.toDouble(),
      height: size.height.toDouble(),
      color: widget.backgroundColor,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildAdWidget() {
    final content = Container(
      alignment: Alignment.center,
      width: widget.isSticky ? double.infinity : _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      color: widget.backgroundColor,
      child: AdWidget(ad: _ad!),
    );

    if (!widget.isSticky) return content;

    // Sticky banner with optional close button
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
                onPressed: _close,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _service.disposeBanner(widget.placement);
    super.dispose();
  }
}

// ════════════════════════════════════════════════════════════════
// Legacy aliases for backwards compatibility
// ════════════════════════════════════════════════════════════════

/// @deprecated Use AdBannerWidget instead
typedef AdBanner = AdBannerWidget;

/// @deprecated Use AdBannerWidget with isSticky: true instead
class AdStickyBanner extends StatelessWidget {
  const AdStickyBanner({super.key, required this.placement, this.showCloseButton = false});

  final AdPlacement placement;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return AdBannerWidget(placement: placement, isSticky: true, showCloseButton: showCloseButton);
  }
}
