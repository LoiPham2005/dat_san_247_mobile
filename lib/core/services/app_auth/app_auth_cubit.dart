// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/auth/auth_cubit.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/services/app_auth_service.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_state.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// 🌍 Global Auth Cubit - Manages the authenticated state of the entire app
@LazySingleton()
class AppAuthCubit extends Cubit<AppAuthState> {
  final AppAuthService _authService;
  StreamSubscription? _authStreamSubscription;

  AppAuthCubit(this._authService) : super(AppAuthState.initial()) {
    _listenToAuthChanges();
  }

  // ═══════════════════════════════════════════════════════════════
  // Initialization
  // ═══════════════════════════════════════════════════════════════

  /// Lắng nghe thay đổi trạng thái từ AppAuthService
  void _listenToAuthChanges() {
    _authStreamSubscription = _authService.authStateStream.listen((status) {
      _handleStatusChange(status);
    });
  }

  /// Khởi tạo trạng thái ban đầu của App (gọi lúc Splash/Init)
  Future<void> init() async {
    emit(AppAuthState.loading());

    final status = await _authService.checkInitialStatus();
    _handleStatusChange(status);
  }

  // ═══════════════════════════════════════════════════════════════
  // Actions
  // ═══════════════════════════════════════════════════════════════

  /// Cập nhật trạng thái sau khi Login thành công
  Future<void> loginSuccess(AuthResponseModel response) async {
    await _authService.saveLoginData(response);
    // AppAuthService sẽ tự emit AppAuthStatus.authenticated, _listenToAuthChanges sẽ bắt được
  }

  /// Thực hiện Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  /// Cập nhật thông tin user (ví dụ sau khi sửa profile)
  void updateUser(UserModel user) {
    if (state.isAuthenticated) {
      emit(state.copyWith(user: user));
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Private Logic
  // ═══════════════════════════════════════════════════════════════

  void _handleStatusChange(AppAuthStatus status) {
    switch (status) {
      case AppAuthStatus.authenticated:
        final user = _authService.currentUser;
        if (user != null) {
          emit(AppAuthState.authenticated(user));
        } else {
          emit(AppAuthState.unauthenticated());
        }
        break;
      case AppAuthStatus.unauthenticated:
        emit(AppAuthState.unauthenticated());
        break;
      case AppAuthStatus.expired:
        emit(AppAuthState.expired());
        break;
      case AppAuthStatus.unauthorized:
        emit(AppAuthState.unauthorized());
        break;
      case AppAuthStatus.loading:
        emit(AppAuthState.loading());
        break;
      case AppAuthStatus.initial:
        emit(AppAuthState.initial());
        break;
    }
  }

  @override
  Future<void> close() {
    _authStreamSubscription?.cancel();
    return super.close();
  }
}
