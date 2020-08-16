import 'package:CyclingEscape/components/data/team.dart';

class ResultData {
  int rank = 0;
  int time = 0;
  int number = 0;
  Team team;
  int points = 0;
  int mountain = 0;
  double value;

  ResultData(
      [this.rank,
      this.time,
      this.points,
      this.mountain,
      this.number,
      this.team]) {
    if (rank == null) {
      rank = 0;
    }
    if (time == null) {
      time = 0;
    }
    if (number == null) {
      number = 0;
    }
    if (points == null) {
      points = 0;
    }
    if (mountain == null) {
      mountain = 0;
    }
  }

  ResultData copy() {
    return ResultData(this.rank, this.time, this.points, this.mountain,
        this.number, this.team);
  }
}
