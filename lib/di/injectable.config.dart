// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i49;
import 'package:drift/drift.dart' as _i8;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_architecture/icapps_architecture.dart' as _i6;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i16;

import '../database/career/calendar_results_dao_storage.dart' as _i24;
import '../database/career/career_calendar_dao_storage.dart' as _i23;
import '../database/cycling_escape_database.dart' as _i20;
import '../database/tour_results/tour_results_dao_storage.dart' as _i21;
import '../repository/calendar/calendar_repository.dart' as _i38;
import '../repository/career/career_repository.dart' as _i40;
import '../repository/debug/debug_repository.dart' as _i25;
import '../repository/locale/locale_repository.dart' as _i28;
import '../repository/name/name_repository.dart' as _i29;
import '../repository/refresh/refresh_repository.dart' as _i31;
import '../repository/secure_storage/auth/auth_storage.dart' as _i22;
import '../repository/secure_storage/secure_storage.dart' as _i15;
import '../repository/shared_prefs/local/local_storage.dart' as _i27;
import '../repository/tour/tour_repository.dart' as _i34;
import '../repository/tutorial/tutorial_repository.dart' as _i36;
import '../util/cache/cache_controller.dart' as _i4;
import '../util/cache/cache_controlling.dart' as _i3;
import '../util/interceptor/network_auth_interceptor.dart' as _i30;
import '../util/interceptor/network_error_interceptor.dart' as _i13;
import '../util/interceptor/network_log_interceptor.dart' as _i14;
import '../util/interceptor/network_refresh_interceptor.dart' as _i47;
import '../viewmodel/active_tour/active_tour_viewmodel.dart' as _i37;
import '../viewmodel/career_calendar/career_calendar_viewmodel.dart' as _i39;
import '../viewmodel/career_overview/career_overview_viewmodel.dart' as _i5;
import '../viewmodel/career_select_riders/career_select_riders_viewmodel.dart'
    as _i41;
import '../viewmodel/career_standings/career_standings_viewmodel.dart' as _i42;
import '../viewmodel/change_cyclist_names/change_cyclist_names_viewmodel.dart'
    as _i43;
