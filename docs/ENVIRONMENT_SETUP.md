# 🌍 Environment Setup Guide

## Cấu hình Environment (Dev/Staging/Prod)

Dự án hỗ trợ **3 môi trường** (dev, stg, prod) bằng cách kết hợp:
- ✅ **Flavors** (native config: appId, icon, tên app)
- ✅ **Entrypoint riêng** (`main_dev.dart`, `main_stg.dart`, `main_prod.dart`)
- ✅ **Environment Config** (cấu hình tại khởi tạo app)

---

## 1. Quick Start

### Command line

```bash
# Development
flutter run --flavor dev -t lib/main_dev.dart

# Staging
flutter run --flavor stg -t lib/main_stg.dart

# Production
flutter run --flavor prod -t lib/main_prod.dart
```

### VS Code (nhấn F5)

Chọn configuration:
- 🧑‍💻 **Development (Debug)** → run dev
- 🧪 **Staging (Debug)** → run staging
- 🚀 **Production (Debug)** → run production

---

## 2. VS Code Setup

File: [`.vscode/launch.json`](.vscode/launch.json)

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "🧑‍💻 Development (Debug)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart",
      "args": ["--flavor", "dev"],
      "flutterMode": "debug"
    },
    {
      "name": "🧪 Staging (Debug)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_stg.dart",
      "args": ["--flavor", "stg"],
      "flutterMode": "debug"
    },
    {
      "name": "🚀 Production (Debug)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": ["--flavor", "prod"],
      "flutterMode": "debug"
    },
    {
      "name": "📦 Production (Release)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": ["--flavor", "prod", "--release"],
      "flutterMode": "release"
    }
  ]
}
```

---

## 3. Environment Configuration (Dart)

File: [`lib/core/config/environment_config.dart`](../lib/core/config/environment_config.dart)

```dart
import 'package:flutter_base_template/env/env_dev.dart';
import 'package:flutter_base_template/env/env_stg.dart';
import 'package:flutter_base_template/env/env_prod.dart';

enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment _current = Environment.development;

  // Set environment từ entrypoint (main_dev.dart, main_stg.dart, main_prod.dart)
  static void setEnvironment(Environment env) => _current = env;
  static Environment get environment => _current;

  // ════════════════════════════════════════════════════════════
  // API CONFIGURATION
  // ════════════════════════════════════════════════════════════
  static String get apiBaseUrl => switch (_current) {
    Environment.development => EnvDev.apiBaseUrl,
    Environment.staging => EnvStg.apiBaseUrl,
    Environment.production => EnvProd.apiBaseUrl,
  };

  static String get wsUrl => switch (_current) {
    Environment.development => EnvDev.wsUrl,
    Environment.staging => EnvStg.wsUrl,
    Environment.production => EnvProd.wsUrl,
  };

  // ════════════════════════════════════════════════════════════
  // FEATURE FLAGS
  // ════════════════════════════════════════════════════════════
  static bool get enableLogging => switch (_current) {
    Environment.development => EnvDev.enableLogging,
    Environment.staging => EnvStg.enableLogging,
    Environment.production => EnvProd.enableLogging,
  };

  static bool get enableDebugTools => switch (_current) {
    Environment.development => EnvDev.enableDebugTools,
    Environment.staging => EnvStg.enableDebugTools,
    Environment.production => EnvProd.enableDebugTools,
  };

  // ... (Các getters khác)

  // ════════════════════════════════════════════════════════════
  // HELPERS
  // ════════════════════════════════════════════════════════════
  static bool get isDev => _current == Environment.development;
  static bool get isStaging => _current == Environment.staging;
  static bool get isProd => _current == Environment.production;
}
```

---

## 4. Entrypoint Files

### `lib/main_dev.dart`

```dart
import 'package:flutter_base_template/core/config/environment_config.dart';
import 'package:flutter_base_template/main_common.dart';

void main() => mainCommon(Environment.development);
```

### `lib/main_stg.dart`

```dart
import 'package:flutter_base_template/core/config/environment_config.dart';
import 'package:flutter_base_template/main_common.dart';

void main() => mainCommon(Environment.staging);
```

### `lib/main_prod.dart`

```dart
import 'package:flutter_base_template/core/config/environment_config.dart';
import 'package:flutter_base_template/main_common.dart';

