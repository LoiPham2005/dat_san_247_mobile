import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_config_models.freezed.dart';
part 'ad_config_models.g.dart';

// ─────────────────────────────────────────────────────────────────
// AD UNIT CONFIG — cấu hình cho 1 placement
// ─────────────────────────────────────────────────────────────────

@freezed
abstract class AdUnitConfig with _$AdUnitConfig {
  @JsonSerializable(explicitToJson: true)
  const factory AdUnitConfig({
    @Default('') String id,
    @Default('') String id2,

    /// 0–100: % request dùng id2 thay vì id (A/B test). 0 = tắt A/B.
    @Default(0) int id2Rate,
    @Default(true) bool enable,
  }) = _AdUnitConfig;

  const AdUnitConfig._();

  factory AdUnitConfig.fromJson(Map<String, dynamic> json) => _$AdUnitConfigFromJson(json);

  /// Resolve ID thực tế dùng để load ad (có A/B split).
  String resolveId() {
    if (!enable || id.isEmpty) return '';
    if (id2.isNotEmpty && id2Rate > 0 && DateTime.now().millisecondsSinceEpoch % 100 < id2Rate) {
      return id2;
    }
    return id;
  }
}

// ─────────────────────────────────────────────────────────────────
// AD UNITS CONFIG — typed fields cho từng placement
// ─────────────────────────────────────────────────────────────────

@freezed
abstract class AdUnitsConfig with _$AdUnitsConfig {
  @JsonSerializable(explicitToJson: true)
  const factory AdUnitsConfig({
    // ── App Open ──────────────────────────────────────────────
    @Default(AdUnitConfig()) AdUnitConfig openSplash,
    @Default(AdUnitConfig()) AdUnitConfig openOnResume,
    // ── Interstitial ──────────────────────────────────────────
    @Default(AdUnitConfig()) AdUnitConfig interSplash,
    @Default(AdUnitConfig()) AdUnitConfig interFullSplash,
    @Default(AdUnitConfig()) AdUnitConfig interHome,
    @Default(AdUnitConfig()) AdUnitConfig interBack,
    @Default(AdUnitConfig()) AdUnitConfig interBackHome,
    @Default(AdUnitConfig()) AdUnitConfig interIntro,
    @Default(AdUnitConfig()) AdUnitConfig interPasswordShow,
    @Default(AdUnitConfig()) AdUnitConfig interUninstall,
    // ── Banner ────────────────────────────────────────────────
    @Default(AdUnitConfig()) AdUnitConfig bannerHome,
    // ── Native ────────────────────────────────────────────────
    @Default(AdUnitConfig()) AdUnitConfig nativeHome,
    @Default(AdUnitConfig()) AdUnitConfig nativeAll,
    @Default(AdUnitConfig()) AdUnitConfig nativeFull,
    @Default(AdUnitConfig()) AdUnitConfig nativeFullSplash,
    @Default(AdUnitConfig()) AdUnitConfig nativeIntro1,
    @Default(AdUnitConfig()) AdUnitConfig nativeIntro2,
    @Default(AdUnitConfig()) AdUnitConfig nativeIntro3,
    @Default(AdUnitConfig()) AdUnitConfig nativeIntro4,
    @Default(AdUnitConfig()) AdUnitConfig nativeLanguage,
    @Default(AdUnitConfig()) AdUnitConfig nativeLanguageSelect,
    @Default(AdUnitConfig()) AdUnitConfig nativePermission,
    @Default(AdUnitConfig()) AdUnitConfig nativePermissionNotification,
    @Default(AdUnitConfig()) AdUnitConfig nativeCurrency,
    @Default(AdUnitConfig()) AdUnitConfig nativeCurrencySelect,
    @Default(AdUnitConfig()) AdUnitConfig nativeExit,
    @Default(AdUnitConfig()) AdUnitConfig nativeUninstall,
    // ── Rewarded ──────────────────────────────────────────────
    @Default(AdUnitConfig()) AdUnitConfig rewardPasswordShow,
    @Default(AdUnitConfig()) AdUnitConfig rewardDisconnect,
    @Default(AdUnitConfig()) AdUnitConfig rewardVideoUnlock,
  }) = _AdUnitsConfig;

  const AdUnitsConfig._();

  factory AdUnitsConfig.fromJson(Map<String, dynamic> json) => _$AdUnitsConfigFromJson(json);

  factory AdUnitsConfig.allWith({
    required String inter,
    required String appOpen,
    required String native,
    required String banner,
    required String rewarded,
  }) {
    AdUnitConfig on(String id) => AdUnitConfig(id: id, enable: true);
    AdUnitConfig off(String id) => AdUnitConfig(id: id, enable: false);
    return AdUnitsConfig(
      openSplash: on(appOpen),
      openOnResume: on(appOpen),
      interSplash: on(inter),
      interFullSplash: on(inter),
      interHome: on(inter),
      interBack: on(inter),
      interBackHome: off(inter),
      interIntro: on(inter),
      interPasswordShow: on(inter),
      interUninstall: off(inter),
      bannerHome: on(banner),
      nativeHome: on(native),
      nativeAll: on(native),
      nativeFull: on(native),
      nativeFullSplash: off(native),
      nativeIntro1: on(native),
      nativeIntro2: on(native),
      nativeIntro3: off(native),
      nativeIntro4: off(native),
      nativeLanguage: on(native),
      nativeLanguageSelect: on(native),
      nativePermission: off(native),
      nativePermissionNotification: off(native),
      nativeCurrency: off(native),
      nativeCurrencySelect: off(native),
      nativeExit: off(native),
      nativeUninstall: off(native),
      rewardPasswordShow: on(rewarded),
      rewardDisconnect: off(rewarded),
      rewardVideoUnlock: on(rewarded),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// ADS REMOTE CONFIG — toàn bộ config ads, fetch từ Firebase RC
// ─────────────────────────────────────────────────────────────────

@freezed
abstract class AdsRemoteConfig with _$AdsRemoteConfig {
  @JsonSerializable(explicitToJson: true)
  const factory AdsRemoteConfig({
    @Default(AdUnitsConfig()) AdUnitsConfig units,

    /// Kill switch toàn bộ ads
    @Default(true) bool showAllAds,

    /// Tắt riêng App Open
    @Default(true) bool enableAppOpen,

    /// Cooldown giữa 2 lần show interstitial (giây)
    @Default(15) int interInterval,

    /// Cooldown giữa 2 lần show App Open (giây)
    @Default(30) int appOpenInterval,

    /// Giới hạn số lần show interstitial trong 1 session
    @Default(5) int maxInterPerSession,

    /// Sau khi đóng interstitial có show native full overlay không
    @Default(false) bool nativeFullAfterInter,
  }) = _AdsRemoteConfig;

  const AdsRemoteConfig._();

  factory AdsRemoteConfig.fromJson(Map<String, dynamic> json) => _$AdsRemoteConfigFromJson(json);

  bool isEnabled(AdUnitConfig unit) => showAllAds && unit.enable;

  bool isAppOpenEnabled(AdUnitConfig unit) => showAllAds && enableAppOpen && unit.enable;
}
