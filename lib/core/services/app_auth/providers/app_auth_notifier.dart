import 'dart:async';

import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../features/auth/data/models/auth_response.dart';
import '../../../../features/auth/data/models/user_model.dart';
import 'app_auth_state.dart';

part 'app_auth_notifier.g.dart';

/// 🌍 Global App Auth Notifier - Quản lý trạng thái đăng nhập toàn ứng dụng (Riverpod version)
@Riverpod(keepAlive: true, name: 'appAuth')
class AppAuthNotifier extends _$AppAuthNotifier {
  late final AppAuthService _authService;
  StreamSubscription? _authStreamSubscription;

  // Stream controller to expose state changes to GoRouter or other listeners
  final _stateController = StreamController<AppAuthState>.broadcast();
  Stream<AppAuthState> get stream => _stateController.stream;

  @override
  AppAuthState build() {
    _authService = getIt<AppAuthService>();

    // Cleanup when provider is disposed
    ref.onDispose(() {
      _authStreamSubscription?.cancel();
      _stateController.close();
    });

    // Notify listeners when state changes
    ref.listen<AppAuthState>(appAuth, (previous, next) {
      if (!_stateController.isClosed) {
        _stateController.add(next);
      }
    });

    // Start listening to auth changes
    _listenToAuthChanges();

    return const AppAuthState();
  }

  // ═══════════════════════════════════════════════════════════════
  // Initialization
  // ═══════════════════════════════════════════════════════════════

  /// Lắng nghe thay đổi trạng thái từ AppAuthService
  void _listenToAuthChanges() {
    _authStreamSubscription?.cancel();
    _authStreamSubscription = _authService.authStateStream.listen((status) {
      _handleStatusChange(status);
    });
  }

  /// Khởi tạo trạng thái ban đầu của App (gọi lúc Splash/Init)
  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    final status = await _authService.checkInitialStatus();
    _handleStatusChange(status);
  }

  // ═══════════════════════════════════════════════════════════════
  // Actions
  // ═══════════════════════════════════════════════════════════════

  /// Cập nhật trạng thái sau khi Login thành công
  Future<void> loginSuccess(AuthResponse response, AppLoginMode mode) async {
    await _authService.saveLoginData(response, mode);
    // AppAuthService sẽ tự emit AuthStatus.authenticated, _listenToAuthChanges sẽ bắt được
  }

  /// Thực hiện Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  /// Cập nhật thông tin user (ví dụ sau khi sửa profile)
  void updateUser(UserModel user) {
    if (state.isAuthenticated) {
      state = state.copyWith(user: user);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Private Logic
  // ═══════════════════════════════════════════════════════════════

  void _handleStatusChange(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        final user = _authService.currentUser;
        final mode = _authService.getPersistentLoginMode();
        if (user != null) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            loginMode: mode,
          );
        } else {
          state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
        }
        break;
      case AuthStatus.unauthenticated:
        state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
        break;
      case AuthStatus.expired:
        state = state.copyWith(status: AuthStatus.expired);
        break;
      case AuthStatus.unauthorized:
        state = state.copyWith(status: AuthStatus.unauthorized);
        break;
      case AuthStatus.loading:
        state = state.copyWith(status: AuthStatus.loading);
        break;
      case AuthStatus.initial:
        state = state.copyWith(status: AuthStatus.initial);
        break;
    }
  }
}
