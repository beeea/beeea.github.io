import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Separador discontinuo, como el de un ticket.
class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.height = 1.6,
    this.dash = 5,
    this.gap = 4,
    this.color,
  });

  final double height;
  final double dash;
  final double gap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashPainter(
          color: color ?? palette.line,
          dash: dash,
          gap: gap,
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter({
    required this.color,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.square;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + dash).clamp(0, size.width), size.height / 2),
        paint,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dash != dash ||
        oldDelegate.gap != gap;
  }
}
