// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/auth_state.dart
// ════════════════════════════════════════════════════════════════
import 'package:equatable/equatable.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/features/auth/domain/entities/auth_entity.dart';

/// 🔐 Global Authentication State
class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser? user;
  final String? error;
  final String? message;

  const AuthState({required this.status, this.user, this.error, this.message});

  // ════════════════════════════════════════════════════════════
  // Factories
  // ════════════════════════════════════════════════════════════

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.unauthenticated({String? error}) =>
      AuthState(status: AuthStatus.unauthenticated, error: error);

  factory AuthState.authenticating() => const AuthState(status: AuthStatus.authenticating);

  factory AuthState.authenticated(AuthUser user, {String? message}) =>
      AuthState(status: AuthStatus.authenticated, user: user, message: message);

  factory AuthState.tokenExpired({String? message}) =>
      AuthState(status: AuthStatus.tokenExpired, message: message ?? 'Phiên đăng nhập hết hạn');

  factory AuthState.unauthorized({String? error}) =>
      AuthState(status: AuthStatus.unauthorized, error: error ?? 'Bạn không có quyền truy cập');

  factory AuthState.loggedOut() =>
      const AuthState(status: AuthStatus.loggedOut, message: 'Đã đăng xuất');

  // ════════════════════════════════════════════════════════════
  // Getters
  // ════════════════════════════════════════════════════════════

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isAuthenticating => status == AuthStatus.authenticating;
  bool get isTokenExpired => status == AuthStatus.tokenExpired;
  bool get isInitial => status == AuthStatus.initial;

  bool get hasUser => user != null;

  // ════════════════════════════════════════════════════════════
  // Utility
  // ════════════════════════════════════════════════════════════

  AuthState copyWith({AuthStatus? status, AuthUser? user, String? error, String? message}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, error, message];

  @override
  String toString() => 'AuthState(status: $status, user: ${user?.email})';
}
