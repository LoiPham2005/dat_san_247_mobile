// ════════════════════════════════════════════════════════════════
// 📁 lib/core/services/auth_service.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/constants/api_constants.dart';
import 'package:dat_san_247_mobile/core/network/api_client.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/storage/local/local_storage_service.dart';
import 'package:dat_san_247_mobile/core/storage/secure/secure_storage_service.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_model.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// 🎯 AppAuthService - Centralized Authentication Service
@LazySingleton()
class AppAuthService {
  final SecureStorage _secureStorage;
  final LocalStorageService _storageService;
  final ApiClient _apiClient;

  AppAuthService(this._secureStorage, this._storageService, this._apiClient);

  // ═══════════════════════════════════════════════════════════════
  // State Broadcasting
  // ═══════════════════════════════════════════════════════════════

  final _authStateController = StreamController<AppAuthStatus>.broadcast();
  Stream<AppAuthStatus> get authStateStream => _authStateController.stream;

  AppAuthStatus _currentStatus = AppAuthStatus.initial;
  AppAuthStatus get currentStatus => _currentStatus;

  // ═══════════════════════════════════════════════════════════════
  // Check Status
  // ═══════════════════════════════════════════════════════════════

  /// Initialize and check current auth state
  Future<AppAuthStatus> checkInitialStatus() async {
    final token = await _secureStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      _updateStatus(AppAuthStatus.unauthenticated);
      return AppAuthStatus.unauthenticated;
    }

    // Check if token is expired
    if (isTokenExpired(token)) {
      final success = await refreshToken();
      if (!success) {
        await logout();
        return AppAuthStatus.unauthenticated;
      }
    }

    // Get user from local storage
    final userData = _storageService.getUser();
    if (userData == null) {
      _updateStatus(AppAuthStatus.unauthenticated);
      return AppAuthStatus.unauthenticated;
    }

    _updateStatus(AppAuthStatus.authenticated);
    return AppAuthStatus.authenticated;
  }

  // ═══════════════════════════════════════════════════════════════
  // Token Management
  // ═══════════════════════════════════════════════════════════════

  bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final result = await _apiClient.post(
        ApiConstants.refreshToken,
        (json) => json as Map<String, dynamic>,
        data: {'refresh_token': refreshToken},
      );

      return result.fold(
        onSuccess: (data) async {
          final accessToken = data['access_token'] ?? data['accessToken'];
          final newRefreshToken = data['refresh_token'] ?? data['refreshToken'];

          if (accessToken != null) {
            await _secureStorage.saveAccessToken(accessToken);
          }
          if (newRefreshToken != null) {
            await _secureStorage.saveRefreshToken(newRefreshToken);
          }
          return true;
        },
        onFailure: (failure) {
          Logger.error('AuthService: Refresh failed: ${failure.message}');
          return false;
        },
      );
    } catch (e) {
      return false;
    }
  }

  /// Check and refresh token if needed
  Future<bool> checkAndRefreshToken() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) return false;

    if (isTokenExpiringSoon(token)) {
      return await refreshToken();
    }
    return !isTokenExpired(token);
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

  // ═══════════════════════════════════════════════════════════════
  // Auth Actions
  // ═══════════════════════════════════════════════════════════════

  /// Save login data
  Future<void> saveLoginData(AuthResponseModel response) async {
    await _secureStorage.saveAccessToken(response.accessToken);
    await _secureStorage.saveRefreshToken(response.refreshToken);

    await _storageService.saveUser(response.user.toJson());

    await _storageService.setLoggedIn(true);

    _updateStatus(AppAuthStatus.authenticated);
  }

  /// Logout cleanup
  Future<void> logout() async {
    try {
      await _secureStorage.clearTokens();
      await _storageService.clearAuthData();
      _apiClient.clearAuthorization();

      _updateStatus(AppAuthStatus.unauthenticated);
    } catch (e) {
      Logger.error('AppAuthService: Logout failed', error: e);
    }
  }

  /// Get current user from storage
  UserModel? get currentUser {
    final data = _storageService.getUser();
    if (data == null) return null;
    try {
      return UserModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Updates
  // ═══════════════════════════════════════════════════════════════

  void _updateStatus(AppAuthStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _authStateController.add(status);
      Logger.info('AppAuthService: Status -> $status');
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
