import 'package:flutter/material.dart';
import 'package:grownomics/loadingPage.dart';
import 'package:grownomics/logins/registerPage.dart';
import 'package:grownomics/paginas/inicio.dart';
import 'package:grownomics/logins/loginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,  // Color primario verde
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        // Ruta inicial que muestra la página de LoadingPage.
        '/': (context) => LoadingPage(),

        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        // Ruta '/home' que muestra la página MyHomeScreen.
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

