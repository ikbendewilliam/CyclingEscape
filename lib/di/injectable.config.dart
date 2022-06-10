// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i53;
import 'package:drift/drift.dart' as _i7;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_architecture/icapps_architecture.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i16;

import '../database/career/calendar_results_dao_storage.dart' as _i25;
import '../database/career/career_calendar_dao_storage.dart' as _i24;
import '../database/cycling_escape_database.dart' as _i21;
import '../database/tour_results/tour_results_dao_storage.dart' as _i22;
import '../repository/calendar/calendar_repository.dart' as _i39;
import '../repository/career/career_repository.dart' as _i41;
import '../repository/debug/debug_repository.dart' as _i26;
import '../repository/locale/locale_repository.dart' as _i29;
import '../repository/name/name_repository.dart' as _i30;
import '../repository/refresh/refresh_repository.dart' as _i32;
import '../repository/secure_storage/auth/auth_storage.dart' as _i23;
import '../repository/secure_storage/secure_storage.dart' as _i15;
import '../repository/shared_prefs/local/local_storage.dart' as _i28;
import '../repository/tour/tour_repository.dart' as _i35;
import '../repository/tutorial/tutorial_repository.dart' as _i37;
import '../util/cache/cache_controller.dart' as _i4;
import '../util/cache/cache_controlling.dart' as _i3;
import '../util/interceptor/network_auth_interceptor.dart' as _i31;
import '../util/interceptor/network_error_interceptor.dart' as _i13;
import '../util/interceptor/network_log_interceptor.dart' as _i14;
import '../util/interceptor/network_refresh_interceptor.dart' as _i49;
import '../viewmodel/active_tour/active_tour_viewmodel.dart' as _i38;
import '../viewmodel/career_calendar/career_calendar_viewmodel.dart' as _i40;
import '../viewmodel/career_finish/career_finish_viewmodel.dart' as _i51;
import '../viewmodel/career_overview/career_overview_viewmodel.dart' as _i52;
import '../viewmodel/career_reset/career_reset_viewmodel.dart' as _i42;
import '../viewmodel/career_select_riders/career_select_riders_viewmodel.dart'
    as _i43;
import '../viewmodel/career_standings/career_standings_viewmodel.dart' as _i44;
import '../viewmodel/change_cyclist_names/change_cyclist_names_viewmodel.dart'
    as _i45;
