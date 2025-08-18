import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckVersion {
  static Future<void> check(BuildContext context, {
    required String androidPackageId,
    required String iosBundleId,
  }) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      String appName = packageInfo.appName;

      ModelVersion? storeVersion;

      if (Platform.isAndroid) {
        storeVersion = await _getAndroidStoreVersion(androidPackageId);
      } else if (Platform.isIOS) {
        storeVersion = await _getIosStoreVersion(iosBundleId);
      }

      if (storeVersion == null) return;

      if (_isNewer(currentVersion, storeVersion.version)) {
        _showUpdateDialog(context, appName, currentVersion, storeVersion);
      }
    } catch (e) {
      print("Check version error: $e");
    }
  }

  static Future<ModelVersion?> _getAndroidStoreVersion(String id) async {
    final url = 'https://play.google.com/store/apps/details?id=$id&hl=en';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) return null;

    final match = RegExp(r'\[\[\["([0-9.,]*)"]],')
        .firstMatch(response.body);

    final version = match?.group(1)?.replaceAll(",", "") ?? "1.0.0";

    return ModelVersion(
      version: version,
      url: url,
    );
  }

  static Future<ModelVersion?> _getIosStoreVersion(String bundleId) async {
    final url = 'https://itunes.apple.com/vn/lookup?bundleId=$bundleId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) return null;

    final jsonObj = json.decode(response.body);
    final results = jsonObj['results'];

    if (results == null || results.isEmpty) return null;

    return ModelVersion(
      version: results[0]['version'],
      url: results[0]['trackViewUrl'],
    );
  }

  static bool _isNewer(String current, String remote) {
    List<int> c = current.split('.').map(int.parse).toList();
    List<int> r = remote.split('.').map(int.parse).toList();
    for (int i = 0; i < r.length; i++) {
      if (i >= c.length || r[i] > c[i]) return true;
      if (r[i] < c[i]) return false;
    }
    return false;
  }

  static void _showUpdateDialog(BuildContext context, String appName, String currentVersion, ModelVersion storeVersion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cập nhật"),
        content: Text(
            "Đã có phiên bản mới của $appName.\n\n"
            "Phiên bản mới: ${storeVersion.version}\n"
            "Phiên bản hiện tại: $currentVersion"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
          TextButton(
            onPressed: () async {
              final uri = Uri.parse(storeVersion.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Không thể mở link cập nhật")),
                );
              }
            },
            child: const Text("Cập nhật"),
          ),
        ],
      ),
    );
  }
}

class ModelVersion {
  final String version;
  final String url;

  ModelVersion({required this.version, required this.url});
}
