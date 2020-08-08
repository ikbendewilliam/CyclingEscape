import 'package:CyclingEscape/components/moveable/cyclist.dart';

class CyclistPlace {
  final Cyclist cyclist;
  final double value;
  bool displayed = false;

  CyclistPlace(this.cyclist, this.value);

  int getTurns() {
    return (-value / 1000 / 1000 / 1000 + 1).floor();
  }
}
