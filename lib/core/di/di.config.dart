// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/Auth/data/contracts/offline_data_source.dart' as _i537;
import '../../features/Auth/data/contracts/online_data_source.dart' as _i597;
import '../../features/Auth/data/data_sources/offline_data_source_impl.dart'
    as _i553;
import '../../features/Auth/data/data_sources/online_data_source_impl.dart'
    as _i163;
import '../../features/Auth/data/repos/auth_repository_impl.dart' as _i481;
import '../../features/Auth/domain/repos/auth_repository.dart' as _i492;
import '../../features/Auth/domain/use_cases/check_user_cache_use_case.dart'
    as _i513;
import '../../features/Auth/domain/use_cases/login_use_case.dart' as _i694;
import '../../features/Auth/domain/use_cases/logout_use_case.dart' as _i1054;
import '../../features/Auth/domain/use_cases/register_use_case.dart' as _i228;
import '../../features/Auth/presentation/login/login_viewmodel.dart' as _i641;
import '../../features/Auth/presentation/register/register_viewmodel.dart'
    as _i902;
import '../../features/Home/presentation/home_view_model.dart' as _i286;
import '../../features/profile/presentation/view_models/profile_view_model.dart'
    as _i668;
import '../../features/steps/presentation/steps_viewmodel.dart' as _i1071;
import '../api/api_manager.dart' as _i1047;
import '../local/hive_manager.dart' as _i587;
import '../modules/shared_prefs_module.dart' as _i998;
import '../provider/steps_provider.dart' as _i1021;
import '../provider/usage_provider.dart' as _i229;
import '../provider/user_provider.dart' as _i505;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final sharedPrefsModule = _$SharedPrefsModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPrefsModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i1047.ApiManager>(() => _i1047.ApiManager());
    gh.singleton<_i587.HiveManager>(() => _i587.HiveManager());
    gh.singleton<_i481.AuthEventService>(() => _i481.AuthEventService());
    gh.lazySingleton<_i505.UserNotifier>(() => _i505.UserNotifier());
    gh.factory<_i537.OfflineDataSource>(
        () => _i553.OfflineDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i1021.StepsNotifier>(
        () => _i1021.StepsNotifier(gh<_i587.HiveManager>()));
    gh.factory<_i229.AppUsageNotifier>(
        () => _i229.AppUsageNotifier(gh<_i587.HiveManager>()));
    gh.factory<_i1071.StepsViewmodel>(() => _i1071.StepsViewmodel(
          gh<_i460.SharedPreferences>(),
          gh<_i481.AuthEventService>(),
        ));
    gh.factory<_i597.OnlineDataSource>(
        () => _i163.OnlineDataSourceImpl(gh<_i1047.ApiManager>()));
    gh.factory<_i492.AuthRepository>(() => _i481.AuthRepositoryImpl(
          gh<_i597.OnlineDataSource>(),
          gh<_i537.OfflineDataSource>(),
          gh<_i587.HiveManager>(),
          gh<_i481.AuthEventService>(),
        ));
    gh.factory<_i513.CheckUserCacheUseCase>(
        () => _i513.CheckUserCacheUseCase(gh<_i492.AuthRepository>()));
    gh.factory<_i694.LoginUseCase>(
        () => _i694.LoginUseCase(gh<_i492.AuthRepository>()));
    gh.factory<_i1054.LogoutUseCase>(
        () => _i1054.LogoutUseCase(gh<_i492.AuthRepository>()));
    gh.factory<_i228.RegisterUseCase>(
        () => _i228.RegisterUseCase(gh<_i492.AuthRepository>()));
    gh.factory<_i286.HomeViewModel>(() => _i286.HomeViewModel(
          gh<_i513.CheckUserCacheUseCase>(),
          gh<_i481.AuthEventService>(),
        ));
    gh.factory<_i668.ProfileViewModel>(
        () => _i668.ProfileViewModel(gh<_i1054.LogoutUseCase>()));
    gh.factory<_i902.RegisterViewmodel>(
        () => _i902.RegisterViewmodel(gh<_i228.RegisterUseCase>()));
    gh.factory<_i641.LoginViewmodel>(
        () => _i641.LoginViewmodel(gh<_i694.LoginUseCase>()));
    return this;
  }
}

class _$SharedPrefsModule extends _i998.SharedPrefsModule {}
