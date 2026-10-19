import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modo de tema elegido por la persona que visita la web.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
