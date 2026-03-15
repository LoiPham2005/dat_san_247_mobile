import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/base/di/injection.dart';
import '../domain/ad_placements.dart';
import '../services/ad_manager.dart';
import '../services/core/ad_store.dart';
import 'ad_skeletons.dart';

class AdNativeWidget extends StatefulWidget {
  const AdNativeWidget({
    super.key,
    required this.placement,
    this.template = NativeAdTemplate.medium,
    this.height,
    this.sizeConfig,
    this.customStyle,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.borderRadius = 10.0,
    this.border,
    this.autoDispose = true,
    this.onLoaded,
    this.onFailed,
  });

  final AdPlacement placement;
  final NativeAdTemplate template;
  final double? height;
  final NativeAdSizeConfig? sizeConfig;
  final NativeTemplateStyle? customStyle;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? backgroundColor;
  final double borderRadius;
  final Border? border;
  final bool autoDispose;
  final VoidCallback? onLoaded;
  final VoidCallback? onFailed;

  double get _h => height ?? sizeConfig?.effective ?? template.defaultHeight;

  @override
  State<AdNativeWidget> createState() => _AdNativeWidgetState();
}

class _AdNativeWidgetState extends State<AdNativeWidget> {
  NativeAd? _ad;
  AdLoadState _state = AdLoadState.idle;
  AdManager get _mgr => getIt<AdManager>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  NativeTemplateStyle get _style =>
      widget.customStyle ??
      NativeTemplateStyle(
        templateType:
            (widget.template == NativeAdTemplate.small ||
                widget.template == NativeAdTemplate.listTile)
            ? TemplateType.small
            : TemplateType.medium,
        mainBackgroundColor: widget.backgroundColor ?? Colors.white,
        cornerRadius: widget.borderRadius,
      );

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _state = AdLoadState.loading);
    final ad = await _mgr.loadNative(widget.placement, style: _style);
    if (!mounted) return;
    setState(() {
      _ad = ad;
      _state = ad != null ? AdLoadState.loaded : AdLoadState.failed;
    });
    ad != null ? widget.onLoaded?.call() : widget.onFailed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall =
        widget.template == NativeAdTemplate.small || widget.template == NativeAdTemplate.listTile;

    return switch (_state) {
      AdLoadState.loading ||
      AdLoadState.idle => NativeSkeleton(isSmall: isSmall, height: widget._h),
      AdLoadState.failed => const SizedBox.shrink(),
      _ when _ad != null => Container(
        height: widget._h,
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
      ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  void dispose() {
    if (widget.autoDispose) _mgr.disposeNative(widget.placement);
    super.dispose();
  }
}
