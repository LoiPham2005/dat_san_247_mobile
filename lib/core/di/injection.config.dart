// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dat_san_247_mobile/core/cache/app_cache_manager.dart' as _i681;
import 'package:dat_san_247_mobile/core/di/injection.dart' as _i741;
import 'package:dat_san_247_mobile/core/l10n/localization_service.dart'
    as _i534;
import 'package:dat_san_247_mobile/core/network/api_client.dart' as _i649;
import 'package:dat_san_247_mobile/core/network/dio_client.dart' as _i297;
import 'package:dat_san_247_mobile/core/network/interceptors/auth_interceptor.dart'
    as _i795;
import 'package:dat_san_247_mobile/core/network/interceptors/error_interceptor.dart'
    as _i132;
import 'package:dat_san_247_mobile/core/network/interceptors/logging_interceptor.dart'
    as _i6;
import 'package:dat_san_247_mobile/core/network/interceptors/smart_cache_interceptor.dart'
    as _i348;
import 'package:dat_san_247_mobile/core/network/network_info.dart' as _i616;
import 'package:dat_san_247_mobile/core/routes/app_router.dart' as _i863;
import 'package:dat_san_247_mobile/core/services/auth_service.dart' as _i455;
import 'package:dat_san_247_mobile/core/services/cache_service.dart' as _i412;
import 'package:dat_san_247_mobile/core/services/navigation_service.dart'
    as _i724;
import 'package:dat_san_247_mobile/core/storage/secure_storage.dart' as _i47;
import 'package:dat_san_247_mobile/core/storage/storage_service.dart' as _i926;
import 'package:dat_san_247_mobile/core/theme/theme_cubit.dart' as _i711;
import 'package:dat_san_247_mobile/features/auth/data/datasources/auth_remote_datasourse.dart'
    as _i170;
import 'package:dat_san_247_mobile/features/auth/data/repositories/auth_repository_impl.dart'
    as _i618;
import 'package:dat_san_247_mobile/features/auth/domain/repositories/auth_repository.dart'
    as _i376;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/delete_account_use_case.dart'
    as _i627;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/forgot_password_use_case.dart'
    as _i1032;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/login_usecase.dart'
    as _i655;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/logout_usecase.dart'
    as _i194;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/register_use_case.dart'
    as _i512;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/reset_password_use_case.dart'
    as _i565;
import 'package:dat_san_247_mobile/features/auth/presentation/cubit/auth_cubit.dart'
    as _i724;
import 'package:dat_san_247_mobile/features/category/data/datasourse/sport_category_remote_datasourse.dart'
    as _i967;
import 'package:dat_san_247_mobile/features/category/data/repositories/sport_category_repository_impl.dart'
    as _i288;
import 'package:dat_san_247_mobile/features/category/domain/repositories/sport_category_repository.dart'
    as _i983;
import 'package:dat_san_247_mobile/features/category/domain/usecases/get_sport_category.dart'
    as _i21;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i681.AppCacheManager>(() => _i681.AppCacheManager());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i132.ErrorInterceptor>(() => _i132.ErrorInterceptor());
    gh.lazySingleton<_i6.LoggingInterceptor>(() => _i6.LoggingInterceptor());
    gh.lazySingleton<_i348.SmartCacheInterceptor>(
      () => _i348.SmartCacheInterceptor(),
    );
    gh.lazySingleton<_i863.AppRouter>(() => _i863.AppRouter());
    gh.lazySingleton<_i412.CacheService>(() => _i412.CacheService());
    gh.lazySingleton<_i724.NavigationService>(() => _i724.NavigationService());
    gh.lazySingleton<_i926.StorageService>(
      () => _i926.StorageService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i47.SecureStorage>(
      () => _i47.SecureStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i795.AuthInterceptor>(
      () => _i795.AuthInterceptor(gh<_i47.SecureStorage>()),
    );
    gh.lazySingleton<_i616.NetworkInfo>(
      () => _i616.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i534.LocaleCubit>(
      () => _i534.LocaleCubit(gh<_i926.StorageService>()),
    );
    gh.factory<_i711.ThemeCubit>(
      () => _i711.ThemeCubit(gh<_i926.StorageService>()),
    );
    gh.lazySingleton<_i455.AuthService>(
      () => _i455.AuthService(
        gh<_i926.StorageService>(),
        gh<_i47.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i297.DioClient>(
      () => _i297.DioClient(
        gh<_i795.AuthInterceptor>(),
        gh<_i132.ErrorInterceptor>(),
        gh<_i6.LoggingInterceptor>(),
        gh<_i348.SmartCacheInterceptor>(),
      ),
    );
    gh.lazySingleton<_i649.ApiClient>(
      () => _i649.ApiClient(gh<_i297.DioClient>(), gh<_i616.NetworkInfo>()),
    );
    gh.lazySingleton<_i170.AuthRemoteDataSource>(
      () => _i170.AuthRemoteDataSourceImpl(gh<_i649.ApiClient>()),
    );
    gh.lazySingleton<_i376.AuthRepository>(
      () => _i618.AuthRepositoryImpl(gh<_i170.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i967.SportCategoryRemoteDataSource>(
      () => _i967.SportCategoryRemoteDataSourceImpl(gh<_i649.ApiClient>()),
    );
    gh.factory<_i627.DeleteAccountUseCase>(
      () => _i627.DeleteAccountUseCase(gh<_i376.AuthRepository>()),
    );
    gh.factory<_i1032.ForgotPasswordUseCase>(
      () => _i1032.ForgotPasswordUseCase(gh<_i376.AuthRepository>()),
    );
    gh.factory<_i655.LoginUseCase>(
      () => _i655.LoginUseCase(gh<_i376.AuthRepository>()),
    );
    gh.factory<_i194.LogoutUseCase>(
      () => _i194.LogoutUseCase(gh<_i376.AuthRepository>()),
    );
    gh.factory<_i512.RegisterUseCase>(
      () => _i512.RegisterUseCase(gh<_i376.AuthRepository>()),
    );
    gh.factory<_i565.ResetPasswordUseCase>(
      () => _i565.ResetPasswordUseCase(gh<_i376.AuthRepository>()),
    );
    gh.lazySingleton<_i983.SportCategoryRepository>(
      () => _i288.SportCategoryRepositoryImpl(
        gh<_i967.SportCategoryRemoteDataSource>(),
      ),
    );
    gh.factory<_i21.GetSportCategories>(
      () => _i21.GetSportCategories(gh<_i983.SportCategoryRepository>()),
    );
    gh.factory<_i724.AuthCubit>(
      () => _i724.AuthCubit(gh<_i655.LoginUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i741.RegisterModule {}
