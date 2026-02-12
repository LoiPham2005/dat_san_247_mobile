import 'package:dat_san_247_mobile/core/services/auth_service.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_bloc.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_event.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/storage/secure/secure_storage_service.dart';
import 'package:dat_san_247_mobile/core/storage/local/local_storage_service.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_model.dart';
import 'package:dat_san_247_mobile/features/auth/domain/entities/auth_entity.dart';
import 'package:dat_san_247_mobile/features/auth/domain/usecases/delete_account_use_case.dart';
import 'package:dat_san_247_mobile/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:dat_san_247_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:dat_san_247_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:dat_san_247_mobile/features/auth/domain/usecases/register_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// ═══════════════════════════════════════════════════════════════
// EVENTS
// ═══════════════════════════════════════════════════════════════

class LoginEvent extends BaseEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginEvent({required this.email, required this.password, this.rememberMe = false});

  @override
  List<Object?> get props => [email, password, rememberMe];
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
  List<Object?> get props => [fullname, username, email, password, passwordConfirm];
}

class LogoutEvent extends BaseEvent {
  const LogoutEvent();
}

class ForgotPasswordEvent extends BaseEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class DeleteAccountEvent extends BaseEvent {
  final String? reason;

  const DeleteAccountEvent({this.reason});

  @override
  List<Object?> get props => [reason];
}

class CheckAuthStatusEvent extends BaseEvent {
  const CheckAuthStatusEvent();
}

class RefreshProfileEvent extends BaseEvent {
  const RefreshProfileEvent();
}

// ═══════════════════════════════════════════════════════════════
// BLOC - ĐƠN GIẢN HÓA VỚI SMART EXECUTE
// ═══════════════════════════════════════════════════════════════

@injectable
class AuthBloc extends BaseBloc {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final LocalStorageService _storageService;
  final SecureStorage _secureStorage;
  final AuthService _authService;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterUseCase registerUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required LocalStorageService storageService,
    required SecureStorage secureStorage,
    required AuthService authService,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _registerUseCase = registerUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _deleteAccountUseCase = deleteAccountUseCase,
       _storageService = storageService,
       _secureStorage = secureStorage,
       _authService = authService,
       super(BaseState<AuthResponse>.initial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<RefreshProfileEvent>(_onRefreshProfile);
  }

  // ═══════════════════════════════════════════════════════════════
  // Getters
  // ═══════════════════════════════════════════════════════════════

  AuthResponse? get authResponse => state.data as AuthResponse?;
  AuthUser? get currentUser => authResponse?.user;
  bool get isLoggedIn => currentUser != null;

  // ═══════════════════════════════════════════════════════════════
  // 🔐 LOGIN - Tự động submitting → success/failure
  // ═══════════════════════════════════════════════════════════════

