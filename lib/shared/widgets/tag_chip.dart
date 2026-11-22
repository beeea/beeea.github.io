import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.highlighted = false,
    this.color,
  });

  final String label;
  final bool highlighted;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final background = color ?? (highlighted ? palette.lilac : palette.surface);
    // En modo oscuro los fondos claros (menta, sol, coral…) siguen siendo
    // claros, así que el texto debe ser oscuro para mantener el contraste.
    final textColor = background.computeLuminance() > 0.4
        ? const Color(0xFF1B1730)
        : palette.ink;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.line, width: 1.5),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          height: 1.2,
        ),
      ),
    );
  }
}
