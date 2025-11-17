# Hướng dẫn đổi tên dự án Flutter

```bash
Các bước nhanh nhất:
 # 1. Cài đặt rename package
dart pub global activate rename

# 2. Đổi tên app hiển thị
dart run rename setAppName --value "Tên App Của Bạn"

# 3. Đổi package name/bundle ID
dart run rename setBundleId --value "com.yourcompany.yourapp"

# 4. Clean và rebuild
flutter clean
flutter pub get
flutter run

```

# Hướng dẫn chi tiết đổi tên dự án Flutter
## Phương pháp 1: Sử dụng Package (Khuyên dùng - Nhanh nhất)

### Bước 1: Cài đặt rename package
```bash
dart pub global activate rename
```

### Bước 2: Đổi tên app
```bash
# Đổi tên hiển thị của app
dart run rename setAppName --targets ios,android,macos,linux,windows --value "Tên App Mới"

# Hoặc đổi ngắn gọn
dart run rename setAppName --value "Tên App Mới"
```

### Bước 3: Đổi bundle identifier / package name
```bash
# Đổi bundle ID
dart run rename setBundleId --targets ios,android,macos,linux,windows --value "com.company.newapp"

# Hoặc đổi ngắn gọn
dart run rename setBundleId --value "com.company.newapp"
```

### Ví dụ cụ thể:
```bash
# Đổi tên app thành "My Shop"
dart run rename setAppName --value "My Shop"

# Đổi package thành com.mycompany.myshop
dart run rename setBundleId --value "com.mycompany.myshop"
```

---

## Phương pháp 2: Đổi thủ công (Chi tiết)

Nếu bạn muốn hiểu rõ hoặc package không hoạt động, đây là cách đổi thủ công:

### 1. Đổi tên Android

#### File: `android/app/build.gradle`
```gradle
defaultConfig {
    applicationId "com.company.newapp"  // Đổi dòng này
    minSdkVersion flutter.minSdkVersion
    targetSdkVersion flutter.targetSdkVersion
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
}
```

#### File: `android/app/src/main/AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.company.newapp">  <!-- Đổi dòng này -->
    
    <application
        android:label="Tên App Mới"  <!-- Đổi tên hiển thị -->
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
```

#### Đổi cấu trúc thư mục:
```
android/app/src/main/kotlin/
└── com/
    └── company/        ← Đổi tên folder
        └── newapp/     ← Đổi tên folder
            └── MainActivity.kt
```

#### File: `android/app/src/main/kotlin/.../MainActivity.kt`
```kotlin
package com.company.newapp  // Đổi package name

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

### 2. Đổi tên iOS

#### File: `ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>Tên App Mới</string>  <!-- Đổi tên hiển thị -->

<key>CFBundleName</key>
<string>Tên App Mới</string>  <!-- Đổi tên -->
```

#### Trong Xcode (nếu cần đổi Bundle Identifier):
1. Mở `ios/Runner.xcworkspace` bằng Xcode
2. Chọn **Runner** project ở sidebar trái
3. Chọn tab **General**
4. Đổi **Bundle Identifier** thành `com.company.newapp`

#### Hoặc đổi trong file: `ios/Runner.xcodeproj/project.pbxproj`
Tìm và thay thế:
```
PRODUCT_BUNDLE_IDENTIFIER = com.company.newapp;
```

### 3. Đổi tên trong pubspec.yaml

#### File: `pubspec.yaml`
```yaml
name: new_app_name  # Đổi tên package (dùng snake_case)
description: Mô tả app mới của bạn

publish_to: 'none'
version: 1.0.0+1
```

### 4. Đổi import trong code Dart

Sau khi đổi `name` trong `pubspec.yaml`, phải đổi tất cả import:

**Cũ:**
```dart
import 'package:flutter_base_template/screens/home.dart';
```

**Mới:**
```dart
import 'package:new_app_name/screens/home.dart';
```

**Cách nhanh:** Dùng Find & Replace trong IDE:
- **Find:** `package:flutter_base_template/`
- **Replace:** `package:new_app_name/`

### 5. Đổi tên macOS (nếu có)

#### File: `macos/Runner/Configs/AppInfo.xcconfig`
```
PRODUCT_NAME = Tên App Mới
PRODUCT_BUNDLE_IDENTIFIER = com.company.newapp
```

### 6. Đổi tên Linux (nếu có)

#### File: `linux/CMakeLists.txt`
```cmake
set(BINARY_NAME "new_app_name")
set(APPLICATION_ID "com.company.newapp")
```

### 7. Đổi tên Windows (nếu có)

#### File: `windows/runner/Runner.rc`
Tìm và đổi các dòng:
```
VALUE "ProductName", "Tên App Mới"
VALUE "FileDescription", "Tên App Mới"
```

---

## Checklist sau khi đổi tên

- [ ] Chạy `flutter clean`
- [ ] Chạy `flutter pub get`
- [ ] Xóa thư mục `build/`
- [ ] Với Android: Xóa `android/.gradle` và `android/app/build`
- [ ] Với iOS: Xóa `ios/Pods` và `ios/Podfile.lock`, chạy `cd ios && pod install`
- [ ] Build và test app:
  ```bash
  flutter run
  flutter build apk  # Test Android
  flutter build ios  # Test iOS
  ```

---

## Lưu ý quan trọng

1. **Package name / Bundle ID phải unique:**
   - Format: `com.company.appname`
   - Chỉ dùng chữ thường, không dấu, không ký tự đặc biệt
   - Ví dụ: `com.mycompany.myshop`

2. **Tên trong pubspec.yaml:**
   - Dùng snake_case: `my_shop_app`
   - Không dùng dấu cách, không ký tự đặc biệt

3. **Tên hiển thị app:**
   - Có thể dùng dấu cách, chữ hoa
   - Ví dụ: "My Shop App"

4. **Backup trước khi đổi:**
   ```bash
   git commit -am "Backup before rename"
   ```

5. **Nếu dùng Firebase:**
   - Tải lại `google-services.json` (Android)
   - Tải lại `GoogleService-Info.plist` (iOS)
   - Cập nhật bundle ID trong Firebase Console

---

## Khắc phục lỗi thường gặp

### Lỗi "Couldn't find package"
```bash
flutter clean
flutter pub get
```

### Lỗi build Android
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Lỗi build iOS
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

### Lỗi import không tìm thấy
- Kiểm tra lại tên package trong `pubspec.yaml`
- Find & Replace tất cả import cũ sang import mới