class MovingObject {
  final String asset;
  final double speed;
  final double horizontalOffset;
  final double topOffsetPercentage;
  final double scale;

  MovingObject({
    required this.asset,
    required this.speed,
    required this.horizontalOffset,
    required this.topOffsetPercentage,
    this.scale = 1,
  });
}
