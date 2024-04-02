import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grownomics/paginas/Cartera/widgets/balanceHistoryWidget.dart';

void main() {
  group('HistorialWidget Tests', () {
    testWidgets('Muestra los elementos UI esperados y cambia intervalos', (WidgetTester tester) async {
      // Renderiza el widget HistorialWidget en el árbol de widgets
      await tester.pumpWidget(MaterialApp(
        home: HistorialWidget(userEmail: 'test@example.com'),
      ));

      // Verifica la presencia de ciertos textos y elementos en la UI
      expect(find.text('Historial'), findsOneWidget);
      expect(find.text('1 Semana'), findsOneWidget);
      expect(find.text('1 mes'), findsOneWidget);
      expect(find.text('3 meses'), findsOneWidget);
      expect(find.text('1 año'), findsOneWidget);

      // Simula el tap en el botón "1 mes" para cambiar el intervalo
      await tester.tap(find.text('1 mes'));
      await tester.pumpAndSettle();
    });
  });
}
