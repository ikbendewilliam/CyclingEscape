import 'package:cycling_escape/database/career/career_calendar_dao_storage.dart';
import 'package:cycling_escape/model/data/calendar_event.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/util/env/flavor_config.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
abstract class CalendarRepository {
  @factoryMethod
  factory CalendarRepository(
    LocalStorage localStorage,
    CareerCalendarDaoStorage calendarDaoStorage,
  ) = _CalendarRepository;

  Future<List<CalendarEvent>> get calendarEvents;

  Future<void> saveResults(List<CalendarEvent> event);

  int get eventsCompleted;

  set eventsCompleted(int value);

  Future<void> reset();
}

class _CalendarRepository implements CalendarRepository {
  final _events = [
    if (!FlavorConfig.isProd()) CalendarEvent(0, 'debug', 0, PlaySettings(2, 2, MapType.flat, MapLength.debug, null, 1, true)),
    CalendarEvent(1, 'calendarEvent1', 500, PlaySettings(3, 2, MapType.flat, MapLength.medium, null, 3, true)), // "Tour Down Under"
    CalendarEvent(2, 'calendarEvent2', 300, PlaySettings(3, 3, MapType.hills, MapLength.medium, null, 3, true)), // "Tour of Valencia"
    CalendarEvent(3, 'calendarEvent3', 400, PlaySettings(4, 2, MapType.flat, MapLength.long, null, 3, true)), // "Tour of Dubai"
    CalendarEvent(4, 'calendarEvent4', 300, PlaySettings(3, 3, MapType.hills, MapLength.medium, null, 2, true)), // "Ruta del Sol"
    CalendarEvent(5, 'calendarEvent5', 400, PlaySettings(3, 4, MapType.flat, MapLength.long, null, 2, true)), // "Tour of Abu Dhabi"
    CalendarEvent(6, 'calendarEvent6', 300, PlaySettings(3, 4, MapType.heavy, MapLength.long, null, 1, true)), // "Omloop Het Nieuwsblad"
    CalendarEvent(7, 'calendarEvent7', 300, PlaySettings(3, 4, MapType.heavy, MapLength.long, null, 1, true)), // "Kuurne - Brussels - Kuurne"
    CalendarEvent(8, 'calendarEvent8', 300, PlaySettings(4, 4, MapType.hills, MapLength.long, null, 1, true)), // "Strade Bianche"
    CalendarEvent(9, 'calendarEvent9', 500, PlaySettings(4, 4, MapType.flat, MapLength.medium, null, 4, true)), // "Paris - Nice"
    CalendarEvent(10, 'calendarEvent10', 500, PlaySettings(4, 4, MapType.hills, MapLength.medium, null, 4, true)), //  "Tirreno-Adriatico"
    CalendarEvent(11, 'calendarEvent11', 500, PlaySettings(5, 4, MapType.hills, MapLength.veryLong, null, 1, true)), //  "Milan-San Remo"
    CalendarEvent(12, 'calendarEvent12', 400, PlaySettings(4, 4, MapType.flat, MapLength.long, null, 4, true)), //  "Tour of Catalonia"
    CalendarEvent(13, 'calendarEvent13', 400, PlaySettings(6, 4, MapType.cobble, MapLength.long, null, 1, true)), //  "E3 Harelbeke"
    CalendarEvent(14, 'calendarEvent14', 500, PlaySettings(6, 4, MapType.cobble, MapLength.long, null, 1, true)), //  "Gent - Wevelgem"
    CalendarEvent(15, 'calendarEvent15', 300, PlaySettings(5, 5, MapType.cobble, MapLength.long, null, 1, true)), //  "Dwars door Vlaanderen"
    CalendarEvent(16, 'calendarEvent16', 300, PlaySettings(5, 5, MapType.flat, MapLength.long, null, 1, true)), //  "Volta Limburg Classic"
    CalendarEvent(17, 'calendarEvent17', 500, PlaySettings(6, 4, MapType.heavy, MapLength.veryLong, null, 1, true)), //  "Ronde van Vlaanderen"
    CalendarEvent(18, 'calendarEvent18', 400, PlaySettings(4, 4, MapType.hills, MapLength.long, null, 3, true)), //  "Tour of the Basque Country"
    CalendarEvent(19, 'calendarEvent19', 500, PlaySettings(7, 4, MapType.cobble, MapLength.veryLong, null, 1, true)), //  "Paris - Roubaix"
    CalendarEvent(20, 'calendarEvent20', 300, PlaySettings(7, 4, MapType.cobble, MapLength.long, null, 1, true)), //  "Brabantse Pijl"
    CalendarEvent(21, 'calendarEvent21', 500, PlaySettings(6, 5, MapType.flat, MapLength.medium, null, 1, true)), //  "Amstel Gold Race"
    CalendarEvent(22, 'calendarEvent22', 300, PlaySettings(5, 4, MapType.hills, MapLength.medium, null, 3, true)), //  "Tour of the Alps"
    CalendarEvent(23, 'calendarEvent23', 400, PlaySettings(7, 5, MapType.flat, MapLength.medium, null, 1, true)), //  "Walloon Arrow"
    CalendarEvent(24, 'calendarEvent24', 500, PlaySettings(7, 5, MapType.flat, MapLength.medium, null, 1, true)), //  "Liège-Bastogne-Liège"
    CalendarEvent(25, 'calendarEvent25', 500, PlaySettings(5, 5, MapType.hills, MapLength.medium, null, 3, true)), //  "Tour de Romandie"
    CalendarEvent(26, 'calendarEvent26', 800, PlaySettings(5, 4, MapType.hills, MapLength.long, null, 10, true)), //  "Giro d'Italia"
    CalendarEvent(27, 'calendarEvent27', 300, PlaySettings(7, 4, MapType.flat, MapLength.long, null, 4, true)), //  "Tour of California"
    CalendarEvent(28, 'calendarEvent28', 500, PlaySettings(8, 4, MapType.hills, MapLength.medium, null, 4, true)), //  "Critérium du Dauphiné"
    CalendarEvent(29, 'calendarEvent29', 500, PlaySettings(7, 5, MapType.hills, MapLength.medium, null, 5, true)), //  "Tour of Switzerland"
    CalendarEvent(30, 'calendarEvent30', 1000, PlaySettings(6, 5, MapType.hills, MapLength.long, null, 10, true)), //  "Tour de France"
    CalendarEvent(31, 'calendarEvent31', 400, PlaySettings(8, 5, MapType.hills, MapLength.veryLong, null, 1, true)), //  "Clásica San Sebastián"
    CalendarEvent(32, 'calendarEvent32', 400, PlaySettings(8, 5, MapType.flat, MapLength.medium, null, 4, true)), //  "Binckbank Tour"
    CalendarEvent(33, 'calendarEvent33', 800, PlaySettings(8, 5, MapType.hills, MapLength.long, null, 10, true)), //  "Vuelta a España"
    CalendarEvent(34, 'calendarEvent34', 300, PlaySettings(8, 5, MapType.hills, MapLength.medium, null, 4, true)), //  "Tour of Britain"
    CalendarEvent(35, 'calendarEvent35', 500, PlaySettings(8, 5, MapType.hills, MapLength.long, null, 1, true)), //  "Grand Prix of Quebec"
    CalendarEvent(36, 'calendarEvent36', 500, PlaySettings(8, 5, MapType.hills, MapLength.long, null, 1, true)), //  "Montreal Grand Prix"
    CalendarEvent(37, 'calendarEvent37', 500, PlaySettings(8, 5, MapType.flat, MapLength.medium, null, 4, true)), //  "Tour of Lombardy"
  ];

  final LocalStorage _localStorage;
  final CareerCalendarDaoStorage _calendarDaoStorage;

  @override
  Future<List<CalendarEvent>> get calendarEvents async {
    await _calendarDaoStorage.getAllWinners(_events);
    return _events;
  }

  @override
  int get eventsCompleted => _localStorage.eventsCompleted;

  @override
  set eventsCompleted(int value) => _localStorage.eventsCompleted = value;

  _CalendarRepository(
    this._localStorage,
    this._calendarDaoStorage,
  );

  @override
  Future<void> saveResults(List<CalendarEvent> events) => _calendarDaoStorage.saveResults(events);

  @override
  Future<void> reset() async {
    eventsCompleted = 0;
    for (final element in _events) {
      element.winner = null;
    }
    await saveResults(_events);
  }
}
