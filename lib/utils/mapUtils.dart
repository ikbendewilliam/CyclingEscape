import 'dart:math';
import 'dart:ui';

import 'package:CyclingEscape/components/data/playSettings.dart';
import 'package:CyclingEscape/components/positions/gameMap.dart';
import 'package:CyclingEscape/components/positions/sprint.dart';

import '../components/positions/position.dart';

class MapUtils {
  final PositionListener listener;
  int currentSegment = 0;
  int fieldValue = 0;
  double currentAngle = 0;
  double jOffset = 0;
  Offset currentPosition;
  Sprint nextSprint;
  PositionType currentPositionType = PositionType.FLAT;
  List<Sprint> sprints = [];
  List<Position> mapPositions;

  MapUtils(this.listener, this.currentPosition) {
    mapPositions = [];
  }

  void moveWithoutAdding(Offset offset, double jOffset) {
    this.currentPosition += offset;
    this.jOffset += jOffset;
  }

  void addSprint(int width, SprintType type) {
    Sprint sprint =
        Sprint(type, currentPosition, width, -currentAngle, currentSegment++);
    sprints.add(sprint);
    this.moveWithoutAdding(Offset(cos(currentAngle), sin(currentAngle)) / 3, 0);
    nextSprint = sprint;
  }

  void addStraight(int length, int width, {bool reverseJ: false}) {
    List<Position> positions = [];
    double dx = 2;
    double dy = 2;
    for (int i = 0; i < length; i++) {
      for (int j = 0; j < width; j++) {
        int jAccent = reverseJ ? width - j - 1 : j;
        double fieldValue = 0;
        Offset p1 = Offset(
            currentPosition.dx +
                dx * i * cos(currentAngle) +
                dx * (j / 2) * cos(currentAngle + pi / 2),
            currentPosition.dy +
                dy * i * sin(currentAngle) +
                dy * (j / 2) * sin(currentAngle + pi / 2));
        switch (currentPositionType) {
          case PositionType.COBBLE:
            String t = (p1.dx * p1.dy / 61667).toString();
            int x =
                int.parse(t.toString().substring(t.length - 6, t.length - 5));
            fieldValue = x < 4 ? -1 : (x < 7 ? -2 : (x < 9 ? -3 : -4));
            break;
          case PositionType.UPHILL:
            fieldValue = -this.fieldValue + 0.0;
            break;
          case PositionType.DOWNHILL:
            fieldValue = this.fieldValue + 0.0;
            break;
          default:
            fieldValue = 0;
        }
        positions.add(new Position(
            p1,
            Offset(
                currentPosition.dx +
                    (dx * (i + 1)) * cos(currentAngle) +
                    dx * (j / 2) * cos(currentAngle + pi / 2),
                currentPosition.dy +
                    (dy * (i + 1)) * sin(currentAngle) +
                    dy * (j / 2) * sin(currentAngle + pi / 2)),
            listener,
            i == length - 1,
            currentSegment,
            i * 1.0,
            i / length * 100,
            jAccent + jOffset,
            0,
            0,
            false,
            currentPositionType,
            fieldValue: fieldValue,
            sprint: nextSprint));
      }
      nextSprint = null;
    }
    currentPosition += Offset(
        dx * length * cos(currentAngle), dy * length * sin(currentAngle));
    currentSegment++;
    mapPositions.addAll(positions);
  }

