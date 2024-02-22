// Importaciones de paquetes y bibliotecas necesarios
import 'dart:math';
import 'package:animated_button_bar/animated_button_bar.dart'; // Paquete para botones animados
import 'package:fl_chart/fl_chart.dart'; // Paquete para gráficos FL
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart'; // Funciones relacionadas con el mercado
import 'package:intl/intl.dart'; // Paquete para formatear fechas
import '../../../modelos/HistoricalData.dart'; // Modelo de datos históricos
import 'package:k_chart/flutter_k_chart.dart'; // Paquete para gráficos KChart

// Enumeración para definir el tipo de gráfico
enum TipoGrafico { linea, vela }

// Widget para el gráfico
class WidgetGrafico extends StatefulWidget {
  final String symbol; // Símbolo del gráfico

  WidgetGrafico({required this.symbol}); // Constructor

  @override
  _EstadoWidgetGrafico createState() =>
      _EstadoWidgetGrafico(); // Crea el estado del widget
}

class _EstadoWidgetGrafico extends State<WidgetGrafico> {
  String _intervalo = '1mo'; // Intervalo de tiempo inicial
  List<HistoricalData> _datosHistoricos = []; // Lista de datos históricos
  TipoGrafico _tipoGrafico = TipoGrafico.vela; // Tipo de gráfico inicial

  @override
  void initState() {
    super.initState();
    _cargarDatos(); // Carga los datos históricos al iniciar el widget
  }

  // Función para cargar los datos históricos
  void _cargarDatos() async {
    final datos = await obtenerDatosHistoricos(
        widget.symbol, _intervalo); // Obtiene los datos históricos del mercado
    setState(() {
      _datosHistoricos =
          datos; // Actualiza los datos históricos en el estado del widget
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row para seleccionar el tipo de gráfico
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _tipoGrafico = TipoGrafico.vela),
                child: Text('Gráfico de Velas'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return _tipoGrafico == TipoGrafico.vela
                          ? Colors.white
                          : Theme.of(context).primaryColor; // Color del texto
                    },
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return _tipoGrafico == TipoGrafico.vela
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!; // Color de fondo
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10), // Espaciador entre botones
              ElevatedButton(
                onPressed: () => setState(() => _tipoGrafico = TipoGrafico.linea),
                child: Text('Gráfico de Línea'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return _tipoGrafico == TipoGrafico.linea
                          ? Colors.white
                          : Theme.of(context).primaryColor; // Color del texto
                    },
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return _tipoGrafico == TipoGrafico.linea
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!; // Color de fondo
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        // Sección para seleccionar el intervalo de tiempo
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: AnimatedButtonBar(
            // Barra de botones animados para intervalos de tiempo
            radius: 8.0, // Radio de borde de los botones
            padding: const EdgeInsets.all(8.0), // Padding
            backgroundColor: Colors
                .white, // Color de fondo por defecto para todos los botones
            foregroundColor: Theme.of(context)
                .primaryColor, // Color de texto por defecto para todos los botones

            children: [
              
              ButtonBarEntry(
                // Entrada para el botón de 1 mes
                onTap: () {
                  // Acción al hacer tap
                  setState(() {
                    // Actualizar estado
                    _intervalo = '1mo'; // Cambiar intervalo a 1 mes
                  });
                  _cargarDatos();
                },
                child: Text(
                  '1 mes',
                  style: TextStyle(
                    color: _intervalo == '1mo' ? Colors.white : Colors.black,
                  ),
                ), // Texto del botón
              ),
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
                    color: _intervalo == '3mo' ? Colors.white : Colors.black,
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
                    color: _intervalo == '6mo' ? Colors.white : Colors.black,
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
                    color: _intervalo == '1y' ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Sección para mostrar el gráfico
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            height: 300, // Altura del área del gráfico
            child: _datosHistoricos == null || _datosHistoricos.isEmpty
                ? Center(
                    child:
                        CircularProgressIndicator()) // Muestra un indicador de carga si no hay datos
                : _tipoGrafico == TipoGrafico.linea
                    ? construirGrafico(
                        _datosHistoricos) // Construye un gráfico de línea si es seleccionado
                    : construirGraficoVelas(
                        _datosHistoricos), // Construye un gráfico de velas si es seleccionado
          ),
        ),
      ],
    );
  }
}

// Función para construir un gráfico de línea
Widget construirGrafico(List<HistoricalData> datos) {
  final double minY = datos.map((e) => e.low).reduce(min).floorToDouble();
  final double maxY = datos.map((e) => e.high).reduce(max).ceilToDouble();
  final double midY = ((minY + maxY) / 2).roundToDouble();
  final int midXIndex = (datos.length / 2).floor();

  return LineChart(
    LineChartData(
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (double value, TitleMeta meta) {
              final index = value.toInt();
              if (index == 0 ||
                  index == midXIndex ||
                  index == datos.length - 1) {
                return Text(DateFormat('yMd').format(datos[index].date));
              }
              return Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value == minY || value == maxY) {
                return Text(value.toInt().toString());
              } else if (value == midY) {
                return Text("AVG ${value.toInt()}");
              }
              return Text('');
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 4),
      ),
      gridData: FlGridData(show: false),
      minX: 0,
      maxX: (datos.length.toDouble() - 1),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: datos.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            return FlSpot(index.toDouble(), value.close);
          }).toList(),
          isCurved: true,
          color: Colors.green,
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF2F8B62).withOpacity(0.6),
          ),
        ),
      ],
    ),
  );
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
