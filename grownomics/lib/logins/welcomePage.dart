import 'package:flutter/material.dart'; // Importar el paquete flutter/material.dart para usar widgets de Flutter
import 'dart:math'; // Importar el paquete dart:math para usar funciones matemáticas

import 'package:grownomics/paginas/inicio.dart'; // Importar la página de inicio (asegúrate de tener el import correcto para HomeScreen)

// Widget de la página de bienvenida
class PaginaBienvenida extends StatefulWidget {
  @override
  _PaginaBienvenidaState createState() => _PaginaBienvenidaState();
}

class _PaginaBienvenidaState extends State<PaginaBienvenida> {
  @override
  Widget build(BuildContext context) {
    // Construir el scaffold de la página de bienvenida
    return Scaffold(
      body: Container(
        color: Colors.white, // Color de fondo blanco
        child: Padding(
          padding: EdgeInsets.all(20.0), // Espaciado interno de 20
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Alinear los elementos verticalmente al centro
            crossAxisAlignment: CrossAxisAlignment.stretch, // Alinear los elementos horizontalmente al estiramiento
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Color de fondo blanco
                    image: DecorationImage(
                      image: AssetImage("assets/images/grownomics_logo.png"), // Imagen de fondo del logo de Grownomics
                      fit: BoxFit.fitWidth, // Ajustar la imagen al ancho del contenedor
                    ),
                  ),
                ),
              ),
              Text(
                'Bienvenido a Grownomics', // Texto de bienvenida
                textAlign: TextAlign.center, // Alinear el texto al centro
                style: TextStyle(
                  fontSize: 24.0, // Tamaño de fuente 24
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
              Text(
                'El lugar para aprender y crecer económicamente', // Texto descriptivo
                textAlign: TextAlign.center, // Alinear el texto al centro
                style: TextStyle(
                  fontSize: 14.0, // Tamaño de fuente 14
                ),
              ),
              SizedBox(height: 20.0), // Espaciado vertical de 20
              // Botón para iniciar sesión
              ElevatedButton(
                child: Text('Iniciar sesión'), // Texto del botón de inicio de sesión
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/iniciar_sesion'); // Navegar a la página de inicio de sesión al presionar el botón
                },
              ),
              SizedBox(height: 10.0), // Espaciado vertical de 10
              // Botón para registrarse
              OutlinedButton(
                child: Text('Registrarse'), // Texto del botón de registro
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/registrar'); // Navegar a la página de registro al presionar el botón
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
