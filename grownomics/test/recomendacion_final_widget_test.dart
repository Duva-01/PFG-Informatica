import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grownomics/paginas/Analisis/widgets/recomendacionFinalWidget.dart';

void main() {
  group('RecomendacionFinalWidget Tests', () {
    // Test para verificar la estructura y contenido básico del widget
    testWidgets('Estructura básica y contenido del widget', (WidgetTester tester) async {
      // Definir datos de prueba para pasar al widget
      final simboloAccionTest = 'AAPL';
      final correoElectronicoTest = 'correo@test.com';

      // Cargar el widget en el árbol de widgets de prueba
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: RecomendacionFinalWidget(
            simboloAccion: simboloAccionTest,
            correoElectronico: correoElectronicoTest,
          ),
        ),
      ));

      // Simular la carga de datos para el test
      await tester.pumpAndSettle();

      // Verificar la presencia de textos y elementos clave basados en los datos de prueba
      expect(find.text('Recomendación final'), findsOneWidget);
      expect(find.text(simboloAccionTest), findsWidgets); // Podría aparecer más de una vez
      // Verifica la presencia de los iconos esperados
      expect(find.byIcon(Icons.attach_money), findsOneWidget);
      expect(find.byIcon(Icons.monetization_on), findsOneWidget);

      // Verificar la presencia de texto para "Precio ideal de compra" y "Precio ideal de venta"
      // Nota: Los siguientes finders son solo ejemplos. Ajusta estos según cómo renderizas esos valores específicamente.
      expect(find.textContaining('Precio ideal de compra'), findsOneWidget);
      expect(find.textContaining('Precio ideal de venta'), findsOneWidget);
    });
  });
}
