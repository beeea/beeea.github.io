import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/platform/web_semantics.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  enableWebSemantics();
  runApp(const ProviderScope(child: BeatrizPortfolioApp()));
}
