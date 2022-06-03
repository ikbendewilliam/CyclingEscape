// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i45;
import 'package:drift/drift.dart' as _i11;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i13;
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_architecture/icapps_architecture.dart' as _i9;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i19;

import '../database/cycling_escape_database.dart' as _i23;
import '../database/tour_results/tour_results_dao_storage.dart' as _i24;
import '../repository/debug/debug_repository.dart' as _i26;
import '../repository/locale/locale_repository.dart' as _i29;
import '../repository/name/name_repository.dart' as _i30;
import '../repository/refresh/refresh_repository.dart' as _i32;
import '../repository/secure_storage/auth/auth_storage.dart' as _i25;
import '../repository/secure_storage/secure_storage.dart' as _i18;
import '../repository/shared_prefs/local/local_storage.dart' as _i28;
import '../repository/tour/tour_repository.dart' as _i35;
import '../repository/tutorial/tutorial_repository.dart' as _i37;
import '../util/cache/cache_controller.dart' as _i4;
import '../util/cache/cache_controlling.dart' as _i3;
import '../util/interceptor/network_auth_interceptor.dart' as _i31;
import '../util/interceptor/network_error_interceptor.dart' as _i16;
import '../util/interceptor/network_log_interceptor.dart' as _i17;
import '../util/interceptor/network_refresh_interceptor.dart' as _i43;
import '../viewmodel/active_tour/active_tour_viewmodel.dart' as _i38;
import '../viewmodel/career_calendar/career_calendar_viewmodel.dart' as _i5;
import '../viewmodel/career_overview/career_overview_viewmodel.dart' as _i6;
import '../viewmodel/career_select_riders/career_select_riders_viewmodel.dart'
    as _i7;
import '../viewmodel/career_standings/career_standings_viewmodel.dart' as _i8;
import '../viewmodel/change_cyclist_names/change_cyclist_names_viewmodel.dart'
    as _i39;
