# 🚀 Flutter Build & Code Generation Commands (With Flavors)

Hướng dẫn đầy đủ cho build, code generation, và management dự án với **3 flavors: dev, stg, prod** (chỉ dùng Flavors + file main riêng).


```bash

flutter pub run flutter_flavorizr

```

---

## 1. Code Generation (Build Runner)

Generate `.g.dart`, `.freezed.dart`, `.config.dart` files:

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild on changes)
dart run build_runner watch --delete-conflicting-outputs
```

**Output:** Tự động generate files trong `lib/`, `lib/env/`, `lib/gen/`

---

## 2. Generate Localization (i18n)

Generate localization files từ `.arb`:

```bash
flutter gen-l10n
```

**Output:** `lib/gen/l10n/` (localization files được generate)

---

## 3. Clean Project

Remove build artifacts và regenerate:

```bash
flutter clean && flutter pub get
```

---

## 4. Build APK (With Flavors + Entrypoint)

Build APK cho từng environment sử dụng **flavor riêng + file main riêng**:

### Development

```bash
flutter build apk --flavor dev -t lib/main_dev.dart
```

### Staging

```bash
flutter build apk --flavor stg -t lib/main_stg.dart
```

### Production (Optimized)

```bash
flutter build apk --flavor prod -t lib/main_prod.dart --release \
  --obfuscate --split-debug-info=build/debug-symbols
```

**Output location:** `build/app/outputs/flutter-apk/`

---

## 5. Build AAB (App Bundle - For Google Play)

Build Android App Bundle cho từng environment:

### Development

```bash
flutter build appbundle --flavor dev -t lib/main_dev.dart
```

### Staging

```bash
flutter build appbundle --flavor stg -t lib/main_stg.dart
```

### Production (Optimized)

```bash
flutter build appbundle --flavor prod -t lib/main_prod.dart --release \
  --obfuscate --split-debug-info=build/debug-symbols
```

**Output location:** `build/app/outputs/bundle/`

---

## 6. Build iOS (With Flavors)

### Development

```bash
flutter build ios --flavor dev -t lib/main_dev.dart
```

### Staging

```bash
flutter build ios --flavor stg -t lib/main_stg.dart
```

### Production

```bash
flutter build ios --flavor prod -t lib/main_prod.dart --release
```

**Output location:** `build/ios/iphoneos/`

---

## 7. Run on Device/Emulator (With Flavors)

### Development

```bash
flutter run --flavor dev -t lib/main_dev.dart
```

### Staging

```bash
flutter run --flavor stg -t lib/main_stg.dart
```

### Production

```bash
flutter run --flavor prod -t lib/main_prod.dart
```

**VS Code:** Nhấn `F5` → Chọn flavor (🧑‍💻 Dev / 🧪 Stg / 🚀 Prod) → Run

---

## 8. Upgrade Dependencies

Check và upgrade packages:

```bash
# Upgrade tất cả packages
flutter pub upgrade

# Xem packages outdated
flutter pub outdated

# Upgrade specific package
flutter pub upgrade package_name
```

---

## 9. Code Analysis & Formatting

### Analyze code cho lỗi

```bash
flutter analyze
```

### Format code (Dart style)

```bash
dart format .
```

---

## 10. Run Tests

### Unit & Widget Tests

```bash
flutter test
```

### Run specific test file

```bash
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart
```

### Run with coverage

```bash
flutter test --coverage
```

---

## 📋 Quick Command Reference

| Task                   | Command |
|------------------------|---------|
| **Build APK Dev**      | `flutter build apk --flavor dev -t lib/main_dev.dart` |
| **Build APK Stg**      | `flutter build apk --flavor stg -t lib/main_stg.dart` |
| **Build APK Prod**     | `flutter build apk --flavor prod -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-symbols` |
| **Build AAB Dev**      | `flutter build appbundle --flavor dev -t lib/main_dev.dart` |
| **Build AAB Stg**      | `flutter build appbundle --flavor stg -t lib/main_stg.dart` |
| **Build AAB Prod**     | `flutter build appbundle --flavor prod -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-symbols` |
| **Run Dev**            | `flutter run --flavor dev -t lib/main_dev.dart` |
| **Run Stg**            | `flutter run --flavor stg -t lib/main_stg.dart` |
| **Run Prod**           | `flutter run --flavor prod -t lib/main_prod.dart` |
| **Code Gen (One-time)**| `dart run build_runner build --delete-conflicting-outputs` |
| **Code Gen (Watch)**   | `dart run build_runner watch --delete-conflicting-outputs` |
| **i18n**               | `flutter gen-l10n` |
| **Clean & Get**        | `flutter clean && flutter pub get` |
| **Analyze**            | `flutter analyze` |
| **Format**             | `dart format .` |
| **Test**               | `flutter test` |

---

## 🎯 Typical Workflow

### Lần đầu setup

```bash
# 1. Clone & setup
git clone <repo-url>
cd flutter_base_template
flutter pub get

# 2. Code generation
dart run build_runner build --delete-conflicting-outputs

# 3. Generate localization
flutter gen-l10n

# 4. Run development
flutter run --flavor dev -t lib/main_dev.dart
```

### Development workflow

```bash
# Code generation (watch mode - auto update)
dart run build_runner watch --delete-conflicting-outputs

# Run app (trong terminal khác)
flutter run --flavor dev -t lib/main_dev.dart
```

### Before commit

```bash
# Format code
dart format .

# Analyze
flutter analyze

# Run tests
flutter test
```

### Build for release

```bash
# Clean
flutter clean && flutter pub get

# Code gen
dart run build_runner build --delete-conflicting-outputs

# i18n
flutter gen-l10n

# Build staging (test)
flutter build apk --flavor stg -t lib/main_stg.dart

# Build production
flutter build apk --flavor prod -t lib/main_prod.dart --release \
  --obfuscate --split-debug-info=build/debug-symbols

# Build AAB for Google Play
flutter build appbundle --flavor prod -t lib/main_prod.dart --release \
  --obfuscate --split-debug-info=build/debug-symbols
```

---

## 📝 Notes

- **Flavors**: Đã cấu hình trong [`android/app/build.gradle.kts`](../android/app/build.gradle.kts) (dev, stg, prod).
- **Entrypoint**: Mỗi flavor có file main riêng: `lib/main_dev.dart`, `lib/main_stg.dart`, `lib/main_prod.dart`.
- **Environment Config**: Cấu hình trong `lib/core/config/environment_config.dart` (set khi init app).
- **Minification**: Chỉ enable cho production (xem build command).
- **Output**: APK/AAB sẽ nằm trong `build/app/outputs/`.
- **Performance**: Dùng `--split-debug-info` để giảm size APK (~8-10MB).

---

## 🔗 Related Docs

- 📖 [Environment Setup](ENVIRONMENT_SETUP.md)
- 🏗️ [Architecture](architecture.md)
- 📝 [Keybinding](keybinding.md)
- 📱 [Setup Keystore](setup_keystore.md)
- 🚀 [CI/CD](cicd.md)

---
