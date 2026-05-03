import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../features/auth/data/models/user_model.dart';

part 'app_auth_state.freezed.dart';

@freezed
abstract class AppAuthState with _$AppAuthState {
  const factory AppAuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserModel? user,
    String? error,
    String? message,
    @Default(AppLoginMode.customer) AppLoginMode loginMode,
  }) = _AppAuthState;

  const AppAuthState._();

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isExpired => status == AuthStatus.expired;
  bool get isInitial => status == AuthStatus.initial;
  bool get hasUser => user != null;
}

enum AppLoginMode { customer, staff, owner }
