// ════════════════════════════════════════════════════════════════
// 📁 lib/services/permission_service.dart (TỐI ƯU + CACHE)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  // Cache permission status
  final Map<Permission, PermissionStatus> _cache = {};

  /// Check single permission (with cache)
  Future<bool> checkPermission(Permission permission, {bool useCache = true}) async {
    if (useCache && _cache.containsKey(permission)) {
      return _cache[permission]!.isGranted;
    }
    
    final status = await permission.status;
    _cache[permission] = status;
    return status.isGranted;
  }

  /// Request single permission
  Future<bool> requestPermission(
    Permission permission, {
    BuildContext? context,
    String? message,
  }) async {
    final status = await permission.request();
    _cache[permission] = status;
    
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied && context != null) {
      await _showOpenSettingsDialog(context, message);
    }
    
    return false;
  }

  /// Request multiple permissions
  Future<Map<Permission, bool>> requestMultiplePermissions(
    List<Permission> permissions, {
    BuildContext? context,
  }) async {
    final statuses = await permissions.request();
    final results = <Permission, bool>{};
    
    for (final entry in statuses.entries) {
      _cache[entry.key] = entry.value;
      results[entry.key] = entry.value.isGranted;
      
      if (entry.value.isPermanentlyDenied && context != null) {
        await _showOpenSettingsDialog(context, null);
        break; // Only show once
      }
    }
    
    return results;
  }

  // ═══════════════════════════════════════════════════════════════
  // COMMON PERMISSIONS (Quick access)
  // ═══════════════════════════════════════════════════════════════

  Future<bool> checkCamera() => checkPermission(Permission.camera);
  Future<bool> requestCamera(BuildContext? context) => 
    requestPermission(Permission.camera, context: context);

  Future<bool> checkPhotos() async {
    return await checkPermission(Permission.photos) ||
           await checkPermission(Permission.storage);
  }

  Future<bool> requestPhotos(BuildContext? context) async {
    if (await checkPhotos()) return true;
    return await requestPermission(Permission.photos, context: context) ||
           await requestPermission(Permission.storage, context: context);
  }

  Future<bool> checkLocation() => checkPermission(Permission.locationWhenInUse);
  Future<bool> requestLocation(BuildContext? context) =>
    requestPermission(Permission.locationWhenInUse, context: context);

  Future<bool> checkNotification() => checkPermission(Permission.notification);
  Future<bool> requestNotification(BuildContext? context) =>
    requestPermission(Permission.notification, context: context);

  Future<bool> checkMicrophone() => checkPermission(Permission.microphone);
  Future<bool> requestMicrophone(BuildContext? context) =>
    requestPermission(Permission.microphone, context: context);

  // ═══════════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════════

  void clearCache() => _cache.clear();

  Future<void> openSettings() => openAppSettings();

  Future<void> _showOpenSettingsDialog(BuildContext context, String? message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yêu cầu quyền'),
        content: Text(message ?? 'Vui lòng cấp quyền trong Cài đặt để tiếp tục.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('Mở cài đặt'),
          ),
        ],
      ),
    );
  }
}
