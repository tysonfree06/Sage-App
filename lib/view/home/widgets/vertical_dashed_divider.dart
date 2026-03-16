import 'package:flutter/material.dart';

class VerticalDashedDivider extends StatelessWidget {
  const VerticalDashedDivider({
    super.key,
    this.height = 100,
    this.dashHeight = 5,
    this.dashSpacing = 5,
    this.color = Colors.grey,
  });
  final double height;
  final double dashHeight;
  final double dashSpacing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _DashedLinePainter(
          dashHeight: dashHeight,
          dashSpacing: dashSpacing,
          color: color,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    required this.dashHeight,
    required this.dashSpacing,
    required this.color,
  });
  final double dashHeight;
  final double dashSpacing;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    double y = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashHeight), paint);
      y += dashHeight + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
