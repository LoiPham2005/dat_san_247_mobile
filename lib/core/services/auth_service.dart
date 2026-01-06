// ════════════════════════════════════════════════════════════════
// 📁 lib/core/services/auth_service.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/network/api_client.dart';
import 'package:dat_san_247_mobile/core/storage/secure_storage.dart';
import 'package:dat_san_247_mobile/core/storage/storage_service.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Auth state enum
enum AuthStatus { unknown, authenticated, unauthenticated }

/// ════════════════════════════════════════════════════════════════
/// 📁 AuthService - Manages authentication state
/// ════════════════════════════════════════════════════════════════
@LazySingleton()
class AuthService {
  final SecureStorage _secureStorage;
  final StorageService _storageService;
  final ApiClient _apiClient;

  AuthService(this._secureStorage, this._storageService, this._apiClient);

  // Stream để broadcast auth state changes
  final _authStateController = StreamController<AuthStatus>.broadcast();
  Stream<AuthStatus> get authStateStream => _authStateController.stream;

  AuthStatus _currentStatus = AuthStatus.unknown;
  AuthStatus get currentStatus => _currentStatus;

  // ═══════════════════════════════════════════════════════════════
  // Token Management
  // ═══════════════════════════════════════════════════════════════

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      _updateStatus(AuthStatus.unauthenticated);
      return false;
    }

    // Check if token is expired
    if (isTokenExpired(token)) {
      // Try to refresh
      final refreshed = await refreshToken();
      if (!refreshed) {
        _updateStatus(AuthStatus.unauthenticated);
        return false;
      }
    }

    _updateStatus(AuthStatus.authenticated);
    return true;
  }

  /// Check if token is expired
  bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      Logger.warning('Invalid JWT token', tag: 'AUTH');
      return true;
    }
  }

  /// Check if token will expire soon (within 5 minutes)
  bool isTokenExpiringSoon(String token, {Duration threshold = const Duration(minutes: 5)}) {
    try {
      final expiryDate = JwtDecoder.getExpirationDate(token);
      return DateTime.now().isAfter(expiryDate.subtract(threshold));
    } catch (e) {
      return true;
    }
  }

  /// Refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        Logger.warning('No refresh token available', tag: 'AUTH');
        return false;
      }

      // Call refresh API
      final result = await _apiClient.post(
        '/auth/refresh',
        (json) => json as Map<String, dynamic>,
        data: {'refresh_token': refreshToken},
      );

      // ✅ FIX: Dùng named arguments
      return result.fold(
        onFailure: (failure) {
          Logger.error('Token refresh failed: ${failure.message}', tag: 'AUTH');
          return false;
        },
        onSuccess: (data) async {
          final newAccessToken = data['access_token'] as String?;
          final newRefreshToken = data['refresh_token'] as String?;

          if (newAccessToken != null) {
            await _secureStorage.saveAccessToken(newAccessToken);
          }
          if (newRefreshToken != null) {
            await _secureStorage.saveRefreshToken(newRefreshToken);
          }

          Logger.success('Token refreshed successfully', tag: 'AUTH');
          return true;
        },
      );
    } catch (e) {
      Logger.error('Token refresh error', error: e, tag: 'AUTH');
      return false;
    }
  }

  /// Check and refresh token if needed
  Future<bool> checkAndRefreshToken() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) return false;

    if (isTokenExpiringSoon(token)) {
      return await refreshToken();
    }
    return true;
  }

  // ═══════════════════════════════════════════════════════════════
  // Auth Actions
  // ═══════════════════════════════════════════════════════════════

  /// Logout user
  Future<void> logout() async {
    try {
      // Clear tokens
      await _secureStorage.deleteAccessToken();
      await _secureStorage.deleteRefreshToken();

      // Clear user data
      await _storageService.setLoggedIn(false);
      await _storageService.clearAuthData();

      // Cancel pending requests
      _apiClient.cancelAllRequests('Logged out');

      _updateStatus(AuthStatus.unauthenticated);
      Logger.success('Logged out successfully', tag: 'AUTH');
    } catch (e) {
      Logger.error('Logout error', error: e, tag: 'AUTH');
    }
  }

  /// Save auth data after login
  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> user,
  }) async {
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
    await _storageService.saveUser(user);
    await _storageService.setLoggedIn(true);
    _updateStatus(AuthStatus.authenticated);
  }

  // ═══════════════════════════════════════════════════════════════
  // Private Methods
  // ═══════════════════════════════════════════════════════════════

  void _updateStatus(AuthStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _authStateController.add(status);
      Logger.info('Auth status changed: $status', tag: 'AUTH');
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
