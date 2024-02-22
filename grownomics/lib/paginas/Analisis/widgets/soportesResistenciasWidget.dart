import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:grownomics/api/recomendationAPI.dart';
import 'package:grownomics/modelos/HistoricalData.dart';
import 'package:grownomics/paginas/Analisis/widgets/graficoBarrasWidget.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:intl/intl.dart';
import 'package:k_chart/flutter_k_chart.dart'; // Paquete para gráficos KChart

class SoportesResistenciasTab extends StatefulWidget {
  final String simboloAccion;

  const SoportesResistenciasTab({
    Key? key,
    required this.simboloAccion,
  }) : super(key: key);

  @override
  _SoportesResistenciasTabState createState() =>
      _SoportesResistenciasTabState();
}

class _SoportesResistenciasTabState extends State<SoportesResistenciasTab> {
  Map<String, dynamic>? _resultadoAnalisis;
  bool _isLoading = true; // Indica si los datos están siendo cargados
  List<HistoricalData> _datosHistoricos = []; // Lista de datos históricos

  @override
  void initState() {
    super.initState();
    _obtenerAnalisisTecnico();
    _cargarDatos(); // Carga los datos históricos al iniciar el widget
  }

  _obtenerAnalisisTecnico() async {
    try {
      final resultado = await obtenerAnalisisTecnico(widget.simboloAccion);
      setState(() {
        _resultadoAnalisis = resultado;
        _isLoading =
            false; // Datos cargados, se desactiva el indicador de carga
      });
    } catch (e) {
      print("Error al obtener el análisis técnico: $e");
      setState(() {
        _isLoading =
            false; // Asumir que se completó la carga, aunque haya un error
      });
    }
  }

  // Función para cargar los datos históricos
  void _cargarDatos() async {
    final datos = await obtenerDatosHistoricos(
        widget.simboloAccion, "1y"); // Obtiene los datos históricos del mercado
    setState(() {
      _datosHistoricos =
          datos; // Actualiza los datos históricos en el estado del widget
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _resultadoAnalisis == null
            ? Center(child: Text('No se pudo obtener el análisis técnico.'))
            : SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitulo(
                        "Resultados del Análisis para ${widget.simboloAccion}"),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Soporte:",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${_resultadoAnalisis!['analisis_tecnico']['precio_soporte']}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Resistencia:",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${_resultadoAnalisis!['analisis_tecnico']['precio_resistencia']}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Estado:",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${_resultadoAnalisis!['analisis_tecnico']['estado']}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Acción recomendada:",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${_resultadoAnalisis!['analisis_tecnico']['accion_recomendada']}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        height: 300, // Altura del área del gráfico
                        child: _datosHistoricos == null ||
                                _datosHistoricos.isEmpty
                            ? Center(
                                child:
                                    CircularProgressIndicator()) // Muestra un indicador de carga si no hay datos
                            : construirGraficoVelas(
                                _datosHistoricos), // Construye un gráfico de velas si es seleccionado
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        height: 300, // Altura del área del gráfico
                        child: _datosHistoricos.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : CandlestickBarChart(
                                historicalData: _datosHistoricos,
                                supportLine:
                                    _resultadoAnalisis!['analisis_tecnico']
                                        ['precio_soporte'],
                                resistanceLine:
                                    _resultadoAnalisis!['analisis_tecnico']
                                        ['precio_resistencia'],
                              ),
                      ),
                    ),
                  ],
                ),
              );
  }
}

// Función para construir un gráfico de velas
Widget construirGraficoVelas(List<HistoricalData> datos) {
  List<KLineEntity> datosKLinea = [];

  // Convierte los datos históricos en datos de velas
  for (var datoHistorico in datos) {
    double volumen = datoHistorico.volume ?? 1.0;
    KLineEntity entidad = KLineEntity.fromCustom(
      time: datoHistorico.date.millisecondsSinceEpoch,
      open: datoHistorico.open,
      high: datoHistorico.high,
      low: datoHistorico.low,
      close: datoHistorico.close,
      vol: volumen,
    );
    datosKLinea.add(entidad);
  }

  // Calcula los datos necesarios para el gráfico de velas
  DataUtil.calculate(datosKLinea);

  // Define los colores y estilos del gráfico de velas
  ChartColors coloresGrafico = ChartColors()
    ..bgColor = [Colors.white, Colors.white] // Fondo blanco
    ..defaultTextColor = Colors.black // Texto negro sobre fondo blanco
    ..gridColor = Colors.grey[300]! // Color de la línea de la cuadrícula
    ..ma5Color = Colors.blueAccent // Colores para las líneas MA
    ..ma10Color = Colors.orange
    ..ma30Color = Colors.purple
    ..upColor = Colors.green // Color para precios en aumento
    ..dnColor = Colors.red; // Color para precios en descenso

  // Estilo del gráfico de velas
  ChartStyle estiloGrafico = ChartStyle()
    ..topPadding = 30.0
    ..bottomPadding = 20.0
    ..childPadding = 12.0
    ..candleWidth = 8.5
    ..candleLineWidth = 1.5
    ..volWidth = 8.5
    ..macdWidth = 3.0
    ..vCrossWidth = 8.5
    ..hCrossWidth = 0.5;

  // Retorna el widget del gráfico de velas
  return KChartWidget(
    datosKLinea,
    estiloGrafico,
    coloresGrafico,
    isTrendLine: false, // No muestra línea de tendencia
    xFrontPadding: 100,
    mainState: MainState.NONE,
    secondaryState: SecondaryState.NONE,
    onSecondaryTap: () {},
    volHidden: false,
    isLine: false,
    isTapShowInfoDialog: true,
    hideGrid: false,
    isChinese: false,
    showNowPrice: true,
    showInfoDialog: true,
    materialInfoDialog: true,
    timeFormat: TimeFormat.YEAR_MONTH_DAY,
    fixedLength: 2,
    maDayList: [5, 10, 20],
    flingTime: 600,
    flingRatio: 0.5,
    flingCurve: Curves.decelerate,
    isOnDrag: (bool onDrag) {},
    verticalTextAlignment: VerticalTextAlignment.right,
  );
}
