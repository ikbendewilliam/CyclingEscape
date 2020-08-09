import 'package:CyclingEscape/components/data/resultData.dart';
import 'package:CyclingEscape/views/resultsView.dart';

class Results {
  final ResultsType type;
  List<ResultData> data = [];
  int whiteJersey;
  int greenJersey;
  int bouledJersey;

  Results(this.type);
}
