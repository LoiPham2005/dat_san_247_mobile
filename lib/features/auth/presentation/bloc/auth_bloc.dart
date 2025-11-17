import 'package:flutter_base_template/core/services/auth_service.dart';
import 'package:flutter_base_template/core/state_management/bloc/base_event.dart';
import 'package:flutter_base_template/core/state_management/bloc/base_state.dart';
import 'package:flutter_base_template/core/state_management/bloc/bloc_helper.dart';
import 'package:flutter_base_template/core/utils/logger.dart';
import 'package:flutter_base_template/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_base_template/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:flutter_base_template/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_base_template/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_base_template/features/auth/domain/usecases/register_use_case.dart';
import 'package:flutter_base_template/features/auth/domain/usecases/delete_account_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/storage_service.dart';
import 'package:flutter_base_template/core/storage/secure_storage.dart'; // ✅ THÊM

// ═══════════════════════════════════════════════════════════════
// EVENTS
// ═══════════════════════════════════════════════════════════════

class LoginEvent extends BaseEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends BaseEvent {
  final String fullname;
  final String username;
  final String email;
  final String password;
  final String passwordConfirm;

  const RegisterEvent({
    required this.fullname,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });

  @override
  List<Object?> get props => [
    fullname,
    username,
    email,
    password,
    passwordConfirm,
  ];
}

class LogoutEvent extends BaseEvent {}

class ForgotPasswordEvent extends BaseEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class DeleteAccountEvent extends BaseEvent {}

// ═══════════════════════════════════════════════════════════════
// BLOC
// ═══════════════════════════════════════════════════════════════

@injectable
class AuthBloc extends Bloc<BaseEvent, BaseState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase; // ✅ THÊM
  final StorageService _storageService = getIt<StorageService>();
  final SecureStorage _secureStorage = getIt<SecureStorage>();
  final AuthService _authService = getIt<AuthService>();

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterUseCase registerUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required DeleteAccountUseCase deleteAccountUseCase, // ✅ THÊM
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _registerUseCase = registerUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _deleteAccountUseCase = deleteAccountUseCase, // ✅ THÊM
       super(BaseState.initial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RegisterEvent>(_onRegister);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<DeleteAccountEvent>(_onDeleteAccount); // ✅ THÊM
  }

  // ═══════════════════════════════════════════════════════════════
  // LOGIN
  // ═══════════════════════════════════════════════════════════════
  Future<void> _onLogin(LoginEvent event, Emitter<BaseState> emit) async {
    await execute<AuthResponse, BaseState>(
      emit: emit,
      useCaseCall: () =>
          _loginUseCase(email: event.email, password: event.password),
      stateBuilder: ({status, data, errorMessage}) => state.copyWith(
        status: status,
        data: data ?? state.data,
        error: errorMessage,
      ),
      onSuccess: (data) async {
        try {
          // ✅ Lưu tokens vào SecureStorage (encrypted)
          await _secureStorage.saveAccessToken(data.accessToken);
          await _secureStorage.saveRefreshToken(data.refreshToken);

          // ✅ Lưu user data vào StorageService
          await _storageService.setLoggedIn(true);
          await _storageService.saveUser((data.user as dynamic).toJson());

          Logger.success('✅ Login data saved successfully');
        } catch (e) {
          Logger.error('❌ Failed to save login data', error: e);
        }
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // REGISTER
  // ═══════════════════════════════════════════════════════════════
  Future<void> _onRegister(RegisterEvent event, Emitter<BaseState> emit) async {
    await execute<AuthResponse, BaseState>(
      emit: emit,
      useCaseCall: () => _registerUseCase(
        fullname: event.fullname,
        username: event.username,
        email: event.email,
        password: event.password,
        passwordConfirm: event.passwordConfirm,
      ),
      stateBuilder: ({status, data, errorMessage}) => state.copyWith(
        status: status,
        data: data ?? state.data,
        error: errorMessage,
      ),
      onSuccess: (data) async {
        try {
          // ✅ Lưu tokens vào SecureStorage (encrypted)
          await _secureStorage.saveAccessToken(data.accessToken);
          await _secureStorage.saveRefreshToken(data.refreshToken);

          // ✅ Lưu user data vào StorageService
          await _storageService.setLoggedIn(true);
          await _storageService.saveUser((data.user as dynamic).toJson());

          Logger.success('✅ Register data saved successfully');
        } catch (e) {
          Logger.error('❌ Failed to save register data', error: e);
        }
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FORGOT PASSWORD
  // ═══════════════════════════════════════════════════════════════
  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<BaseState> emit,
  ) async {
    await execute<bool, BaseState>(
      emit: emit,
      useCaseCall: () => _forgotPasswordUseCase(event.email),
      stateBuilder: ({status, data, errorMessage}) =>
          state.copyWith(status: status, error: errorMessage),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // LOGOUT
  // ═══════════════════════════════════════════════════════════════
  Future<void> _onLogout(LogoutEvent event, Emitter<BaseState> emit) async {
    await execute<bool, BaseState>(
      emit: emit,
      useCaseCall: () => _logoutUseCase(),
      stateBuilder: ({status, data, errorMessage}) =>
          state.copyWith(status: status, data: null, error: errorMessage),
      onSuccess: (_) async {
        await _authService.logout();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DELETE ACCOUNT
  // ═══════════════════════════════════════════════════════════════
  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<BaseState> emit,
  ) async {
    await execute<bool, BaseState>(
      emit: emit,
      useCaseCall: () => _deleteAccountUseCase(),
      stateBuilder: ({status, data, errorMessage}) =>
          state.copyWith(status: status, data: null, error: errorMessage),
      onSuccess: (_) async {
        await _authService.logout();
        Logger.success('✅ Account deleted and logged out');
      },
    );
  }
}
