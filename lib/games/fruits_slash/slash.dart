import 'dart:collection';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Slash extends PositionComponent with CollisionCallbacks {
  ListQueue<Vector2> points = ListQueue();
  Paint paint;
  double duration;
  DateTime? firstPointTimestamp;
  int maxPoints;


  Slash({required List<Vector2> initialPoints, required this.paint, this.duration = 0.0001, this.maxPoints = 10}) {
    points.addAll(initialPoints);
    firstPointTimestamp = DateTime.now();

  }

  void addPoint(Vector2 point) {
    if (points.length >= maxPoints) {
      points.removeFirst();
    }
    points.add(point);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (firstPointTimestamp != null && DateTime.now().difference(firstPointTimestamp!).inMilliseconds > duration * 1000) {
      points.removeFirst();
      firstPointTimestamp = points.isNotEmpty ? DateTime.now() : null;
    }
  }

  @override
  void render(Canvas canvas) {
    if (points.length < 2) return;
    final path = Path()..moveTo(points.first.x, points.first.y);
    points.forEach((point) => path.lineTo(point.x, point.y));
    canvas.drawPath(path, paint);
  }
}
