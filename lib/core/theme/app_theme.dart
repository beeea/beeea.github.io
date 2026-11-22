import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_page_transitions.dart';

class AppTheme {
  const AppTheme._();

  static const String displayFont = 'SpaceGrotesk';
  static const String bodyFont = 'Inter';
  static const String monoFont = 'JetBrainsMono';

  static ThemeData light() => _base(AppPalette.light, Brightness.light);

  static ThemeData dark() => _base(AppPalette.dark, Brightness.dark);

  static ThemeData _base(AppPalette palette, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: palette.violet,
      brightness: brightness,
    ).copyWith(
      primary: palette.violet,
      onPrimary: brightness == Brightness.dark
          ? palette.paper
          : const Color(0xFFFFFBF2),
      primaryContainer: palette.lilac,
      onPrimaryContainer: palette.ink,
      secondary: palette.coral,
      onSecondary: palette.ink,
      secondaryContainer: palette.lilac,
      onSecondaryContainer: palette.ink,
      surface: palette.paper,
      onSurface: palette.ink,
      surfaceContainerLow: palette.surface,
      surfaceContainer: palette.surface,
      surfaceContainerHigh: palette.surface,
      surfaceContainerHighest: palette.lilac,
      onSurfaceVariant: palette.inkSoft,
      outline: palette.line,
      outlineVariant: palette.line,
      shadow: palette.shadow,
    );

    final text = _textTheme(palette);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: bodyFont,
      scaffoldBackgroundColor: palette.paper,
      canvasColor: palette.paper,
      textTheme: text,
      primaryTextTheme: text,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.paper,
        surfaceTintColor: Colors.transparent,
        foregroundColor: palette.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 72,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: palette.line, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.line,
        thickness: 1.5,
        space: 32,
      ),
      iconTheme: IconThemeData(color: palette.ink),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.violet,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: bodyFont,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: palette.line, width: 2),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.ink,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          elevation: 0,
          side: BorderSide(color: palette.line, width: 2),
          textStyle: const TextStyle(
            fontFamily: bodyFont,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.ink,
          textStyle: const TextStyle(
            fontFamily: bodyFont,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: TextStyle(
          fontFamily: monoFont,
          fontSize: 12,
          letterSpacing: 0.4,
          color: palette.inkSoft,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: monoFont,
          fontSize: 12,
          letterSpacing: 0.4,
          color: palette.violet,
        ),
        hintStyle: TextStyle(color: palette.inkSoft),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.line, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.line, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.violet, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.coral, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.coral, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        elevation: 0,
        backgroundColor: palette.paper,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.lilac,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: monoFont,
            fontSize: 11,
            letterSpacing: 0.3,
            color: palette.ink,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? palette.violet
                : palette.inkSoft,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.ink,
        contentTextStyle: TextStyle(
          fontFamily: bodyFont,
          color: palette.paper,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(palette.violet),
        radius: const Radius.circular(8),
        thickness: const WidgetStatePropertyAll(6),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: AppPageTransitionsBuilder(),
          TargetPlatform.iOS: AppPageTransitionsBuilder(),
          TargetPlatform.macOS: AppPageTransitionsBuilder(),
          TargetPlatform.windows: AppPageTransitionsBuilder(),
          TargetPlatform.linux: AppPageTransitionsBuilder(),
          TargetPlatform.fuchsia: AppPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _textTheme(AppPalette palette) {
    final heading = TextStyle(
      fontFamily: displayFont,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.6,
      height: 1.05,
      color: palette.ink,
    );

    TextStyle body(double size, {double height = 1.6, FontWeight? weight}) {
      return TextStyle(
        fontFamily: bodyFont,
        fontSize: size,
        fontWeight: weight ?? FontWeight.w400,
        height: height,
        color: palette.ink,
      );
    }

    TextStyle mono(double size, {FontWeight weight = FontWeight.w400}) {
      return TextStyle(
        fontFamily: monoFont,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: 0.6,
        color: palette.inkSoft,
      );
    }

    return TextTheme(
      displayLarge: heading.copyWith(fontSize: 64),
      displayMedium: heading.copyWith(fontSize: 52),
      displaySmall: heading.copyWith(fontSize: 40),
      headlineLarge: heading.copyWith(fontSize: 34, letterSpacing: -0.4),
      headlineMedium: heading.copyWith(fontSize: 28, letterSpacing: -0.3),
      headlineSmall: heading.copyWith(fontSize: 23, letterSpacing: -0.2),
      titleLarge: heading.copyWith(fontSize: 20, height: 1.2),
      titleMedium: body(16, weight: FontWeight.w600, height: 1.4),
      titleSmall: body(14, weight: FontWeight.w600, height: 1.4),
      bodyLarge: body(17),
      bodyMedium: body(15),
      bodySmall: body(13, height: 1.5),
      labelLarge: body(14, weight: FontWeight.w600, height: 1.2),
      labelMedium: mono(12, weight: FontWeight.w600),
      labelSmall: mono(11),
    );
  }
}