  Future<void> _onLogin(LoginEvent event, Emitter<BaseState> emit) async {
    await execute<AuthResponse>(
      emit: emit,
      action: () => _loginUseCase(email: event.email, password: event.password),
      successMessage: 'Đăng nhập thành công', // ← Có message = mutation
      onSuccess: (data) {
        _saveAuthData(data, rememberMe: event.rememberMe);
        Logger.success('✅ Login: ${data.user.email}');
      },
      onFailure: (failure) {
        Logger.error('❌ Login failed: ${failure.message}');
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 📝 REGISTER - Tự động submitting → success/failure
  // ═══════════════════════════════════════════════════════════════

  Future<void> _onRegister(RegisterEvent event, Emitter<BaseState> emit) async {
    await execute<AuthResponse>(
      emit: emit,
      action: () => _registerUseCase(
        fullname: event.fullname,
        username: event.username,
        email: event.email,
        password: event.password,
        passwordConfirm: event.passwordConfirm,
      ),
      successMessage: 'Đăng ký thành công',
      onSuccess: (data) {
        _saveAuthData(data);
        Logger.success('✅ Register: ${data.user.email}');
      },
      onFailure: (failure) {
        Logger.error('❌ Register failed: ${failure.message}');
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🚪 LOGOUT - Luôn logout local dù API fail
  // ═══════════════════════════════════════════════════════════════

  Future<void> _onLogout(LogoutEvent event, Emitter<BaseState> emit) async {
    await execute<bool>(
      emit: emit,
      action: () => _logoutUseCase(),
      successMessage: 'Đăng xuất thành công',
      onSuccess: (_) async {
        await _authService.logout();
        Logger.success('✅ Logged out');
      },
      onFailure: (_) async {
        // Vẫn logout local khi API fail
        await _authService.logout();
        Logger.warning('⚠️ API failed but local logout done');
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔑 FORGOT PASSWORD
  // ═══════════════════════════════════════════════════════════════

  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<BaseState> emit) async {
    await execute<bool>(
      emit: emit,
      action: () => _forgotPasswordUseCase(event.email),
      successMessage: 'Email đặt lại mật khẩu đã được gửi',
      onSuccess: (_) {
        Logger.success('✅ Password reset email → ${event.email}');
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🗑️ DELETE ACCOUNT
  // ═══════════════════════════════════════════════════════════════

  Future<void> _onDeleteAccount(DeleteAccountEvent event, Emitter<BaseState> emit) async {
    await execute<bool>(
      emit: emit,
      action: () => _deleteAccountUseCase(),
      successMessage: 'Tài khoản đã được xóa',
      onSuccess: (_) async {
        await _authService.logout();
        Logger.success('✅ Account deleted');
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔍 CHECK AUTH STATUS - Không có message = query
  // ═══════════════════════════════════════════════════════════════

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<BaseState> emit) async {
    // Quick check trước
    if (!_storageService.isLoggedIn()) {
      emit(BaseState<AuthResponse>.initial());
      return;
    }

    // Validate token
    final isValid = await _authService.checkAndRefreshToken();
    if (!isValid) {
      emit(BaseState<AuthResponse>.initial());
      return;
    }

    // Load saved data
    final userData = _storageService.getUser();
    if (userData == null) {
      emit(BaseState<AuthResponse>.initial());
      return;
    }

    try {
      final user = AuthUserModel.fromJson(userData).toEntity();
      final accessToken = await _secureStorage.getAccessToken() ?? '';
      final refreshToken = await _secureStorage.getRefreshToken() ?? '';

      final authResponse = AuthResponse(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      emit(BaseState<AuthResponse>.loaded(authResponse));
      Logger.success('✅ Auth restored');
    } catch (e) {
      Logger.error('❌ Failed to restore auth', error: e);
      emit(BaseState<AuthResponse>.initial());
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔄 REFRESH PROFILE - Tự động refreshing state (đã có data)
  // ═══════════════════════════════════════════════════════════════

  Future<void> _onRefreshProfile(RefreshProfileEvent event, Emitter<BaseState> emit) async {
    if (authResponse == null) {
      Logger.warning('⚠️ Cannot refresh: No auth data');
      return;
    }

    // Giả sử bạn có GetProfileUseCase
    // await execute<AuthUser>(
    //   emit: emit,
    //   action: () => _getProfileUseCase(),
    //   // Không có successMessage = tự động refreshing
    //   onSuccess: (user) {
    //     // Update auth response
    //     final newResponse = authResponse!.copyWith(user: user);
    //     _storageService.saveUser(AuthUserModel.fromEntity(user).toJson());
    //     Logger.success('✅ Profile refreshed');
    //   },
    // );

    // Temporary: Just reload from storage
    Logger.info('🔄 Profile refresh called (implement GetProfileUseCase)');
  }

  // ═══════════════════════════════════════════════════════════════
  // 💾 Private Helpers
  // ═══════════════════════════════════════════════════════════════

  Future<void> _saveAuthData(AuthResponse data, {bool rememberMe = true}) async {
    try {
      // 1. Save tokens (encrypted)
      await _secureStorage.saveAccessToken(data.accessToken);
      await _secureStorage.saveRefreshToken(data.refreshToken);

      // 2. Save user data
      await _storageService.setLoggedIn(true);
      await _storageService.saveUser(AuthUserModel.fromEntity(data.user).toJson());

      // 3. Remember me
      if (rememberMe) {
        await _storageService.set('remember_me', true);
      }

      Logger.success('💾 Auth data saved');
    } catch (e) {
      Logger.error('❌ Failed to save auth data', error: e);
    }
  }
}
