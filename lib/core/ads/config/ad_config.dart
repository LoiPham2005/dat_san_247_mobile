// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/config/ad_config.dart
// ════════════════════════════════════════════════════════════════

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/ad_placement.dart';

part 'ad_config.freezed.dart';
part 'ad_config.g.dart';

@freezed
abstract class AdUnitConfig with _$AdUnitConfig {
  const factory AdUnitConfig({
    @Default('') String id,
    @Default('') String id2,
    @Default(true) bool enable,
    @Default(100) int id2RequestPercentage,
  }) = _AdUnitConfig;

  factory AdUnitConfig.fromJson(Map<String, dynamic> json) => _$AdUnitConfigFromJson(json);
}

@freezed
abstract class AdConfig with _$AdConfig {
  const factory AdConfig({
    @Default(true) bool showAllAds,
    @Default(true) bool showTopButton,
    @Default(1) int nativeFullDisplayMode,
    @Default(15) int interInterval,
    @Default(0) int id2RequestTimeout,
    @Default('nativeLanguageSelect') String reloadKey,
    @Default({}) Map<String, AdUnitConfig> adUnits,
  }) = _AdConfig;
  const AdConfig._();

  factory AdConfig.fromJson(Map<String, dynamic> json) {
    final adUnitsMap = json['adUnitsConfig'] as Map<String, dynamic>? ?? {};
    final adUnits = adUnitsMap.map(
      (key, value) => MapEntry(key, AdUnitConfig.fromJson(value as Map<String, dynamic>)),
    );

    return AdConfig(
      showAllAds: json['showAllAds'] as bool? ?? true,
      showTopButton: json['showTopButton'] as bool? ?? true,
      nativeFullDisplayMode: json['nativeFullDisplayMode'] as int? ?? 1,
      interInterval: json['interInterval'] as int? ?? 15,
      id2RequestTimeout: json['id2RequestTimeout'] as int? ?? 0,
      reloadKey: json['reloadKey'] as String? ?? 'nativeLanguageSelect',
      adUnits: adUnits,
    );
  }

  /// Get unit config for a placement (enum version)
  AdUnitConfig getUnitFor(AdPlacement placement) {
    return adUnits[placement.key] ?? const AdUnitConfig();
  }

  /// Get unit config by string key (backwards compatibility)
  AdUnitConfig getUnit(String placement) {
    return adUnits[placement] ?? const AdUnitConfig();
  }

  /// Check if placement is enabled (enum version)
  bool isPlacementEnabled(AdPlacement placement) {
    if (!showAllAds) return false;
    return getUnitFor(placement).enable;
  }

  /// Check if placement is enabled by string key
  bool isEnabled(String placement) {
    if (!showAllAds) return false;
    return getUnit(placement).enable;
  }

  /// Get ad ID for placement (enum version)
  String getAdIdFor(AdPlacement placement, {bool useId2 = false}) {
    final unit = getUnitFor(placement);
    if (!unit.enable) return '';
    if (useId2 && unit.id2.isNotEmpty) return unit.id2;
    return unit.id;
  }

  /// Get ad ID by string key (backwards compatibility)
  String getAdId(String placement, {bool useId2 = false}) {
    final unit = getUnit(placement);
    if (!unit.enable) return '';
    if (useId2 && unit.id2.isNotEmpty) return unit.id2;
    return unit.id;
  }

  Map<String, dynamic> toJson() {
    return {
      'showAllAds': showAllAds,
      'showTopButton': showTopButton,
      'nativeFullDisplayMode': nativeFullDisplayMode,
      'interInterval': interInterval,
      'id2RequestTimeout': id2RequestTimeout,
      'reloadKey': reloadKey,
      'adUnitsConfig': adUnits.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}
