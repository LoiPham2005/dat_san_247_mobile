// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/widgets/ad_interstitial_helper.dart
// ════════════════════════════════════════════════════════════════

// ignore_for_file: unawaited_futures

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';

import '../domain/ad_placement.dart';
import '../services/ad_service.dart';

/// Helper class for showing interstitial ads with loading UI
class AdInterstitialHelper {
  AdInterstitialHelper._();

  /// Show interstitial with loading indicator
  static Future<bool> show({
    required BuildContext context,
    required AdPlacement placement,
    Widget? loadingWidget,
    bool barrierDismissible = false,
  }) async {
    final service = getIt<AdService>();

    // Show loading dialog
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) =>
            loadingWidget ??
            const Center(
              child: Card(
                child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),
              ),
            ),
      );
    }

    // Load if needed
    await service.loadInterstitial(placement);

    // Dismiss loading
    if (context.mounted) Navigator.pop(context);

    // Show ad
    return await service.showInterstitial(placement);
  }

  /// Show interstitial then navigate
  static Future<void> showThenNavigate({
    required BuildContext context,
    required AdPlacement placement,
    required VoidCallback onNavigate,
    Widget? loadingWidget,
  }) async {
    await show(context: context, placement: placement, loadingWidget: loadingWidget);

    // Navigate regardless of ad shown
    if (context.mounted) {
      onNavigate();
    }
  }

  /// Show interstitial before replacing route
  static Future<void> showThenReplace({
    required BuildContext context,
    required AdPlacement placement,
    required String routeName,
    Object? arguments,
  }) async {
    await show(context: context, placement: placement);

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
    }
  }

  /// Show interstitial before pushing new route
  static Future<void> showThenPush({
    required BuildContext context,
    required AdPlacement placement,
    required String routeName,
    Object? arguments,
  }) async {
    await show(context: context, placement: placement);

    if (context.mounted) {
      Navigator.of(context).pushNamed(routeName, arguments: arguments);
    }
  }
}
