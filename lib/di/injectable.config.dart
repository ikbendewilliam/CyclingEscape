// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i32;
import 'package:drift/drift.dart' as _i6;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_architecture/icapps_architecture.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i15;

import '../database/cycling_escape_database.dart' as _i19;
import '../repository/debug/debug_repository.dart' as _i21;
import '../repository/locale/locale_repository.dart' as _i24;
import '../repository/refresh/refresh_repository.dart' as _i26;
import '../repository/secure_storage/auth/auth_storage.dart' as _i20;
import '../repository/secure_storage/secure_storage.dart' as _i14;
import '../repository/shared_prefs/local/local_storage.dart' as _i23;
import '../repository/tutorial/tutorial_repository.dart' as _i28;
import '../util/cache/cache_controller.dart' as _i4;
import '../util/cache/cache_controlling.dart' as _i3;
import '../util/interceptor/network_auth_interceptor.dart' as _i25;
import '../util/interceptor/network_error_interceptor.dart' as _i12;
import '../util/interceptor/network_log_interceptor.dart' as _i13;
import '../util/interceptor/network_refresh_interceptor.dart' as _i31;
import '../viewmodel/debug/debug_platform_selector_viewmodel.dart' as _i7;
import '../viewmodel/debug/debug_viewmodel.dart' as _i22;
import '../viewmodel/game/game_viewmodel.dart' as _i29;
import '../viewmodel/global/global_viewmodel.dart' as _i30;
import '../viewmodel/license/license_viewmodel.dart' as _i9;
import '../viewmodel/main_menu/main_menu_viewmodel.dart' as _i10;
import '../viewmodel/menu_background/menu_background_viewmodel.dart' as _i11;
import '../viewmodel/single_race_menu/single_race_menu_viewmodel.dart' as _i16;
import '../viewmodel/splash/splash_viewmodel.dart' as _i27;
import '../viewmodel/tour_menu/tour_menu_viewmodel.dart' as _i18;
import '../widget_game/data/sprite_manager.dart' as _i17;
import 'injectable.dart' as _i33; // ignore_for_file: unnecessary_lambdas

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
  gh.factory<_i9.LicenseViewModel>(() => _i9.LicenseViewModel());
  gh.factory<_i10.MainMenuViewModel>(() => _i10.MainMenuViewModel());
  gh.factory<_i11.MenuBackgroundViewModel>(
      () => _i11.MenuBackgroundViewModel());
  gh.singleton<_i12.NetworkErrorInterceptor>(
      _i12.NetworkErrorInterceptor(get<_i5.ConnectivityHelper>()));
  gh.singleton<_i13.NetworkLogInterceptor>(_i13.NetworkLogInterceptor());
  gh.lazySingleton<_i14.SecureStorage>(
      () => _i14.SecureStorage(get<_i8.FlutterSecureStorage>()));
  await gh.singletonAsync<_i15.SharedPreferences>(() => registerModule.prefs(),
      preResolve: true);
  gh.factory<_i16.SingleRaceMenuViewModel>(
      () => _i16.SingleRaceMenuViewModel());
  gh.singleton<_i17.SpriteManager>(_i17.SpriteManager());
  gh.factory<_i18.TourMenuViewModel>(() => _i18.TourMenuViewModel());
  gh.lazySingleton<_i19.CyclingEscapeDatabase>(() => registerModule
      .provideCyclingEscapeDatabase(get<_i6.DatabaseConnection>()));
  gh.lazySingleton<_i5.SharedPreferenceStorage>(
      () => registerModule.sharedPreferences(get<_i15.SharedPreferences>()));
  gh.lazySingleton<_i5.SimpleKeyValueStorage>(() =>
      registerModule.keyValueStorage(
          get<_i5.SharedPreferenceStorage>(), get<_i14.SecureStorage>()));
  gh.lazySingleton<_i20.AuthStorage>(
      () => _i20.AuthStorage(get<_i5.SimpleKeyValueStorage>()));
  gh.lazySingleton<_i21.DebugRepository>(
      () => _i21.DebugRepository(get<_i5.SharedPreferenceStorage>()));
  gh.factory<_i22.DebugViewModel>(
      () => _i22.DebugViewModel(get<_i21.DebugRepository>()));
  gh.lazySingleton<_i23.LocalStorage>(() => _i23.LocalStorage(
      get<_i20.AuthStorage>(), get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i24.LocaleRepository>(
      () => _i24.LocaleRepository(get<_i5.SharedPreferenceStorage>()));
  gh.singleton<_i25.NetworkAuthInterceptor>(
      _i25.NetworkAuthInterceptor(get<_i20.AuthStorage>()));
  gh.lazySingleton<_i26.RefreshRepository>(
      () => _i26.RefreshRepository(get<_i20.AuthStorage>()));
  gh.factory<_i27.SplashViewModel>(
      () => _i27.SplashViewModel(get<_i23.LocalStorage>()));
  gh.lazySingleton<_i28.TutorialRepository>(
      () => _i28.TutorialRepository(get<_i23.LocalStorage>()));
  gh.factory<_i29.GameViewModel>(() => _i29.GameViewModel(
      get<_i28.TutorialRepository>(),
      get<_i23.LocalStorage>(),
      get<_i17.SpriteManager>()));
  gh.singleton<_i30.GlobalViewModel>(_i30.GlobalViewModel(
      get<_i24.LocaleRepository>(),
      get<_i21.DebugRepository>(),
      get<_i23.LocalStorage>()));
  gh.singleton<_i31.NetworkRefreshInterceptor>(
      _i31.NetworkRefreshInterceptor(get<_i26.RefreshRepository>()));
  gh.lazySingleton<_i5.CombiningSmartInterceptor>(() =>
      registerModule.provideCombiningSmartInterceptor(
          get<_i13.NetworkLogInterceptor>(),
          get<_i25.NetworkAuthInterceptor>(),
          get<_i12.NetworkErrorInterceptor>(),
          get<_i31.NetworkRefreshInterceptor>()));
  gh.lazySingleton<_i32.Dio>(
      () => registerModule.provideDio(get<_i5.CombiningSmartInterceptor>()));
  return get;
}

class _$RegisterModule extends _i33.RegisterModule {}
