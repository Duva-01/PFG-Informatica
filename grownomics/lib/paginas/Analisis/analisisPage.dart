import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/api/recomendationAPI.dart';
import 'package:grownomics/paginas/Analisis/analisisAccionPage.dart';
import 'package:grownomics/paginas/Mercado/Widgets/marketListWidget.dart';
import 'package:grownomics/widgets/tituloWidget.dart'; // Asegúrate de que esta importación sea correcta según la ubicación de tu API

class PaginaAnalisis extends StatefulWidget {
  final String userEmail;

  PaginaAnalisis({required this.userEmail});

  @override
  _PaginaAnalisisState createState() => _PaginaAnalisisState();
}

class _PaginaAnalisisState extends State<PaginaAnalisis> {
  TextEditingController _controller = TextEditingController();
  List<String> _todosLosSimbolos =
      []; // Agregado: Lista para almacenar todos los símbolos
  List<String> _simbolosFiltrados =
      []; // Agregado: Lista para almacenar símbolos filtrados

  @override
  void initState() {
    super.initState();
    _cargarSimbolos();
  }

  Future<void> _cargarSimbolos() async {
    try {
      final simbolos = await obtenerCodigosTicker();
      setState(() {
        _todosLosSimbolos = simbolos;
        _simbolosFiltrados = simbolos;
      });
    } catch (e) {
      print("Error al obtener los símbolos: $e");
    }
  }

  void _filtrarSimbolos(String consulta) {
    final resultados = _todosLosSimbolos
        .where(
            (simbolo) => simbolo.toLowerCase().contains(consulta.toLowerCase()))
        .toList();
    setState(() {
      _simbolosFiltrados = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controlador = ZoomDrawer.of(context); // Controlador para el cajón de navegación
    return Scaffold(
      appBar: AppBar(
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          'Análisis de acciones',
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

