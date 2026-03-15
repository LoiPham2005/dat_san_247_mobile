import 'package:google_mobile_ads/google_mobile_ads.dart';

// ─────────────────────────────────────────────────────────────────
// NATIVE AD TEMPLATE — preset kích thước native ad
// ─────────────────────────────────────────────────────────────────

enum NativeAdTemplate {
  small(90),
  medium(320),
  full(400),
  listTile(100);

  const NativeAdTemplate(this.defaultHeight);
  final double defaultHeight;
}

// ─────────────────────────────────────────────────────────────────
// AD SIZE HELPERS
// ─────────────────────────────────────────────────────────────────

/// Preset cho banner. Truyền vào AdBannerWidget(preset: ...).
enum AdSizePreset {
  standard(AdSize.banner),
  large(AdSize.largeBanner),
  medium(AdSize.mediumRectangle),
  full(AdSize.fullBanner),
  leaderboard(AdSize.leaderboard);

  const AdSizePreset(this.size);
  final AdSize size;
}

/// Height config cho native ad với min/max clamp.
class NativeAdSizeConfig {
  const NativeAdSizeConfig(this.height, {this.min, this.max});
  const NativeAdSizeConfig.small() : height = 90, min = 60, max = 120;
  const NativeAdSizeConfig.medium() : height = 320, min = 250, max = 400;
  const NativeAdSizeConfig.full() : height = 400, min = 350, max = 500;
  const NativeAdSizeConfig.listTile() : height = 100, min = 80, max = 140;

  final double height;
  final double? min;
  final double? max;

  double get effective {
    double h = height;
    if (min != null && h < min!) h = min!;
    if (max != null && h > max!) h = max!;
    return h;
  }
}
