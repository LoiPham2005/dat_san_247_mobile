// ════════════════════════════════════════════════════════════════
// 📁 lib/core/utils/app_info.dart (MỚI - CHỈ APP)
// ════════════════════════════════════════════════════════════════
import 'package:package_info_plus/package_info_plus.dart';

/// Application metadata information
class AppInfo {
  AppInfo._();

  // Cache
  static PackageInfo? _cached;

  /// Get package info (cached)
  static Future<PackageInfo> getPackageInfo() async {
    _cached ??= await PackageInfo.fromPlatform();
    return _cached!;
  }

  /// Get app name
  static Future<String> getAppName() async {
    final info = await getPackageInfo();
    return info.appName;
  }

  /// Get package name (bundle ID)
  static Future<String> getPackageName() async {
    final info = await getPackageInfo();
    return info.packageName;
  }

  /// Get app version
  static Future<String> getVersion() async {
    final info = await getPackageInfo();
    return info.version;
  }

  /// Get build number
  static Future<String> getBuildNumber() async {
    final info = await getPackageInfo();
    return info.buildNumber;
  }

  /// Get full version string (e.g., "1.0.0 (123)")
  static Future<String> getFullVersion() async {
    final info = await getPackageInfo();
    return '${info.version} (${info.buildNumber})';
  }

  /// Get all info as Map
  static Future<Map<String, String>> getAll() async {
    final info = await getPackageInfo();
    return {
      'appName': info.appName,
      'packageName': info.packageName,
      'version': info.version,
      'buildNumber': info.buildNumber,
    };
  }

  /// Get app info as string (for logging)
  static Future<String> getInfoString() async {
    final info = await getAll();
    return '${info['appName']} v${info['version']} (${info['buildNumber']})';
  }

  /// Clear cache
  static void clearCache() {
    _cached = null;
  }
}
