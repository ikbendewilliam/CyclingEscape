import 'package:cycling_escape/model/data/calendar_event.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
abstract class CalendarRepository {
  @factoryMethod
  factory CalendarRepository(LocalStorage localStorage) = _CalendarRepository;

  List<CalendarEvent> get calendarEvents;

  int get eventsCompleted;

  set eventsCompleted(int value);
}

class _CalendarRepository implements CalendarRepository {
  static final List<CalendarEvent> _events = [
    CalendarEvent(1, 'calendarEvent1', 500, PlaySettings(3, 2, MapType.flat, MapLength.medium, null, 3)), // "Tour Down Under"
    CalendarEvent(2, 'calendarEvent2', 300, PlaySettings(3, 3, MapType.hills, MapLength.medium, null, 3)), // "Tour of Valencia"
    CalendarEvent(3, 'calendarEvent3', 400, PlaySettings(4, 2, MapType.flat, MapLength.long, null, 3)), // "Tour of Dubai"
    CalendarEvent(4, 'calendarEvent4', 300, PlaySettings(3, 3, MapType.hills, MapLength.medium, null, 2)), // "Ruta del Sol"
    CalendarEvent(5, 'calendarEvent5', 400, PlaySettings(3, 4, MapType.flat, MapLength.long, null, 2)), // "Tour of Abu Dhabi"
    CalendarEvent(6, 'calendarEvent6', 300, PlaySettings(3, 4, MapType.heavy, MapLength.long, null, 1)), // "Omloop Het Nieuwsblad"
    CalendarEvent(7, 'calendarEvent7', 300, PlaySettings(3, 4, MapType.heavy, MapLength.long, null, 1)), // "Kuurne - Brussels - Kuurne"
    CalendarEvent(8, 'calendarEvent8', 300, PlaySettings(4, 4, MapType.hills, MapLength.long, null, 1)), // "Strade Bianche"
    CalendarEvent(9, 'calendarEvent9', 500, PlaySettings(4, 4, MapType.flat, MapLength.medium, null, 4)), // "Paris - Nice"
    CalendarEvent(10, 'calendarEvent10', 500, PlaySettings(4, 4, MapType.hills, MapLength.medium, null, 4)), //  "Tirreno-Adriatico"
    CalendarEvent(11, 'calendarEvent11', 500, PlaySettings(5, 4, MapType.hills, MapLength.veryLong, null, 1)), //  "Milan-San Remo"
    CalendarEvent(12, 'calendarEvent12', 400, PlaySettings(4, 4, MapType.flat, MapLength.long, null, 4)), //  "Tour of Catalonia"
    CalendarEvent(13, 'calendarEvent13', 400, PlaySettings(6, 4, MapType.cobble, MapLength.long, null, 1)), //  "E3 Harelbeke"
    CalendarEvent(14, 'calendarEvent14', 500, PlaySettings(6, 4, MapType.cobble, MapLength.long, null, 1)), //  "Gent - Wevelgem"
    CalendarEvent(15, 'calendarEvent15', 300, PlaySettings(5, 5, MapType.cobble, MapLength.long, null, 1)), //  "Dwars door Vlaanderen"
    CalendarEvent(16, 'calendarEvent16', 300, PlaySettings(5, 5, MapType.flat, MapLength.long, null, 1)), //  "Volta Limburg Classic"
    CalendarEvent(17, 'calendarEvent17', 500, PlaySettings(6, 4, MapType.heavy, MapLength.veryLong, null, 1)), //  "Ronde van Vlaanderen"
    CalendarEvent(18, 'calendarEvent18', 400, PlaySettings(4, 4, MapType.hills, MapLength.long, null, 3)), //  "Tour of the Basque Country"
    CalendarEvent(19, 'calendarEvent19', 500, PlaySettings(7, 4, MapType.cobble, MapLength.veryLong, null, 1)), //  "Paris - Roubaix"
    CalendarEvent(20, 'calendarEvent20', 300, PlaySettings(7, 4, MapType.cobble, MapLength.long, null, 1)), //  "Brabantse Pijl"
    CalendarEvent(21, 'calendarEvent21', 500, PlaySettings(6, 5, MapType.flat, MapLength.medium, null, 1)), //  "Amstel Gold Race"
    CalendarEvent(22, 'calendarEvent22', 300, PlaySettings(5, 4, MapType.hills, MapLength.medium, null, 3)), //  "Tour of the Alps"
    CalendarEvent(23, 'calendarEvent23', 400, PlaySettings(7, 5, MapType.flat, MapLength.medium, null, 1)), //  "Walloon Arrow"
    CalendarEvent(24, 'calendarEvent24', 500, PlaySettings(7, 5, MapType.flat, MapLength.medium, null, 1)), //  "Liège-Bastogne-Liège"
    CalendarEvent(25, 'calendarEvent25', 500, PlaySettings(5, 5, MapType.hills, MapLength.medium, null, 3)), //  "Tour de Romandie"
    CalendarEvent(26, 'calendarEvent26', 800, PlaySettings(5, 4, MapType.hills, MapLength.long, null, 10)), //  "Giro d'Italia"
    CalendarEvent(27, 'calendarEvent27', 300, PlaySettings(7, 4, MapType.flat, MapLength.long, null, 4)), //  "Tour of California"
    CalendarEvent(28, 'calendarEvent28', 500, PlaySettings(8, 4, MapType.hills, MapLength.medium, null, 4)), //  "Critérium du Dauphiné"
    CalendarEvent(29, 'calendarEvent29', 500, PlaySettings(7, 5, MapType.hills, MapLength.medium, null, 5)), //  "Tour of Switzerland"
    CalendarEvent(30, 'calendarEvent30', 1000, PlaySettings(6, 5, MapType.hills, MapLength.long, null, 10)), //  "Tour de France"
    CalendarEvent(31, 'calendarEvent31', 400, PlaySettings(8, 5, MapType.hills, MapLength.veryLong, null, 1)), //  "Clásica San Sebastián"
    CalendarEvent(32, 'calendarEvent32', 400, PlaySettings(8, 5, MapType.flat, MapLength.medium, null, 4)), //  "Binckbank Tour"
    CalendarEvent(33, 'calendarEvent33', 800, PlaySettings(8, 5, MapType.hills, MapLength.long, null, 10)), //  "Vuelta a España"
    CalendarEvent(34, 'calendarEvent34', 300, PlaySettings(8, 5, MapType.hills, MapLength.medium, null, 4)), //  "Tour of Britain"
    CalendarEvent(35, 'calendarEvent35', 500, PlaySettings(8, 5, MapType.hills, MapLength.long, null, 1)), //  "Grand Prix of Quebec"
    CalendarEvent(36, 'calendarEvent36', 500, PlaySettings(8, 5, MapType.hills, MapLength.long, null, 1)), //  "Montreal Grand Prix"
    CalendarEvent(37, 'calendarEvent37', 500, PlaySettings(8, 5, MapType.flat, MapLength.medium, null, 4)), //  "Tour of Lombardy"
  ];

  final LocalStorage _localStorage;

  @override
  List<CalendarEvent> get calendarEvents => _events;

  @override
  int get eventsCompleted => _localStorage.eventsCompleted;

  @override
  set eventsCompleted(int value) => _localStorage.eventsCompleted = value;

  _CalendarRepository(this._localStorage);
}
