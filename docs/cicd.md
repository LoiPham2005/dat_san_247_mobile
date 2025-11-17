# .github/workflows/build.yml
name: Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        env: [dev, staging, prod]
      
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.5'
      
      - run: flutter pub get
      - run: flutter pub run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: flutter test
      
      - name: Build APK (${{ matrix.env }})
        run: flutter build apk --release --dart-define=ENV=${{ matrix.env }}
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-${{ matrix.env }}.apk
          path: build/app/outputs/flutter-apk/app-release.apk