import 'package:json_annotation/json_annotation.dart';

part 'career.g.dart';

@JsonSerializable(explicitToJson: true)
class Career {
  @JsonKey(name: 'riders', required: true, includeIfNull: false)
  int riders;
  @JsonKey(name: 'rankingTypes', required: true, includeIfNull: false)
  int rankingTypes;
  @JsonKey(name: 'raceTypes', required: true, includeIfNull: false)
  int raceTypes;
  @JsonKey(name: 'cash', required: true, includeIfNull: false)
  int cash;

  Career({
    required this.riders,
    required this.rankingTypes,
    required this.raceTypes,
    required this.cash,
  });

  factory Career.fromJson(Map<String, dynamic> json) => _$CareerFromJson(json);

  Map<String, dynamic> toJson() => _$CareerToJson(this);

}
