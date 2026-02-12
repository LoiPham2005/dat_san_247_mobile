// ════════════════════════════════════════════════════════════════
// 📁 lib/core/services/auth_service.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/constants/api_constants.dart';
import 'package:dat_san_247_mobile/core/network/api_client.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/storage/secure/secure_storage_service.dart';
import 'package:dat_san_247_mobile/core/storage/local/local_storage_service.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_model.dart';
import 'package:dat_san_247_mobile/features/auth/domain/entities/auth_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// 🎯 AuthService - Centralized Authentication Service
@LazySingleton()
class AuthService {
  final SecureStorage _secureStorage;
  final LocalStorageService _storageService;
  final ApiClient _apiClient;

  AuthService(this._secureStorage, this._storageService, this._apiClient);

  // ═══════════════════════════════════════════════════════════════
  // State Broadcasting
  // ═══════════════════════════════════════════════════════════════

  final _authStateController = StreamController<AuthStatus>.broadcast();
  Stream<AuthStatus> get authStateStream => _authStateController.stream;

  AuthStatus _currentStatus = AuthStatus.initial;
  AuthStatus get currentStatus => _currentStatus;

  // ═══════════════════════════════════════════════════════════════
  // Check Status
  // ═══════════════════════════════════════════════════════════════

  /// Initialize and check current auth state
  Future<AuthStatus> checkInitialStatus() async {
    final token = await _secureStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      _updateStatus(AuthStatus.unauthenticated);
      return AuthStatus.unauthenticated;
    }

    // Check if token is expired
    if (isTokenExpired(token)) {
      final success = await refreshToken();
      if (!success) {
        await logout();
        return AuthStatus.unauthenticated;
      }
    }

    // Get user from local storage
    final userData = _storageService.getUser();
    if (userData == null) {
      _updateStatus(AuthStatus.unauthenticated);
      return AuthStatus.unauthenticated;
    }

    _updateStatus(AuthStatus.authenticated);
    return AuthStatus.authenticated;
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
  Future<void> saveLoginData(AuthResponse response) async {
    await _secureStorage.saveAccessToken(response.accessToken);
    await _secureStorage.saveRefreshToken(response.refreshToken);

    // Use AuthUserModel for JSON conversion
    final model = AuthUserModel.fromEntity(response.user);
    await _storageService.saveUser(model.toJson());
    await _storageService.setLoggedIn(true);

    _updateStatus(AuthStatus.authenticated);
  }

  /// Logout cleanup
  Future<void> logout() async {
    try {
      await _secureStorage.clearTokens();
      await _storageService.clearAuthData();
      _apiClient.clearAuthorization();

      _updateStatus(AuthStatus.loggedOut);
      // Quickly reset to unauthenticated to allow re-login
      _updateStatus(AuthStatus.unauthenticated);
    } catch (e) {
      Logger.error('AuthService: Logout failed', error: e);
    }
  }

  /// Get current user from storage
  AuthUser? get currentUser {
    final data = _storageService.getUser();
    if (data == null) return null;
    try {
      return AuthUserModel.fromJson(data).toEntity();
    } catch (e) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Updates
  // ═══════════════════════════════════════════════════════════════

  void _updateStatus(AuthStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _authStateController.add(status);
      Logger.info('AuthService: Status -> $status');
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
