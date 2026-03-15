import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../../core/base/di/injection.dart';
import '../domain/ad_placements.dart';
import '../services/ad_manager.dart';
import 'ad_native_widget.dart';

// ─────────────────────────────────────────────────────────────────
// AD REWARDED DIALOG
// ─────────────────────────────────────────────────────────────────

class AdRewardedDialog {
  AdRewardedDialog._();

  static Future<bool> show({
    required BuildContext context,
    required AdPlacement placement,
    required VoidCallback onRewarded,
    String title = 'Watch Ad',
    String description = 'Watch a short video to unlock this feature.',
    String watchLabel = 'Watch Ad',
    String cancelLabel = 'Cancel',
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelLabel)),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text(watchLabel)),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return false;

    showDialog(context: context, barrierDismissible: false, builder: (_) => const RewardedLoader());

    final earned = await getIt<AdManager>().showRewardedAd(p: placement, onRewarded: onRewarded);
    if (context.mounted) Navigator.pop(context);

    if (!earned && context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Ad Not Available'),
          content: const Text('Please try again later.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
    }
    return earned;
  }
}

class RewardedLoader extends StatelessWidget {
  const RewardedLoader({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black54,
    body: Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 3),
            SizedBox(height: 16),
            Text('Preparing your reward...', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────
// AD APP OPEN LOADER
// ─────────────────────────────────────────────────────────────────

class AdAppOpenLoader extends StatelessWidget {
  const AdAppOpenLoader({
    super.key,
    this.icon,
    this.title = 'WELCOME BACK',
    this.subtitle = 'Preparing your experience...',
    this.color = Colors.blueAccent,
  });

  final Widget? icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, color.withOpacity(0.08)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.15), blurRadius: 20, spreadRadius: 5),
                ],
              ),
              child: icon ?? Icon(Icons.rocket_launch_rounded, size: 64, color: color),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color.withOpacity(0.9),
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            Text(subtitle, style: TextStyle(fontSize: 14, color: color.withOpacity(0.5))),
            const Spacer(flex: 2),
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// AD NATIVE FULL DIALOG
// ─────────────────────────────────────────────────────────────────

class AdNativeFullDialog extends StatelessWidget {
  const AdNativeFullDialog({super.key, required this.placement});
  final AdPlacement placement;

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: sz.width * 0.9,
          constraints: BoxConstraints(maxHeight: sz.height * 0.8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: IconButton(icon: Icon(Icons.close), onPressed: SmartDialog.dismiss),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: AdNativeWidget(placement: placement, template: NativeAdTemplate.full),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
