import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/positions/game_map.dart';
import 'package:cycling_escape/widget_game/positions/position.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';

/// DISCLAIMER:
/// This is some strong spagetti code and I don't know how it works anymore
/// My apologies for that.
/// Continue reading at your own risk.

class MapUtils {
  final PositionListener listener;
  static final _random = Random();
  int currentSegment = 0;
  int fieldValue = 0;
  double currentAngle = 0;
  double jOffset = 0;
  Offset currentPosition;
  Sprint? nextSprint;
  var currentPositionType = PositionType.flat;
  var sprints = <Sprint>[];
  var mapPositions = <Position>[];

  MapUtils(this.listener, this.currentPosition);

  void moveWithoutAdding(Offset offset, double jOffset) {
    currentPosition += offset;
    this.jOffset += jOffset;
  }

  void addSprint(int width, SprintType type) {
    final Sprint sprint = Sprint(type, currentPosition, width, -currentAngle, currentSegment++);
    sprints.add(sprint);
    moveWithoutAdding(Offset(cos(currentAngle), sin(currentAngle)) / 3, 0);
    nextSprint = sprint;
  }

  void addStraight(int length, int width, {bool reverseJ = false}) {
    final positions = <Position>[];
    const dx = 2;
    const dy = 2;
    for (var i = 0; i < length; i++) {
      for (var j = 0; j < width; j++) {
        final jAccent = reverseJ ? width - j - 1 : j;
        var fieldValue = 0.0;
        final p1 = Offset(
          currentPosition.dx + dx * i * cos(currentAngle) + dx * (j / 2) * cos(currentAngle + pi / 2),
          currentPosition.dy + dy * i * sin(currentAngle) + dy * (j / 2) * sin(currentAngle + pi / 2),
        );
        switch (currentPositionType) {
          case PositionType.cobble:
            final t = (p1.dx * p1.dy / 61667).toString();
            final x = int.parse(t.toString().substring(t.length - 6, t.length - 5));
            fieldValue = x < 4 ? -1 : (x < 7 ? -2 : (x < 9 ? -3 : -4));
            break;
          case PositionType.uphill:
            fieldValue = -this.fieldValue + 0.0;
            break;
          case PositionType.downhill:
            fieldValue = this.fieldValue + 0.0;
            break;
          default:
            fieldValue = 0;
        }
        positions.add(Position(
          p1,
          Offset(
            currentPosition.dx + (dx * (i + 1)) * cos(currentAngle) + dx * (j / 2) * cos(currentAngle + pi / 2),
            currentPosition.dy + (dy * (i + 1)) * sin(currentAngle) + dy * (j / 2) * sin(currentAngle + pi / 2),
          ),
          listener,
          i == length - 1,
          currentSegment,
          i * 1.0,
          i / length * 100,
          jAccent + jOffset,
          0,
          false,
          0,
          0,
          false,
          currentPositionType,
          fieldValue: fieldValue,
          sprint: nextSprint,
        ));
      }
      nextSprint = null;
    }
    currentPosition += Offset(
      dx * length * cos(currentAngle),
      dy * length * sin(currentAngle),
    );
    currentSegment++;
    mapPositions.addAll(positions);
  }

  void addCorner(double deltaAngle, int width, double radius) {
    final positions = <Position>[];
    final endAngle = currentAngle + deltaAngle;
    final clockwise = deltaAngle < 0;
    for (var j = 0; j < width; j++) {
      final jAccent = clockwise ? width - j - 1 : j;
      final segmentStart = currentPosition + Offset(-j * sin(currentAngle), j * cos(currentAngle));
      positions.addAll(_addCornerSegment(
        segmentStart,
        currentAngle + (clockwise ? pi : 0),
        endAngle + (clockwise ? pi : 0),
        radius - jAccent,
        clockwise,
        currentSegment,
        j + jOffset,
      ));
    }
    nextSprint = null;
    final double radiusAccent = radius - (clockwise ? width - 1 : 0);
    currentPosition += Offset(
          radiusAccent * cos(currentAngle - pi / 2),
          radiusAccent * sin(currentAngle - pi / 2),
        ) *
        (clockwise ? 1 : -1);
    currentPosition += Offset(
          radiusAccent * cos(endAngle - pi / 2),
          radiusAccent * sin(endAngle - pi / 2),
        ) *
        (clockwise ? -1 : 1);
    currentSegment++;
    currentAngle = endAngle;
    mapPositions.addAll(positions);
  }

