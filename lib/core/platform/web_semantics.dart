import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';

/// En Flutter Web la semántica arranca desactivada hasta que el usuario
/// pulsa el botón "Enable accessibility". La activamos al inicio para que
/// lectores de pantalla y herramientas de accesibilidad funcionen desde
/// el primer render.
void enableWebSemantics() {
  if (!kIsWeb) return;
  SemanticsBinding.instance.ensureSemantics();
}