  void addCorner(double deltaAngle, int width, double radius) {
    List<Position> positions = [];
    double endAngle = currentAngle + deltaAngle;
    bool clockwise = deltaAngle < 0;
    for (int j = 0; j < width; j++) {
      int jAccent = clockwise ? width - j - 1 : j;
      Offset segmentStart = currentPosition +
          Offset(-j * sin(currentAngle), j * cos(currentAngle));
      positions.addAll(_addCornerSegment(
          segmentStart,
          currentAngle + (clockwise ? pi : 0),
          endAngle + (clockwise ? pi : 0),
          radius - jAccent,
          clockwise,
          currentSegment,
          j + jOffset));
    }
    nextSprint = null;
    double radiusAccent = radius - (clockwise ? width - 1 : 0);
    currentPosition += Offset(radiusAccent * cos(currentAngle - pi / 2),
            radiusAccent * sin(currentAngle - pi / 2)) *
        (clockwise ? 1 : -1);
    currentPosition += Offset(radiusAccent * cos(endAngle - pi / 2),
            radiusAccent * sin(endAngle - pi / 2)) *
        (clockwise ? -1 : 1);
    currentSegment++;
    currentAngle = endAngle;
    mapPositions.addAll(positions);
  }

  List<Position> _addCornerSegment(Offset start, double startAngle,
      double endAngle, double radius, bool clockwise, int segment, double j) {
    List<Position> positions = [];
    double length = radius * (startAngle - endAngle).abs();
    int numberOfPositions = (length / 2).floor();
    double centerAngle = (startAngle + endAngle) / 2;
    double maxAngle = (startAngle - centerAngle).abs();
    double istart = -(numberOfPositions % 2) / 2 + 0.5;
    Offset centerOfCorner;
    centerOfCorner =
        start + Offset(-radius * sin(startAngle), radius * cos(startAngle));
    double imax = (numberOfPositions / 2);
    for (double i = istart; i < imax; i++) {
      for (int k = -1; (k <= 1 && i > 0) || (k == -1 && i == 0); k += 2) {
        double startAngle2 =
            centerAngle + maxAngle * (i + 0.5) * k / (numberOfPositions / 2);
        double angle = centerAngle + maxAngle * i * k / (numberOfPositions / 2);
        Offset center =
            centerOfCorner + Offset(radius * sin(angle), -radius * cos(angle));
        Offset offset = Offset(cos(angle), sin(angle)) *
            length /
            2 /
            numberOfPositions.toDouble();
        Offset p1 = center + offset * k.toDouble();
        Offset p2 = center - offset * k.toDouble();

        if (!clockwise) {
          // For text purposes
          p1 = center + offset * k.toDouble();
          p2 = center - offset * k.toDouble();
        }
        int iAccent;
        if (istart == 0.5) {
          iAccent = (numberOfPositions / 2).floor() -
              k * i.ceil() +
              (k == -1 ? -1 : 0);
        } else {
          iAccent = (numberOfPositions / 2).floor() - i.floor() * k;
        }
        if (!clockwise) {
          iAccent = numberOfPositions - iAccent - 1;
        }
        double fieldValue = 0;
        switch (currentPositionType) {
          case PositionType.COBBLE:
            String t = (p1.dx * p1.dy / 61667).toString();
            int x =
                int.parse(t.toString().substring(t.length - 6, t.length - 5));
            fieldValue = x < 4 ? -1 : (x < 7 ? -2 : (x < 9 ? -3 : -4));
            break;
          case PositionType.UPHILL:
            fieldValue = -this.fieldValue + 0.0;
            break;
          case PositionType.DOWNHILL:
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
            iAccent / numberOfPositions * 100,
            j,
            (startAngle2 + pi * 2) % (pi * 2),
            radius,
            true,
            currentPositionType,
            curvature: numberOfPositions,
            fieldValue: fieldValue,
            sprint: i < 1 ? nextSprint : null));
      }
    }
    return positions;
  }

  void setPositionType(PositionType positionType, [int fieldValue]) {
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
    List<List<Position>> segments = new List();
    positions.forEach((element) {
      if (segments.length == 0) {
        segments.add([element]);
      } else {
        List<Position> segment = segments.firstWhere(
            (a) =>
                a.firstWhere((b) => b.segment == element.segment,
                    orElse: () => null) !=
                null,
            orElse: () => null);
        if (segment != null) {
          segment.add(element);
        } else {
          segments.add([element]);
        }
      }
    });
    segments.forEach((segment) {
      int segmentId = segment.first.segment;
      List<Position> nextSegment = segments.firstWhere(
          (a) =>
              a.first.segment == segmentId + 1 ||
              (a.first.segment == segmentId + 2 && a.first.sprint != null),
          orElse: () => null);
      List<Position> nextSegmentPositions = new List();
      if (nextSegment != null) {
        nextSegmentPositions =
            nextSegment.where((position) => position.i == 0).toList();
      }
      segment.forEach((position) {
        if (position.isLast) {
          position.connections = nextSegmentPositions
              .where((element) => (element.j - position.j).abs() <= 1)
              .toList();
        } else {
          position.connections = segment
              .where((element) =>
                  (((position.isCurved &&
                          (element.curvature == position.curvature) &&
                          (element.j - position.j).abs() <= 1)) ||
                      (!position.isCurved &&
                          (element.j - position.j).abs() <= 1)) &&
                  (element.i == position.i + 1))
              .toList();
        }
      });
    });
  }

  static bool isInside(
      Offset point, Offset p1, Offset p2, double width, double angle) {
    Offset center = (p1 + p2) / 2;
    Offset rotatedPoint = rotatePoint(point - center, -angle);
    Offset rotatedPoint1 = rotatePoint(p1 - center, -angle);
    Offset rotatedPoint2 = rotatePoint(p2 - center, -angle);
    return isInsideLine(rotatedPoint, rotatedPoint1, rotatedPoint2, width);
  }

  static bool isInsideLine(Offset point, Offset p1, Offset p2, double width) {
    return point.dx >= p1.dx &&
        point.dx <= p2.dx &&
        point.dy >= -width / 2 &&
        point.dy <= width / 2;
  }

  static bool isInsideRect(Offset point, Offset p1, Offset p2) {
    return point.dx >= p1.dx &&
        point.dx <= p2.dx &&
        point.dy >= p1.dy &&
        point.dy <= p2.dy;
  }

  static Offset rotatePoint(localPoint, angle) {
    return Offset(localPoint.dx * cos(angle) - localPoint.dy * sin(angle),
        localPoint.dy * cos(angle) + localPoint.dx * sin(angle));
  }

  static List<Sprint> getSprintsBetween(Position from, Position to,
      [List<Sprint> currentSprints]) {
    if (currentSprints == null) {
      currentSprints = [];
    }
    if (from.sprint != null && currentSprints.indexOf(from.sprint) == -1) {
      currentSprints.add(from.sprint);
    }
    if (to.segment - from.segment >= 2) {
      return getSprintsBetween(from.connections.first, to, currentSprints);
    }
    return currentSprints;
  }

  static findPlaceBefore(Position position, double maxDepth, bool emptyPosition,
      {List<Position> positions, Position startPosition, int currentDepth}) {
    if (currentDepth == null) {
      currentDepth = 0;
    } else if (currentDepth > maxDepth) {
      return null;
    }
    if (startPosition == null) {
      Position positionFound;
      positions.forEach((element) {
        if (element.connections.length > 0 &&
            element.connections.indexOf(position) >= 0 &&
            element.j == position.j) {
          positionFound = element;
        }
      });
      return positionFound;
    } else {
      Position currentPosition = startPosition;
      if (currentPosition.connections.length > 0 &&
          currentPosition.getValue(false) < position.getValue(false)) {
        if (currentPosition.connections.indexOf(position) >= 0 &&
            currentPosition.j == position.j) {
          return currentPosition;
        } else {
          for (int i = 0; i < currentPosition.connections.length; i++) {
            if (currentPosition.connections[i].cyclist == null ||
                !emptyPosition) {
              Position placeBefore = findPlaceBefore(
                  position, maxDepth, emptyPosition,
                  startPosition: currentPosition.connections[i],
                  currentDepth: currentDepth + 1);
              if (placeBefore != null) {
                return placeBefore;
              }
            }
          }
        }
      }
    }
    return null;
  }

  static Position findMaxValue(Position currentPosition, double maxValue,
      [int currentValue]) {
    if (currentValue == null) {
      currentValue = 0;
    } else if (currentValue > maxValue) {
      return null;
    }
    if (currentPosition.connections.length > 0) {
      if (currentValue >= maxValue) {
        double bestValue = 0;
        Position bestPosition;
        currentPosition.connections.forEach((element) {
          if (element.cyclist == null &&
              (bestPosition == null || element.getValue(false) > bestValue)) {
            bestValue = element.getValue(false);
            bestPosition = element;
          }
        });
        return (bestPosition != null) ? bestPosition : currentPosition;
      } else {
        double bestValue = 0;
        Position bestPosition;
        for (int i = 0; i < currentPosition.connections.length; i++) {
          if (currentPosition.connections[i].cyclist == null) {
            Position maxValuePosition = findMaxValue(
                currentPosition.connections[i], maxValue, currentValue + 1);
            if (maxValuePosition != null &&
                (bestPosition == null ||
                    maxValuePosition.getValue(false) > bestValue)) {
              bestValue = maxValuePosition.getValue(false);
              bestPosition = maxValuePosition;
            }
          }
        }
        return (bestPosition != null) ? bestPosition : currentPosition;
      }
    }
    return currentPosition;
  }

  // minDistance is used for when you don't move your max potential (for example taking the outer edge of a corner) so more riders can follow
  static double calculateDistance(Position start, Position end,
      {double currentDistance, double minDistance}) {
    if (minDistance == null) {
      minDistance = -1;
    }
    if (currentDistance == null) {
      currentDistance = 0;
    }
    if (start == end) {
      return currentDistance;
    } else if (start.getValue(false) > end.getValue(false)) {
      return 9999;
    } else {
      double shortestDistance = 9999;
      start.connections.forEach((element) {
        double distance = calculateDistance(element, end,
            currentDistance: currentDistance + 1, minDistance: minDistance);
        if (distance < shortestDistance) {
          shortestDistance = distance;
        }
      });
      return max(shortestDistance, minDistance);
    }
  }

  static GameMap generateMap(PlaySettings playSettings, listener) {
    MapUtils newMap = new MapUtils(listener, Offset(0, 4));

    newMap.addStraight(playSettings.ridersPerTeam, max(playSettings.teams, 3));
    newMap.addSprint(max(playSettings.teams, 3), SprintType.START);

    int width = max(playSettings.teams, 3);
    int minLength = 3;
    int maxLength = 8;
    int minWidth = 3;
    int maxWidth = 8;
    double angle = 0;
    List<double> angles = [pi / 4, pi / 3];
    double minAngle = -pi / 2;
    double maxAngle = pi / 2;
    int segmentLength;
    switch (playSettings.mapLength) {
      case MapLength.SHORT:
        segmentLength = 15;
        break;
      case MapLength.MEDIUM:
        segmentLength = 30;
        break;
      case MapLength.LONG:
        segmentLength = 45;
        break;
      case MapLength.VERY_LONG:
        segmentLength = 60;
        break;
    }
    PositionType positionType = PositionType.FLAT;
    int fieldValue;

    for (int i = 0; i < segmentLength; i++) {
      if (Random().nextDouble() > 0.9) {
        double change = Random().nextBool() ? -1 : 1;
        width += change.floor();
        if (width > maxWidth || width < minWidth) {
          change = -change;
          width = width + 2 * change.floor();
        }
        newMap.moveWithoutAdding(
            Offset(sin(angle), -cos(angle)) * change / 2, -change / 2);
      }
      if (fieldValue != null && (i % 2 == 0 || fieldValue >= 4)) {
        if (positionType == PositionType.UPHILL) {
          fieldValue++;
          if (fieldValue > 5) {
            fieldValue = 5;
            positionType = PositionType.DOWNHILL;
            newMap.addSprint(width, SprintType.MOUNTAIN_SPRINT);
          }
        } else {
          fieldValue--;
          if (fieldValue <= 0) {
            positionType =
                Random().nextBool() && playSettings.mapType == MapType.HEAVY
                    ? PositionType.COBBLE
                    : PositionType.FLAT;
            fieldValue = null;
          }
        }
        newMap.setPositionType(positionType, fieldValue);
      }
      if (Random().nextBool()) {
        // Is straight
        int length = Random().nextInt(maxLength - minLength) + minLength;
        newMap.addStraight(length, width);
      } else {
        int radius = Random().nextInt(4) + 6 + (width / 2).ceil();
        int a = Random().nextBool() ? -1 : 1;
        int angleIndex = Random().nextInt(angles.length);
        double deltaAngle = angles[angleIndex];
        if (angle + deltaAngle * a > maxAngle ||
            angle + deltaAngle * a < minAngle) {
          a = -a;
        }
        angle += deltaAngle * a;
        newMap.addCorner(deltaAngle * a, width, radius + 0.0);
      }
      if (i % 7 == 0 &&
          i < segmentLength * 0.8 &&
          i > segmentLength * 0.2 &&
          Random().nextDouble() < 0.3 &&
          positionType != PositionType.UPHILL) {
        newMap.addSprint(width, SprintType.SPRINT);
      }
      if (playSettings.mapType != MapType.FLAT &&
          i % 3 == 0 &&
          Random().nextDouble() < 0.2) {
        switch (positionType) {
          case PositionType.FLAT:
            positionType = (Random().nextBool() &&
                        playSettings.mapType == MapType.HEAVY) ||
                    playSettings.mapType == MapType.HILLS
                ? PositionType.UPHILL
                : PositionType.COBBLE;
            break;
          case PositionType.UPHILL:
            positionType = PositionType.DOWNHILL;
            if (i < segmentLength * 0.8 &&
                i > segmentLength * 0.2 &&
                Random().nextDouble() < 0.7) {
              newMap.addSprint(width, SprintType.MOUNTAIN_SPRINT);
            }
            break;
          case PositionType.COBBLE:
            positionType = (Random().nextBool() &&
                        playSettings.mapType == MapType.HEAVY) ||
                    playSettings.mapType == MapType.HILLS
                ? PositionType.UPHILL
                : PositionType.FLAT;
            break;

          case PositionType.DOWNHILL:
          default:
          // On Downhill do nothing
        }
        if (positionType == PositionType.UPHILL) {
          fieldValue = 1;
        } else if (positionType != PositionType.DOWNHILL) {
          fieldValue = null;
        }
        newMap.setPositionType(positionType, fieldValue);
      }
    }

    newMap.addSprint(width, SprintType.FINISH);
    newMap.addStraight(12, width);
    List<Position> positions = newMap.generatePositions();
    GameMap map = GameMap(positions, newMap.sprints);

    return map;
  }

  static GameMap generateFlatMap(listener) {
    MapUtils newMap = new MapUtils(listener, Offset(0, 4));
    newMap.addCorner(pi / 4, 4, 8);
    newMap.addStraight(4, 4);
    newMap.addSprint(4, SprintType.START);
    newMap.addCorner(-pi / 2, 4, 8);
    newMap.addCorner(pi / 3, 4, 8);
    newMap.addCorner(-pi / 2, 4, 8);
    newMap.addCorner(pi / 3, 4, 8);
    newMap.addSprint(4, SprintType.FINISH);
    newMap.addStraight(8, 4);

    List<Position> positions = newMap.generatePositions();
    GameMap map = GameMap(positions, newMap.sprints);

    return map;
  }

  static GameMap generateCobbleMap(listener) {
    MapUtils newMap = new MapUtils(listener, Offset(0, 4));
    newMap.addStraight(4, 4);
    newMap.addSprint(4, SprintType.START);
    newMap.addStraight(17, 4);
    newMap.addCorner(pi / 2, 4, 8);
    newMap.addCorner(pi / 2, 4, 8);
    newMap.setPositionType(PositionType.COBBLE);
    newMap.addStraight(8, 4);
    newMap.addCorner(-pi, 4, 6);
    newMap.addStraight(18, 4);
    newMap.addCorner(-pi / 4, 4, 10);
    newMap.addStraight(4, 4);
    newMap.addSprint(4, SprintType.SPRINT);
    newMap.addStraight(4, 4);
    newMap.addCorner(pi / 4, 4, 10);
    newMap.setPositionType(PositionType.FLAT);
    newMap.addStraight(7, 4);
    newMap.addCorner(pi / 2, 4, 10);
    newMap.addStraight(7, 4);
    newMap.addCorner(pi / 2, 4, 10);
    newMap.addStraight(7, 4);
    newMap.setPositionType(PositionType.COBBLE);
    newMap.addStraight(17, 4);
    newMap.setPositionType(PositionType.FLAT);
    newMap.addStraight(8, 4);
    newMap.addSprint(4, SprintType.FINISH);
    newMap.addStraight(8, 4);

    List<Position> positions = newMap.generatePositions();
    GameMap map = GameMap(positions, newMap.sprints);

    return map;
  }

  static GameMap generateMountainMap(listener) {
    MapUtils newMap = new MapUtils(listener, Offset(0, 4));
    newMap.addStraight(4, 4);
    newMap.addSprint(4, SprintType.START);
    newMap.addCorner(pi / 2, 4, 8);
    newMap.addStraight(3, 4);
    newMap.moveWithoutAdding(Offset(-0.5, 0), 0.5);
    newMap.setPositionType(PositionType.UPHILL, 1);
    newMap.addStraight(3, 3);
    newMap.addCorner(pi / 4, 3, 6);
    newMap.addCorner(-pi / 2, 3, 9);
    newMap.setPositionType(PositionType.UPHILL, 2);
    newMap.addCorner(-pi / 2, 3, 9);
    newMap.addStraight(2, 3);
    newMap.moveWithoutAdding(Offset(0.5, 0.5), 0.5);
    newMap.setPositionType(PositionType.UPHILL, 3);
    newMap.addCorner(pi / 2, 2, 6);
    newMap.setPositionType(PositionType.UPHILL, 4);
    newMap.addStraight(3, 2);
    newMap.addCorner(-pi, 2, 6);
    newMap.setPositionType(PositionType.UPHILL, 5);
    newMap.addCorner(pi * 3 / 4, 2, 4);
    newMap.addStraight(1, 2);
    newMap.addSprint(2, SprintType.MOUNTAIN_SPRINT);
    newMap.setPositionType(PositionType.DOWNHILL, 5);
    newMap.addStraight(2, 2);
    newMap.addCorner(-pi, 2, 4);
    newMap.setPositionType(PositionType.DOWNHILL, 4);
    newMap.addStraight(8, 3);
    newMap.addCorner(pi / 2, 3, 6);
    newMap.setPositionType(PositionType.DOWNHILL, 3);
    newMap.addCorner(pi / 2, 3, 8);
    newMap.addStraight(5, 3);
    newMap.setPositionType(PositionType.DOWNHILL, 2);
    newMap.addStraight(8, 4);
    newMap.addCorner(pi / 2, 4, 10);
    newMap.setPositionType(PositionType.DOWNHILL, 1);
    newMap.addStraight(10, 4);
    newMap.setPositionType(PositionType.FLAT);
    newMap.addCorner(-pi / 2, 4, 10);
    newMap.addStraight(4, 4);
    newMap.addStraight(6, 4);
    newMap.addCorner(-pi / 4, 4, 10);
    newMap.addStraight(8, 4);
    newMap.addCorner(pi / 4, 4, 10);
    newMap.addStraight(18, 4);
    newMap.addSprint(4, SprintType.FINISH);
    newMap.addStraight(12, 4);

    List<Position> positions = newMap.generatePositions();
    GameMap map = GameMap(positions, newMap.sprints);

    return map;
  }
}

enum MapType { FLAT, COBBLE, HILLS, HEAVY }
enum MapLength { SHORT, MEDIUM, LONG, VERY_LONG }