void main() => mainCommon(Environment.production);
```

---

## 5. Android Flavors Setup

File: [`android/app/build.gradle.kts`](../android/app/build.gradle.kts)

```kotlin
flavorDimensions += "environment"
productFlavors {
    create("dev") {
        dimension = "environment"
        applicationIdSuffix = ".dev"
        versionNameSuffix = "-dev"
        resValue("string", "app_name", "Base App Dev")
    }
    create("stg") {
        dimension = "environment"
        applicationIdSuffix = ".stg"
        versionNameSuffix = "-stg"
        resValue("string", "app_name", "Base App Stg")
    }
    create("prod") {
        dimension = "environment"
        resValue("string", "app_name", "Base App")
    }
}
```

**Result**: 3 app khác nhau có thể cài song song:
- `com.example.flutter_base_template.dev` (Base App Dev)
- `com.example.flutter_base_template.stg` (Base App Stg)
- `com.example.flutter_base_template` (Base App)

---

## 6. iOS Flavors Setup (Xcode)

1. **Tạo 3 Schemes**: dev, stg, prod
2. **Tạo 3 Targets**: Base App Dev, Base App Stg, Base App
3. **Cấu hình Bundle Identifier** cho mỗi target:
   - Dev: `com.example.flutter_base_template.dev`
   - Stg: `com.example.flutter_base_template.stg`
   - Prod: `com.example.flutter_base_template`
4. **Cấu hình icon, launch screen, Firebase** riêng cho mỗi target (tùy chọn)

---

## 7. Build Commands

### APK

```bash
# Dev
flutter build apk --flavor dev -t lib/main_dev.dart

# Stg
flutter build apk --flavor stg -t lib/main_stg.dart

# Prod (optimized)
flutter build apk --flavor prod -t lib/main_prod.dart --release \
  --obfuscate --split-debug-info=build/debug-symbols
```

### AAB (Google Play)

```bash
# Prod
flutter build appbundle --flavor prod -t lib/main_prod.dart --release \
  --obfuscate --split-debug-info=build/debug-symbols
```

---

## 8. Environment Files (.env)

Files: [`.env.dev`](.env.dev), [`.env.stg`](.env.stg), [`.env.prod`](.env.prod)

### `.env.dev`

```
API_BASE_URL=https://dev-api.example.com
WS_URL=wss://dev-ws.example.com
ENABLE_LOGGING=true
ENABLE_DEBUG_TOOLS=true
ENABLE_ANALYTICS=false
CONNECT_TIMEOUT=60
RECEIVE_TIMEOUT=60
```

### `.env.stg`

```
API_BASE_URL=https://stg-api.example.com
WS_URL=wss://stg-ws.example.com
ENABLE_LOGGING=true
ENABLE_DEBUG_TOOLS=false
ENABLE_ANALYTICS=true
CONNECT_TIMEOUT=30
RECEIVE_TIMEOUT=30
```

### `.env.prod`

```
API_BASE_URL=https://api.example.com
WS_URL=wss://ws.example.com
ENABLE_LOGGING=false
ENABLE_DEBUG_TOOLS=false
ENABLE_ANALYTICS=true
CONNECT_TIMEOUT=30
RECEIVE_TIMEOUT=30
```

Generated files: `lib/env/env_dev.dart`, `lib/env/env_stg.dart`, `lib/env/env_prod.dart` (auto-generated by `envied`)

---

## 9. CI/CD Integration

File: `.github/workflows/build.yml`

```yaml
name: Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        env: [dev, stg, prod]

    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.5'

      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: flutter test

      - name: Build APK (${{ matrix.env }})
        run: |
          if [ "${{ matrix.env }}" == "prod" ]; then
            flutter build apk --flavor prod -t lib/main_prod.dart --release \
              --obfuscate --split-debug-info=build/debug-symbols
          else
            flutter build apk --flavor ${{ matrix.env }} -t lib/main_${{ matrix.env }}.dart
          fi

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-${{ matrix.env }}.apk
          path: build/app/outputs/flutter-apk/app-*.apk
```

## 🔗 Related Docs

- 📖 [docs/build_flavor.md](build_flavor.md)
- 🏗️ [docs/architecture.md](architecture.md)
- ⌨️ [docs/keybinding.md](keybinding.md)

---
