import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Fondo del sitio: papel con una retícula de puntos y un halo suave.
///
/// Se pinta detrás del contenido de cada página. También lo usa la transición
/// para que el fondo opaco que tapa la pantalla anterior sea exactamente el
/// mismo y no se note el cambio.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return CustomPaint(
      painter: _DotGridPainter(
        paper: palette.paper,
        dot: palette.dot,
        glow: palette.violet,
      ),
      child: child,
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter({
    required this.paper,
    required this.dot,
    required this.glow,
  });

  final Color paper;
  final Color dot;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = paper);

    final dotPaint = Paint()..color = dot;
    const step = 28.0;
    for (double x = 14; x < size.width; x += step) {
      for (double y = 14; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.15, dotPaint);
      }
    }

    final haloRect = Rect.fromCircle(
      center: Offset(size.width * 0.88, -40),
      radius: size.width * 0.55,
    );
    final halo = Paint()
      ..shader = RadialGradient(
        colors: [
          glow.withAlpha(28),
          glow.withAlpha(0),
        ],
      ).createShader(haloRect);
    canvas.drawRect(Offset.zero & size, halo);
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) {
    return oldDelegate.paper != paper ||
        oldDelegate.dot != dot ||
        oldDelegate.glow != glow;
  }
}