import '../viewmodel/credits/credits_viewmodel.dart' as _i7;
import '../viewmodel/debug/debug_platform_selector_viewmodel.dart' as _i9;
import '../viewmodel/debug/debug_viewmodel.dart' as _i26;
import '../viewmodel/game/game_viewmodel.dart' as _i44;
import '../viewmodel/global/global_viewmodel.dart' as _i45;
import '../viewmodel/license/license_viewmodel.dart' as _i11;
import '../viewmodel/main_menu/main_menu_viewmodel.dart' as _i46;
import '../viewmodel/menu_background/menu_background_viewmodel.dart' as _i12;
import '../viewmodel/results/results_viewmodel.dart' as _i48;
import '../viewmodel/settings/settings_viewmodel.dart' as _i32;
import '../viewmodel/single_race_menu/single_race_menu_viewmodel.dart' as _i17;
import '../viewmodel/splash/splash_viewmodel.dart' as _i33;
import '../viewmodel/tour_in_progress/tour_in_progress_viewmodel.dart' as _i19;
import '../viewmodel/tour_select/tour_select_viewmodel.dart' as _i35;
import '../widget_game/data/sprite_manager.dart' as _i18;
import 'injectable.dart' as _i50; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.CacheControlling>(_i4.CacheController());
  gh.factory<_i5.CareerOverviewViewModel>(() => _i5.CareerOverviewViewModel());
  gh.singleton<_i6.ConnectivityHelper>(registerModule.connectivityHelper());
  gh.factory<_i7.CreditsViewModel>(() => _i7.CreditsViewModel());
  await gh.singletonAsync<_i8.DatabaseConnection>(
      () => registerModule.provideDatabaseConnection(),
      preResolve: true);
  gh.factory<_i9.DebugPlatformSelectorViewModel>(
      () => _i9.DebugPlatformSelectorViewModel());
  gh.lazySingleton<_i10.FlutterSecureStorage>(() => registerModule.storage());
  gh.factory<_i11.LicenseViewModel>(() => _i11.LicenseViewModel());
  gh.factory<_i12.MenuBackgroundViewModel>(
      () => _i12.MenuBackgroundViewModel());
  gh.singleton<_i13.NetworkErrorInterceptor>(
      _i13.NetworkErrorInterceptor(get<_i6.ConnectivityHelper>()));
  gh.singleton<_i14.NetworkLogInterceptor>(_i14.NetworkLogInterceptor());
  gh.lazySingleton<_i15.SecureStorage>(
      () => _i15.SecureStorage(get<_i10.FlutterSecureStorage>()));
  await gh.singletonAsync<_i16.SharedPreferences>(() => registerModule.prefs(),
      preResolve: true);
  gh.factory<_i17.SingleRaceMenuViewModel>(
      () => _i17.SingleRaceMenuViewModel());
  gh.singleton<_i18.SpriteManager>(_i18.SpriteManager());
  gh.factory<_i19.TourInProgressViewModel>(
      () => _i19.TourInProgressViewModel());
  gh.lazySingleton<_i20.CyclingEscapeDatabase>(() => registerModule
      .provideCyclingEscapeDatabase(get<_i8.DatabaseConnection>()));
  gh.lazySingleton<_i6.SharedPreferenceStorage>(
      () => registerModule.sharedPreferences(get<_i16.SharedPreferences>()));
  gh.lazySingleton<_i6.SimpleKeyValueStorage>(() =>
      registerModule.keyValueStorage(
          get<_i6.SharedPreferenceStorage>(), get<_i15.SecureStorage>()));
  gh.lazySingleton<_i21.TourResultsDaoStorage>(
      () => _i21.TourResultsDaoStorage(get<_i20.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i22.AuthStorage>(
      () => _i22.AuthStorage(get<_i6.SimpleKeyValueStorage>()));
  gh.lazySingleton<_i23.CareerCalendarDaoStorage>(
      () => _i23.CareerCalendarDaoStorage(get<_i20.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i24.CareerResultsDaoStorage>(
      () => _i24.CareerResultsDaoStorage(get<_i20.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i25.DebugRepository>(
      () => _i25.DebugRepository(get<_i6.SharedPreferenceStorage>()));
  gh.factory<_i26.DebugViewModel>(
      () => _i26.DebugViewModel(get<_i25.DebugRepository>()));
  gh.lazySingleton<_i27.LocalStorage>(() => _i27.LocalStorage(
      get<_i22.AuthStorage>(), get<_i6.SharedPreferenceStorage>()));
  gh.lazySingleton<_i28.LocaleRepository>(
      () => _i28.LocaleRepository(get<_i6.SharedPreferenceStorage>()));
  gh.lazySingleton<_i29.NameRepository>(
      () => _i29.NameRepository(get<_i27.LocalStorage>()));
  gh.singleton<_i30.NetworkAuthInterceptor>(
      _i30.NetworkAuthInterceptor(get<_i22.AuthStorage>()));
  gh.lazySingleton<_i31.RefreshRepository>(
      () => _i31.RefreshRepository(get<_i22.AuthStorage>()));
  gh.factory<_i32.SettingsViewModel>(
      () => _i32.SettingsViewModel(get<_i27.LocalStorage>()));
  gh.factory<_i33.SplashViewModel>(
      () => _i33.SplashViewModel(get<_i27.LocalStorage>()));
  gh.lazySingleton<_i34.TourRepository>(() => _i34.TourRepository(
      get<_i21.TourResultsDaoStorage>(), get<_i27.LocalStorage>()));
  gh.factory<_i35.TourSelectViewModel>(
      () => _i35.TourSelectViewModel(get<_i34.TourRepository>()));
  gh.lazySingleton<_i36.TutorialRepository>(
      () => _i36.TutorialRepository(get<_i27.LocalStorage>()));
  gh.factory<_i37.ActiveTourViewModel>(() => _i37.ActiveTourViewModel(
      get<_i34.TourRepository>(), get<_i29.NameRepository>()));
  gh.lazySingleton<_i38.CalendarRepository>(() => _i38.CalendarRepository(
      get<_i27.LocalStorage>(), get<_i23.CareerCalendarDaoStorage>()));
  gh.factory<_i39.CareerCalendarViewModel>(() => _i39.CareerCalendarViewModel(
      get<_i38.CalendarRepository>(), get<_i29.NameRepository>()));
  gh.lazySingleton<_i40.CareerRepository>(() => _i40.CareerRepository(
      get<_i24.CareerResultsDaoStorage>(), get<_i38.CalendarRepository>()));
  gh.factory<_i41.CareerSelectRidersViewModel>(() =>
      _i41.CareerSelectRidersViewModel(
          get<_i38.CalendarRepository>(), get<_i34.TourRepository>()));
  gh.factory<_i42.CareerStandingsViewModel>(() => _i42.CareerStandingsViewModel(
      get<_i40.CareerRepository>(),
      get<_i38.CalendarRepository>(),
      get<_i29.NameRepository>()));
  gh.factory<_i43.ChangeCyclistNamesViewModel>(
      () => _i43.ChangeCyclistNamesViewModel(get<_i29.NameRepository>()));
  gh.factory<_i44.GameViewModel>(() => _i44.GameViewModel(
      get<_i36.TutorialRepository>(),
      get<_i27.LocalStorage>(),
      get<_i18.SpriteManager>()));
  gh.singleton<_i45.GlobalViewModel>(_i45.GlobalViewModel(
      get<_i28.LocaleRepository>(),
      get<_i25.DebugRepository>(),
      get<_i27.LocalStorage>()));
  gh.factory<_i46.MainMenuViewModel>(
      () => _i46.MainMenuViewModel(get<_i34.TourRepository>()));
  gh.singleton<_i47.NetworkRefreshInterceptor>(
      _i47.NetworkRefreshInterceptor(get<_i31.RefreshRepository>()));
  gh.factory<_i48.ResultsViewModel>(() => _i48.ResultsViewModel(
      get<_i29.NameRepository>(),
      get<_i34.TourRepository>(),
      get<_i40.CareerRepository>()));
  gh.lazySingleton<_i6.CombiningSmartInterceptor>(() =>
      registerModule.provideCombiningSmartInterceptor(
          get<_i14.NetworkLogInterceptor>(),
          get<_i30.NetworkAuthInterceptor>(),
          get<_i13.NetworkErrorInterceptor>(),
          get<_i47.NetworkRefreshInterceptor>()));
  gh.lazySingleton<_i49.Dio>(
      () => registerModule.provideDio(get<_i6.CombiningSmartInterceptor>()));
  return get;
}

class _$RegisterModule extends _i50.RegisterModule {}
