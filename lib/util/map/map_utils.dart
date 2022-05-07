import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/positions/game_map.dart';
import 'package:cycling_escape/widget_game/positions/position.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';

class MapUtils {
  final PositionListener listener;
  int currentSegment = 0;
  int fieldValue = 0;
  double currentAngle = 0;
  double jOffset = 0;
  Offset currentPosition;
  Sprint? nextSprint;
  PositionType currentPositionType = PositionType.flat;
  List<Sprint> sprints = [];
  List<Position>? mapPositions;

  MapUtils(this.listener, this.currentPosition) {
    mapPositions = [];
  }

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
    final List<Position> positions = [];
    const double dx = 2;
    const double dy = 2;
    for (int i = 0; i < length; i++) {
      for (int j = 0; j < width; j++) {
        final int jAccent = reverseJ ? width - j - 1 : j;
        double fieldValue = 0;
        final Offset p1 = Offset(currentPosition.dx + dx * i * cos(currentAngle) + dx * (j / 2) * cos(currentAngle + pi / 2),
            currentPosition.dy + dy * i * sin(currentAngle) + dy * (j / 2) * sin(currentAngle + pi / 2));
        switch (currentPositionType) {
          case PositionType.cobble:
            final String t = (p1.dx * p1.dy / 61667).toString();
            final int x = int.parse(t.toString().substring(t.length - 6, t.length - 5));
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
            Offset(currentPosition.dx + (dx * (i + 1)) * cos(currentAngle) + dx * (j / 2) * cos(currentAngle + pi / 2),
                currentPosition.dy + (dy * (i + 1)) * sin(currentAngle) + dy * (j / 2) * sin(currentAngle + pi / 2)),
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
            sprint: nextSprint));
      }
      nextSprint = null;
    }
    currentPosition += Offset(dx * length * cos(currentAngle), dy * length * sin(currentAngle));
    currentSegment++;
    mapPositions!.addAll(positions);
  }

  void addCorner(double deltaAngle, int width, double radius) {
    final List<Position> positions = [];
    final double endAngle = currentAngle + deltaAngle;
    final bool clockwise = deltaAngle < 0;
    for (int j = 0; j < width; j++) {
      final int jAccent = clockwise ? width - j - 1 : j;
      final Offset segmentStart = currentPosition + Offset(-j * sin(currentAngle), j * cos(currentAngle));
      positions
          .addAll(_addCornerSegment(segmentStart, currentAngle + (clockwise ? pi : 0), endAngle + (clockwise ? pi : 0), radius - jAccent, clockwise, currentSegment, j + jOffset));
    }
    nextSprint = null;
    final double radiusAccent = radius - (clockwise ? width - 1 : 0);
    currentPosition += Offset(radiusAccent * cos(currentAngle - pi / 2), radiusAccent * sin(currentAngle - pi / 2)) * (clockwise ? 1 : -1);
    currentPosition += Offset(radiusAccent * cos(endAngle - pi / 2), radiusAccent * sin(endAngle - pi / 2)) * (clockwise ? -1 : 1);
    currentSegment++;
    currentAngle = endAngle;
    mapPositions!.addAll(positions);
  }

  List<Position> _addCornerSegment(Offset start, double startAngle, double endAngle, double radius, bool clockwise, int segment, double j) {
    final List<Position> positions = [];
    final double length = radius * (startAngle - endAngle).abs();
    final int numberOfPositions = (length / 2).floor();
    final double centerAngle = (startAngle + endAngle) / 2;
    final double maxAngle = (startAngle - centerAngle).abs();
    final double istart = -(numberOfPositions % 2) / 2 + 0.5;
    final Offset centerOfCorner = start + Offset(-radius * sin(startAngle), radius * cos(startAngle));
    final int imax = (numberOfPositions / 2).ceil();
    for (double i = istart; i < imax; i++) {
      for (int k = -1; (k <= 1 && i > 0) || (k == -1 && i == 0); k += 2) {
        final double startAngle2 = centerAngle + maxAngle * (i + 0.5) * k / (numberOfPositions / 2);
        final double angle = centerAngle + maxAngle * i * k / (numberOfPositions / 2);
        final Offset offset = Offset(cos(angle), sin(angle)) * length / 2 / numberOfPositions.toDouble();

        final double radiusPart = pow(pow(radius, 2) - (pow(offset.dx, 2) + pow(offset.dy, 2)), 1 / 2) as double;

        final Offset center = centerOfCorner + Offset(radiusPart * sin(angle), -radiusPart * cos(angle));
        Offset p1 = center + offset * k.toDouble();
        Offset p2 = center - offset * k.toDouble();

        if (!clockwise) {
          // For text purposes
          p1 = center + offset * k.toDouble();
          p2 = center - offset * k.toDouble();
        }
        int iAccent;
        if (istart == 0.5) {
          iAccent = (numberOfPositions / 2).floor() - k * i.ceil() + (k == -1 ? -1 : 0);
        } else {
          iAccent = (numberOfPositions / 2).floor() - i.floor() * k;
        }
        if (!clockwise) {
          iAccent = numberOfPositions - iAccent - 1;
        }
        double fieldValue = 0;
        switch (currentPositionType) {
          case PositionType.cobble:
            final String t = (p1.dx * p1.dy / 61667).toString();
            final int x = int.parse(t.toString().substring(t.length - 6, t.length - 5));
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
        positions.add(Position(p1, p2, listener, iAccent == numberOfPositions - 1, segment, iAccent * 1.0, ((iAccent + 1) * 100.0 / (numberOfPositions)).roundToDouble(), j,
            clockwise ? k : -k, clockwise, (startAngle2 + pi * 2) % (pi * 2), radius, true, currentPositionType,
            curvature: numberOfPositions, fieldValue: fieldValue, sprint: iAccent < 1 ? nextSprint : null));
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

  List<Position>? generatePositions() {
    MapUtils.connectPositions(mapPositions!);
    return mapPositions;
  }

  static void connectPositions(List<Position> positions) {
    final List<List<Position>?> segments = [];
    for (final element in positions) {
      if (segments.isEmpty) {
        segments.add([element]);
      } else {
        final List<Position>? segment = segments.firstWhereOrNull(((a) => a!.firstWhereOrNull((b) => b.segment == element.segment) != null));
        if (segment != null) {
          segment.add(element);
        } else {
          segments.add([element]);
        }
      }
    }
    for (final segment in segments) {
      final int segmentId = segment!.first.segment;
      final List<Position>? nextSegment = segments
          .firstWhereOrNull(((a) => a!.first.segment == segmentId + 1 || (a.firstWhereOrNull((element) => element.segment == segmentId + 2 && element.sprint != null) != null)));
      var nextSegmentPositions = <Position>[];
      if (nextSegment != null) {
        nextSegmentPositions = nextSegment.where((position) => position.i < 1).toList();
      }
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

  static bool isInside(Offset point, Offset p1, Offset p2, double width, double angle) {
    final Offset center = (p1 + p2) / 2;
    final Offset rotatedPoint = rotatePoint(point - center, -angle);
    final Offset rotatedPoint1 = rotatePoint(p1 - center, -angle);
    final Offset rotatedPoint2 = rotatePoint(p2 - center, -angle);
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
      final Position currentPosition = startPosition;
      if (currentPosition.connections!.isNotEmpty && currentPosition.getValue(false) < position!.getValue(false)) {
        if (currentPosition.connections!.contains(position) && currentPosition.j == position.j) {
          final List<Position?> route = [currentPosition];
          return route;
        } else {
          // priorityPosition is for nicer animation/movement of cyclists
          final Position? priorityPosition = currentPosition.connections?.firstWhereOrNull(((element) => element?.j == currentPosition.j));
          if (priorityPosition != null) {
            currentPosition.connections!.insert(0, priorityPosition);
            currentPosition.connections!.removeAt(currentPosition.connections!.lastIndexOf(priorityPosition));
          }
          for (int i = 0; i < currentPosition.connections!.length; i++) {
            if (currentPosition.connections![i]!.cyclist == null || !emptyPosition) {
              final List<Position?> routeFound = findPlaceBefore(
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
        double bestValue = 0;
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
        double bestValue = 0;
        List<Position?>? bestRoute;
        // priorityPosition is for nicer animation/movement of cyclists
        final Position? priorityPosition = currentPosition.connections?.firstWhereOrNull(((element) => element?.j == currentPosition.j));
        if (priorityPosition != null) {
          currentPosition.connections!.insert(0, priorityPosition);
          currentPosition.connections!.removeAt(currentPosition.connections!.lastIndexOf(priorityPosition));
        }
        for (int i = 0; i < currentPosition.connections!.length; i++) {
          if (currentPosition.connections![i]!.cyclist == null) {
            final List<Position?>? maxValueRoute = findMaxValue(currentPosition.connections![i], maxValue, route.toList());
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
      double shortestDistance = 9999;
      for (final element in start.connections!) {
        final double distance = calculateDistance(element, end, currentDistance: currentDistance + 1, minDistance: minDistance);
        if (distance < shortestDistance) {
          shortestDistance = distance;
        }
      }
      return max(shortestDistance, minDistance);
    }
  }

  static GameMap generateMap(PlaySettings playSettings, PositionListener listener, SpriteManager spriteManager) {
    final MapUtils newMap = MapUtils(listener, const Offset(0, 4));

    newMap.addStraight(playSettings.ridersPerTeam, max(playSettings.teams, 3));
    newMap.addSprint(max(playSettings.teams, 3), SprintType.start);

    int width = max(playSettings.teams, 3);
    const int minLength = 3;
    const int maxLength = 8;
    const int minWidth = 3;
    const int maxWidth = 8;
    double angle = 0;
    final List<double> angles = [pi / 4, pi / 3];
    const double minAngle = -pi / 2;
    const double maxAngle = pi / 2;
    late int segmentLength;
    switch (playSettings.mapLength) {
      case MapLength.short:
        segmentLength = 15;
        break;
      case MapLength.medium:
        segmentLength = 20;
        break;
      case MapLength.long:
        segmentLength = 30;
        break;
      case MapLength.veryLong:
        segmentLength = 60;
        break;
    }
    PositionType positionType = PositionType.flat;
    int? fieldValue;

    for (int i = 0; i < segmentLength; i++) {
      if (Random().nextDouble() > 0.9) {
        double change = Random().nextBool() ? -1 : 1;
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
            positionType = Random().nextBool() && playSettings.mapType == MapType.heavy ? PositionType.cobble : PositionType.flat;
            fieldValue = null;
          }
        }
        newMap.setPositionType(positionType, fieldValue);
      }
      if (Random().nextBool()) {
        // Is straight
        final int length = Random().nextInt(maxLength - minLength) + minLength;
        newMap.addStraight(length, width);
      } else {
        final int radius = Random().nextInt(4) + 6 + (width / 2).ceil();
        int a = Random().nextBool() ? -1 : 1;
        final int angleIndex = Random().nextInt(angles.length);
        final double deltaAngle = angles[angleIndex];
        if (angle + deltaAngle * a > maxAngle || angle + deltaAngle * a < minAngle) {
          a = -a;
        }
        angle += deltaAngle * a;
        newMap.addCorner(deltaAngle * a, width, radius + 0.0);
      }
      if (i % 7 == 0 && i < segmentLength * 0.8 && i > segmentLength * 0.2 && Random().nextDouble() < 0.3 && positionType != PositionType.uphill) {
        newMap.addSprint(width, SprintType.sprint);
      }
      if (playSettings.mapType != MapType.flat && i % 3 == 0 && Random().nextDouble() < 0.2) {
        switch (positionType) {
          case PositionType.flat:
            positionType = (Random().nextBool() && playSettings.mapType == MapType.heavy) || playSettings.mapType == MapType.hills ? PositionType.uphill : PositionType.cobble;
            break;
          case PositionType.uphill:
            positionType = PositionType.downhill;
            if (i < segmentLength * 0.8 && i > segmentLength * 0.2 && Random().nextDouble() < 0.7) {
              newMap.addSprint(width, SprintType.mountainSprint);
            }
            break;
          case PositionType.cobble:
            positionType = (Random().nextBool() && playSettings.mapType == MapType.heavy) || playSettings.mapType == MapType.hills ? PositionType.uphill : PositionType.flat;
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
    final List<Position>? positions = newMap.generatePositions();
    final GameMap map = GameMap(positions, newMap.sprints, spriteManager);

    return map;
  }
}

MapType getMapTypeFromString(String mapTypeAsString) {
  for (final MapType element in MapType.values) {
    if (element.toString() == mapTypeAsString) {
      return element;
    }
  }
  throw Exception("Incorrect mapTypeAsString $mapTypeAsString");
}

enum MapType { flat, cobble, hills, heavy }

MapLength getMapLengthFromString(String mapLengthAsString) {
  for (final MapLength element in MapLength.values) {
    if (element.toString() == mapLengthAsString) {
      return element;
    }
  }
  throw Exception("Incorrect mapLengthAsString $mapLengthAsString");
}

enum MapLength { short, medium, long, veryLong }

String mapTypeAsString(MapType maptype, Localization localizations) {
  switch (maptype) {
    case MapType.flat:
      return localizations.raceTypeFlat;
    case MapType.cobble:
      return localizations.raceTypeCobbled;
    case MapType.hills:
      return localizations.raceTypeHilled;
    case MapType.heavy:
      return localizations.raceTypeHeavy;
  }
}

String mapLengthAsString(MapLength mapLength, Localization localizations) {
  switch (mapLength) {
    case MapLength.short:
      return localizations.raceDurationShort;
    case MapLength.medium:
      return localizations.raceDurationMedium;
    case MapLength.long:
      return localizations.raceDurationLong;
    case MapLength.veryLong:
      return localizations.raceDurationVeryLong;
  }
}
