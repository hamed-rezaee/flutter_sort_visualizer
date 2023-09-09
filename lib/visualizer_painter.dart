import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class VisualizerPainter extends CustomPainter {
  VisualizerPainter(this.data, [this.pointMode = PointMode.points]);

  final List<int> data;
  final PointMode pointMode;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 3
      ..color = Colors.orange
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final int minValue = data.reduce(min);
    final int maxValue = data.reduce(max);

    final double step = 2 * pi / data.length;

    final List<Offset> points = <Offset>[];

    for (int i = 0; i < data.length - 1; i++) {
      final double r = _normalize(data[i], minValue, maxValue);

      final double x = cos(i * step) * r * size.width / 2;
      final double y = sin(i * step) * r * size.height / 2;

      points.add(Offset(x, y));
    }

    canvas
      ..translate(size.width / 2, size.height / 2)
      ..drawPoints(pointMode, points, paint);
  }

  double _normalize(int value, int min, int max) => (value - min) / (max - min);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
