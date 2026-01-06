# 📖 Ads Integration Guide

## 🎯 Overview

Hệ thống ads hoàn chỉnh với Remote Config, hỗ trợ tất cả loại quảng cáo Google Mobile Ads.

### ✅ Features
- ✅ Remote Config integration
- ✅ Multiple ad formats (Banner, Interstitial, Rewarded, Native, App Open)
- ✅ Smart frequency capping
- ✅ Placement-based control
- ✅ A/B testing support (id2)
- ✅ Kill switches
- ✅ Cooldown management

---

## 📦 Installation

### 1. Add dependencies to `pubspec.yaml`

```yaml
dependencies:
  google_mobile_ads: ^5.2.0
  firebase_remote_config: ^5.1.4
  freezed_annotation: ^2.4.4
  injectable: ^2.5.0

dev_dependencies:
  freezed: ^2.5.7
  build_runner: ^2.4.13
  json_serializable: ^6.8.0
```

### 2. Run build_runner

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## ⚙️ Setup

### 1. Initialize in `main.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'core/di/injection.dart';
import 'core/ads/services/ad_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize DI
  configureDependencies();

  // Initialize Ads
  final adManager = getIt<AdManager>();
  await adManager.initialize();

  runApp(MyApp());
}
```

### 2. Configure Firebase Remote Config

Trong Firebase Console → Remote Config, thêm parameter:

**Key**: `ad_config`
**Type**: JSON
**Value**: Copy JSON từ document bạn cung cấp

### 3. AndroidManifest.xml

```xml
<manifest>
    <application>
        <!-- Google Mobile Ads App ID -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

### 4. Info.plist (iOS)

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
<key>SKAdNetworkItems</key>
<array>
  <dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cstr6suwn9.skadnetwork</string>
  </dict>
</array>
```

---

## 🚀 Usage Examples

### Example 1: Splash Screen với App Open Ad

```dart
class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _adManager = getIt<AdManager>();

  @override
  void initState() {
    super.initState();
    _showSplashAd();
  }

  Future<void> _showSplashAd() async {
    await Future.delayed(Duration(seconds: 2)); // Splash duration

    await _adManager.showSplashAppOpen(
      onAdDismissed: () => _navigateToHome(),
      onAdFailed: () => _navigateToHome(),
    );
  }

  void _navigateToHome() {
    context.goTo('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

### Example 2: Home Screen với Banner Ad

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Your content
                Text('Home content here'),
              ],
            ),
          ),

          // Banner ad at bottom
          SmartBannerAdWidget(placement: 'bannerHome'),
        ],
      ),
    );
  }
}
```

### Example 3: Navigation với Interstitial

```dart
class HomePage extends StatelessWidget {
  final _adManager = getIt<AdManager>();

  void _navigateToDetails(BuildContext context) async {
    // Show ad on navigation
    await _adManager.maybeShowNavigationAd();

    // Navigate
    context.pushTo('/details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].name),
            onTap: () => _navigateToDetails(context),
          );
        },
      ),
    );
  }
}
```

### Example 4: Native Ad trong List

```dart
class ArticleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          // Show native ad every 5 items
          if (index % 5 == 4) {
            return SmartNativeAdWidget(
              placement: 'nativeAll',
              height: 300,
            );
          }

          return ArticleCard(article: articles[index]);
        },
      ),
    );
  }
}
```

### Example 5: Rewarded Ad cho Unlock Feature

```dart
class PasswordDetailPage extends StatelessWidget {
  final _adManager = getIt<AdManager>();

