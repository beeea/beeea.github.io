import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'core/platform/web_semantics.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // URLs reales, sin '#': /proyectos/estanteria en vez de /#/proyectos/estanteria.
  // Sin esto Flutter Web usa la estrategia con hash, go_router lee la ruta
  // inicial como '/' y cualquier enlace profundo acaba en la portada.
  usePathUrlStrategy();
  enableWebSemantics();
  runApp(const ProviderScope(child: BeatrizPortfolioApp()));
}