  List<Position> _addCornerSegment(
    Offset start,
    double startAngle,
    double endAngle,
    double radius,
    bool clockwise,
    int segment,
    double j,
  ) {
    final positions = <Position>[];
    final double length = max(2, radius * (startAngle - endAngle).abs());
    final numberOfPositions = length ~/ 2;
    final centerAngle = (startAngle + endAngle) / 2;
    final maxAngle = (startAngle - centerAngle).abs();
    final istart = -(numberOfPositions % 2) / 2 + 0.5;
    final centerOfCorner = start + Offset(-radius * sin(startAngle), radius * cos(startAngle));
    final imax = (numberOfPositions / 2).ceil();
    for (var i = istart; i < imax; i++) {
      for (var k = -1; (k <= 1 && i > 0) || (k == -1 && i == 0); k += 2) {
        final startAngle2 = centerAngle + maxAngle * (i + 0.5) * k / (numberOfPositions / 2);
        final angle = centerAngle + maxAngle * i * k / (numberOfPositions / 2);
        final offset = Offset(cos(angle), sin(angle)) * length / 2 / numberOfPositions.toDouble();
        final radiusPart = pow(pow(radius, 2) - (pow(offset.dx, 2) + pow(offset.dy, 2)), 1 / 2) as double;
        final center = centerOfCorner + Offset(radiusPart * sin(angle), -radiusPart * cos(angle));
        var p1 = center + offset * k.toDouble();
        var p2 = center - offset * k.toDouble();

        if (!clockwise) {
          // For text purposes
          p1 = center + offset * k.toDouble();
          p2 = center - offset * k.toDouble();
        }
        int iAccent;
        if (istart == 0.5) {
          iAccent = numberOfPositions ~/ 2 - k * i.ceil() + (k == -1 ? -1 : 0);
        } else {
          iAccent = numberOfPositions ~/ 2 - i.floor() * k;
        }
        if (!clockwise) {
          iAccent = numberOfPositions - iAccent - 1;
        }
        double fieldValue = 0;
        switch (currentPositionType) {
          case PositionType.cobble:
            final t = (p1.dx * p1.dy / 61667).toString();
            final x = int.parse(t.toString().substring(t.length - 6, t.length - 5));
            fieldValue = x < 4 ? -1 : (x < 7 ? -2 : (x < 9 ? -3 : -4));
            break;
          case PositionType.uphill:
            fieldValue = -this.fieldValue + 0.0;
            break;
          case PositionType.downhill:
            fieldValue = this.fieldValue + 0.0;
            break;
          default:
            fieldValue = 0;
        }
        positions.add(Position(
          p1,
          p2,
          listener,
          iAccent == numberOfPositions - 1,
          segment,
          iAccent * 1.0,
          ((iAccent + 1) * 100.0 / (numberOfPositions)).roundToDouble(),
          j,
          clockwise ? k : -k,
          clockwise,
          (startAngle2 + pi * 2) % (pi * 2),
          radius,
          true,
          currentPositionType,
          curvature: numberOfPositions,
          fieldValue: fieldValue,
          sprint: iAccent < 1 ? nextSprint : null,
        ));
      }
    }
    return positions;
  }

  void setPositionType(PositionType positionType, [int? fieldValue]) {
    currentPositionType = positionType;
    if (fieldValue != null) {
      this.fieldValue = fieldValue;
    }
  }

