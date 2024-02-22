import 'package:flutter/material.dart';
import 'package:grownomics/api/recomendationAPI.dart';
import 'package:grownomics/paginas/Analisis/widgets/soportesResistenciasWidget.dart'; // Asegúrate de importar tu API correctamente

class AnalisisAccionPage extends StatefulWidget {
  final String simboloAccion;

  AnalisisAccionPage({required this.simboloAccion});

  @override
  _AnalisisAccionPageState createState() => _AnalisisAccionPageState();
}

class _AnalisisAccionPageState extends State<AnalisisAccionPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          // Barra de aplicaciones en la parte superior de la página
          title: Text(
            "Analisis de " + widget.simboloAccion,
            style: TextStyle(
              color: Colors.white, // Color del texto blanco
            ),
          ), // Título de la aplicación
          centerTitle: true, // Centra el título en la barra de aplicaciones
          backgroundColor: Theme.of(context)
              .primaryColor, // Color de fondo de la AppBar según el color primario del tema
          shadowColor: Colors.black,
          elevation: 4,
          leading: IconButton(
            // Widget de icono para el botón de retroceso
            icon: Icon(Icons.arrow_back,
                color: Colors.white), // Icono de flecha hacia atrás
            onPressed: () {
              // Manejador de eventos cuando se presiona el botón de retroceso
              Navigator.of(context).pop(); // Volver atrás en la navegación
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Soportes y Resistencias"),
              Tab(text: "Indicadores Económicos"),
              Tab(text: "Estrategias"),
            ],
            labelColor: Colors.white, // Color del texto de la pestaña seleccionada
            unselectedLabelColor: Colors.white.withOpacity(0.5), // Color del texto de las pestañas no seleccionadas
            // Color de la barra de selección
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña de Soportes y Resistencias
            SoportesResistenciasTab(simboloAccion: widget.simboloAccion),
            // Pestaña de Indicadores Económicos
            Center(
              child: Text("Indicadores Económicos no implementados aún."),
            ),
            // Pestaña de Estrategias
            Center(
              child: Text("Estrategias no implementadas aún."),
            ),
          ],
        ),
      ),
    );
  }
}