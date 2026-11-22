import 'package:flutter/material.dart';

import '../../shared/widgets/app_background.dart';

/// Transición entre páginas: el contenido nuevo entra con un fundido, un
/// desplazamiento corto hacia arriba y un leve zoom.
///
/// Las páginas del proyecto son transparentes y el color lo pone el `Scaffold`
/// del shell. Al avanzar, el fondo (el mismo papel con puntos que se ve al
/// terminar) tapa la pantalla anterior desde el primer fotograma, que era la
/// causa de que se vieran las dos superpuestas. Al volver atrás se funde la
/// página entera para que la anterior aparezca de forma progresiva en lugar de
/// dejar un salto en blanco.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fade = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.1, 1, curve: Curves.easeOut),
      reverseCurve: const Interval(0, 1, curve: Curves.easeIn),
    );
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
    final scale = Tween<double>(begin: 0.985, end: 1).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    final content = FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: ScaleTransition(scale: scale, child: child),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        // Al volver atrás, el fondo se funde con la página para no dejar un
        // hueco del color de superficie antes de que la anterior aparezca.
        if (animation.status == AnimationStatus.reverse) {
          return content;
        }
        return AppBackground(child: content);
      },
    );
  }
}