  List<Position> generatePositions() {
    MapUtils.connectPositions(mapPositions);
    return mapPositions;
  }

  static void connectPositions(List<Position> positions) {
    final segments = <List<Position>?>[];
    for (final element in positions) {
      if (segments.isEmpty) {
        segments.add([element]);
      } else {
        final segment = segments.firstWhereOrNull(((a) => a!.firstWhereOrNull((b) => b.segment == element.segment) != null));
        if (segment != null) {
          segment.add(element);
        } else {
          segments.add([element]);
        }
      }
    }
    for (final segment in segments) {
      final segmentId = segment!.first.segment;
      final nextSegment = segments
          .firstWhereOrNull(((a) => a!.first.segment == segmentId + 1 || (a.firstWhereOrNull((element) => element.segment == segmentId + 2 && element.sprint != null) != null)));
      final nextSegmentPositions = nextSegment?.where((position) => position.i < 1).toList() ?? [];
      for (final position in segment) {
        if (position.isLast) {
          position.connections = nextSegmentPositions.where((element) => (element.j - position.j).abs() <= 1).toList();
        } else {
          position.connections = segment
              .where((element) =>
                  (position.isCurved && (element.curvature == position.curvature) && (element.j - position.j).abs() <= 1 ||
                      (!position.isCurved && (element.j - position.j).abs() <= 1)) &&
                  (element.i == position.i + 1))
              .toList();
        }
      }
    }
  }

  static bool isInside(
    Offset point,
    Offset p1,
    Offset p2,
    double width,
    double angle,
  ) {
    final center = (p1 + p2) / 2;
    final rotatedPoint = rotatePoint(point - center, -angle);
    final rotatedPoint1 = rotatePoint(p1 - center, -angle);
    final rotatedPoint2 = rotatePoint(p2 - center, -angle);
    return isInsideLine(rotatedPoint, rotatedPoint1, rotatedPoint2, width);
  }

  static bool isInsideLine(Offset point, Offset p1, Offset p2, double width) {
    return point.dx >= p1.dx && point.dx <= p2.dx && point.dy >= -width / 2 && point.dy <= width / 2;
  }

  static bool isInsideRect(Offset point, Offset p1, Offset p2) {
    return point.dx >= p1.dx && point.dx <= p2.dx && point.dy >= p1.dy && point.dy <= p2.dy;
  }

  static Offset rotatePoint(Offset localPoint, double angle) {
    return Offset(localPoint.dx * cos(angle) - localPoint.dy * sin(angle), localPoint.dy * cos(angle) + localPoint.dx * sin(angle));
  }

  static List<Sprint?> getSprintsBetween(Position from, Position to, [List<Sprint?>? currentSprints]) {
    currentSprints ??= [];
    if (from.sprint != null && !currentSprints.contains(from.sprint)) {
      currentSprints.add(from.sprint);
    }
    if (to.segment - from.segment >= 1) {
      return getSprintsBetween(from.connections!.first!, to, currentSprints);
    }
    return currentSprints;
  }

