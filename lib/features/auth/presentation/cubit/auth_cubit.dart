import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/core/state_management/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_model.dart';
import 'package:dat_san_247_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/state_management/bloc/base_state.dart';

// @injectable
// class AuthCubit extends BaseCubit<UserModel?> {
//   final AuthRepository _repository;

//   AuthCubit(this._repository) : super(BaseState.initial());

//   /// 🔑 Login
//   Future<void> login({required String email, required String password}) async {
//     safeEmit(BaseState.loading());

//     final result = await _repository.login(email: email, password: password);

//     result.fold(
//       onSuccess: (authResponse) {
//         safeEmit(BaseState.success(data: authResponse.user, message: 'Đăng nhập thành công'));
//       },
//       onFailure: (failure) {
//         safeEmit(BaseState.failure(error: failure.message));
//       },
//     );
//   }

//   /// 📝 Register
//   Future<void> register({
//     required String fullName,
//     required String username,
//     required String email,
//     required String password,
//     required String passwordConfirm,
//   }) async {
//     safeEmit(BaseState.loading());

//     final result = await _repository.register(
//       fullName: fullName,
//       username: username,
//       email: email,
//       password: password,
//       passwordConfirm: passwordConfirm,
//     );

//     result.fold(
//       onSuccess: (authResponse) {
//         safeEmit(BaseState.success(data: authResponse.user, message: 'Đăng ký thành công'));
//       },
//       onFailure: (failure) {
//         safeEmit(BaseState.failure(error: failure.message));
//       },
//     );
//   }

//   /// 👤 Get Profile
//   Future<void> getProfile() async {
//     await execute(action: () => _repository.getProfile());
//   }

//   /// 🚪 Logout
//   Future<void> logout() async {
//     safeEmit(BaseState.loading(previousData: state.data));

//     final result = await _repository.logout();

//     result.fold(
//       onSuccess: (_) {
//         safeEmit(BaseState.initial());
//       },
//       onFailure: (failure) {
//         safeEmit(BaseState.failure(error: failure.message, previousData: state.data));
//       },
//     );
//   }

//   /// 📧 Forgot Password
//   Future<void> forgotPassword(String email) async {
//     safeEmit(BaseState.loading(previousData: state.data));

//     final result = await _repository.forgotPassword(email: email);

//     result.fold(
//       onSuccess: (_) {
//         safeEmit(
//           BaseState.success(data: state.data, message: 'Yêu cầu đặt lại mật khẩu đã được gửi'),
//         );
//       },
//       onFailure: (failure) {
//         safeEmit(BaseState.failure(error: failure.message, previousData: state.data));
//       },
//     );
//   }

//   /// 🔄 Reset Password
//   Future<void> resetPassword({
//     required String token,
//     required String password,
//     required String passwordConfirm,
//   }) async {
//     safeEmit(BaseState.loading(previousData: state.data));

//     final result = await _repository.resetPassword(
//       token: token,
//       password: password,
//       passwordConfirm: passwordConfirm,
//     );

//     result.fold(
//       onSuccess: (_) {
//         safeEmit(BaseState.success(data: state.data, message: 'Đặt lại mật khẩu thành công'));
//       },
//       onFailure: (failure) {
//         safeEmit(BaseState.failure(error: failure.message, previousData: state.data));
//       },
//     );
//   }

//   /// 🔍 Check Login Status
//   Future<void> checkLoginStatus() async {
//     final result = await _repository.checkLoginStatus();
//     result.fold(
//       onSuccess: (isLoggedIn) {
//         if (isLoggedIn) {
//           getProfile();
//         } else {
//           safeEmit(BaseState.initial());
//         }
//       },
//       onFailure: (_) {
//         safeEmit(BaseState.initial());
//       },
//     );
//   }
// }








@injectable
class AuthCubit extends BaseCubit<UserModel?> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(BaseState.initial());

  /// 🔑 Login
  Future<void> login({required String email, required String password}) async {
    await execute(
      // action: () async {
      //   final result = await _repository.login(email: email, password: password);
      //   return result.map((response) {
      //     getIt<AppAuthCubit>().loginSuccess(response);
      //     return response.user;
      //   });
      // },
      // successMessage: 'Đăng nhập thành công',
      action: () => _repository.login(email: email, password: password),
      mapper: (response) => response.user,
      onSuccess: (response) => getIt<AppAuthCubit>().loginSuccess(response),
      successMessage: 'Đăng nhập thành công',
    );
  }

  /// 📝 Register
  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    await execute(
      // action: () async {
      //   final result = await _repository.register(
      //   fullName: fullName,
      //   username: username,
      //   email: email,
      //   password: password,
      //   passwordConfirm: passwordConfirm,
      //   );
      //   return result.map((response) {
      //     getIt<AppAuthCubit>().loginSuccess(response);
      //     return response.user;
      //   });
      // },
      // successMessage: 'Đăng ký thành công',
      action: () => _repository.register(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      ),
      mapper: (response) => response.user,
      onSuccess: (response) => getIt<AppAuthCubit>().loginSuccess(response),
      successMessage: 'Đăng ký thành công',
    );
  }

  /// 👤 Get Profile
  Future<void> getProfile() async {
    await execute(action: () => _repository.getProfile());
  }

  /// 🚪 Logout
  Future<void> logout() async {
    await execute(
      // action: () async {
      //   final result = await _repository.logout();
      //   return result.map((_) {
      //     getIt<AppAuthCubit>().logout();
      //     return null;
      //   });
      // },
      // successMessage: 'Đăng xuất thành công',
      action: () => _repository.logout(),
      mapper: (_) => null,
      onSuccess: (_) => getIt<AppAuthCubit>().logout(),
      successMessage: 'Đăng xuất thành công',
    );
  }

  /// 📧 Forgot Password
  Future<void> forgotPassword(String email) async {
    await execute(
      // action: () async {
      //   final result = await _repository.forgotPassword(email: email);
      //   return result.map((_) => state.data);
      // },
      action: () => _repository.forgotPassword(email: email),
      mapper: (_) => state.data,
      successMessage: 'Yêu cầu đặt lại mật khẩu đã được gửi',
    );
  }

  /// 🔄 Reset Password
  Future<void> resetPassword({
    required String token,
    required String password,
    required String passwordConfirm,
  }) async {
    await execute(
      // action: () async {
      //   final result = await _repository.resetPassword(
      //   token: token,
      //   password: password,
      //   passwordConfirm: passwordConfirm,
      //   );
      //   return result.map((_) => state.data);
      // },
      // successMessage: 'Đặt lại mật khẩu thành công',
      action: () => _repository.resetPassword(
        token: token,
        password: password,
        passwordConfirm: passwordConfirm,
      ),
      mapper: (_) => state.data,
      successMessage: 'Đặt lại mật khẩu thành công',
    );
  }

  /// 🔍 Check Login Status
  Future<void> checkLoginStatus() async {
    final result = await _repository.checkLoginStatus();
    result.fold(
      onSuccess: (isLoggedIn) {
        if (isLoggedIn) {
          getProfile();
        } else {
          safeEmit(BaseState.initial());
        }
      },
      onFailure: (_) {
        safeEmit(BaseState.initial());
      },
    );
  }
}
