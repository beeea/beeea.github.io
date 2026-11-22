import 'package:flutter/material.dart';

/// Paleta del sitio: papel cálido, tinta oscura y acentos de marcador.
///
/// La misma estructura sirve para los dos modos, así que los widgets piden
/// colores con nombre (`ink`, `lilac`, `coral`…) en vez de repetir hex.
class AppPalette {
  const AppPalette({
    required this.paper,
    required this.surface,
    required this.ink,
    required this.inkSoft,
    required this.line,
    required this.violet,
    required this.lilac,
    required this.coral,
    required this.mint,
    required this.sky,
    required this.sun,
    required this.shadow,
    required this.dot,
  });

  final Color paper;
  final Color surface;
  final Color ink;
  final Color inkSoft;
  final Color line;
  final Color violet;
  final Color lilac;
  final Color coral;
  final Color mint;
  final Color sky;
  final Color sun;
  final Color shadow;
  final Color dot;

  static const AppPalette light = AppPalette(
    paper: Color(0xFFF8F3E9),
    surface: Color(0xFFFFFBF2),
    ink: Color(0xFF1B1730),
    inkSoft: Color(0xFF5B5573),
    line: Color(0xFF1B1730),
    violet: Color(0xFF5B4BE0),
    lilac: Color(0xFFDCD2FB),
    coral: Color(0xFFFF8A5B),
    mint: Color(0xFFA9E5C4),
    sky: Color(0xFF8CCBF7),
    sun: Color(0xFFFFD45C),
    shadow: Color(0x331B1730),
    dot: Color(0x1F1B1730),
  );

  static const AppPalette dark = AppPalette(
    paper: Color(0xFF121019),
    surface: Color(0xFF1C1928),
    ink: Color(0xFFF6F1E7),
    inkSoft: Color(0xFFAAA4BD),
    line: Color(0xFF413A5C),
    violet: Color(0xFF9C8BFF),
    lilac: Color(0xFF2C2645),
    coral: Color(0xFFFF9A70),
    mint: Color(0xFF7FD9A8),
    sky: Color(0xFF7CC0F5),
    sun: Color(0xFFF7C948),
    shadow: Color(0x99000000),
    dot: Color(0x24F6F1E7),
  );

  static AppPalette of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  /// Color de acento por tipo de proyecto. Se usa en etiquetas y detalles.
  Color forProjectType(String type) {
    return switch (type) {
      'Empresa' => sky,
      'Personal' => mint,
      'Académico' => sun,
      _ => coral,
    };
  }
}
