// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i35;
import 'package:drift/drift.dart' as _i7;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_architecture/icapps_architecture.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i17;

import '../database/cycling_escape_database.dart' as _i21;
import '../repository/debug/debug_repository.dart' as _i23;
import '../repository/locale/locale_repository.dart' as _i26;
import '../repository/refresh/refresh_repository.dart' as _i28;
import '../repository/secure_storage/auth/auth_storage.dart' as _i22;
import '../repository/secure_storage/secure_storage.dart' as _i16;
import '../repository/shared_prefs/local/local_storage.dart' as _i25;
import '../repository/tutorial/tutorial_repository.dart' as _i31;
import '../util/cache/cache_controller.dart' as _i4;
import '../util/cache/cache_controlling.dart' as _i3;
import '../util/interceptor/network_auth_interceptor.dart' as _i27;
import '../util/interceptor/network_error_interceptor.dart' as _i13;
import '../util/interceptor/network_log_interceptor.dart' as _i14;
import '../util/interceptor/network_refresh_interceptor.dart' as _i34;
import '../viewmodel/credits/credits_viewmodel.dart' as _i6;
import '../viewmodel/debug/debug_platform_selector_viewmodel.dart' as _i8;
import '../viewmodel/debug/debug_viewmodel.dart' as _i24;
import '../viewmodel/game/game_viewmodel.dart' as _i32;
import '../viewmodel/global/global_viewmodel.dart' as _i33;
import '../viewmodel/license/license_viewmodel.dart' as _i10;
import '../viewmodel/main_menu/main_menu_viewmodel.dart' as _i11;
import '../viewmodel/menu_background/menu_background_viewmodel.dart' as _i12;
import '../viewmodel/results/results_viewmodel.dart' as _i15;
import '../viewmodel/settings/settings_viewmodel.dart' as _i29;
import '../viewmodel/single_race_menu/single_race_menu_viewmodel.dart' as _i18;
import '../viewmodel/splash/splash_viewmodel.dart' as _i30;
import '../viewmodel/tour_menu/tour_menu_viewmodel.dart' as _i20;
import '../widget_game/data/sprite_manager.dart' as _i19;
import 'injectable.dart' as _i36; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.CacheControlling>(_i4.CacheController());
  gh.singleton<_i5.ConnectivityHelper>(registerModule.connectivityHelper());
  gh.factory<_i6.CreditsViewModel>(() => _i6.CreditsViewModel());
  await gh.singletonAsync<_i7.DatabaseConnection>(
      () => registerModule.provideDatabaseConnection(),
      preResolve: true);
  gh.factory<_i8.DebugPlatformSelectorViewModel>(
      () => _i8.DebugPlatformSelectorViewModel());
  gh.lazySingleton<_i9.FlutterSecureStorage>(() => registerModule.storage());
  gh.factory<_i10.LicenseViewModel>(() => _i10.LicenseViewModel());
  gh.factory<_i11.MainMenuViewModel>(() => _i11.MainMenuViewModel());
  gh.factory<_i12.MenuBackgroundViewModel>(
      () => _i12.MenuBackgroundViewModel());
  gh.singleton<_i13.NetworkErrorInterceptor>(
      _i13.NetworkErrorInterceptor(get<_i5.ConnectivityHelper>()));
  gh.singleton<_i14.NetworkLogInterceptor>(_i14.NetworkLogInterceptor());
  gh.factory<_i15.ResultsViewModel>(() => _i15.ResultsViewModel());
  gh.lazySingleton<_i16.SecureStorage>(
      () => _i16.SecureStorage(get<_i9.FlutterSecureStorage>()));
  await gh.singletonAsync<_i17.SharedPreferences>(() => registerModule.prefs(),
      preResolve: true);
  gh.factory<_i18.SingleRaceMenuViewModel>(
      () => _i18.SingleRaceMenuViewModel());
  gh.singleton<_i19.SpriteManager>(_i19.SpriteManager());
  gh.factory<_i20.TourMenuViewModel>(() => _i20.TourMenuViewModel());
  gh.lazySingleton<_i21.CyclingEscapeDatabase>(() => registerModule
      .provideCyclingEscapeDatabase(get<_i7.DatabaseConnection>()));
  gh.lazySingleton<_i5.SharedPreferenceStorage>(
      () => registerModule.sharedPreferences(get<_i17.SharedPreferences>()));
  gh.lazySingleton<_i5.SimpleKeyValueStorage>(() =>
      registerModule.keyValueStorage(
          get<_i5.SharedPreferenceStorage>(), get<_i16.SecureStorage>()));
  gh.lazySingleton<_i22.AuthStorage>(
      () => _i22.AuthStorage(get<_i5.SimpleKeyValueStorage>()));
  gh.lazySingleton<_i23.DebugRepository>(
      () => _i23.DebugRepository(get<_i5.SharedPreferenceStorage>()));
  gh.factory<_i24.DebugViewModel>(
      () => _i24.DebugViewModel(get<_i23.DebugRepository>()));
  gh.lazySingleton<_i25.LocalStorage>(() => _i25.LocalStorage(
      get<_i22.AuthStorage>(), get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i26.LocaleRepository>(
      () => _i26.LocaleRepository(get<_i5.SharedPreferenceStorage>()));
  gh.singleton<_i27.NetworkAuthInterceptor>(
      _i27.NetworkAuthInterceptor(get<_i22.AuthStorage>()));
  gh.lazySingleton<_i28.RefreshRepository>(
      () => _i28.RefreshRepository(get<_i22.AuthStorage>()));
  gh.factory<_i29.SettingsViewModel>(
      () => _i29.SettingsViewModel(get<_i25.LocalStorage>()));
  gh.factory<_i30.SplashViewModel>(
      () => _i30.SplashViewModel(get<_i25.LocalStorage>()));
  gh.lazySingleton<_i31.TutorialRepository>(
      () => _i31.TutorialRepository(get<_i25.LocalStorage>()));
  gh.factory<_i32.GameViewModel>(() => _i32.GameViewModel(
      get<_i31.TutorialRepository>(),
      get<_i25.LocalStorage>(),
      get<_i19.SpriteManager>()));
  gh.singleton<_i33.GlobalViewModel>(_i33.GlobalViewModel(
      get<_i26.LocaleRepository>(),
      get<_i23.DebugRepository>(),
      get<_i25.LocalStorage>()));
  gh.singleton<_i34.NetworkRefreshInterceptor>(
      _i34.NetworkRefreshInterceptor(get<_i28.RefreshRepository>()));
  gh.lazySingleton<_i5.CombiningSmartInterceptor>(() =>
      registerModule.provideCombiningSmartInterceptor(
          get<_i14.NetworkLogInterceptor>(),
          get<_i27.NetworkAuthInterceptor>(),
          get<_i13.NetworkErrorInterceptor>(),
          get<_i34.NetworkRefreshInterceptor>()));
  gh.lazySingleton<_i35.Dio>(
      () => registerModule.provideDio(get<_i5.CombiningSmartInterceptor>()));
  return get;
}

class _$RegisterModule extends _i36.RegisterModule {}
