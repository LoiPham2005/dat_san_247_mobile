import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/core/utils/device_info.dart'; // ✅ CHANGED

/// Mixin quản lý System UI (Status Bar, Navigation Bar)
///
/// Example:
/// ```dart
/// class MyPage extends StatefulWidget {
///   const MyPage({super.key});
/// }
///
/// class _MyPageState extends State<MyPage> with SystemUiMixin {
///   @override
///   void initState() {
///     super.initState();
///     hideSystemNavigationBar();
///   }
/// }
/// ```
mixin SystemUiMixin<T extends StatefulWidget> on State<T> {
  /// Hide system navigation bar (Android only)
  void hideSystemNavigationBar() {
    if (!Platform.isAndroid) return;

    _setSystemUIMode();
    _setupAutoHide();
  }

  /// Show system navigation bar
  void showSystemNavigationBar() {
    if (!Platform.isAndroid) return;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
  }

  /// Hide with specific mode
  void _setSystemUIMode() async {
    final androidVersion = await DeviceInfo.getAndroidSdkVersion(); // ✅ CHANGED

    final mode = androidVersion > 30 ? SystemUiMode.manual : SystemUiMode.immersive;

    SystemChrome.setEnabledSystemUIMode(mode, overlays: [SystemUiOverlay.top]);
  }

  /// Setup auto-hide when navigation bar appears
  void _setupAutoHide() {
    SystemChrome.setSystemUIChangeCallback((bool systemOverlaysAreVisible) async {
      if (systemOverlaysAreVisible) {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _setSystemUIMode();
        }
      }
    });
  }

  /// Set transparent system bars
  void setTransparentSystemBars({
    Color? statusBarColor,
    Color? navigationBarColor,
    Brightness? statusBarIconBrightness,
    Brightness? navigationBarIconBrightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? Colors.transparent,
        systemNavigationBarColor: navigationBarColor ?? Colors.transparent,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        systemNavigationBarIconBrightness: navigationBarIconBrightness ?? Brightness.dark,
      ),
    );
  }

  /// Lock orientation to portrait
  void lockPortraitOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Lock orientation to landscape
  void lockLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Allow all orientations
  void allowAllOrientations() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  /// Enter fullscreen mode (hide status bar + navigation bar)
  void enterFullscreen() {
    if (Platform.isAndroid) {
      hideSystemNavigationBar();
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  /// Exit fullscreen mode
  void exitFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
  }

  @override
  void dispose() {
    // Reset to default when widget disposed
    if (Platform.isAndroid) {
      showSystemNavigationBar();
    }
    SystemChrome.setSystemUIChangeCallback(null);
    super.dispose();
  }
}
