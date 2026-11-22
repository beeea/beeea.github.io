import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Botón con borde grueso y sombra dura que se hunde al pulsarlo.
///
/// Material no permite animar la sombra desde un `ButtonStyle`, así que el
/// estado de hover y pulsación se pinta aquí.
class ChunkyButton extends StatefulWidget {
  const ChunkyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ChunkyVariant.primary,
    this.dense = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ChunkyVariant variant;
  final bool dense;

  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

enum ChunkyVariant { primary, outline, lilac }

class _ChunkyButtonState extends State<ChunkyButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final disabled = widget.onPressed == null;

    final (background, foreground) = switch (widget.variant) {
      ChunkyVariant.primary => (
          palette.violet,
          theme.brightness == Brightness.dark
              ? palette.paper
              : const Color(0xFFFFFBF2),
        ),
      ChunkyVariant.outline => (palette.surface, palette.ink),
      ChunkyVariant.lilac => (palette.lilac, palette.ink),
    };

    final offset = _pressed ? 1.0 : (_hovered ? 6.5 : 4.0);
    final lift = _pressed ? 1.0 : (_hovered ? -2.0 : 0.0);

    return MouseRegion(
      cursor: disabled ? MouseCursor.defer : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
        onTapCancel: disabled ? null : () => setState(() => _pressed = false),
        onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(lift, lift, 0),
          decoration: BoxDecoration(
            color: disabled ? palette.lilac : background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.line, width: 2),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                offset: Offset(offset, offset),
                blurRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onPressed,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.dense ? 14 : 20,
                  vertical: widget.dense ? 10 : 14,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon,
                          size: widget.dense ? 15 : 17,
                          color: disabled ? palette.inkSoft : foreground),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: disabled ? palette.inkSoft : foreground,
                        fontSize: widget.dense ? 12 : 14,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
