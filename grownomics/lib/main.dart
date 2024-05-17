import 'package:flutter/material.dart';
import 'package:grownomics/loadingPage.dart';
import 'package:grownomics/logins/registerPage.dart';
import 'package:grownomics/logins/welcomePage.dart';
import 'package:grownomics/paginas/inicio.dart';
import 'package:grownomics/logins/loginPage.dart';
import 'package:grownomics/socketService.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:dcdg/dcdg.dart'; // Esto sirve para crearme los diagramas UML automaticamente


void main() async {
  // Nos aseguramos de que los widgets estan correctamente inicializados antes de ejecutar cualquier accion
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Definir el MaterialColor personalizado para el tema
    MaterialColor primarySwatch = const MaterialColor(
      0xFF2F8B62,
      <int, Color>{
        50: Color(0xFFE0F3EA),
        100: Color(0xFFB3DFCC),
        200: Color(0xFF82CBB0),
        300: Color(0xFF52B797),
        400: Color(0xFF34AE85),
        500: Color(0xFF2F8B62), // Color primario
        600: Color(0xFF287855),
        700: Color(0xFF216C4A),
        800: Color(0xFF1B5F3F),
        900: Color(0xFF124E2E),
      },
    );

    return MaterialApp(
      // Configurar el tema de la aplicación
      theme: ThemeData(
        primarySwatch: primarySwatch,
        primaryColor: Color(0xFF2F8B62),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      initialRoute: '/', // Ruta inicial de la aplicación
      routes: {
        // Definir rutas y asignar widgets a cada ruta
        // Ruta inicial que muestra la página de PaginaCarga.
        '/': (context) => PaginaCarga(),

        // Páginas de inicio de sesión y registro
        '/bienvenida': (context) => PaginaBienvenida(),
        '/iniciar_sesion': (context) => PaginaInicioSesion(),
        '/registrar': (context) => PaginaRegistro(),

        // Ruta '/home' que muestra la página PantallaInicio.
        '/home': (context) => PantallaInicio(),
      },
    );
  }
}
