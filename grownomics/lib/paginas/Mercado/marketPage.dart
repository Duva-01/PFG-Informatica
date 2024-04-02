import 'package:flutter/material.dart';
import 'package:grownomics/controladores/marketController.dart'; // Importación del archivo de API para obtener datos del mercado
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart'; // Importación de Flutter Zoom Drawer para el cajón de navegación
import 'package:grownomics/paginas/Mercado/Widgets/marketListWidget.dart'; // Importación del widget de lista de mercado
import 'package:shared_preferences/shared_preferences.dart'; // Importación de SharedPreferences para almacenar datos localmente

import 'stockPage.dart'; // Importación de la página de detalles de acciones

class PaginaMercado extends StatefulWidget {
  final String userEmail; // Correo electrónico del usuario
  PaginaMercado({required this.userEmail}); // Constructor con parámetro obligatorio

  @override
  _PaginaMercadoState createState() => _PaginaMercadoState();
}

class _PaginaMercadoState extends State<PaginaMercado> {
  @override
  Widget build(BuildContext context) {
    final controlador = ZoomDrawer.of(context); // Controlador para el cajón de navegación
    return Scaffold(
      appBar: AppBar(
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          'Cotizaciones',
          style: TextStyle(
            color: Colors.white, // Color del texto blanco
          ),
        ), // Título de la aplicación
        centerTitle: true, // Centra el título en la barra de aplicaciones
        leading: IconButton(
          // Botón de menú en el lado izquierdo de la barra de aplicaciones
          icon: Icon(Icons.menu, color: Colors.white), // Icono de menú
          onPressed: () {
            // Manejador de eventos cuando se presiona el botón de menú
            controlador
                ?.toggle(); // Alterna el estado del ZoomDrawer (abre/cierra)
          },
        ),
        backgroundColor: Theme.of(context)
            .primaryColor, // Color de fondo de la AppBar según el color primario del tema

        shadowColor: Colors.black,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListaMercado(correoElectronico: widget.userEmail) // Widget de lista de mercado con el correo electrónico del usuario
          ],
        ),
      ),
    );
  }
}
