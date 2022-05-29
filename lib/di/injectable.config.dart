// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i41;
import 'package:drift/drift.dart' as _i7;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_architecture/icapps_architecture.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i15;

import '../database/cycling_escape_database.dart' as _i19;
import '../database/tour_results/tour_results_dao_storage.dart' as _i20;
import '../repository/debug/debug_repository.dart' as _i22;
import '../repository/locale/locale_repository.dart' as _i25;
import '../repository/name/name_repository.dart' as _i26;
import '../repository/refresh/refresh_repository.dart' as _i28;
import '../repository/secure_storage/auth/auth_storage.dart' as _i21;
import '../repository/secure_storage/secure_storage.dart' as _i14;
import '../repository/shared_prefs/local/local_storage.dart' as _i24;
import '../repository/tour/tour_repository.dart' as _i31;
import '../repository/tutorial/tutorial_repository.dart' as _i33;
import '../util/cache/cache_controller.dart' as _i4;
import '../util/cache/cache_controlling.dart' as _i3;
import '../util/interceptor/network_auth_interceptor.dart' as _i27;
import '../util/interceptor/network_error_interceptor.dart' as _i12;
import '../util/interceptor/network_log_interceptor.dart' as _i13;
import '../util/interceptor/network_refresh_interceptor.dart' as _i39;
import '../viewmodel/active_tour/active_tour_viewmodel.dart' as _i34;
import '../viewmodel/change_cyclist_names/change_cyclist_names_viewmodel.dart'
    as _i35;