  static List<Position?> findPlaceBefore(Position? position, double? maxDepth, bool emptyPosition, {List<Position>? positions, Position? startPosition, int? currentDepth}) {
    if (currentDepth == null) {
      currentDepth = 0;
    } else if (currentDepth > maxDepth!) {
      return [];
    }
    if (startPosition == null) {
      Position? positionFound;
      for (final element in positions!) {
        if (element.connections!.isNotEmpty && element.connections!.contains(position) && element.j == position!.j) {
          positionFound = element;
        }
      }
      return [positionFound];
    } else {
      final currentPosition = startPosition;
      if (currentPosition.connections!.isNotEmpty && currentPosition.getValue(false) < position!.getValue(false)) {
        if (currentPosition.connections!.contains(position) && currentPosition.j == position.j) {
          final route = [currentPosition];
          return route;
        } else {
          // priorityPosition is for nicer animation/movement of cyclists
          final priorityPosition = currentPosition.connections?.firstWhereOrNull(((element) => element?.j == currentPosition.j));
          if (priorityPosition != null) {
            currentPosition.connections!.insert(0, priorityPosition);
            currentPosition.connections!.removeAt(currentPosition.connections!.lastIndexOf(priorityPosition));
          }
          for (var i = 0; i < currentPosition.connections!.length; i++) {
            if (currentPosition.connections![i]!.cyclist == null || !emptyPosition) {
              final routeFound = findPlaceBefore(
                position,
                maxDepth,
                emptyPosition,
                startPosition: currentPosition.connections![i],
                currentDepth: currentDepth + 1,
              );
              if (routeFound.isNotEmpty) {
                routeFound.insert(0, currentPosition);
                return routeFound;
              }
            }
          }
        }
      }
    }
    return [];
  }

  static List<Position?>? findMaxValue(Position? currentPosition, double maxValue, [List<Position?>? route]) {
    if (maxValue == 0) {
      return [currentPosition];
    } else if (route == null) {
      route = [];
    } else if (route.length > maxValue) {
      return null;
    }
    route.add(currentPosition);
    if (currentPosition!.connections!.isNotEmpty) {
      if (route.length - 1 > maxValue) {
        var bestValue = 0.0;
        Position? bestPosition;
        for (final element in currentPosition.connections!) {
          if (element!.cyclist == null && (bestPosition == null || element.getValue(false) > bestValue)) {
            bestValue = element.getValue(false);
            bestPosition = element;
          }
        }
        if (bestPosition != null) {
          route.add(bestPosition);
        }
        return route;
      } else {
        var bestValue = 0.0;
        List<Position?>? bestRoute;
        // priorityPosition is for nicer animation/movement of cyclists
        final priorityPosition = currentPosition.connections?.firstWhereOrNull(((element) => element?.j == currentPosition.j));
        if (priorityPosition != null) {
          currentPosition.connections!.insert(0, priorityPosition);
          currentPosition.connections!.removeAt(currentPosition.connections!.lastIndexOf(priorityPosition));
        }
        for (var i = 0; i < currentPosition.connections!.length; i++) {
          if (currentPosition.connections![i]!.cyclist == null) {
            final maxValueRoute = findMaxValue(currentPosition.connections![i], maxValue, route.toList());
            if (maxValueRoute != null && (bestRoute == null || maxValueRoute.last!.getValue(false) > bestValue)) {
              bestValue = maxValueRoute.last!.getValue(false);
              bestRoute = maxValueRoute;
            }
          }
        }
        return (bestRoute != null && bestRoute.isNotEmpty) ? bestRoute : route;
      }
    }
    return route;
  }

  // minDistance is used for when you don't move your max potential (for example taking the outer edge of a corner) so more riders can follow
  static double calculateDistance(Position? start, Position end, {double? currentDistance, double? minDistance}) {
    minDistance ??= -1;
    currentDistance ??= 0;
    if (start == end) {
      return currentDistance;
    } else if (start!.getValue(false) > end.getValue(false)) {
      return 9999;
    } else {
      var shortestDistance = 9999.9;
      for (final element in start.connections!) {
        final distance = calculateDistance(element, end, currentDistance: currentDistance + 1, minDistance: minDistance);
        if (distance < shortestDistance) {
          shortestDistance = distance;
        }
      }
      return max(shortestDistance, minDistance);
    }
  }

