// import 'dart:async';
// import 'package:dat_san_247_mobile/core/state_management/riverpod/base_async_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dat_san_247_mobile/core/di/injection.dart';
// import 'package:dat_san_247_mobile/features/auth/domain/entities/auth_entity.dart';
// import 'package:dat_san_247_mobile/features/auth/domain/usecases/login_usecase.dart';

// /// ✅ Provider Riverpod 3.x
// final authProvider =
//     AsyncNotifierProvider<AuthNotifier, AuthResponse?>(AuthNotifier.new);

// /// ✅ AuthNotifier kế thừa BaseAsyncNotifier để dùng hàm executeUseCase()
// class AuthNotifier extends BaseAsyncNotifier<AuthResponse?> {
//   late final LoginUseCase _loginUseCase;
//   // late final RegisterUseCase _registerUseCase;

//   @override
//   FutureOr<AuthResponse?> build() {
//     _loginUseCase = getIt<LoginUseCase>();
//     // _registerUseCase = getIt<RegisterUseCase>();
//     return null;
//   }

//   /// ✅ Login
//   Future<void> login(String email, String password) async {
//     await execute(
//       action: () => _loginUseCase(email: email, password: password),
//       onSuccess: (data) => state = AsyncData(data),
//     );
//   }

//   /// ✅ Register
//   // Future<void> register(String email, String password) async {
//   //   await execute(
//   //     action: () => _registerUseCase(email: email, password: password),
//   //     onSuccess: (data) => state = AsyncData(data),
//   //   );
//   // }
// }
