import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart'; // Importación del archivo de API para obtener datos del mercado
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
    final controller = ZoomDrawer.of(context); // Controlador para el cajón de navegación
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotizaciones'), // Título de la página de cotizaciones
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle(); // Botón del menú para abrir el cajón de navegación
          },
        ),
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
