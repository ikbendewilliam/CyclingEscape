import 'package:cycling_escape/model/data/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tour.g.dart';

@JsonSerializable(explicitToJson: true)
class Tour {
  @JsonKey(name: 'teams', required: true, includeIfNull: false)
  final int teams;
  @JsonKey(name: 'ridersPerTeam', required: true, includeIfNull: false)
  final int ridersPerTeam;
  @JsonKey(name: 'races', required: true, includeIfNull: false)
  final int races;
  @JsonKey(name: 'mapType', required: true, includeIfNull: false)
  final MapType mapType;
  @JsonKey(name: 'mapLength', required: true, includeIfNull: false)
  final MapLength mapLength;

  const Tour({
    required this.teams,
    required this.ridersPerTeam,
    required this.races,
    required this.mapType,
    required this.mapLength,
  });

  factory Tour.fromJson(Map<String, dynamic> json) => _$TourFromJson(json);

  Map<String, dynamic> toJson() => _$TourToJson(this);

}
