import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../modelos/HistoricalData.dart';
import 'package:animated_button_bar/animated_button_bar.dart';

import '../../widgets/indicadores_economicos.dart';

Future<List<HistoricalData>> obtenerDatosHistoricos(
    String symbol, String interval) async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:5000/historical_data?symbol=$symbol&interval=$interval'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data.entries.map<HistoricalData>((entry) {
      return HistoricalData.fromJson({
        'date': entry.key,
        ...entry.value,
      });
    }).toList();
  } else {
    throw Exception('Failed to load historical data');
  }
}

class DetallesAccion extends StatefulWidget {
  final String symbol;

  DetallesAccion(this.symbol);

  @override
  _DetallesAccionState createState() => _DetallesAccionState();
}

class _DetallesAccionState extends State<DetallesAccion> {
  String _interval = '1wk';
  List<HistoricalData> _historicalData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await obtenerDatosHistoricos(widget.symbol, _interval);
    setState(() {
      _historicalData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
      ),
      body: _historicalData == null || _historicalData.isEmpty ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(

        // Agregado para permitir desplazamiento
        child: Column(
          children: [
            // Sección de la Gráfica

            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade200, // Color de fondo
                border: Border(
                  top: BorderSide(
                      width: 1.0, color: Colors.black), // Borde superior
                  bottom: BorderSide(
                      width: 1.0, color: Colors.black), // Borde inferior
                ),
              ),
              
              padding: EdgeInsets.all(8.0), // Padding interno
              child: Center(
                child: Text(
                  'Gráfica',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: AnimatedButtonBar(
                radius: 8.0,
                padding: const EdgeInsets.all(8.0),
                children: [
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        _interval = '1wk';
                        _loadData();
                      });
                    },
                    child: Text('1 Week'),
                  ),
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        _interval = '1mo';
                        _loadData();
                      });
                    },
                    child: Text('1 Month'),
                  ),
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        _interval = '3mo';
                        _loadData();
                      });
                    },
                    child: Text('3 Months'),
                  ),
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        _interval = '1y';
                        _loadData();
                      });
                    },
                    child: Text('1 Year'),
                  ),
                ],
              ),
            ),

            Padding(
              // Padding agregado
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 300, // Establece la altura de la tabla
                child: buildChart(_historicalData),
              ),
            ),

            // Sección de la Tabla
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade200, // Color de fondo
                border: Border(
                  top: BorderSide(
                      width: 1.0, color: Colors.black), // Borde superior
                  bottom: BorderSide(
                      width: 1.0, color: Colors.black), // Borde inferior
                ),
              ),
              
              padding: EdgeInsets.all(8.0), // Padding interno
              child: Center(
                child: Text(
                  'Tabla de datos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 300, // Establece la altura de la tabla
              child: buildDataTable(_historicalData),
            ),


            // Sección de la Información
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade200, // Color de fondo
                border: Border(
                  top: BorderSide(
                      width: 1.0, color: Colors.black), // Borde superior
                  bottom: BorderSide(
                      width: 1.0, color: Colors.black), // Borde inferior
                ),
              ),
              
              padding: EdgeInsets.all(8.0), // Padding interno
              child: Center(
                child: Text(
                  'Información',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: generarInformacion(_historicalData),
              ),
            ),

            // Sección de Recomendaciones
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade200, // Color de fondo
                border: Border(
                  top: BorderSide(
                      width: 1.0, color: Colors.black), // Borde superior
                  bottom: BorderSide(
                      width: 1.0, color: Colors.black), // Borde inferior
                ),
              ),
              
              padding: EdgeInsets.all(8.0), // Padding interno
              child: Center(
                child: Text(
                  'Recomendaciones',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: generarRecomendaciones(_historicalData),
              ),
            ),
          ],
        ),
      ),
    );
  }

