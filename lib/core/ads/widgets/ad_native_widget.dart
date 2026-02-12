// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/widgets/ad_native_widget.dart
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/ad_placement.dart';
import '../services/ad_service.dart';

/// Template presets for native ads
enum NativeAdTemplate {
  /// Small template (height ~80)
  small,

  /// Medium template (height ~320)
  medium,

  /// Full page template
  full,

  /// List tile style (for ListView)
  listTile,
}

/// Unified native ad widget - replaces AdNative and AdNativeListTile
class AdNativeWidget extends StatefulWidget {
  const AdNativeWidget({
    super.key,
    required this.placement,
    this.template = NativeAdTemplate.medium,
    this.height,
    this.customStyle,
    this.loadingWidget,
    this.errorWidget,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.borderRadius = 10.0,
    this.border,
    this.onAdLoaded,
    this.onAdFailed,
  });

  /// The ad placement
  final AdPlacement placement;

  /// Template preset
  final NativeAdTemplate template;

  /// Custom height (overrides template height)
  final double? height;

  /// Custom NativeTemplateStyle (overrides template style)
  final NativeTemplateStyle? customStyle;

  /// Widget to show while loading
  final Widget? loadingWidget;

  /// Widget to show on error
  final Widget? errorWidget;

  /// Padding inside the ad container
  final EdgeInsets padding;

  /// Margin around the ad container
  final EdgeInsets margin;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final double borderRadius;

  /// Border
  final Border? border;

  /// Callback when ad is loaded
  final VoidCallback? onAdLoaded;

  /// Callback when ad fails to load
  final VoidCallback? onAdFailed;

  @override
  State<AdNativeWidget> createState() => _AdNativeWidgetState();
}

class _AdNativeWidgetState extends State<AdNativeWidget> {
  final _service = getIt<AdService>();
  NativeAd? _ad;
  AdLoadState _state = AdLoadState.idle;

  @override
  void initState() {
    super.initState();
    _load();
  }

  double get _height {
    if (widget.height != null) return widget.height!;
    return switch (widget.template) {
      NativeAdTemplate.small => 80,
      NativeAdTemplate.medium => 320,
      NativeAdTemplate.full => 400,
      NativeAdTemplate.listTile => 120,
    };
  }

  NativeTemplateStyle get _templateStyle {
    if (widget.customStyle != null) return widget.customStyle!;

    final bgColor = widget.backgroundColor ?? Colors.white;

    return switch (widget.template) {
      NativeAdTemplate.small => NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: bgColor,
        cornerRadius: widget.borderRadius,
      ),
      NativeAdTemplate.medium || NativeAdTemplate.full => NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: bgColor,
        cornerRadius: widget.borderRadius,
      ),
      NativeAdTemplate.listTile => NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: bgColor,
        cornerRadius: 8.0,
      ),
    };
  }

  Future<void> _load() async {
    if (!mounted) return;

    setState(() => _state = AdLoadState.loading);

    final ad = await _service.loadNative(widget.placement, templateStyle: _templateStyle);

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

  @override
  Widget build(BuildContext context) {
    return switch (_state) {
      AdLoadState.idle || AdLoadState.loading => widget.loadingWidget ?? _buildLoadingPlaceholder(),
      AdLoadState.failed => widget.errorWidget ?? const SizedBox.shrink(),
      AdLoadState.loaded when _ad != null => _buildAdWidget(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      height: _height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.border,
      ),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildAdWidget() {
    return Container(
      height: _height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: AdWidget(ad: _ad!),
      ),
    );
  }

  @override
  void dispose() {
    _service.disposeNative(widget.placement);
    super.dispose();
  }
}

// ════════════════════════════════════════════════════════════════
// Legacy aliases for backwards compatibility
// ════════════════════════════════════════════════════════════════

/// @deprecated Use AdNativeWidget instead
class AdNative extends StatelessWidget {
  const AdNative({super.key, required this.placement, this.height = 300, this.templateStyle});

  final AdPlacement placement;
  final double height;
  final NativeTemplateStyle? templateStyle;

  @override
  Widget build(BuildContext context) {
    return AdNativeWidget(placement: placement, height: height, customStyle: templateStyle);
  }
}

/// @deprecated Use AdNativeWidget with template: NativeAdTemplate.listTile instead
class AdNativeListTile extends StatelessWidget {
  const AdNativeListTile({super.key, required this.placement, this.height = 320});

  final AdPlacement placement;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AdNativeWidget(
      placement: placement,
      template: NativeAdTemplate.listTile,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      backgroundColor: Colors.grey[50],
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: 8,
    );
  }
}
