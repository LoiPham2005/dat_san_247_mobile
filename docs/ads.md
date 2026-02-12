# 📺 Ads Implementation

Hệ thống quảng cáo (Ads) được thiết kế theo module hóa, dễ dàng mở rộng và cấu hình từ xa thông qua Firebase Remote Config.

**Thư mục chính**: `lib/core/ads/`

---

## 1. Cấu hình (Configuration)

### Data cấu hình
Cấu hình Ads được định nghĩa trong `AdConfig`. Mỗi `AdPlacement` có thể cấu hình riêng biệt:

| Field | Type | Description |
|-------|------|-------------|
| `showAllAds` | `bool` | Bật/tắt toàn bộ quảng cáo trong app |
| `interInterval` | `int` | Thời gian giãn cách giữa 2 lần hiện Interstitial (giây) |
| `adUnits` | `Map` | Danh sách cấu hình cho từng placement |

**Mỗi `AdUnitConfig` gồm:**
- `id`: Ad Unit ID chính (AdMob).
- `id2`: ID dự phòng (nếu cần).
- `enable`: Bật/tắt riêng cho placement này.

### Remote Config
Hệ thống sử dụng **Firebase Remote Config** để cập nhật ID và trạng thái ads mà không cần update app.
- **Key**: `ad_config`
- **Fallback**: Tự động dùng `lib/core/ads/config/ad_default_config.dart` nếu fetch lỗi.

```json
// Ví dụ JSON trên Firebase Remote Config
{
  "showAllAds": true,
  "interInterval": 15,
  "adUnitsConfig": {
    "bannerHome": {
      "id": "ca-app-pub-3940256099942544/6300978111",
      "enable": true
    },
    "interSplash": {
      "id": "ca-app-pub-3940256099942544/1033173712",
      "enable": true
    }
  }
}
```

---

## 2. Thêm Placement mới

Để thêm một vị trí quảng cáo mới:

1. Mở `lib/core/ads/domain/ad_placement.dart`.
2. Thêm case mới vào enum `AdPlacement`:

```dart
enum AdPlacement {
  // ... các cái cũ
  bannerProfile(key: 'bannerProfile', type: AdType.banner),
  nativeDetail(key: 'nativeDetail', type: AdType.native);

  final String key;
  final AdType type;
}
```

3. Thêm config mặc định vào `ad_default_config.dart`.

---

## 3. Cách sử dụng (UI Widgets)

### Banner Ads
Sử dụng `AdBannerWidget` để hiển thị banner. Hỗ trợ cả banner thường và sticky.

```dart
// Banner thường
AdBannerWidget(
  placement: AdPlacement.bannerHome,
  size: AdSize.banner,
);

// Sticky Ad (full width, bottom screen)
AdBannerWidget(
  placement: AdPlacement.bannerHome,
  isSticky: true,
  showCloseButton: true, // Nút tắt ad
);
```

### Native Ads
Sử dụng `AdNativeWidget` với các template dựng sẵn (Small, Medium, Full, List Tile).

```dart
// Native Medium (hình chữ nhật)
AdNativeWidget(
  placement: AdPlacement.nativeHome,
  template: NativeAdTemplate.medium,
);

// Native Small (trong list)
AdNativeWidget(
  placement: AdPlacement.nativeList,
  template: NativeAdTemplate.listTile,
  margin: EdgeInsets.all(8),
  backgroundColor: Colors.grey[50],
);
```

---

## 4. Full Screen Ads (Interstitial, Rewarded, AppOpen)

Các loại quảng cáo này được quản lý bởi `AdService` (Singleton). Nên preload trước khi show.

### Interstitial (Quảng cáo xen kẽ)

```dart
final adService = getIt<AdService>();

// 1. Load trước (ví dụ ở màn hình trước đó)
adService.loadInterstitial(AdPlacement.interSplash);

// 2. Show khi cần (tự động check cooldown và cache)
final showed = await adService.showInterstitial(AdPlacement.interSplash);
if (!showed) {
  // Ad chưa load xong hoặc đang cooldown -> chuyển màn hình luôn
  context.go('/home');
}
```

### Rewarded (Quảng cáo thưởng)

```dart
// 1. Load
adService.loadRewarded(AdPlacement.rewardGame);

// 2. Show
await adService.showRewarded(
  AdPlacement.rewardGame,
  onReward: (ad, reward) {
     // User đã xem xong, cộng điểm
     print('User earned: ${reward.amount} ${reward.type}');
  },
);
```

### App Open (Mở app)

```dart
// Thường gọi trong AppLifecycleReactor hoặc Splash
adService.loadAppOpen(AdPlacement.appOpen);

// Show khi resume app
if (adService.isAppOpenLoaded(AdPlacement.appOpen)) {
  adService.showAppOpen(AdPlacement.appOpen);
}
```

---

## 5. AdService Architecture

Class `AdService` là trung tâm xử lý logic Ads:
- **Singleton**: Đảm bảo chỉ có 1 instance quản lý state.
- **Smart Caching**:
    - Cache ads đã load trong bộ nhớ.
    - Tự động hủy (`dispose`) ads hết hạn (sau 1 giờ) để tránh leak memory.
    - Preload ads tiếp theo ngay sau khi dismiss ads cũ.
- **Retry Mechanism**: Tự động reload với chiến thuật *Exponential Backoff* (chờ 2s, 4s, 8s...) khi load thất bại.
- **Circuit Breaker**: Check `interInterval` (giãn cách) để tránh spam quảng cáo vào mặt user.

---

## 6. Debugging & Logs

- Log được gắn tag `[ADS]`.
- Mở Logcat/Console để xem trạng thái:
  - `✅ Ads initialized`: Khởi tạo thành công.
  - `✅ Banner loaded`: Load xong.
  - `📦 Using cached inter`: Dùng lại ad đã load sẵn.
  - `⚠️ Placement disabled`: Config đang tắt ad này.
