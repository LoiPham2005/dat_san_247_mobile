// import 'package:dat_san_247_mobile/core/state_management/getx/base_controller.dart';
// import 'package:dat_san_247_mobile/features/auth/domain/entities/auth_entity.dart';
// import 'package:dat_san_247_mobile/features/auth/domain/usecases/login_usecase.dart';
// import 'package:get/get.dart';
// import 'package:injectable/injectable.dart';

// @injectable
// class AuthController extends BaseController {
//   final LoginUseCase _loginUseCase;
//   // final RegisterUseCase _registerUseCase;

//   AuthController(this._loginUseCase,);

//   final Rx<AuthResponse?> user = Rx<AuthResponse?>(null);

//   /// ✅ Login dùng hàm tái sử dụng
//   Future<void> login(String email, String password) async {
//     await execute<AuthResponse>(
//       action: () => _loginUseCase(email: email, password: password),
//       onSuccess: (data) => user.value = data,
//     );
//   }

//   /// ✅ Register cũng dùng lại y chang
//   // Future<void> register(String email, String password) async {
//   //   await execute<AuthResponse>(
//   //     action: () => _registerUseCase(email: email, password: password),
//   //     onSuccess: (data) => user.value = data,
//   //   );
//   // }
// }
