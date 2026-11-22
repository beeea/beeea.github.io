import 'package:beatriz_portfolio/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

bool overlaps(Rect a, Rect b) =>
    a.left < b.right && a.right > b.left && a.top < b.bottom && a.bottom > b.top;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('el hero no tapa texto ni recorta la foto en ningún ancho',
      (WidgetTester tester) async {
    for (final width in <double>[
      320, 375, 600, 900, 948, 1000, 1100, 1199, 1200, 1300, 1339, 1340, 1400, 1600
    ]) {
      await tester.binding.setSurfaceSize(Size(width, 1000));
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(size: Size(width, 1000)),
              child: child!,
            ),
            home: const Scaffold(body: HomePage()),
          ),
        ),
      );
      // La carga de assets es I/O real: dejar girar el event loop.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      // Hay animaciones repetitivas: pumpAndSettle no converge.
      for (var frame = 0; frame < 12; frame++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      final photo = find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.image is AssetImage &&
            (w.image as AssetImage).assetName.contains('bea-portrait'),
      );
      final title = find.text('Hola, soy Bea Barber');
      final kicker = find.text('[ MOBILE SOFTWARE ENGINEER ]');

      expect(photo, findsOneWidget, reason: 'falta la foto del hero a ${width.toInt()}px');
      expect(title, findsOneWidget, reason: 'falta el título a ${width.toInt()}px');

      final photoRect = tester.getRect(photo);
      final titleRect = tester.getRect(title);
      final kickerRect = tester.getRect(kicker.first);

      expect(overlaps(photoRect, titleRect), isFalse,
          reason: 'la foto tapa el título a ${width.toInt()}px');
      expect(overlaps(photoRect, kickerRect), isFalse,
          reason: 'la foto tapa el kicker a ${width.toInt()}px');
      expect(photoRect.left, greaterThanOrEqualTo(0),
          reason: 'la foto se corta por la izquierda a ${width.toInt()}px');
      expect(photoRect.right, lessThanOrEqualTo(width),
          reason: 'la foto se corta por la derecha a ${width.toInt()}px');

      await tester.pumpWidget(const SizedBox.shrink());
    }
    await tester.binding.setSurfaceSize(null);
  });
}
