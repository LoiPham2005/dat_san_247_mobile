// import 'package:flutter/material.dart';
// import 'package:flutter_base_template/core/state_management/providers/base_provider.dart';
// import 'package:flutter_base_template/features/auth/domain/entities/auth_entity.dart';
// import 'package:flutter_base_template/features/auth/domain/usecases/login_usecase.dart';
// import 'package:injectable/injectable.dart';

// @injectable
// class AuthProvider extends BaseProvider {
//   AuthProvider(this._loginUseCase);

//   final LoginUseCase _loginUseCase;
//   // final RegisterUseCase _registerUseCase;

//   AuthResponse? _authData;
//   AuthResponse? get authData => _authData;

//   /// ✅ Login tái sử dụng từ BaseProvider
//   Future<void> login(String email, String password) async {
//     await execute<AuthResponse>(
//       action: () => _loginUseCase(email: email, password: password),
//       onSuccess: (data) {
//         _authData = data;
//         notifyListeners();
//       },
//     );
//   }

//   /// ✅ Register tái sử dụng chung logic
//   // Future<void> register(String email, String password) async {
//   //   await execute<AuthResponse>(
//   //     action: () => _registerUseCase(email: email, password: password),
//   //     onSuccess: (data) {
//   //       _authData = data;
//   //       notifyListeners();
//   //     },
//   //   );
//   // }
// }
