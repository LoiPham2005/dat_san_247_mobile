import 'ad_config_models.dart';

// ─────────────────────────────────────────────────────────────────
// FULL ADS OPTION — cấu hình cho Adjust "full ads" detection
// ─────────────────────────────────────────────────────────────────

class FullAdsOption {
  const FullAdsOption({
    this.useNull = false,
    this.useEmpty = false,
    this.useUnAttributed = false,
    this.maxFull = false,
  });

  factory FullAdsOption.fromJson(Map<String, dynamic> map) => FullAdsOption(
    useNull: map['useNull'] as bool? ?? false,
    useEmpty: map['useEmpty'] as bool? ?? false,
    useUnAttributed: map['useUnAttributed'] as bool? ?? false,
    maxFull: map['maxFull'] as bool? ?? false,
  );

  final bool useNull;
  final bool useEmpty;
  final bool useUnAttributed;
  final bool maxFull;

  Map<String, dynamic> toJson() => {
    'useNull': useNull,
    'useEmpty': useEmpty,
    'useUnAttributed': useUnAttributed,
    'maxFull': maxFull,
  };
}

// ─────────────────────────────────────────────────────────────────
// ADS USER STATE — runtime state, không lưu trong config
// ─────────────────────────────────────────────────────────────────

class AdsUserState {
  AdsUserState._();
  static final AdsUserState instance = AdsUserState._();

  bool? isFullAds;
  String? fullAdsNetwork;
  bool fullAdsFromCache = false;

  bool shouldShowAds(AdsRemoteConfig cfg) {
    if (!cfg.showAllAds) return false;
    if (isFullAds == true) return false;
    return true;
  }
}