List<Widget> generarInformacion(List<HistoricalData> data) {
  final double inicio = data.first.close;
  final double fin = data.last.close;
  final String tendencia = inicio < fin ? 'ascendente' : 'descendente';

  final double cambioPorcentual = ((fin - inicio) / inicio) * 100;

  final double volatilidad = data.fold(0.0, (double previous, current) {
    final diferencia = current.close - inicio;
    return previous + diferencia * diferencia;
  }) / data.length;

  final List<String> puntosDeInflexionInfo = [];
  int puntosDeInflexion = 0;
  for (int index = 1; index < data.length - 1; index++) {
    final anterior = data[index - 1].close;
    final current = data[index].close;
    final siguiente = data[index + 1].close;
    if ((current > anterior && current > siguiente) ||
        (current < anterior && current < siguiente)) {
      puntosDeInflexion++;
      puntosDeInflexionInfo.add(
          '${DateFormat('yMd').format(data[index].date)}: ${current.toStringAsFixed(2)}');
    }
  }

  return [
    Card(
      color: Colors.grey.shade200,  // Fondo neutro
      child: ListTile(
        leading: Icon(
          tendencia == 'ascendente' ? Icons.trending_up : Icons.trending_down,
          color: tendencia == 'ascendente' ? Colors.green : Colors.red,
          size: 30,  // Icono más grande
        ),
        title: Text('Tendencia $tendencia'),
        subtitle: Text('Cambio porcentual: ${cambioPorcentual.toStringAsFixed(2)}%'),
        trailing: Tooltip(
          message: 'Una tendencia ascendente indica que el precio de la acción está aumentando, mientras que una tendencia descendente indica que está disminuyendo.',
          child: Icon(Icons.info, size: 30),  // Icono de información
        ),
      ),
    ),
    Card(
      color: Colors.grey.shade200,  // Fondo neutro
      child: ListTile(
        leading: Icon(Icons.show_chart, color: Colors.yellow, size: 30),  // Icono más grande
        title: Text('Volatilidad'),
        subtitle: Text('La volatilidad de la acción es ${volatilidad.toStringAsFixed(2)}'),
        trailing: Tooltip(
          message: 'La volatilidad representa la variabilidad del precio de una acción en un período de tiempo específico.',
          child: Icon(Icons.info, size: 30),  // Icono de información
        ),
      ),
    ),
    Card(
      color: Colors.grey.shade200,  // Fondo neutro
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.change_history, color: Colors.blue, size: 30),  // Icono más grande
            title: Text('Puntos de Inflexión'),
            subtitle: Text('$puntosDeInflexion puntos de inflexión identificados.'),
            trailing: Tooltip(
            message: 'Los puntos de inflexión representan donde el precio de la acción cambió de dirección. Estos puntos pueden ser útiles para identificar tendencias y posibles puntos de entrada o salida.',
            child: Icon(Icons.info, size: 30),  // Icono de información
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(),
              children: puntosDeInflexionInfo.map((info) {
                final parts = info.split(': ');
                return TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(parts[0]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(parts[1]),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  ];
}



  List<Widget> generarRecomendaciones(List<HistoricalData> data) {
  List<double> preciosCierre = data.map((e) => e.close).toList();

  double sma20 = calcularSMA(preciosCierre, 20);
  double ema20 = calcularEMA(preciosCierre, 20);
  double rsi = calcularRSI(preciosCierre, 14);  // Usando un periodo de 14 como es común

  String recomendacionCompra = '';
  String recomendacionVenta = '';
  String detalleCompra = '';
  String detalleVenta = '';

  // Suponiendo que ya has calculado sma20, ema20 y rsi a partir de tu análisis
  if (ema20 > sma20 && rsi < 30) {
    recomendacionCompra = 'Compra recomendada.';
    detalleCompra = 'La EMA 20 está por encima de la SMA 20 y el RSI está por debajo de 30, indicando una posible sobreventa. Esta situación sugiere que la acción puede estar undervaluada, lo que podría presentar una oportunidad de compra.';
  } else {
    recomendacionCompra = 'Compra no recomendada.';
    detalleCompra = 'La EMA 20 por debajo de la SMA 20 puede indicar una tendencia bajista, y un RSI por encima de 30 no sugiere sobreventa. Estas condiciones podrían indicar que la acción no está en una posición favorable para la compra en este momento.';
  }

  if (ema20 < sma20 && rsi > 70) {
    recomendacionVenta = 'Venta recomendada.';
    detalleVenta = 'La EMA 20 está por debajo de la SMA 20 y el RSI está por encima de 70, indicando una posible sobrecompra. Esta situación sugiere que la acción puede estar sobrevalorada, lo que podría presentar una oportunidad de venta.';
  } else {
    recomendacionVenta = 'Venta no recomendada.';
    detalleVenta = 'La EMA 20 por encima de la SMA 20 puede indicar una tendencia alcista, y un RSI por debajo de 70 no sugiere sobrecompra. Estas condiciones podrían indicar que la acción no está en una posición favorable para la venta en este momento.';
  }

  return [
    Card(
      color: Colors.grey.shade200,  // Fondo neutro
      child: ListTile(
        leading: Icon(Icons.trending_up, color: Colors.blue, size: 30),  // Icono más grande
        title: Text('Media Móvil Simple (20 días)'),
        subtitle: Text('SMA 20: $sma20'),
        trailing: Tooltip(
          message: 'La Media Móvil Simple (SMA) es el promedio de los precios de cierre de un activo durante un número específico de periodos.',
          child: Icon(Icons.info, size: 30),  // Icono de información
        ),
      ),
    ),
    Card(
      color: Colors.grey.shade200,  // Fondo neutro
      child: ListTile(
        leading: Icon(Icons.trending_up, color: Colors.blue, size: 30),  // Icono más grande
        title: Text('Media Móvil Exponencial (20 días)'),
        subtitle: Text('EMA 20: $ema20'),
        trailing: Tooltip(
          message: 'La Media Móvil Exponencial (EMA) es similar a la SMA, pero da más peso a los precios más recientes, lo que la hace más sensible a los cambios recientes en el precio.',
          child: Icon(Icons.info, size: 30),  // Icono de información
        ),
      ),
    ),
    Card(
      color: rsi < 30 ? Colors.green.shade200 : rsi > 70 ? Colors.red.shade200 : Colors.grey.shade200,
      child: ListTile(
        leading: Icon(rsi < 30 ? Icons.arrow_upward : rsi > 70 ? Icons.arrow_downward : Icons.remove, color: rsi < 30 ? Colors.green : rsi > 70 ? Colors.red : Colors.yellow, size: 30),
        title: Text('Índice de Fuerza Relativa (14 días)'),
        subtitle: Text('RSI: $rsi'),
        trailing: Tooltip(
          message: 'El Índice de Fuerza Relativa (RSI) es un indicador de momento que mide la velocidad y el cambio de los movimientos de precio. Un RSI por encima de 70 sugiere sobrecompra, mientras que un RSI por debajo de 30 sugiere sobreventa.',
          child: Icon(Icons.info, size: 30),  // Icono de información
        ),
      ),
    ),
    Card(
      color: Colors.green.shade200,
      child: ExpansionTile(
        leading: Icon(recomendacionCompra.contains('Recomendada') ? Icons.attach_money : Icons.pan_tool, color: Colors.green, size: 30),
        title: Text(recomendacionCompra),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detalleCompra),
                SizedBox(height: 10),  // Espacio entre el texto y "Más Información"
                Tooltip(
                  message: 'Basado en el análisis de los indicadores, esta es una recomendación simplificada sobre la compra de la acción.',
                  child: Row(
                    children: [
                      Text('Más Información'),
                      Icon(Icons.info, size: 30),  // Icono de información
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    Card(
      color: Colors.red.shade200,
      child: ExpansionTile(
        leading: Icon(recomendacionVenta.contains('Recomendada') ? Icons.attach_money : Icons.pan_tool, color: Colors.red, size: 30),
        title: Text(recomendacionVenta),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detalleVenta),
                SizedBox(height: 10),  // Espacio entre el texto y "Más Información"
                Tooltip(
                  message: 'Basado en el análisis de los indicadores, esta es una recomendación simplificada sobre la venta de la acción.',
                  child: Row(
                    children: [
                      Text('Más Información'),
                      Icon(Icons.info, size: 30),  // Icono de información
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ];
}


Widget buildChart(List<HistoricalData> data) {
  final double minY = (data.map((e) => e.low).reduce((a, b) => a < b ? a : b)).floorToDouble();
  final double maxY = (data.map((e) => e.high).reduce((a, b) => a > b ? a : b)).ceilToDouble();
  final double midY = ((minY + maxY) / 2).roundToDouble();

  final int midXIndex = (data.length / 2).floor();
  final DateTime midX = data[midXIndex].date;

  return LineChart(
    LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            final int index = value.toInt();
            if (index == 0 || index == midXIndex) {
              final date = data[index].date;
              return DateFormat('yMd').format(date);
            }
            if(index == data.length - 1){
              final date = data[index].date;
              return DateFormat('Md').format(date);
            }
            
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            if (value == minY || value == maxY || value == midY) {
              return value.toInt().toString();
            }
            return '';
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: (data.length.toDouble() - 1),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: data.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            return FlSpot(index.toDouble(), value.close);
          }).toList(),
          isCurved: true,
          colors: [Colors.blue],
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
        ),
      ],
    ),
  );
}

Widget buildDataTable(List<HistoricalData> data) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.grey[300]!), // Color de fondo para los títulos
        columns: const [
          DataColumn(label: Text('Fecha')),
          DataColumn(label: Text('Apertura')),
          DataColumn(label: Text('Cierre')),
          DataColumn(label: Text('Alto')),
          DataColumn(label: Text('Bajo')),
        ],
        rows: data.map((item) {
          int index = data.indexOf(item);
          Color bgColor = index.isEven
              ? Colors.green[100]!
              : Colors.white; // Alternar colores
          return DataRow(
              color: MaterialStateProperty.resolveWith((states) => bgColor),
              cells: [
                DataCell(Text(DateFormat('yMd').format(item.date))),
                DataCell(Text(item.open.toStringAsFixed(2))),
                DataCell(Text(item.close.toStringAsFixed(2))),
                DataCell(Text(item.high.toStringAsFixed(2))),
                DataCell(Text(item.low.toStringAsFixed(2))),
              ]);
        }).toList(),
      ),
    ),
  );
}
}