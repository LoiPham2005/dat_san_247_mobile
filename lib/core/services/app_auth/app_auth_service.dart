// ════════════════════════════════════════════════════════════════
// 📁 lib/core/services/app_auth/app_auth_service.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/common/constants/api_constants.dart';
import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/common/utils/logger.dart';
import 'package:dat_san_247_mobile/core/data/network/api_client.dart';
import 'package:dat_san_247_mobile/core/data/storage/local/local_storage_service.dart';
import 'package:dat_san_247_mobile/core/data/storage/secure/secure_storage_service.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../features/auth/data/models/auth_response.dart';
import '../../../features/auth/data/models/auth_token_model.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../base/state/base_status.dart';

/// 🎯 AppAuthService - Centralized Authentication Service for the entire App
@LazySingleton()
class AppAuthService {
  final SecureStorage _secureStorage;
  final LocalStorageService _storageService;
  final ApiClient _apiClient;

  AppAuthService(this._secureStorage, this._storageService, this._apiClient);

  final _authStateController = StreamController<AuthStatus>.broadcast();
  Stream<AuthStatus> get authStateStream => _authStateController.stream;

  AuthStatus _currentStatus = AuthStatus.initial;
  AuthStatus get currentStatus => _currentStatus;

  Future<AuthStatus> checkInitialStatus() async {
    final token = await _secureStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      _updateStatus(AuthStatus.unauthenticated);
      return AuthStatus.unauthenticated;
    }

    if (isTokenExpired(token)) {
      final success = await refreshToken();
      if (!success) {
        await logout();
        return AuthStatus.unauthenticated;
      }
    }

    final userData = _storageService.getUser();
    if (userData == null) {
      _updateStatus(AuthStatus.unauthenticated);
      return AuthStatus.unauthenticated;
    }

    _updateStatus(AuthStatus.authenticated);
    return AuthStatus.authenticated;
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
  }

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
        ApiEndpoints.refreshToken,
        (json) => json as Map<String, dynamic>,
        data: {'refresh_token': refreshToken},
      );

      return result.fold(
        onSuccess: (data) async {
          final accessToken = data['access_token'] ?? data['accessToken'];
          final newRefreshToken = data['refresh_token'] ?? data['refreshToken'];

          if (accessToken != null)
            await _secureStorage.saveAccessToken(accessToken);
          if (newRefreshToken != null)
            await _secureStorage.saveRefreshToken(newRefreshToken);
          return true;
        },
        onFailure: (failure) {
          Logger.error('AppAuthService: Refresh failed: ${failure.message}');
          return false;
        },
      );
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkAndRefreshToken() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) return false;

    if (isTokenExpiringSoon(token)) {
      return await refreshToken();
    }
    return !isTokenExpired(token);
  }

  bool isTokenExpiringSoon(
    String token, {
    Duration threshold = const Duration(minutes: 5),
  }) {
    try {
      final expiryDate = JwtDecoder.getExpirationDate(token);
      return DateTime.now().isAfter(expiryDate.subtract(threshold));
    } catch (e) {
      return true;
    }
  }

  Future<UserModel?> fetchUserProfile() async {
    final result = await _apiClient.get(
      ApiEndpoints.profile,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
    return result.fold(
      onSuccess: (user) => user,
      onFailure: (failure) {
        Logger.error('AppAuthService: Fetch profile failed: ${failure.message}');
        return null;
      },
    );
  }

  Future<void> saveLoginData(AuthResponse response) async {
    await _secureStorage.saveAccessToken(response.accessToken);
    await _secureStorage.saveRefreshToken(response.refreshToken);

    // Lưu User sơ bộ từ login response trước để Router có data redirect ngay
    final minimalUser = response.user;
    final Map<String, dynamic> userData = {
      'id': minimalUser.id,
      'email': minimalUser.email,
      'full_name': minimalUser.fullName,
      'avatar_url': minimalUser.avatarUrl,
      'role': minimalUser.role?.toJson(),
      'role_id': minimalUser.role?.id,
      'is_venue_staff': minimalUser.isVenueStaff,
      'kyc_status': 'PENDING', // Default cho đến khi fetch xong profile
      'status': 'ACTIVE',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'is_email_verified': true,
      'is_phone_verified': false,
    };
    
    await _storageService.saveUser(userData);
    await _storageService.setLoggedIn(true);
    _updateStatus(AuthStatus.authenticated);

    // Fetch detail ngầm sau khi đã chuyển màn
    unawaited(fetchUserProfile().then((user) async {
      if (user != null) {
        await _storageService.saveUser(user.toJson());
      }
    }));
  }

  Future<void> logout() async {
    try {
      await _secureStorage.clearTokens();
      await _storageService.clearAuthData();
      _apiClient.clearAuthorization();
      _updateStatus(AuthStatus.unauthenticated);
    } catch (e) {
      Logger.error('AppAuthService: Logout failed', error: e);
    }
  }

  UserModel? get currentUser {
    final data = _storageService.getUser();
    if (data == null) return null;
    try {
      return UserModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  void _updateStatus(AuthStatus status) {
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