  static GameMap generateMap(PlaySettings playSettings, PositionListener listener, SpriteManager spriteManager) {
    final newMap = MapUtils(listener, const Offset(0, 4));

    const minLength = 3;
    const maxLength = 10;
    const minWidth = 3;
    const maxWidth = 8;
    const preferredMaxWidth = 5;
    var width = playSettings.teams.clamp(minWidth, maxWidth);

    newMap.addStraight((playSettings.ridersPerTeam * playSettings.teams / width).ceil().clamp(1, maxLength), width);
    newMap.addSprint(width, SprintType.start);

    double angle = 0;
    final angles = [pi / 4, pi / 3];
    const minAngle = -pi / 2;
    const maxAngle = pi / 2;
    late final segmentLength = playSettings.mapLength.segments;
    var positionType = PositionType.flat;
    int? fieldValue;

    for (var i = 0; i < segmentLength; i++) {
      if (_random.nextDouble() > 0.9 || width > preferredMaxWidth) {
        var change = width > preferredMaxWidth || _random.nextBool() ? -1.0 : 1.0;
        width += change.floor();
        if (width > maxWidth || width < minWidth) {
          change = -change;
          width = width + 2 * change.floor();
        }
        newMap.moveWithoutAdding(Offset(sin(angle), -cos(angle)) * change / 2, -change / 2);
      }
      if (fieldValue != null && (i % 2 == 0 || fieldValue >= 4)) {
        if (positionType == PositionType.uphill) {
          fieldValue++;
          if (fieldValue > 5) {
            fieldValue = 5;
            positionType = PositionType.downhill;
            newMap.addSprint(width, SprintType.mountainSprint);
          }
        } else {
          fieldValue--;
          if (fieldValue <= 0) {
            positionType = _random.nextBool() && playSettings.mapType == MapType.heavy ? PositionType.cobble : PositionType.flat;
            fieldValue = null;
          }
        }
        newMap.setPositionType(positionType, fieldValue);
      }
      if (_random.nextBool()) {
        // Is straight
        final int length = _random.nextInt(maxLength - minLength) + minLength;
        newMap.addStraight(length, width);
      } else {
        final int radius = _random.nextInt(4) + (7.0 + width / 2).ceil();
        int a = _random.nextBool() ? -1 : 1;
        final int angleIndex = _random.nextInt(angles.length);
        final double deltaAngle = angles[angleIndex];
        if (angle + deltaAngle * a > maxAngle || angle + deltaAngle * a < minAngle) {
          a = -a;
        }
        angle += deltaAngle * a;
        newMap.addCorner(deltaAngle * a, width, radius + 0.0);
      }
      if (i % 7 == 0 && i < segmentLength * 0.8 && i > segmentLength * 0.2 && _random.nextDouble() < 0.3 && positionType != PositionType.uphill) {
        newMap.addSprint(width, SprintType.sprint);
      }
      if (playSettings.mapType != MapType.flat && i % 3 == 0 && _random.nextDouble() < 0.2) {
        switch (positionType) {
          case PositionType.flat:
            positionType = (_random.nextBool() && playSettings.mapType == MapType.heavy) || playSettings.mapType == MapType.hills ? PositionType.uphill : PositionType.cobble;
            break;
          case PositionType.uphill:
            positionType = PositionType.downhill;
            if (i < segmentLength * 0.8 && i > segmentLength * 0.2 && _random.nextDouble() < 0.7) {
              newMap.addSprint(width, SprintType.mountainSprint);
            }
            break;
          case PositionType.cobble:
            positionType = (_random.nextBool() && playSettings.mapType == MapType.heavy) || playSettings.mapType == MapType.hills ? PositionType.uphill : PositionType.flat;
            break;
          case PositionType.downhill:
          default:
          // On Downhill do nothing
        }
        if (positionType == PositionType.uphill) {
          fieldValue = 1;
        } else if (positionType != PositionType.downhill) {
          fieldValue = null;
        }
        newMap.setPositionType(positionType, fieldValue);
      }
    }
    newMap.addSprint(width, SprintType.finish);
    newMap.addStraight(12, width);
    final positions = newMap.generatePositions();
    return GameMap(positions, newMap.sprints, spriteManager);
  }
}
