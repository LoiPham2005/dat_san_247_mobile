// ════════════════════════════════════════════════════════════════
// 📁 lib/core/utils/device_info.dart (MỚI - CHỈ DEVICE)
// ════════════════════════════════════════════════════════════════
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Device hardware & platform information
class DeviceInfo {
  DeviceInfo._();

  static final _plugin = DeviceInfoPlugin();
  
  // Cache
  static Map<String, dynamic>? _cachedInfo;
  static String? _cachedDeviceId;

  // ═══════════════════════════════════════════════════════════════
  // PLATFORM CHECKS (Fast, no async)
  // ═══════════════════════════════════════════════════════════════

  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isWindows => Platform.isWindows;
  static bool get isLinux => Platform.isLinux;
  static bool get isWeb => kIsWeb;
  
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => isMacOS || isWindows || isLinux;

  static String get platformName {
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    if (isWeb) return 'Web';
    return 'Unknown';
  }

  // ═══════════════════════════════════════════════════════════════
  // DEVICE INFORMATION (Cached, async)
  // ═══════════════════════════════════════════════════════════════

  /// Get full device info (cached)
  static Future<Map<String, dynamic>> getInfo() async {
    if (_cachedInfo != null) return _cachedInfo!;

    final info = <String, dynamic>{};

    try {
      if (isAndroid) {
        final android = await _plugin.androidInfo;
        info.addAll({
          'platform': 'Android',
          'model': android.model,
          'brand': android.brand,
          'manufacturer': android.manufacturer,
          'device': android.device,
          'product': android.product,
          'osVersion': android.version.release,
          'sdkInt': android.version.sdkInt,
          'isPhysicalDevice': android.isPhysicalDevice,
          'androidId': android.id, // Unique device ID
        });
      } else if (isIOS) {
        final ios = await _plugin.iosInfo;
        info.addAll({
          'platform': 'iOS',
          'model': ios.model,
          'name': ios.name,
          'systemName': ios.systemName,
          'osVersion': ios.systemVersion,
          'isPhysicalDevice': ios.isPhysicalDevice,
          'identifierForVendor': ios.identifierForVendor, // Unique device ID
        });
      } else if (isWeb) {
        final web = await _plugin.webBrowserInfo;
        info.addAll({
          'platform': 'Web',
          'browserName': web.browserName.name,
          'userAgent': web.userAgent,
        });
      }
    } catch (e) {
      info['error'] = e.toString();
    }

    _cachedInfo = info;
    return info;
  }

  /// Get device model
  static Future<String> getModel() async {
    final info = await getInfo();
    return info['model'] as String? ?? 'Unknown';
  }

  /// Get device brand
  static Future<String> getBrand() async {
    final info = await getInfo();
    return info['brand'] as String? ?? 'Unknown';
  }

  /// Get OS version
  static Future<String> getOSVersion() async {
    final info = await getInfo();
    return info['osVersion'] as String? ?? 'Unknown';
  }

  /// Get unique device ID (Android ID / Vendor ID)
  static Future<String?> getDeviceId() async {
    if (_cachedDeviceId != null) return _cachedDeviceId;

    final info = await getInfo();
    
    if (isAndroid) {
      _cachedDeviceId = info['androidId'] as String?;
    } else if (isIOS) {
      _cachedDeviceId = info['identifierForVendor'] as String?;
    }
    
    return _cachedDeviceId;
  }

  /// Check if running on physical device (not emulator)
  static Future<bool> isPhysicalDevice() async {
    final info = await getInfo();
    return info['isPhysicalDevice'] as bool? ?? true;
  }

  /// Check if device is emulator
  static Future<bool> isEmulator() async {
    return !(await isPhysicalDevice());
  }

  /// Get device info as string (for logging)
  static Future<String> getInfoString() async {
    final info = await getInfo();
    final buffer = StringBuffer();
    
    buffer.writeln('Device Information:');
    info.forEach((key, value) {
      buffer.writeln('  $key: $value');
    });
    
    return buffer.toString();
  }

  /// Clear cache (use when needed to refresh)
  static void clearCache() {
    _cachedInfo = null;
    _cachedDeviceId = null;
  }
}