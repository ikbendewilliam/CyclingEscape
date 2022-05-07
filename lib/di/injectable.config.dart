// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i27;
import 'package:drift/drift.dart' as _i6;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_architecture/icapps_architecture.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i14;

import '../database/cycling_escape_database.dart' as _i9;
import '../repository/debug/debug_repository.dart' as _i16;
import '../repository/locale/locale_repository.dart' as _i19;
import '../repository/login/login_repository.dart' as _i20;
import '../repository/refresh/refresh_repository.dart' as _i23;
import '../repository/secure_storage/auth/auth_storage.dart' as _i15;
import '../repository/secure_storage/secure_storage.dart' as _i13;
import '../repository/shared_prefs/local/local_storage.dart' as _i18;
import '../util/cache/cache_controller.dart' as _i4;
import '../util/cache/cache_controlling.dart' as _i3;
import '../util/interceptor/network_auth_interceptor.dart' as _i22;
import '../util/interceptor/network_error_interceptor.dart' as _i11;
import '../util/interceptor/network_log_interceptor.dart' as _i12;
import '../util/interceptor/network_refresh_interceptor.dart' as _i26;
import '../viewmodel/debug/debug_platform_selector_viewmodel.dart' as _i7;
import '../viewmodel/debug/debug_viewmodel.dart' as _i17;
import '../viewmodel/global/global_viewmodel.dart' as _i25;
import '../viewmodel/license/license_viewmodel.dart' as _i10;
import '../viewmodel/login/login_viewmodel.dart' as _i21;
import '../viewmodel/splash/splash_viewmodel.dart' as _i24;
import 'injectable.dart' as _i28; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.CacheControlling>(_i4.CacheController());
  gh.singleton<_i5.ConnectivityHelper>(registerModule.connectivityHelper());
  await gh.singletonAsync<_i6.DatabaseConnection>(
      () => registerModule.provideDatabaseConnection(),
      preResolve: true);
  gh.factory<_i7.DebugPlatformSelectorViewModel>(
      () => _i7.DebugPlatformSelectorViewModel());
  gh.lazySingleton<_i8.FlutterSecureStorage>(() => registerModule.storage());
  gh.lazySingleton<_i9.FlutterTemplateDatabase>(() => registerModule
      .provideFlutterTemplateDatabase(get<_i6.DatabaseConnection>()));
  gh.factory<_i10.LicenseViewModel>(() => _i10.LicenseViewModel());
  gh.singleton<_i11.NetworkErrorInterceptor>(
      _i11.NetworkErrorInterceptor(get<_i5.ConnectivityHelper>()));
  gh.singleton<_i12.NetworkLogInterceptor>(_i12.NetworkLogInterceptor());
  gh.lazySingleton<_i13.SecureStorage>(
      () => _i13.SecureStorage(get<_i8.FlutterSecureStorage>()));
  await gh.singletonAsync<_i14.SharedPreferences>(() => registerModule.prefs(),
      preResolve: true);
  gh.lazySingleton<_i5.SharedPreferenceStorage>(
      () => registerModule.sharedPreferences(get<_i14.SharedPreferences>()));
  gh.lazySingleton<_i5.SimpleKeyValueStorage>(() =>
      registerModule.keyValueStorage(
          get<_i5.SharedPreferenceStorage>(), get<_i13.SecureStorage>()));
  gh.lazySingleton<_i15.AuthStorage>(
      () => _i15.AuthStorage(get<_i5.SimpleKeyValueStorage>()));
  gh.lazySingleton<_i16.DebugRepository>(
      () => _i16.DebugRepository(get<_i5.SharedPreferenceStorage>()));
  gh.factory<_i17.DebugViewModel>(
      () => _i17.DebugViewModel(get<_i16.DebugRepository>()));
  gh.lazySingleton<_i18.LocalStorage>(() => _i18.LocalStorage(
      get<_i15.AuthStorage>(), get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i19.LocaleRepository>(
      () => _i19.LocaleRepository(get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i20.LoginRepository>(
      () => _i20.LoginRepository(get<_i15.AuthStorage>()));
  gh.factory<_i21.LoginViewModel>(
      () => _i21.LoginViewModel(get<_i20.LoginRepository>()));
  gh.singleton<_i22.NetworkAuthInterceptor>(
      _i22.NetworkAuthInterceptor(get<_i15.AuthStorage>()));
  gh.lazySingleton<_i23.RefreshRepository>(
      () => _i23.RefreshRepository(get<_i15.AuthStorage>()));
  gh.factory<_i24.SplashViewModel>(() => _i24.SplashViewModel(
      get<_i20.LoginRepository>(), get<_i18.LocalStorage>()));
  gh.factory<_i25.GlobalViewModel>(() => _i25.GlobalViewModel(
      get<_i19.LocaleRepository>(),
      get<_i16.DebugRepository>(),
      get<_i18.LocalStorage>()));
  gh.singleton<_i26.NetworkRefreshInterceptor>(
      _i26.NetworkRefreshInterceptor(get<_i23.RefreshRepository>()));
  gh.lazySingleton<_i5.CombiningSmartInterceptor>(() =>
      registerModule.provideCombiningSmartInterceptor(
          get<_i12.NetworkLogInterceptor>(),
          get<_i22.NetworkAuthInterceptor>(),
          get<_i11.NetworkErrorInterceptor>(),
          get<_i26.NetworkRefreshInterceptor>()));
  gh.lazySingleton<_i27.Dio>(
      () => registerModule.provideDio(get<_i5.CombiningSmartInterceptor>()));
  return get;
}

class _$RegisterModule extends _i28.RegisterModule {}
