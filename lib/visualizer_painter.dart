import 'package:flutter/material.dart';

class VisualizerPainter extends CustomPainter {
  VisualizerPainter(this.data);

  final List<int> data;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    final width = size.width / data.length;

    for (var i = 0; i < data.length; i++) {
      final height = data[i] / data.length * size.height;

      canvas.drawRect(
        Rect.fromLTWH(width * i, size.height - height, width, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
