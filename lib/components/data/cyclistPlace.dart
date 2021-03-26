import 'package:cycling_escape/components/moveable/cyclist.dart';

class CyclistPlace {
  Cyclist? cyclist;
  final double? value;
  bool? displayed = false;

  CyclistPlace(this.cyclist, this.value);

  int getTurns() {
    return (-value! / 1000 / 1000 / 1000 + 1).floor();
  }

  static CyclistPlace fromJson(Map<String, dynamic> json) {
    CyclistPlace cyclistPlace = CyclistPlace(Cyclist.fromJson(json['cyclist'], [], [], null), json['value']);
    cyclistPlace.displayed = json['displayed'];
    return cyclistPlace;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cyclist'] = this.cyclist!.toJson(true);
    data['value'] = this.value;
    data['displayed'] = this.displayed;
    return data;
  }
}
