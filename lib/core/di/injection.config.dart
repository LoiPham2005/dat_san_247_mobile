// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dat_san_247_mobile/core/ads/config/ad_config.dart' as _i37;
import 'package:dat_san_247_mobile/core/ads/config/ad_module.dart' as _i268;
import 'package:dat_san_247_mobile/core/ads/config/ad_remote_config.dart'
    as _i352;
import 'package:dat_san_247_mobile/core/ads/services/ad_analytics_tracker.dart'
    as _i643;
import 'package:dat_san_247_mobile/core/ads/services/ad_manager.dart' as _i882;
import 'package:dat_san_247_mobile/core/ads/services/ad_service.dart' as _i532;
import 'package:dat_san_247_mobile/core/cache/app_cache_manager.dart' as _i681;
import 'package:dat_san_247_mobile/core/database/app_database.dart' as _i676;
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
import 'package:dat_san_247_mobile/core/services/analytics_service.dart'
    as _i616;
import 'package:dat_san_247_mobile/core/services/auth_service.dart' as _i455;
import 'package:dat_san_247_mobile/core/services/navigation_service.dart'
    as _i724;
import 'package:dat_san_247_mobile/core/services/toast_service.dart' as _i248;
import 'package:dat_san_247_mobile/core/state_management/auth/auth_cubit.dart'
    as _i1068;
import 'package:dat_san_247_mobile/core/storage/local/local_storage_service.dart'
    as _i511;
import 'package:dat_san_247_mobile/core/storage/secure/secure_storage_service.dart'
    as _i564;
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
import 'package:dat_san_247_mobile/features/auth/domain/usecases/get_profile_use_case.dart'
    as _i922;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/login_usecase.dart'
    as _i655;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/logout_usecase.dart'
    as _i194;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/register_use_case.dart'
    as _i512;
import 'package:dat_san_247_mobile/features/auth/domain/usecases/reset_password_use_case.dart'
    as _i565;
import 'package:dat_san_247_mobile/features/auth/presentation/bloc/auth_bloc.dart'
    as _i801;
import 'package:dat_san_247_mobile/features/example/category_ket_hop/data/datasources/category_remote_datasource.dart'
    as _i934;
import 'package:dat_san_247_mobile/features/example/category_ket_hop/data/datasources/category_service.dart'
    as _i296;
import 'package:dat_san_247_mobile/features/example/category_ket_hop/data/repositories/category_repository_impl.dart'
    as _i608;
import 'package:dat_san_247_mobile/features/example/category_ket_hop/domain/repositories/category_repository.dart'
    as _i799;
import 'package:dat_san_247_mobile/features/example/category_ket_hop/domain/usecases/category_usecases.dart'
    as _i344;
import 'package:dat_san_247_mobile/features/example/category_ket_hop/presentation/bloc/category_bloc.dart'
    as _i95;
import 'package:dat_san_247_mobile/features/example/category_rut_gon/data/category_repository.dart'
    as _i1005;
import 'package:dat_san_247_mobile/features/example/category_rut_gon/data/category_service.dart'
    as _i141;
import 'package:dat_san_247_mobile/features/example/category_rut_gon/presentation/bloc/category_bloc.dart'
    as _i348;
import 'package:dat_san_247_mobile/features/example/category_thu_cong/data/datasources/category_remote_datasource.dart'
    as _i232;
import 'package:dat_san_247_mobile/features/example/category_thu_cong/data/repositories/category_repository_impl.dart'
    as _i155;
import 'package:dat_san_247_mobile/features/example/category_thu_cong/domain/repositories/category_repository.dart'
    as _i211;
import 'package:dat_san_247_mobile/features/example/category_thu_cong/domain/usecases/category_usecases.dart'
    as _i602;
import 'package:dat_san_247_mobile/features/example/category_thu_cong/presentation/bloc/category_bloc.dart'
    as _i877;
