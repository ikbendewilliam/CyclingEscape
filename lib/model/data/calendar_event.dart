import 'package:cycling_escape/widget_game/data/play_settings.dart';

class CalendarEvent {
  final int id;
  final PlaySettings playSettings;
  final String localizationKey;
  final int points;
  int? winner;

  CalendarEvent(
    this.id,
    this.localizationKey,
    this.points,
    this.playSettings,
  );
}
