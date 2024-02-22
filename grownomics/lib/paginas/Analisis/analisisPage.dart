import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/api/recomendationAPI.dart';
import 'package:grownomics/paginas/Analisis/analisisAccionPage.dart';
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
  String _simboloSeleccionado = '';
  Map<String, dynamic> _resultadoAnalisis = {};

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

  void _buscarYMostrarAnalisis(String simbolo) async {
    try {
      final resultado = await obtenerAnalisisTecnico(simbolo);
      setState(() {
        _simboloSeleccionado = simbolo;
        _resultadoAnalisis = resultado;
      });
    } catch (e) {
      print("Error al obtener el análisis técnico: $e");
      // Puedes mostrar un diálogo de error aquí
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ZoomDrawer.of(context);
    return Scaffold(
      appBar: AppBar(
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          'Analisis Técnico',
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
            controller
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
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Buscar símbolo',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Agregado: Filtrar símbolos a medida que el usuario escribe
                  _filtrarSimbolos(value);
                },
              ),
            ),
            buildTitulo("Lista de acciones"),
            ..._simbolosFiltrados
                .map((simbolo) => ListTile(
                      title: Text(simbolo),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnalisisAccionPage(simboloAccion: simbolo),
                          ),
                        );
                      },
                    ))
                .toList(),
            
          ],
        ),
      ),
    );
  }
}
