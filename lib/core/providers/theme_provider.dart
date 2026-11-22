import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modo de tema elegido por la persona que visita la web.
///
/// Por defecto se sigue la preferencia del sistema; el botón de la cabecera
/// permite cambiarlo y la elección dura lo que la pestaña, sin guardar nada.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
