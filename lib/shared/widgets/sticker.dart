import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Etiqueta tipo pegatina: borde de tinta, color plano y una pizca de giro.
class Sticker extends StatelessWidget {
  const Sticker({
    super.key,
    required this.label,
    this.color,
    this.angle = -3,
    this.icon,
  });

  final String label;
  final Color? color;
  final double angle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final background = color ?? palette.sun;
    // Las pegatinas siempre tienen fondo claro (sol, menta, coral…), así que
    // en modo oscuro el texto por defecto (claro) no contrasta. Se elige un
    // color de texto oscuro cuando el fondo es claro, y claro cuando es oscuro.
    // Umbral 0.4 (no 0.5): el azul clarito (sky) tiene luminancia ~0.49,
    // así que con 0.5 se quedaba con texto claro y no contrastaba.
    final textColor = background.computeLuminance() > 0.4
        ? const Color(0xFF1B1730)
        : palette.ink;

    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: palette.line, width: 2),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              offset: const Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: textColor),
              const SizedBox(width: 6),
            ],
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
