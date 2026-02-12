// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/widgets/ad_rewarded_dialog.dart
// ════════════════════════════════════════════════════════════════

// ignore_for_file: unawaited_futures

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';

import '../domain/ad_placement.dart';
import '../services/ad_manager.dart';

/// Dialog configuration for rewarded ads
class RewardedAdDialogConfig {
  const RewardedAdDialogConfig({
    this.title = 'Watch Ad',
    this.description = 'Watch a short video to unlock this feature.',
    this.watchButtonText = 'Watch Ad',
    this.cancelButtonText = 'Cancel',
    this.errorTitle = 'Ad Not Available',
    this.errorMessage = 'Please try again later.',
    this.errorButtonText = 'OK',
  });

  final String title;
  final String description;
  final String watchButtonText;
  final String cancelButtonText;
  final String errorTitle;
  final String errorMessage;
  final String errorButtonText;
}

/// Helper class for showing rewarded ads with confirmation dialog
class AdRewardedDialog {
  AdRewardedDialog._();

  /// Show rewarded ad with confirmation dialog
  static Future<bool> show({
    required BuildContext context,
    required AdPlacement placement,
    required VoidCallback onRewarded,
    RewardedAdDialogConfig config = const RewardedAdDialogConfig(),
    Widget Function(BuildContext, RewardedAdDialogConfig)? dialogBuilder,
  }) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          dialogBuilder?.call(context, config) ?? _DefaultRewardedDialog(config: config),
    );

    if (confirmed != true || !context.mounted) return false;

    // Show loading
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: Card(
            child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    // Show ad
    final manager = getIt<AdManager>();
    final earned = await manager.showRewardedAd(placement: placement, onRewarded: onRewarded);

    // Dismiss loading
    if (context.mounted) Navigator.pop(context);

    // Show error if not earned
    if (!earned && context.mounted) {
      _showError(context, config);
    }

    return earned;
  }

  /// Show error dialog
  static void _showError(BuildContext context, RewardedAdDialogConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(config.errorTitle),
        content: Text(config.errorMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(config.errorButtonText)),
        ],
      ),
    );
  }
}

/// Default rewarded ad confirmation dialog
class _DefaultRewardedDialog extends StatelessWidget {
  const _DefaultRewardedDialog({required this.config});

  final RewardedAdDialogConfig config;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(config.title),
      content: Text(config.description),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(config.cancelButtonText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(config.watchButtonText),
        ),
      ],
    );
  }
}
