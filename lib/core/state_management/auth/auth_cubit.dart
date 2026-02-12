// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/auth/auth_cubit.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/services/auth_service.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/state_management/auth/auth_state.dart';
import 'package:dat_san_247_mobile/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// 🌍 Global Auth Cubit - Manages the authenticated state of the entire app
@LazySingleton()
class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  StreamSubscription? _authStreamSubscription;

  AuthCubit(this._authService) : super(AuthState.initial()) {
    _listenToAuthChanges();
  }

  // ═══════════════════════════════════════════════════════════════
  // Initialization
  // ═══════════════════════════════════════════════════════════════

  /// Lắng nghe thay đổi trạng thái từ AuthService
  void _listenToAuthChanges() {
    _authStreamSubscription = _authService.authStateStream.listen((status) {
      _handleStatusChange(status);
    });
  }

  /// Khởi tạo trạng thái ban đầu của App (gọi lúc Splash/Init)
  Future<void> init() async {
    emit(AuthState.authenticating());

    final status = await _authService.checkInitialStatus();
    _handleStatusChange(status);
  }

  // ═══════════════════════════════════════════════════════════════
  // Actions
  // ═══════════════════════════════════════════════════════════════

  /// Cập nhật trạng thái sau khi Login thành công
  Future<void> loginSuccess(AuthResponse response) async {
    await _authService.saveLoginData(response);
    // AuthService sẽ tự emit AuthStatus.authenticated, _listenToAuthChanges sẽ bắt được
  }

  /// Thực hiện Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  /// Cập nhật thông tin user (ví dụ sau khi sửa profile)
  void updateUser(AuthUser user) {
    if (state.isAuthenticated) {
      emit(state.copyWith(user: user));
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Private Logic
  // ═══════════════════════════════════════════════════════════════

  void _handleStatusChange(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        final user = _authService.currentUser;
        if (user != null) {
          emit(AuthState.authenticated(user));
        } else {
          emit(AuthState.unauthenticated());
        }
        break;
      case AuthStatus.unauthenticated:
        emit(AuthState.unauthenticated());
        break;
      case AuthStatus.tokenExpired:
        emit(AuthState.tokenExpired());
        break;
      case AuthStatus.unauthorized:
        emit(AuthState.unauthorized());
        break;
      case AuthStatus.loggedOut:
        emit(AuthState.loggedOut());
        break;
      case AuthStatus.authenticating:
        emit(AuthState.authenticating());
        break;
      case AuthStatus.initial:
        emit(AuthState.initial());
        break;
    }
  }

  @override
  Future<void> close() {
    _authStreamSubscription?.cancel();
    return super.close();
  }
}