import '../viewmodel/credits/credits_viewmodel.dart' as _i6;
import '../viewmodel/debug/debug_platform_selector_viewmodel.dart' as _i8;
import '../viewmodel/debug/debug_viewmodel.dart' as _i23;
import '../viewmodel/game/game_viewmodel.dart' as _i36;
import '../viewmodel/global/global_viewmodel.dart' as _i37;
import '../viewmodel/license/license_viewmodel.dart' as _i10;
import '../viewmodel/main_menu/main_menu_viewmodel.dart' as _i38;
import '../viewmodel/menu_background/menu_background_viewmodel.dart' as _i11;
import '../viewmodel/results/results_viewmodel.dart' as _i40;
import '../viewmodel/settings/settings_viewmodel.dart' as _i29;
import '../viewmodel/single_race_menu/single_race_menu_viewmodel.dart' as _i16;
import '../viewmodel/splash/splash_viewmodel.dart' as _i30;
import '../viewmodel/tour_in_progress/tour_in_progress_viewmodel.dart' as _i18;
import '../viewmodel/tour_select/tour_select_viewmodel.dart' as _i32;
import '../widget_game/data/sprite_manager.dart' as _i17;
import 'injectable.dart' as _i42; // ignore_for_file: unnecessary_lambdas

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
  gh.factory<_i11.MenuBackgroundViewModel>(
      () => _i11.MenuBackgroundViewModel());
  gh.singleton<_i12.NetworkErrorInterceptor>(
      _i12.NetworkErrorInterceptor(get<_i5.ConnectivityHelper>()));
  gh.singleton<_i13.NetworkLogInterceptor>(_i13.NetworkLogInterceptor());
  gh.lazySingleton<_i14.SecureStorage>(
      () => _i14.SecureStorage(get<_i9.FlutterSecureStorage>()));
  await gh.singletonAsync<_i15.SharedPreferences>(() => registerModule.prefs(),
      preResolve: true);
  gh.factory<_i16.SingleRaceMenuViewModel>(
      () => _i16.SingleRaceMenuViewModel());
  gh.singleton<_i17.SpriteManager>(_i17.SpriteManager());
  gh.factory<_i18.TourInProgressViewModel>(
      () => _i18.TourInProgressViewModel());
  gh.lazySingleton<_i19.CyclingEscapeDatabase>(() => registerModule
      .provideCyclingEscapeDatabase(get<_i7.DatabaseConnection>()));
  gh.lazySingleton<_i5.SharedPreferenceStorage>(
      () => registerModule.sharedPreferences(get<_i15.SharedPreferences>()));
  gh.lazySingleton<_i5.SimpleKeyValueStorage>(() =>
      registerModule.keyValueStorage(
          get<_i5.SharedPreferenceStorage>(), get<_i14.SecureStorage>()));
  gh.lazySingleton<_i20.TourResultsDaoStorage>(
      () => _i20.TourResultsDaoStorage(get<_i19.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i21.AuthStorage>(
      () => _i21.AuthStorage(get<_i5.SimpleKeyValueStorage>()));
  gh.lazySingleton<_i22.DebugRepository>(
      () => _i22.DebugRepository(get<_i5.SharedPreferenceStorage>()));
  gh.factory<_i23.DebugViewModel>(
      () => _i23.DebugViewModel(get<_i22.DebugRepository>()));
  gh.lazySingleton<_i24.LocalStorage>(() => _i24.LocalStorage(
      get<_i21.AuthStorage>(), get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i25.LocaleRepository>(
      () => _i25.LocaleRepository(get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i26.NameRepository>(
      () => _i26.NameRepository(get<_i24.LocalStorage>()));
  gh.singleton<_i27.NetworkAuthInterceptor>(
      _i27.NetworkAuthInterceptor(get<_i21.AuthStorage>()));
  gh.lazySingleton<_i28.RefreshRepository>(
      () => _i28.RefreshRepository(get<_i21.AuthStorage>()));
  gh.factory<_i29.SettingsViewModel>(
      () => _i29.SettingsViewModel(get<_i24.LocalStorage>()));
  gh.factory<_i30.SplashViewModel>(
      () => _i30.SplashViewModel(get<_i24.LocalStorage>()));
  gh.lazySingleton<_i31.TourRepository>(() => _i31.TourRepository(
      get<_i20.TourResultsDaoStorage>(), get<_i24.LocalStorage>()));
  gh.factory<_i32.TourSelectViewModel>(
      () => _i32.TourSelectViewModel(get<_i31.TourRepository>()));
  gh.lazySingleton<_i33.TutorialRepository>(
      () => _i33.TutorialRepository(get<_i24.LocalStorage>()));
  gh.factory<_i34.ActiveTourViewModel>(() => _i34.ActiveTourViewModel(
      get<_i31.TourRepository>(), get<_i26.NameRepository>()));
  gh.factory<_i35.ChangeCyclistNamesViewModel>(
      () => _i35.ChangeCyclistNamesViewModel(get<_i26.NameRepository>()));
  gh.factory<_i36.GameViewModel>(() => _i36.GameViewModel(
      get<_i33.TutorialRepository>(),
      get<_i24.LocalStorage>(),
      get<_i17.SpriteManager>()));
  gh.singleton<_i37.GlobalViewModel>(_i37.GlobalViewModel(
      get<_i25.LocaleRepository>(),
      get<_i22.DebugRepository>(),
      get<_i24.LocalStorage>()));
  gh.factory<_i38.MainMenuViewModel>(
      () => _i38.MainMenuViewModel(get<_i31.TourRepository>()));
  gh.singleton<_i39.NetworkRefreshInterceptor>(
      _i39.NetworkRefreshInterceptor(get<_i28.RefreshRepository>()));
  gh.factory<_i40.ResultsViewModel>(() => _i40.ResultsViewModel(
      get<_i26.NameRepository>(), get<_i31.TourRepository>()));
  gh.lazySingleton<_i5.CombiningSmartInterceptor>(() =>
      registerModule.provideCombiningSmartInterceptor(
          get<_i13.NetworkLogInterceptor>(),
          get<_i27.NetworkAuthInterceptor>(),
          get<_i12.NetworkErrorInterceptor>(),
          get<_i39.NetworkRefreshInterceptor>()));
  gh.lazySingleton<_i41.Dio>(
      () => registerModule.provideDio(get<_i5.CombiningSmartInterceptor>()));
  return get;
}

class _$RegisterModule extends _i42.RegisterModule {}
