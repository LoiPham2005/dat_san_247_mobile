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

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated(AuthUser user, {String? message}) =>
      AuthState(status: AuthStatus.authenticated, user: user, message: message);

  factory AuthState.expired({String? message}) =>
      AuthState(status: AuthStatus.expired, message: message ?? 'Phiên đăng nhập hết hạn');

  factory AuthState.unauthorized({String? error}) =>
      AuthState(status: AuthStatus.unauthorized, error: error ?? 'Bạn không có quyền truy cập');

  // ════════════════════════════════════════════════════════════
  // Getters
  // ════════════════════════════════════════════════════════════

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isExpired => status == AuthStatus.expired;
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
