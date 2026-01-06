// ════════════════════════════════════════════════════════════════
// 📁 lib/services/app_version_service.dart (TỐI ƯU)
// ════════════════════════════════════════════════════════════════
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AppVersionService {
  static const String androidPackageName = 'com.example.yourapp';
  static const String iosAppId = '123456789';

  // Cache
  static PackageInfo? _cachedPackageInfo;

  /// Get current app version
  Future<String> getCurrentVersion() async {
    _cachedPackageInfo ??= await PackageInfo.fromPlatform();
    return _cachedPackageInfo!.version;
  }

  /// Get current build number
  Future<String> getBuildNumber() async {
    _cachedPackageInfo ??= await PackageInfo.fromPlatform();
    return _cachedPackageInfo!.buildNumber;
  }

  /// Get full app info
  Future<PackageInfo> getAppInfo() async {
    _cachedPackageInfo ??= await PackageInfo.fromPlatform();
    return _cachedPackageInfo!;
  }

  /// Get latest version from store
  Future<String?> getLatestVersion() async {
    if (Platform.isAndroid) {
      return _getLatestAndroidVersion();
    } else if (Platform.isIOS) {
      return _getLatestIOSVersion();
    }
    return null;
  }

  Future<String?> _getLatestAndroidVersion() async {
    try {
      const url =
          'https://play.google.com/store/apps/details?id=$androidPackageName&hl=vi';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final match = RegExp(
          r'\[\[\["([0-9.]+)"\]\]',
        ).firstMatch(response.body);
        return match?.group(1);
      }
    } catch (e) {
      debugPrint('Error fetching Android version: $e');
    }
    return null;
  }

  Future<String?> _getLatestIOSVersion() async {
    try {
      const url = 'https://itunes.apple.com/lookup?id=$iosAppId&country=vn';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['resultCount'] > 0) {
          return data['results'][0]['version'];
        }
      }
    } catch (e) {
      debugPrint('Error fetching iOS version: $e');
    }
    return null;
  }

  /// Compare versions
  bool isUpdateAvailable(String current, String store) {
    final currentParts = current.split('.').map(int.parse).toList();
    final storeParts = store.split('.').map(int.parse).toList();

    final maxLength = currentParts.length > storeParts.length
        ? currentParts.length
        : storeParts.length;

    for (int i = 0; i < maxLength; i++) {
      final curr = i < currentParts.length ? currentParts[i] : 0;
      final stor = i < storeParts.length ? storeParts[i] : 0;

      if (stor > curr) return true;
      if (stor < curr) return false;
    }

    return false;
  }

  /// Check for update and show dialog
  Future<void> checkForUpdate(
    BuildContext context, {
    bool showNoUpdateDialog = false,
  }) async {
    try {
      final current = await getCurrentVersion();
      final latest = await getLatestVersion();

      if (latest != null && isUpdateAvailable(current, latest)) {
        if (context.mounted) {
          _showUpdateDialog(context, current, latest);
        }
      } else if (showNoUpdateDialog && context.mounted) {
        _showNoUpdateDialog(context);
      }
    } catch (e) {
      debugPrint('Error checking update: $e');
    }
  }

  void _showUpdateDialog(BuildContext context, String current, String latest) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Cập nhật ứng dụng'),
        content: Text(
          'Có phiên bản mới!\n\n'
          'Hiện tại: $current\n'
          'Mới nhất: $latest\n\n'
          'Cập nhật để có trải nghiệm tốt nhất.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Để sau'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openStore();
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  void _showNoUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thông báo'),
        content: const Text('Bạn đang dùng phiên bản mới nhất!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> openStore() async {
    final url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=$androidPackageName'
        : 'https://apps.apple.com/app/id$iosAppId';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
