import 'package:animate_do/animate_do.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:grownomics/api/recomendationAPI.dart';
import 'package:grownomics/modelos/HistoricalData.dart';
import 'package:grownomics/paginas/Analisis/widgets/graficoBarrasWidget.dart';
import 'package:grownomics/paginas/Analisis/widgets/indicadoresEconomicosWidget.dart';
import 'package:grownomics/paginas/Mercado/Widgets/recomendationWidget.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:k_chart/flutter_k_chart.dart'; // Paquete para gráficos KChart

class AnalisisTecnicoWidget extends StatefulWidget {
  final String simboloAccion;

  const AnalisisTecnicoWidget({
    Key? key,
    required this.simboloAccion,
  }) : super(key: key);

  @override
  _AnalisisTecnicoWidgetState createState() => _AnalisisTecnicoWidgetState();
}

class _AnalisisTecnicoWidgetState extends State<AnalisisTecnicoWidget> {
  Map<String, dynamic> _resultadoAnalisis = {};
  bool _isLoading = true; // Indica si los datos están siendo cargados
  List<HistoricalData> _datosHistoricos = []; // Lista de datos históricos
  String _intervalo = '3mo';

  @override
  void initState() {
    super.initState();
    _cargarDatos(); // Carga los datos históricos al iniciar el widget
    _obtenerAnalisisTecnico();
  }

  _obtenerAnalisisTecnico() async {
  try {
    final resultado = await obtenerAnalisisTecnico(widget.simboloAccion, _intervalo);
    List<double> sma20List = List<double>.from(resultado['sma20'].map((e) => e.toDouble()));
    List<double> sma50List = List<double>.from(resultado['sma50'].map((e) => e.toDouble()));

    setState(() {
      _resultadoAnalisis = resultado;
      _resultadoAnalisis['sma20'] = sma20List;
      _resultadoAnalisis['sma50'] = sma50List;
      _isLoading = false; // Datos cargados, se desactiva el indicador de carga
    });
  } catch (e) {
    print("Error al obtener el análisis técnico: $e");
    setState(() {
      _isLoading = false; // Asumir que se completó la carga, aunque haya un error
    });
  }
}


  // Función para cargar los datos históricos
  void _cargarDatos() async {
    final datos = await obtenerDatosHistoricos(widget.simboloAccion,
        _intervalo); // Obtiene los datos históricos del mercado
    setState(() {
      _datosHistoricos =
          datos; // Actualiza los datos históricos en el estado del widget
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator(color: Color(0xFF2F8B62)))
        : _resultadoAnalisis == null
            ? Center(child: Text('No se pudo obtener el análisis técnico.'))
            : FadeInUp(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitulo("Grafico de soportes y Resistencias"),
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
                              _obtenerAnalisisTecnico();
                            },
                            child: Text(
                              '3 meses',
                              style: TextStyle(
                                color: _intervalo == '3mo'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ), // Texto del botón
                          ),
                          ButtonBarEntry(
                            // Entrada para el botón de 1 semana
                            onTap: () {
                              // Acción al hacer tap
                              setState(() {
                                // Actualizar estado
                                _intervalo =
                                    '6mo'; // Cambiar intervalo a 1 semana
                              });
                              _cargarDatos();
                              _obtenerAnalisisTecnico();
                            },
                            child: Text(
                              '6 meses',
                              style: TextStyle(
                                color: _intervalo == '6mo'
                                    ? Colors.white
                                    : Colors.black,
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
                              _obtenerAnalisisTecnico();
                            },
                            child: Text(
                              '1 año',
                              style: TextStyle(
                                color: _intervalo == '1y'
                                    ? Colors.white
                                    : Colors.black,
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
                              _obtenerAnalisisTecnico();
                            },
                            child: Text(
                              '3 años',
                              style: TextStyle(
                                color: _intervalo == '3y'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ), // Texto del botón
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _datosHistoricos.isEmpty
                            ? Center(child: CircularProgressIndicator(color: Color(0xFF2F8B62)))
                            : GraficoBarrasCandlestick(
                                datosHistoricos: _datosHistoricos,
                                lineasSoporte: List<double>.from(
                                    _resultadoAnalisis['soportes']
                                        .map((e) => e.toDouble())
                                        .toList()),
                                lineasResistencia: List<double>.from(
                                    _resultadoAnalisis['resistencias']
                                        .map((e) => e.toDouble())
                                        .toList()),
                                        sma20: _resultadoAnalisis['sma20'],
                                        sma50: _resultadoAnalisis['sma50']
                              ),
                      ),
                      IndicadoresEconomicosWidget(simbolo: widget.simboloAccion),
                       
                    ],
                  ),
                ),
            );
  }
}
