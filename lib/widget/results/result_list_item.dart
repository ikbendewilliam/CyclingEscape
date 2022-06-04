import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:flutter/widgets.dart';

class ResultListItem extends StatelessWidget {
  final int index;
  final String? time;
  final ResultData resultData;
  final List<ResultsColumn>? columns;
  final String Function(int) numberToName;

  const ResultListItem({
    required this.index,
    required this.resultData,
    required this.columns,
    required this.numberToName,
    this.time,
    super.key,
  });

  String _getValue(ResultsColumn column) {
    switch (column) {
      case ResultsColumn.rank:
        return (index + 1).toString();
      case ResultsColumn.number:
        return resultData.number.toString();
      case ResultsColumn.name:
        return numberToName(resultData.number);
      case ResultsColumn.team:
        return resultData.team?.numberStart == null ? '' : '${resultData.team!.numberStart! + 2}0';
      case ResultsColumn.time:
        return time ?? ' ';
      case ResultsColumn.points:
        return resultData.points == 0 ? ' ' : resultData.points.toString();
      case ResultsColumn.mountain:
        return resultData.mountain == 0 ? ' ' : resultData.mountain.toString();
      default:
        return ' ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilderTheme: (context, theme) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: resultData.team?.getColor() ?? Team.getColorFromId(Team.getIdFromCyclistNumber(resultData.number)),
          borderRadius: BorderRadius.circular(80),
        ),
        child: Row(
          children: columns?.map((e) {
                Widget text = Text(
                  _getValue(e),
                  style: theme.coreTextTheme.bodyNormal.copyWith(color: resultData.team?.getTextColor() ?? Team.getTextColorFromId(Team.getIdFromCyclistNumber(resultData.number))),
                  textAlign: e.textAlign,
                );
                if (e.useFittedBox) {
                  text = FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: e.textAlign == TextAlign.start ? Alignment.centerLeft : Alignment.center,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: text,
                    ),
                  );
                }
                return Expanded(
                  flex: e.flex,
                  child: text,
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }
}
