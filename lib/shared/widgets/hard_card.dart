import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Tarjeta con borde de tinta y sombra dura, en la línea del resto del sitio.
///
/// Si recibe [onTap] se comporta como un enlace: cambia el cursor y se levanta
/// ligeramente al pasar por encima.
class HardCard extends StatefulWidget {
  const HardCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.color,
    this.radius = 20,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double radius;
  final VoidCallback? onTap;

  @override
  State<HardCard> createState() => _HardCardState();
}

class _HardCardState extends State<HardCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final interactive = widget.onTap != null;
    final lifted = interactive && _hovered;

    return MouseRegion(
      cursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(
            lifted ? -3 : 0,
            lifted ? -3 : 0,
            0,
          ),
          padding: widget.padding,
          // Recorta el contenido al borde redondeado: si no, las cabeceras
          // de color (por ejemplo la del ticket del perfil) asoman por las
          // esquinas y se salen de la tarjeta.
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: widget.color ?? palette.surface,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: palette.line, width: 2),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                offset: Offset(lifted ? 9 : 5, lifted ? 9 : 5),
                blurRadius: 0,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
