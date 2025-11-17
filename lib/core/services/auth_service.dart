// ════════════════════════════════════════════════════════════════
// 📁 lib/core/services/auth_service.dart
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:flutter_base_template/core/config/environment_config.dart';
import 'package:flutter_base_template/core/constants/api_constants.dart';
import 'package:flutter_base_template/core/di/injection.dart';
import 'package:flutter_base_template/core/storage/secure_storage.dart';
import 'package:flutter_base_template/core/storage/storage_service.dart';
import 'package:flutter_base_template/core/utils/logger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {
  final StorageService _storageService;
  final SecureStorage _secureStorage;

  AuthService(this._storageService, this._secureStorage);

  bool _isRefreshing = false;

  /// Kiểm tra và refresh token nếu cần
  /// Returns: true nếu token còn hợp lệ hoặc refresh thành công
  Future<bool> checkAndRefreshToken() async {
    if (_isRefreshing) {
      Logger.debug('🔄 Refresh đang diễn ra, bỏ qua request mới.');
      return false;
    }

    // ✅ Lấy từ SecureStorage (encrypted)
    final accessToken = await _secureStorage.getAccessToken();
    final refreshTokenValue = await _secureStorage.getRefreshToken();

    if (accessToken == null || refreshTokenValue == null) {
      Logger.debug('🔑 Không có token, bỏ qua kiểm tra.');
      return false;
    }

    try {
      if (JwtDecoder.isExpired(refreshTokenValue)) {
        Logger.error('⏰ Refresh token hết hạn → Đăng xuất.');
        await logout();
        return false;
      }

      if (!JwtDecoder.isExpired(accessToken)) {
        Logger.debug('🔒 Access token vẫn hợp lệ.');
        return true;
      }

      Logger.info('♻️ Access token hết hạn → Bắt đầu refresh...');
      return await refreshToken();
    } catch (e, stack) {
      Logger.error('💥 Lỗi khi kiểm tra token', error: e, stackTrace: stack);
      await logout();
      return false;
    }
  }

  /// Refresh token
  /// Returns: true nếu refresh thành công
  Future<bool> refreshToken() async {
    if (_isRefreshing) {
      Logger.warning('⚠️ Refresh đang diễn ra, không gọi lại.');
      return false;
    }

    // ✅ Lấy từ SecureStorage
    final currentRefreshToken = await _secureStorage.getRefreshToken();
    if (currentRefreshToken == null) {
      Logger.error('❌ Không có refresh token để thực hiện refresh.');
      return false;
    }

    _isRefreshing = true;

    try {
      // Tạo Dio instance riêng để tránh trigger interceptor
      final dio = Dio(
        BaseOptions(
          baseUrl: EnvironmentConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': currentRefreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final newAccessToken = response.data['data']['accessToken'] as String;
        final newRefreshToken = response.data['data']['refreshToken'] as String;

        // ✅ Lưu vào SecureStorage
        await _secureStorage.saveAccessToken(newAccessToken);
        await _secureStorage.saveRefreshToken(newRefreshToken);

        Logger.success('✅ Refresh token thành công.');
        return true;
      } else {
        Logger.error('❌ Refresh token thất bại: ${response.data}');
        await logout();
        return false;
      }
    } catch (e, stack) {
      Logger.error('💥 Lỗi khi refresh token', error: e, stackTrace: stack);
      await logout();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Đăng xuất và xóa dữ liệu xác thực
  Future<void> logout() async {
    try {
      // 1. Clear tokens từ SecureStorage
      await _secureStorage.clearTokens();
      Logger.info('📝 Tokens cleared from secure storage');

      // 2. Clear user data từ StorageService
      await _storageService.clearAuthData();
      Logger.info('📝 User data cleared from storage');

      // 3. Reset DI (xóa cached instances)
      await resetDependencies();
      Logger.info('🔄 Dependencies reset');

      // 4. Re-initialize DI (tạo instances mới)
      await configureDependencies();
      Logger.info('✅ Dependencies re-configured');

      Logger.success('🚪 Logout successful');
    } catch (e, stackTrace) {
      Logger.error('❌ Logout failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Kiểm tra xem user đã đăng nhập chưa
  bool get isLoggedIn {
    return _storageService.isLoggedIn();
  }

  /// Lấy thông tin từ token
  Future<Map<String, dynamic>?> getTokenPayload() async {
    // ✅ Lấy từ SecureStorage
    final token = await _secureStorage.getAccessToken();
    if (token == null) return null;

    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      Logger.error('❌ Không thể decode token', error: e);
      return null;
    }
  }
}
