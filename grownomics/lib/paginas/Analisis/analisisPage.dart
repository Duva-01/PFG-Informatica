import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';


class PaginaAnalisis extends StatefulWidget {
  // Atributo de correo electrónico del usuario
  final String userEmail;

  // Constructor
  PaginaAnalisis({required this.userEmail});

  @override
  _PaginaAnalisisState createState() => _PaginaAnalisisState();
}

class _PaginaAnalisisState extends State<PaginaAnalisis> {
  
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el controlador del ZoomDrawer
    final controller = ZoomDrawer.of(context);
    // Devolver el widget de la página
    return Scaffold(
      appBar: AppBar(
        title: Text('Analisis'), // Título de la página
        leading: IconButton( // Botón de menú en la barra de navegación
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle(); // Activar/desactivar el menú lateral
          },
        ),
      ),
      body: SingleChildScrollView( // Cuerpo de la página, desplazable verticalmente
        child: Column( // Columna que contiene los widgets secundarios
          children: [
            Text("Pagina de Analisis")
          ],
        ),
      ),
    );
  }
}