import '../viewmodel/credits/credits_viewmodel.dart' as _i10;
import '../viewmodel/debug/debug_platform_selector_viewmodel.dart' as _i12;
import '../viewmodel/debug/debug_viewmodel.dart' as _i27;
import '../viewmodel/game/game_viewmodel.dart' as _i40;
import '../viewmodel/global/global_viewmodel.dart' as _i41;
import '../viewmodel/license/license_viewmodel.dart' as _i14;
import '../viewmodel/main_menu/main_menu_viewmodel.dart' as _i42;
import '../viewmodel/menu_background/menu_background_viewmodel.dart' as _i15;
import '../viewmodel/results/results_viewmodel.dart' as _i44;
import '../viewmodel/settings/settings_viewmodel.dart' as _i33;
import '../viewmodel/single_race_menu/single_race_menu_viewmodel.dart' as _i20;
import '../viewmodel/splash/splash_viewmodel.dart' as _i34;
import '../viewmodel/tour_in_progress/tour_in_progress_viewmodel.dart' as _i22;
import '../viewmodel/tour_select/tour_select_viewmodel.dart' as _i36;
import '../widget_game/data/sprite_manager.dart' as _i21;
import 'injectable.dart' as _i46; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.CacheControlling>(_i4.CacheController());
  gh.factory<_i5.CareerCalendarViewModel>(() => _i5.CareerCalendarViewModel());
  gh.factory<_i6.CareerOverviewViewModel>(() => _i6.CareerOverviewViewModel());
  gh.factory<_i7.CareerSelectRidersViewModel>(
      () => _i7.CareerSelectRidersViewModel());
  gh.factory<_i8.CareerStandingsViewModel>(
      () => _i8.CareerStandingsViewModel());
  gh.singleton<_i9.ConnectivityHelper>(registerModule.connectivityHelper());
  gh.factory<_i10.CreditsViewModel>(() => _i10.CreditsViewModel());
  await gh.singletonAsync<_i11.DatabaseConnection>(
      () => registerModule.provideDatabaseConnection(),
      preResolve: true);
  gh.factory<_i12.DebugPlatformSelectorViewModel>(
      () => _i12.DebugPlatformSelectorViewModel());
  gh.lazySingleton<_i13.FlutterSecureStorage>(() => registerModule.storage());
  gh.factory<_i14.LicenseViewModel>(() => _i14.LicenseViewModel());
  gh.factory<_i15.MenuBackgroundViewModel>(
      () => _i15.MenuBackgroundViewModel());
  gh.singleton<_i16.NetworkErrorInterceptor>(
      _i16.NetworkErrorInterceptor(get<_i9.ConnectivityHelper>()));
  gh.singleton<_i17.NetworkLogInterceptor>(_i17.NetworkLogInterceptor());
  gh.lazySingleton<_i18.SecureStorage>(
      () => _i18.SecureStorage(get<_i13.FlutterSecureStorage>()));
  await gh.singletonAsync<_i19.SharedPreferences>(() => registerModule.prefs(),
      preResolve: true);
  gh.factory<_i20.SingleRaceMenuViewModel>(
      () => _i20.SingleRaceMenuViewModel());
  gh.singleton<_i21.SpriteManager>(_i21.SpriteManager());
  gh.factory<_i22.TourInProgressViewModel>(
      () => _i22.TourInProgressViewModel());
  gh.lazySingleton<_i23.CyclingEscapeDatabase>(() => registerModule
      .provideCyclingEscapeDatabase(get<_i11.DatabaseConnection>()));
  gh.lazySingleton<_i9.SharedPreferenceStorage>(
      () => registerModule.sharedPreferences(get<_i19.SharedPreferences>()));
  gh.lazySingleton<_i9.SimpleKeyValueStorage>(() =>
      registerModule.keyValueStorage(
          get<_i9.SharedPreferenceStorage>(), get<_i18.SecureStorage>()));
  gh.lazySingleton<_i24.TourResultsDaoStorage>(
      () => _i24.TourResultsDaoStorage(get<_i23.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i25.AuthStorage>(
      () => _i25.AuthStorage(get<_i9.SimpleKeyValueStorage>()));
  gh.lazySingleton<_i26.DebugRepository>(
      () => _i26.DebugRepository(get<_i9.SharedPreferenceStorage>()));
  gh.factory<_i27.DebugViewModel>(
      () => _i27.DebugViewModel(get<_i26.DebugRepository>()));
  gh.lazySingleton<_i28.LocalStorage>(() => _i28.LocalStorage(
      get<_i25.AuthStorage>(), get<_i9.SharedPreferenceStorage>()));
  gh.lazySingleton<_i29.LocaleRepository>(
      () => _i29.LocaleRepository(get<_i9.SharedPreferenceStorage>()));
  gh.lazySingleton<_i30.NameRepository>(
      () => _i30.NameRepository(get<_i28.LocalStorage>()));
  gh.singleton<_i31.NetworkAuthInterceptor>(
      _i31.NetworkAuthInterceptor(get<_i25.AuthStorage>()));
  gh.lazySingleton<_i32.RefreshRepository>(
      () => _i32.RefreshRepository(get<_i25.AuthStorage>()));
  gh.factory<_i33.SettingsViewModel>(
      () => _i33.SettingsViewModel(get<_i28.LocalStorage>()));
  gh.factory<_i34.SplashViewModel>(
      () => _i34.SplashViewModel(get<_i28.LocalStorage>()));
  gh.lazySingleton<_i35.TourRepository>(() => _i35.TourRepository(
      get<_i24.TourResultsDaoStorage>(), get<_i28.LocalStorage>()));
  gh.factory<_i36.TourSelectViewModel>(
      () => _i36.TourSelectViewModel(get<_i35.TourRepository>()));
  gh.lazySingleton<_i37.TutorialRepository>(
      () => _i37.TutorialRepository(get<_i28.LocalStorage>()));
  gh.factory<_i38.ActiveTourViewModel>(() => _i38.ActiveTourViewModel(
      get<_i35.TourRepository>(), get<_i30.NameRepository>()));
  gh.factory<_i39.ChangeCyclistNamesViewModel>(
      () => _i39.ChangeCyclistNamesViewModel(get<_i30.NameRepository>()));
  gh.factory<_i40.GameViewModel>(() => _i40.GameViewModel(
      get<_i37.TutorialRepository>(),
      get<_i28.LocalStorage>(),
      get<_i21.SpriteManager>()));
  gh.singleton<_i41.GlobalViewModel>(_i41.GlobalViewModel(
      get<_i29.LocaleRepository>(),
      get<_i26.DebugRepository>(),
      get<_i28.LocalStorage>()));
  gh.factory<_i42.MainMenuViewModel>(
      () => _i42.MainMenuViewModel(get<_i35.TourRepository>()));
  gh.singleton<_i43.NetworkRefreshInterceptor>(
      _i43.NetworkRefreshInterceptor(get<_i32.RefreshRepository>()));
  gh.factory<_i44.ResultsViewModel>(() => _i44.ResultsViewModel(
      get<_i30.NameRepository>(), get<_i35.TourRepository>()));
  gh.lazySingleton<_i9.CombiningSmartInterceptor>(() =>
      registerModule.provideCombiningSmartInterceptor(
          get<_i17.NetworkLogInterceptor>(),
          get<_i31.NetworkAuthInterceptor>(),
          get<_i16.NetworkErrorInterceptor>(),
          get<_i43.NetworkRefreshInterceptor>()));
  gh.lazySingleton<_i45.Dio>(
      () => registerModule.provideDio(get<_i9.CombiningSmartInterceptor>()));
  return get;
}

class _$RegisterModule extends _i46.RegisterModule {}
