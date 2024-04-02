import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grownomics/paginas/Home/Widgets/balanceWidget.dart';

void main() {
  group('BalanceCard Widget Tests', () {
    testWidgets('BalanceCard muestra los valores por defecto correctamente',
        (WidgetTester tester) async {
      // Carga el widget en el árbol de widgets de pruebas con un correo no válido
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BalanceCard(
            userEmail: 'correo_no_valido@example.com',
          ),
        ),
      ));

      // Simula la carga de datos
      await tester.pumpAndSettle();

      // Define los valores por defecto esperados
      final saldoEsperado = '0.00€';
      final totalDepositadoEsperado = '0.00€';
      final totalRetiradoEsperado = '0.00€';
      final totalTransaccionesEsperado = '0';

      // Verifica que los textos esperados están en el árbol de widgets
      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.data!.contains(saldoEsperado) &&
              widget.style!.fontSize ==
                  30, // Asumiendo que el saldo se muestra con tamaño de fuente 30
        ),
        findsOneWidget,
      );
      expect(find.text('Balance Actual'), findsOneWidget);
    });
  });
}
