// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:flutter/material.dart';
// import 'package:grownomics/main.dart' as app;

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets("Inicio de sesión exitoso lleva al usuario a la pantalla principal", (WidgetTester tester) async {
//     app.main(); // Inicia tu aplicación
//     await tester.pumpAndSettle(); // Espera a que se complete la renderización inicial

//     // Ingresa credenciales válidas
//     await tester.enterText(find.byKey(Key('correoField')), 'david@gmail.com');
//     await tester.enterText(find.byKey(Key('contrasenaField')), 'clave123');
//     await tester.tap(find.byKey(Key('botonIniciarSesion')));
//     await tester.pumpAndSettle();

//     // Verifica que la pantalla principal se muestre después del inicio de sesión
//     expect(find.text('Bienvenido a la Pantalla Principal'), findsOneWidget);
//   });
// }