import '../viewmodel/credits/credits_viewmodel.dart' as _i6;
import '../viewmodel/debug/debug_platform_selector_viewmodel.dart' as _i8;
import '../viewmodel/debug/debug_viewmodel.dart' as _i27;
import '../viewmodel/game/game_viewmodel.dart' as _i46;
import '../viewmodel/global/global_viewmodel.dart' as _i47;
import '../viewmodel/information/information_viewmodel.dart' as _i10;
import '../viewmodel/license/license_viewmodel.dart' as _i11;
import '../viewmodel/main_menu/main_menu_viewmodel.dart' as _i48;
import '../viewmodel/menu_background/menu_background_viewmodel.dart' as _i12;
import '../viewmodel/results/results_viewmodel.dart' as _i50;
import '../viewmodel/settings/settings_viewmodel.dart' as _i33;
import '../viewmodel/single_race_menu/single_race_menu_viewmodel.dart' as _i17;
import '../viewmodel/splash/splash_viewmodel.dart' as _i34;
import '../viewmodel/tour_in_progress/tour_in_progress_viewmodel.dart' as _i19;
import '../viewmodel/tour_select/tour_select_viewmodel.dart' as _i36;
import '../viewmodel/v2dialog/v2dialog_viewmodel.dart' as _i20;
import '../widget_game/data/sprite_manager.dart' as _i18;
import 'injectable.dart' as _i54; // ignore_for_file: unnecessary_lambdas

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
  gh.factory<_i10.InformationViewModel>(() => _i10.InformationViewModel());
  gh.factory<_i11.LicenseViewModel>(() => _i11.LicenseViewModel());
  gh.factory<_i12.MenuBackgroundViewModel>(
      () => _i12.MenuBackgroundViewModel());
  gh.singleton<_i13.NetworkErrorInterceptor>(
      _i13.NetworkErrorInterceptor(get<_i5.ConnectivityHelper>()));
  gh.singleton<_i14.NetworkLogInterceptor>(_i14.NetworkLogInterceptor());
  gh.lazySingleton<_i15.SecureStorage>(
      () => _i15.SecureStorage(get<_i9.FlutterSecureStorage>()));
  await gh.singletonAsync<_i16.SharedPreferences>(() => registerModule.prefs(),
      preResolve: true);
  gh.factory<_i17.SingleRaceMenuViewModel>(
      () => _i17.SingleRaceMenuViewModel());
  gh.singleton<_i18.SpriteManager>(_i18.SpriteManager());
  gh.factory<_i19.TourInProgressViewModel>(
      () => _i19.TourInProgressViewModel());
  gh.factory<_i20.V2dialogViewModel>(() => _i20.V2dialogViewModel());
  gh.lazySingleton<_i21.CyclingEscapeDatabase>(() => registerModule
      .provideCyclingEscapeDatabase(get<_i7.DatabaseConnection>()));
  gh.lazySingleton<_i5.SharedPreferenceStorage>(
      () => registerModule.sharedPreferences(get<_i16.SharedPreferences>()));
  gh.lazySingleton<_i5.SimpleKeyValueStorage>(() =>
      registerModule.keyValueStorage(
          get<_i5.SharedPreferenceStorage>(), get<_i15.SecureStorage>()));
  gh.lazySingleton<_i22.TourResultsDaoStorage>(
      () => _i22.TourResultsDaoStorage(get<_i21.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i23.AuthStorage>(
      () => _i23.AuthStorage(get<_i5.SimpleKeyValueStorage>()));
  gh.lazySingleton<_i24.CareerCalendarDaoStorage>(
      () => _i24.CareerCalendarDaoStorage(get<_i21.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i25.CareerResultsDaoStorage>(
      () => _i25.CareerResultsDaoStorage(get<_i21.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i26.DebugRepository>(
      () => _i26.DebugRepository(get<_i5.SharedPreferenceStorage>()));
  gh.factory<_i27.DebugViewModel>(
      () => _i27.DebugViewModel(get<_i26.DebugRepository>()));
  gh.lazySingleton<_i28.LocalStorage>(() => _i28.LocalStorage(
      get<_i23.AuthStorage>(), get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i29.LocaleRepository>(
      () => _i29.LocaleRepository(get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i30.NameRepository>(
      () => _i30.NameRepository(get<_i28.LocalStorage>()));
  gh.singleton<_i31.NetworkAuthInterceptor>(
      _i31.NetworkAuthInterceptor(get<_i23.AuthStorage>()));
  gh.lazySingleton<_i32.RefreshRepository>(
      () => _i32.RefreshRepository(get<_i23.AuthStorage>()));
  gh.factory<_i33.SettingsViewModel>(
      () => _i33.SettingsViewModel(get<_i28.LocalStorage>()));
  gh.factory<_i34.SplashViewModel>(
      () => _i34.SplashViewModel(get<_i28.LocalStorage>()));
  gh.lazySingleton<_i35.TourRepository>(() => _i35.TourRepository(
      get<_i22.TourResultsDaoStorage>(), get<_i28.LocalStorage>()));
  gh.factory<_i36.TourSelectViewModel>(
      () => _i36.TourSelectViewModel(get<_i35.TourRepository>()));
  gh.lazySingleton<_i37.TutorialRepository>(
      () => _i37.TutorialRepository(get<_i28.LocalStorage>()));
  gh.factory<_i38.ActiveTourViewModel>(() => _i38.ActiveTourViewModel(
      get<_i35.TourRepository>(), get<_i30.NameRepository>()));
  gh.lazySingleton<_i39.CalendarRepository>(() => _i39.CalendarRepository(
      get<_i28.LocalStorage>(), get<_i24.CareerCalendarDaoStorage>()));
  gh.factory<_i40.CareerCalendarViewModel>(() => _i40.CareerCalendarViewModel(
      get<_i39.CalendarRepository>(), get<_i30.NameRepository>()));
  gh.lazySingleton<_i41.CareerRepository>(() => _i41.CareerRepository(
      get<_i25.CareerResultsDaoStorage>(), get<_i39.CalendarRepository>()));
  gh.factory<_i42.CareerResetViewModel>(
      () => _i42.CareerResetViewModel(get<_i41.CareerRepository>()));
  gh.factory<_i43.CareerSelectRidersViewModel>(() =>
      _i43.CareerSelectRidersViewModel(
          get<_i39.CalendarRepository>(), get<_i35.TourRepository>()));
  gh.factory<_i44.CareerStandingsViewModel>(() => _i44.CareerStandingsViewModel(
      get<_i41.CareerRepository>(),
      get<_i39.CalendarRepository>(),
      get<_i30.NameRepository>()));
  gh.factory<_i45.ChangeCyclistNamesViewModel>(
      () => _i45.ChangeCyclistNamesViewModel(get<_i30.NameRepository>()));
  gh.factory<_i46.GameViewModel>(() => _i46.GameViewModel(
      get<_i37.TutorialRepository>(),
      get<_i28.LocalStorage>(),
      get<_i18.SpriteManager>()));
  gh.singleton<_i47.GlobalViewModel>(_i47.GlobalViewModel(
      get<_i29.LocaleRepository>(),
      get<_i26.DebugRepository>(),
      get<_i28.LocalStorage>()));
  gh.factory<_i48.MainMenuViewModel>(
      () => _i48.MainMenuViewModel(get<_i35.TourRepository>()));
  gh.singleton<_i49.NetworkRefreshInterceptor>(
      _i49.NetworkRefreshInterceptor(get<_i32.RefreshRepository>()));
  gh.factory<_i50.ResultsViewModel>(() => _i50.ResultsViewModel(
      get<_i30.NameRepository>(),
      get<_i35.TourRepository>(),
      get<_i41.CareerRepository>()));
  gh.factory<_i51.CareerFinishViewModel>(
      () => _i51.CareerFinishViewModel(get<_i41.CareerRepository>()));
  gh.factory<_i52.CareerOverviewViewModel>(() => _i52.CareerOverviewViewModel(
      get<_i41.CareerRepository>(),
      get<_i39.CalendarRepository>(),
      get<_i30.NameRepository>()));
  gh.lazySingleton<_i5.CombiningSmartInterceptor>(() =>
      registerModule.provideCombiningSmartInterceptor(
          get<_i14.NetworkLogInterceptor>(),
          get<_i31.NetworkAuthInterceptor>(),
          get<_i13.NetworkErrorInterceptor>(),
          get<_i49.NetworkRefreshInterceptor>()));
  gh.lazySingleton<_i53.Dio>(
      () => registerModule.provideDio(get<_i5.CombiningSmartInterceptor>()));
  return get;
}

class _$RegisterModule extends _i54.RegisterModule {}