  void _unlockPassword(BuildContext context) async {
    final success = await _adManager.showPasswordReward(
      onRewarded: () {
        context.showSuccess('Password unlocked!');
        // Show password
        _showPassword();
      },
    );

    if (!success) {
      context.showError('Ad not available. Try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Password: ********'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _unlockPassword(context),
              child: Text('Watch Ad to Unlock'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Example 6: Intro Flow với Native Ads

```dart
class IntroPage extends StatefulWidget {
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _adManager = getIt<AdManager>();
  int _currentPage = 0;

  void _nextPage() async {
    if (_currentPage == 2) {
      // Show interstitial before finishing intro
      await _adManager.showIntroAd();
      context.goTo('/home');
    } else {
      setState(() => _currentPage++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          // Page 1 with native ad
          Column(
            children: [
              Expanded(child: IntroContent1()),
              SmartNativeAdWidget(
                placement: 'nativeIntro1',
                height: 250,
              ),
            ],
          ),

          // Page 2 with native ad
          Column(
            children: [
              Expanded(child: IntroContent2()),
              SmartNativeAdWidget(
                placement: 'nativeIntro2',
                height: 250,
              ),
            ],
          ),

          // Page 3
          IntroContent3(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _nextPage,
            child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
          ),
        ),
      ),
    );
  }
}
```

### Example 7: App Resume Ad

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _adManager = getIt<AdManager>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Show ad when app resumes
      _adManager.showOnResumeAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: getIt<AppRouter>().router,
    );
  }
}
```

### Example 8: Back Button với Interstitial

```dart
class DetailsPage extends StatelessWidget {
  final _adManager = getIt<AdManager>();

  Future<bool> _onWillPop() async {
    // Show ad before going back
    await _adManager.showBackAd();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: Text('Details')),
        body: Center(child: Text('Content')),
      ),
    );
  }
}
```

---

## 🎛️ Remote Config Control

### Kill Switches

Tắt tất cả quảng cáo:
```json
{
  "showAllAds": false
}
```

Tắt placement cụ thể:
```json
{
  "adUnitsConfig": {
    "interHome": {
      "enable": false
    }
  }
}
```

### Frequency Control

Thay đổi tần suất hiển thị interstitial:
```json
{
  "interInterval": 30
}
```

### A/B Testing với id2

```json
{
  "adUnitsConfig": {
    "nativeHome": {
      "id": "ca-app-pub-xxx/111",
      "id2": "ca-app-pub-xxx/222",
      "id2RequestPercentage": 50
    }
  }
}
```

---

## 🔧 Advanced Usage

### Custom Native Ad Template

```dart
SmartNativeAdWidget(
  placement: 'nativeHome',
  templateStyle: NativeTemplateStyle(
    templateType: TemplateType.medium,
    mainBackgroundColor: Colors.white,
    cornerRadius: 12.0,
    callToActionTextStyle: NativeTemplateTextStyle(
      textColor: Colors.white,
      backgroundColor: Colors.blue,
      style: NativeTemplateFontStyle.bold,
      size: 16.0,
    ),
    primaryTextStyle: NativeTemplateTextStyle(
      textColor: Colors.black,
      backgroundColor: Colors.transparent,
      style: NativeTemplateFontStyle.normal,
      size: 16.0,
    ),
  ),
)
```

### Check Placement Enabled

```dart
if (_adManager.isPlacementEnabled('interHome')) {
  // Load or show ad
}
```

### Refresh Remote Config

```dart
// In settings or admin panel
await _adManager.refreshConfig();
```

---

## 📊 Ad Placements Map

| Placement | Type | Usage |
|-----------|------|-------|
| `interSplash` | Interstitial | Splash screen |
| `openSplash` | App Open | Splash screen |
| `openOnResume` | App Open | App resume |
| `nativeLanguage` | Native | Language selection |
| `nativeIntro1/2/3/4` | Native | Intro pages |
| `interIntro` | Interstitial | After intro |
| `bannerHome` | Banner | Home screen bottom |
| `interHome` | Interstitial | Navigation |
| `nativeHome` | Native | Home screen list |
| `interPasswordShow` | Interstitial | Before showing password |
| `rewardPasswordShow` | Rewarded | Unlock password |
| `rewardDisconnect` | Rewarded | Disconnect feature |
| `interBack` | Interstitial | Back button |
| `nativeAll` | Native | General usage |

---

## ✅ Best Practices

1. ✅ **Preload ads** trong `initialize()` của AdManager
2. ✅ **Use cooldown** để không spam ads
3. ✅ **Test với test IDs** trước khi release
4. ✅ **Monitor Remote Config** để điều chỉnh frequency
5. ✅ **Dispose ads properly** khi widget dispose
6. ✅ **Handle ad failures** gracefully
7. ✅ **Show loading indicators** khi đợi rewarded ads
8. ✅ **Use kill switches** để emergency disable

---

## 🐛 Troubleshooting

### Ads not showing?

1. Check Remote Config: `showAllAds = true`
2. Check placement enabled: `enable = true`
3. Check Ad ID is correct
4. Check cooldown not active
5. Check internet connection

### Test Ads

Use test IDs from your Remote Config (already using test IDs).

---

## 📌 Summary

### Quick Start
```dart
// 1. Initialize in main.dart
await getIt<AdManager>().initialize();

// 2. Show banner
SmartBannerAdWidget(placement: 'bannerHome')

// 3. Show interstitial on navigation
await _adManager.maybeShowNavigationAd();

// 4. Show rewarded
await _adManager.showPasswordReward(
  onRewarded: () => print('Rewarded!'),
);
```

Hệ thống ads của bạn đã sẵn sàng! 🚀
