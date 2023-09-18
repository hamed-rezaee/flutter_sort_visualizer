import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class VisualizerPainter extends CustomPainter {
  VisualizerPainter(this.data, [this.pointMode = PointMode.points]);

  final List<int> data;
  final PointMode pointMode;

  final Paint painter = Paint()
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final List<PointData> points = _converPolarToCartesian(size);

    for (final PointData point in points) {
      canvas.drawCircle(point.offset, 1, painter..color = point.color);
    }
  }

  List<PointData> _converPolarToCartesian(Size size) {
    final List<PointData> points = <PointData>[];

    final int minValue = data.reduce(min);
    final int maxValue = data.reduce(max);

    final double step = 24 * pi / data.length;

    for (int i = 0; i < data.length - 1; i++) {
      final double radius = _normalize(data[i], minValue, maxValue);

      final double x = cos(i * step) * radius * size.width / 2;
      final double y = sin(i * step) * radius * size.height / 2;

      points.add(PointData(Offset(x, y), _getHsvColor(radius)));
    }

    return points;
  }

  double _normalize(int value, int min, int max) => value / (max - min);

  Color _getHsvColor(double value) =>
      HSVColor.fromAHSV(1, 360 - value * 360, 1, 1).toColor();

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PointData {
  PointData(this.offset, this.color);

  final Offset offset;
  final Color color;
}
