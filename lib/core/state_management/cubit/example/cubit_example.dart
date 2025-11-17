// import 'package:flutter_base_template/core/state_management/cubit/base_cubit.dart';
// import 'package:flutter_base_template/core/state_management/cubit/base_state.dart';
// import 'package:flutter_base_template/features/auth/domain/usecases/login_usecase.dart';
// import 'package:injectable/injectable.dart';

// @injectable
// class AuthCubit extends BaseCubit {
//   final LoginUseCase _loginUseCase;

//   AuthCubit(this._loginUseCase) : super(InitialState());

//   Future<void> login({
//     required String email,
//     required String password,
//   }) async {
//     await execute(
//       action: () => _loginUseCase(
//         email: email,
//         password: password,
//       )
//     );
//   }
// }