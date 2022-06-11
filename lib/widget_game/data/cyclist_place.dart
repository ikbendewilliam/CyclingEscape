import 'package:cycling_escape/widget_game/moveable/cyclist.dart';

class CyclistPlace {
  Cyclist? cyclist;
  final double? value;
  bool? displayed = false;

  CyclistPlace(this.cyclist, this.value);

  int getTurns() {
    return (-value! / 1000 / 1000 / 1000 + 1).floor();
  }

  static CyclistPlace fromJson(Map<String, dynamic> json) {
    final CyclistPlace cyclistPlace = CyclistPlace(Cyclist.fromJson(json['cyclist'] as Map<String, dynamic>?, [], [], null), json['value'] as double?);
    cyclistPlace.displayed = json['displayed'] as bool?;
    return cyclistPlace;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cyclist'] = cyclist!.toJson(true);
    data['value'] = value;
    data['displayed'] = displayed;
    return data;
  }
}