import 'package:dat_san_247_mobile/routes/app_router.dart' as _i850;
import 'package:dat_san_247_mobile/routes/app_routes_observer.dart' as _i1062;
import 'package:dat_san_247_mobile/routes/route_guards.dart' as _i899;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final adModule = _$AdModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i1062.AppRoutesObserver>(() => _i1062.AppRoutesObserver());
    gh.lazySingleton<_i352.AdRemoteConfig>(() => _i352.AdRemoteConfig());
    gh.lazySingleton<_i681.AppCacheManager>(() => _i681.AppCacheManager());
    gh.lazySingleton<_i676.AppDatabase>(() => _i676.AppDatabase());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => registerModule.internetConnection,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i132.ErrorInterceptor>(() => _i132.ErrorInterceptor());
    gh.lazySingleton<_i6.LoggingInterceptor>(() => _i6.LoggingInterceptor());
    gh.lazySingleton<_i348.SmartCacheInterceptor>(
      () => _i348.SmartCacheInterceptor(),
    );
    gh.lazySingleton<_i616.AnalyticsService>(() => _i616.AnalyticsService());
    gh.lazySingleton<_i724.NavigationService>(() => _i724.NavigationService());
    gh.lazySingleton<_i248.ToastService>(() => _i248.ToastService());
    gh.lazySingleton<_i511.LocalStorageService>(
      () => _i511.LocalStorageService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i643.AdAnalyticsTracker>(
      () => _i643.AdAnalyticsTracker(gh<_i616.AnalyticsService>()),
    );
    gh.lazySingletonAsync<_i37.AdConfig>(
      () => adModule.provideAdConfig(gh<_i352.AdRemoteConfig>()),
    );
    gh.lazySingleton<_i296.CategoryService>(
      () => _i296.CategoryService.new(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i141.CategoryRutGonService>(
      () => _i141.CategoryRutGonService.new(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i616.NetworkInfo>(
      () => _i616.NetworkInfoImpl(gh<_i161.InternetConnection>()),
    );
    gh.lazySingleton<_i534.LocaleCubit>(
      () => _i534.LocaleCubit(gh<_i511.LocalStorageService>()),
    );
    gh.lazySingleton<_i711.ThemeCubit>(
      () => _i711.ThemeCubit(gh<_i511.LocalStorageService>()),
    );
    gh.lazySingletonAsync<_i532.AdService>(
      () async => _i532.AdService(
        await getAsync<_i37.AdConfig>(),
        gh<_i643.AdAnalyticsTracker>(),
      ),
    );
    gh.lazySingleton<_i564.SecureStorage>(
      () => _i564.SecureStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i934.CategoryRemoteDataSource>(
      () => _i934.CategoryRemoteDataSourceImpl(gh<_i296.CategoryService>()),
    );
    gh.lazySingleton<_i1005.CategoryRutGonRepository>(
      () => _i1005.CategoryRutGonRepository(gh<_i141.CategoryRutGonService>()),
    );
    gh.lazySingletonAsync<_i882.AdManager>(
      () async => _i882.AdManager(
        await getAsync<_i532.AdService>(),
        await getAsync<_i37.AdConfig>(),
      ),
    );
    gh.lazySingleton<_i795.AuthInterceptor>(
      () => _i795.AuthInterceptor(gh<_i564.SecureStorage>()),
    );
    gh.lazySingleton<_i799.CategoryRepository>(
      () => _i608.CategoryRepositoryImpl(gh<_i934.CategoryRemoteDataSource>()),
    );
    gh.lazySingleton<_i297.DioClient>(
      () => _i297.DioClient(
        gh<_i795.AuthInterceptor>(),
        gh<_i132.ErrorInterceptor>(),
        gh<_i6.LoggingInterceptor>(),
        gh<_i348.SmartCacheInterceptor>(),
      ),
    );
    gh.factory<_i348.CategoryRutGonBloc>(
      () => _i348.CategoryRutGonBloc(gh<_i1005.CategoryRutGonRepository>()),
    );
    gh.lazySingleton<_i649.ApiClient>(
      () => _i649.ApiClient(gh<_i297.DioClient>(), gh<_i616.NetworkInfo>()),
    );
    gh.factory<_i344.GetCategoriesUseCase>(
      () => _i344.GetCategoriesUseCase(gh<_i799.CategoryRepository>()),
    );
    gh.factory<_i344.GetCategoryDetailUseCase>(
      () => _i344.GetCategoryDetailUseCase(gh<_i799.CategoryRepository>()),
    );
    gh.factory<_i344.CreateCategoryUseCase>(
      () => _i344.CreateCategoryUseCase(gh<_i799.CategoryRepository>()),
    );
    gh.factory<_i344.UpdateCategoryUseCase>(
      () => _i344.UpdateCategoryUseCase(gh<_i799.CategoryRepository>()),
    );
    gh.factory<_i344.DeleteCategoryUseCase>(
      () => _i344.DeleteCategoryUseCase(gh<_i799.CategoryRepository>()),
    );
    gh.factory<_i95.CategoryBloc>(
      () => _i95.CategoryBloc(gh<_i799.CategoryRepository>()),
    );
    gh.lazySingleton<_i170.AuthRemoteDataSource>(
      () => _i170.AuthRemoteDataSourceImpl(gh<_i649.ApiClient>()),
    );
    gh.lazySingleton<_i376.AuthRepository>(
      () => _i618.AuthRepositoryImpl(gh<_i170.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i455.AuthService>(
      () => _i455.AuthService(
        gh<_i564.SecureStorage>(),
        gh<_i511.LocalStorageService>(),
        gh<_i649.ApiClient>(),
      ),
    );
    gh.factory<_i627.DeleteAccountUseCase>(
      () => _i627.DeleteAccountUseCase(gh<_i376.AuthRepository>()),
    );
    gh.factory<_i1032.ForgotPasswordUseCase>(
      () => _i1032.ForgotPasswordUseCase(gh<_i376.AuthRepository>()),
    );
    gh.factory<_i922.GetProfileUseCase>(
      () => _i922.GetProfileUseCase(gh<_i376.AuthRepository>()),
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
    gh.lazySingleton<_i232.CategoryRemoteDataSource>(
      () => _i232.CategoryRemoteDataSourceImpl(gh<_i649.ApiClient>()),
    );
    gh.factory<_i801.AuthBloc>(
      () => _i801.AuthBloc(
        loginUseCase: gh<_i655.LoginUseCase>(),
        logoutUseCase: gh<_i194.LogoutUseCase>(),
        registerUseCase: gh<_i512.RegisterUseCase>(),
        forgotPasswordUseCase: gh<_i1032.ForgotPasswordUseCase>(),
        deleteAccountUseCase: gh<_i627.DeleteAccountUseCase>(),
        storageService: gh<_i511.LocalStorageService>(),
        secureStorage: gh<_i564.SecureStorage>(),
        authService: gh<_i455.AuthService>(),
      ),
    );
    gh.lazySingleton<_i1068.AuthCubit>(
      () => _i1068.AuthCubit(gh<_i455.AuthService>()),
    );
    gh.lazySingleton<_i211.CategoryRepository>(
      () => _i155.CategoryRepositoryImpl(gh<_i232.CategoryRemoteDataSource>()),
    );
    gh.factory<_i899.RouteGuards>(
      () => _i899.RouteGuards(gh<_i801.AuthBloc>()),
    );
    gh.factory<_i602.GetCategoriesUseCase>(
      () => _i602.GetCategoriesUseCase(gh<_i211.CategoryRepository>()),
    );
    gh.factory<_i602.GetCategoryDetailUseCase>(
      () => _i602.GetCategoryDetailUseCase(gh<_i211.CategoryRepository>()),
    );
    gh.lazySingleton<_i850.AppRouter>(
      () => _i850.AppRouter(
        gh<_i801.AuthBloc>(),
        gh<_i899.RouteGuards>(),
        gh<_i724.NavigationService>(),
        gh<_i1062.AppRoutesObserver>(),
      ),
    );
    gh.factory<_i877.CategoryBloc>(
      () => _i877.CategoryBloc(gh<_i211.CategoryRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i741.RegisterModule {}

class _$AdModule extends _i268.AdModule {}
