// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/auth_state.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_model.dart';
import 'package:equatable/equatable.dart';

/// 🔐 Global Authentication State
class AppAuthState extends Equatable {
  final AppAuthStatus status;
  final UserModel? user;
  final String? error;
  final String? message;

  const AppAuthState({required this.status, this.user, this.error, this.message});

  // ════════════════════════════════════════════════════════════
  // Factories
  // ════════════════════════════════════════════════════════════

  factory AppAuthState.initial() => const AppAuthState(status: AppAuthStatus.initial);

  factory AppAuthState.unauthenticated({String? error}) =>
      AppAuthState(status: AppAuthStatus.unauthenticated, error: error);

  factory AppAuthState.loading() => const AppAuthState(status: AppAuthStatus.loading);

  factory AppAuthState.authenticated(UserModel user, {String? message}) =>
      AppAuthState(status: AppAuthStatus.authenticated, user: user, message: message);

  factory AppAuthState.expired({String? message}) =>
      AppAuthState(status: AppAuthStatus.expired, message: message ?? 'Phiên đăng nhập hết hạn');

  factory AppAuthState.unauthorized({String? error}) => AppAuthState(
    status: AppAuthStatus.unauthorized,
    error: error ?? 'Bạn không có quyền truy cập',
  );

  // ════════════════════════════════════════════════════════════
  // Getters
  // ════════════════════════════════════════════════════════════

  bool get isAuthenticated => status == AppAuthStatus.authenticated;
  bool get isUnauthenticated => status == AppAuthStatus.unauthenticated;
  bool get isLoading => status == AppAuthStatus.loading;
  bool get isExpired => status == AppAuthStatus.expired;
  bool get isInitial => status == AppAuthStatus.initial;

  bool get hasUser => user != null;

  // ════════════════════════════════════════════════════════════
  // Utility
  // ════════════════════════════════════════════════════════════

  AppAuthState copyWith({AppAuthStatus? status, UserModel? user, String? error, String? message}) {
    return AppAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, error, message];

  @override
  String toString() => 'AppAuthState(status: $status, user: ${user?.email})';
}
