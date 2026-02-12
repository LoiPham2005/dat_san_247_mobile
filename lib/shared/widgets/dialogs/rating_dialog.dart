import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/constants/app_constants.dart';
import 'package:dat_san_247_mobile/core/storage/local/local_storage_keys.dart';
import 'package:dat_san_247_mobile/core/storage/secure/secure_storage_keys.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../buttons/app_button.dart';

class AppRatingDialog extends StatefulWidget {
  const AppRatingDialog({super.key, required this.packageName, this.appStoreId});

  final String packageName;
  final String? appStoreId;

  /// Static method to check history and show dialog if not rated yet
  static Future<void> show(BuildContext context, {String? packageName, String? appStoreId}) async {
    final prefs = await SharedPreferences.getInstance();
    final hasRated = prefs.getBool(LocalStorageKeys.hasRatedApp) ?? false;

    if (hasRated) return;

    // Use AppConstants as default values before trying fallback logic
    String resolvedPackageName = packageName ?? AppConstants.androidPackageName;
    final String resolvedAppStoreId = appStoreId ?? AppConstants.appStoreId;

    // If still empty (e.g. constant is empty), try PackageInfo
    if (resolvedPackageName.isEmpty) {
      try {
        final info = await PackageInfo.fromPlatform();
        resolvedPackageName = info.packageName;
      } catch (e) {
        debugPrint('Error getting package info: $e');
      }
    }

    if (context.mounted && resolvedPackageName.isNotEmpty) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) =>
            AppRatingDialog(packageName: resolvedPackageName, appStoreId: resolvedAppStoreId),
      );
    }
  }

  @override
  State<AppRatingDialog> createState() => _AppRatingDialogState();
}

class _AppRatingDialogState extends State<AppRatingDialog> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Đánh giá ứng dụng',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Bạn cảm thấy trải nghiệm với ứng dụng thế nào?', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Expanded(
          child: AppButton(
            onPressed: () => Navigator.pop(context),
            label: 'Để sau',
            type: AppButtonType.outline,
            size: AppButtonSize.small,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            onPressed: _rating == 0 ? null : _onSubmit,
            label: 'Gửi',
            type: AppButtonType.primary,
            size: AppButtonSize.small,
            isDisabled: _rating == 0,
          ),
        ),
      ],
    );
  }

  Future<void> _onSubmit() async {
    if (!mounted) return;

    // 1. Mark as rated permanently
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LocalStorageKeys.hasRatedApp, true);

    // 2. Prepare logic
    final bool shouldOpenStore = _rating >= 4;

    // 3. Show Thank You Toast first (so user sees it)
    if (mounted) {
      _showThankYou();
    }

    // 4. Open Store if high rating
    if (shouldOpenStore) {
      await _openStore();
    }

    // 5. Close Dialog
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _openStore() async {
    try {
      final Uri uri;
      if (Platform.isAndroid) {
        // Try market:// first
        uri = Uri.parse('market://details?id=${widget.packageName}');
      } else if (Platform.isIOS && widget.appStoreId != null) {
        uri = Uri.parse('https://apps.apple.com/app/id${widget.appStoreId}');
      } else {
        return;
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to web link if market:// fails (especially for Android simulators)
        if (Platform.isAndroid) {
          final webUri = Uri.parse(
            'https://play.google.com/store/apps/details?id=${widget.packageName}',
          );
          if (await canLaunchUrl(webUri)) {
            await launchUrl(webUri, mode: LaunchMode.externalApplication);
          }
        }
      }
    } catch (e) {
      debugPrint('Error opening store: $e');
    }
  }

  void _showThankYou() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: const Text('Cảm ơn bạn!'),
      description: const Text('Cảm ơn bạn đã dành thời gian đánh giá.'),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
    );
  }
}
