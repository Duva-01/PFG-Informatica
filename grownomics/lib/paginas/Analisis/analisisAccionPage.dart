import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:grownomics/modelos/HistoricalData.dart';
import 'package:grownomics/paginas/Analisis/widgets/analisisFundamentalWidget.dart';
import 'package:grownomics/paginas/Analisis/widgets/comprarVenderWidget.dart';
import 'package:grownomics/paginas/Analisis/widgets/estrategiasAccionWidget.dart';
import 'package:grownomics/paginas/Analisis/widgets/noticiasAccionWidget.dart';
import 'package:grownomics/paginas/Analisis/widgets/resumenAccionWidget.dart';
import 'package:grownomics/paginas/Analisis/widgets/analisisTecnicoWidget.dart';
import 'package:grownomics/paginas/Mercado/Widgets/dataTableWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalisisAccionPage extends StatefulWidget {
  final String simboloAccion;
  final String correoElectronico;
  AnalisisAccionPage(
      {required this.simboloAccion, required this.correoElectronico});

  @override
  _AnalisisAccionPageState createState() => _AnalisisAccionPageState();
}

class _AnalisisAccionPageState extends State<AnalisisAccionPage> {
  final List<String> tabTexts = [
    "Resumen",
    "Análisis Técnico",
    "Análisis Fundamental",
    "Estrategias",
    "Tabla de datos",
    "Noticias"
  ];

  bool _usuarioLogueado = false;
  List<HistoricalData> _datosHistoricos = []; // Lista de datos históricos

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogueado();
    _cargarDatos();
  }

  // Método para verificar si el usuario está logueado
  void _verificarUsuarioLogueado() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuarioLogueado = prefs.getBool('isUserLoggedIn') ?? false;
    });
  }

  // Método para cargar los datos históricos desde la API
  void _cargarDatos() async {
    final datos = await obtenerDatosHistoricos(widget.simboloAccion,
        "1wk"); // Obtiene los datos históricos para el símbolo y el intervalo especificados
    setState(() {
      _datosHistoricos = datos; // Actualiza los datos históricos en el estado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: Text(
                "Analisis de " + widget.simboloAccion,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              shadowColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              
            ),
      body: Stack(
      children: [
        DefaultTabController(
            length: tabTexts.length,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                  Container(
                    color: Theme.of(context).primaryColor, // Establece el color de fondo del TabBar igual al del AppBar
                    child: TabBar(
                      isScrollable: true,
                      tabs: tabTexts
                          .map((text) => Tab(text: text))
                          .toList(), // Usar la lista de textos de los tabs
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.5),
                      indicatorColor: Colors.white,
                    ),
                  ),
                  Expanded(
                        child: TabBarView(
                          children: [
                            ResumenAccionWidget(simboloAccion: widget.simboloAccion, correoElectronico: widget.correoElectronico),
                            AnalisisTecnicoWidget(simboloAccion: widget.simboloAccion),
                            AnalisisFundamentalWidget(simboloAccion: widget.simboloAccion),
                            EstrategiasAccionWidget(simboloAccion: widget.simboloAccion, correoElectronico: widget.correoElectronico),
                            WidgetTablaDatos(simboloAccion: widget.simboloAccion),
                            NoticiasAccionWidget(simboloAccion: widget.simboloAccion, correoElectronico: widget.correoElectronico),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_usuarioLogueado) // Espacio reservado para el Draggable cuando esté colapsado
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1)
              ],
            ),
          ),
        // Condición para mostrar el DraggableScrollableSheet solo si el usuario está logueado
        _usuarioLogueado == true
            ? ComprarVenderWidget(simboloAccion: widget.simboloAccion, correoElectronico: widget.correoElectronico,)
            : SizedBox(), // Utilizando un operador ternario
      ],
      ),
    );
  }

}