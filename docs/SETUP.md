# 🛠️ Setup & Environment Configuration

## 1. Prerequisites

- **FVM (Flutter Version Manager)**:
  ```bash
  dart pub global activate fvm
  fvm install
  ```
- **Mason (Templates)**:
  ```bash
  dart pub global activate mason_cli
  mason get
  ```

## 2. Environment Configuration

The project uses a robust **Flavor + Environment** strategy.

### 2.1. Flavors (Native Layer)
Configured in `android/app/build.gradle.kts` and `ios/Runner.xcodeproj`.
- **dev**: Development (suffix `.dev`, label "App Dev")
- **stg**: Staging (suffix `.stg`, label "App Stg")
- **prod**: Production (no suffix, label "App")

### 2.2. Environment Variables (.env)
Create these files in root (see `.env.example`):

**`.env.dev`**
```properties
API_BASE_URL=https://dev-api.example.com
ENABLE_LOGGING=true
```

**`.env.stg`**
```properties
API_BASE_URL=https://stg-api.example.com
ENABLE_LOGGING=true
```

**`.env.prod`**
```properties
API_BASE_URL=https://api.example.com
ENABLE_LOGGING=false
```

### 2.3. VS Code Setup
We have pre-configured `.vscode/launch.json` for all flavors.
- Press `F5` to start debugging.
- Select flavor: `Dev (Debug)`, `Stg (Debug)`, 'Prod (Release)', etc.

## 3. Signing (Android)

To build for release, you need a Keystore.

1. **Generate Keystore**:
   ```bash
   keytool -genkey -v -keystore android/app/release.keystore -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Create `android/key.properties`**:
   *(Do NOT commit this file)*
   ```properties
   storePassword=android
   keyPassword=android
   keyAlias=androiddebugkey
   storeFile=release.keystore
   ```

3. **Configure Gradle**:
   The `build.gradle.kts` is already set up to read `key.properties`.

## 4. iOS Setup

1. **Install Pods**:
   ```bash
   cd ios
   fvm flutter preload  # or flutter pub get
   pod install
   ```
2. **Xcode**:
   - Open `ios/Runner.xcworkspace`.
   - Go to **Signing & Capabilities**.
   - Select Team and provisioning profile for each scheme (`dev`, `stg`, `prod`).

## 5. CI/CD (GitHub Actions)
A sample workflow is at `.github/workflows/build.yml`.
It automatically:
- Installs Flutter.
- Runs Analyzer & Tests.
- Builds APK for the target branch/flavor.
