import 'package:animate_do/animate_do.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:grownomics/api/recomendationAPI.dart';
import 'package:grownomics/modelos/HistoricalData.dart';
import 'package:grownomics/paginas/Analisis/widgets/recomendacionFinalWidget.dart';
import 'package:grownomics/paginas/Mercado/Widgets/chartWidget.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:k_chart/flutter_k_chart.dart'; // Paquete para gráficos KChart

class ResumenAccionWidget extends StatefulWidget {
  final String simboloAccion;
  final String correoElectronico;
  
  const ResumenAccionWidget({
    Key? key,
    required this.simboloAccion,
     required this.correoElectronico
  }) : super(key: key);

  @override
  _ResumenAccionWidgetState createState() => _ResumenAccionWidgetState();
}

class _ResumenAccionWidgetState extends State<ResumenAccionWidget> {
  bool _isLoading = true; // Indica si los datos están siendo cargados
  List<HistoricalData> _datosHistoricos = []; // Lista de datos históricos
  String _intervalo = '3mo';
  Map<String, dynamic> resumen = {};

  @override
void initState() {
  super.initState();
  _cargarTodo();
}

void _cargarTodo() async {
  await Future.wait([
    _cargarDatos(),
    _cargarResumenAccion(),
  ]);
  setState(() {
    _isLoading = false;
  });
}

Future<void> _cargarResumenAccion() async {
  try {
    resumen = await obtenerDatosAccion(widget.simboloAccion);
    // Aquí no necesitas llamar a setState ya que lo harás después de cargar todo
  } catch (e) {
    print("Error al cargar el resumen de la acción: $e");
    // Considera manejar el error de manera adecuada
  }
}

Future<void> _cargarDatos() async {
  try {
    final datos = await obtenerDatosHistoricos(widget.simboloAccion, _intervalo);
    _datosHistoricos = datos;
    // Aquí tampoco necesitas llamar a setState
  } catch (e) {
    print("Error al cargar los datos históricos: $e");
    // Considera manejar el error de manera adecuada
  }
}

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator(color: Color(0xFF2F8B62)))
        : FadeInUp(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitulo("Resumen de la acción"),
                  _construirResumenInicial(resumen),
                  buildTitulo("Grafico de precios históricos"),
                  AnimatedButtonBar(
                    // Barra de botones animados para intervalos de tiempo
                    radius: 8.0, // Radio de borde de los botones
                    padding: const EdgeInsets.all(8.0), // Padding
                    backgroundColor: Colors
                        .white, // Color de fondo por defecto para todos los botones
                    foregroundColor: Theme.of(context)
                        .primaryColor, // Color de texto por defecto para todos los botones
          
                    children: [
                      ButtonBarEntry(
                        // Entrada para el botón de 3 meses
                        onTap: () {
                          // Acción al hacer tap
                          setState(() {
                            // Actualizar estado
                            _intervalo = '3mo'; // Cambiar intervalo a 3 meses
                          });
                          _cargarDatos();
                        },
                        child: Text(
                          '3 meses',
                          style: TextStyle(
                            color:
                                _intervalo == '3mo' ? Colors.white : Colors.black,
                          ),
                        ), // Texto del botón
                      ),
                      ButtonBarEntry(
                        // Entrada para el botón de 1 semana
                        onTap: () {
                          // Acción al hacer tap
                          setState(() {
                            // Actualizar estado
                            _intervalo = '6mo'; // Cambiar intervalo a 1 semana
                          });
                          _cargarDatos();
                        },
                        child: Text(
                          '6 meses',
                          style: TextStyle(
                            color:
                                _intervalo == '6mo' ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      ButtonBarEntry(
                        // Entrada para el botón de 1 año
                        onTap: () {
                          // Acción al hacer tap
                          setState(() {
                            // Actualizar estado
                            _intervalo = '1y'; // Cambiar intervalo a 1 año
                          });
                          _cargarDatos();
                        },
                        child: Text(
                          '1 año',
                          style: TextStyle(
                            color:
                                _intervalo == '1y' ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      ButtonBarEntry(
                        // Entrada para el botón de 1 mes
                        onTap: () {
                          // Acción al hacer tap
                          setState(() {
                            // Actualizar estado
                            _intervalo = '3y'; // Cambiar intervalo a 1 mes
                          });
                          _cargarDatos();
                        },
                        child: Text(
                          '3 años',
                          style: TextStyle(
                            color:
                                _intervalo == '3y' ? Colors.white : Colors.black,
                          ),
                        ), // Texto del botón
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: 300, // Altura del área del gráfico
                      child: _datosHistoricos == null || _datosHistoricos.isEmpty
                          ? Center(
                              child:
                                  CircularProgressIndicator(color: Color(0xFF2F8B62))) // Muestra un indicador de carga si no hay datos
                          : construirGraficoVelas(
                              _datosHistoricos), // Construye un gráfico de velas si es seleccionado
                    ),
                  ),
                  RecomendacionFinalWidget(simboloAccion: widget.simboloAccion, correoElectronico: widget.correoElectronico,),
                ],
              ),
            ),
        );
  }


Widget _construirResumenInicial(Map<String, dynamic> resumen) {

  return Card(
    elevation: 4,
    margin: EdgeInsets.all(8),
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre: ${resumen['name']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Precio actual: \$${double.parse(resumen['current_price'].toString()).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Cambio: \$${double.parse(resumen['change'].toString()).toStringAsFixed(2)} (${double.parse(resumen['change_percent'].toString()).toStringAsFixed(2)}%)',
                  style: TextStyle(fontSize: 16),
                ),
                // Añade más detalles según lo que devuelva tu API
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              alignment: Alignment.center,
              child: Text(
                resumen['ticker_symbol'],
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}