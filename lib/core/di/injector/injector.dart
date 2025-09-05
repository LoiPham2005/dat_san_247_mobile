// import 'package:dat_san_247_mobile/core/di/injector/injector_cubit.dart';
// import 'package:dat_san_247_mobile/core/di/injector/injector_repo.dart';
// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final di = GetIt.instance;

// Future<void> initializeDependencies() async {
//   await _dependencyExternal();
//   injectorRepo();
//   injectorCubit();
// }

// _dependencyExternal() async {
//   final preferences = await SharedPreferences.getInstance();
//   di.registerSingleton<SharedPreferences>(
//     preferences,
//   );
// }
