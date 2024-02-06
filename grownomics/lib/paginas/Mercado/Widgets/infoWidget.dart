import 'package:flutter/material.dart';
import 'package:grownomics/modelos/HistoricalData.dart';
import 'package:grownomics/widgets/indicadores_economicos.dart';
import 'package:intl/intl.dart';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:grownomics/modelos/HistoricalData.dart';
import 'package:intl/intl.dart';

class InfoWidget extends StatefulWidget {
  final String symbol;

  InfoWidget({required this.symbol});

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  String _interval = '3mo';
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
    return _historicalData == null || _historicalData.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
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
          );
  }
}

List<Widget> generarInformacion(List<HistoricalData> data) {
  final double inicio = data.first.close;
  final double fin = data.last.close;
  final String tendencia = inicio < fin ? 'ascendente' : 'descendente';

  final double cambioPorcentual = ((fin - inicio) / inicio) * 100;

  final double volatilidad = data.fold(0.0, (double previous, current) {
        final diferencia = current.close - inicio;
        return previous + diferencia * diferencia;
      }) /
      data.length;

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
      color: Colors.grey.shade200, // Fondo neutro
      child: ListTile(
        leading: Icon(
          tendencia == 'ascendente' ? Icons.trending_up : Icons.trending_down,
          color: tendencia == 'ascendente' ? Colors.green : Colors.red,
          size: 30, // Icono más grande
        ),
        title: Text('Tendencia $tendencia'),
        subtitle:
            Text('Cambio porcentual: ${cambioPorcentual.toStringAsFixed(2)}%'),
        trailing: Tooltip(
          message:
              'Una tendencia ascendente indica que el precio de la acción está aumentando, mientras que una tendencia descendente indica que está disminuyendo.',
          child: Icon(Icons.info, size: 30), // Icono de información
        ),
      ),
    ),
    Card(
      color: Colors.grey.shade200, // Fondo neutro
      child: ListTile(
        leading: Icon(Icons.show_chart,
            color: Colors.yellow, size: 30), // Icono más grande
        title: Text('Volatilidad'),
        subtitle: Text(
            'La volatilidad de la acción es ${volatilidad.toStringAsFixed(2)}'),
        trailing: Tooltip(
          message:
              'La volatilidad representa la variabilidad del precio de una acción en un período de tiempo específico.',
          child: Icon(Icons.info, size: 30), // Icono de información
        ),
      ),
    ),
    Card(
      color: Colors.grey.shade200, // Fondo neutro
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.change_history,
                color: Colors.blue, size: 30), // Icono más grande
            title: Text('Puntos de Inflexión'),
            subtitle:
                Text('$puntosDeInflexion puntos de inflexión identificados.'),
            trailing: Tooltip(
              message:
                  'Los puntos de inflexión representan donde el precio de la acción cambió de dirección. Estos puntos pueden ser útiles para identificar tendencias y posibles puntos de entrada o salida.',
              child: Icon(Icons.info, size: 30), // Icono de información
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
  double rsi =
      calcularRSI(preciosCierre, 14); // Usando un periodo de 14 como es común

  String recomendacionCompra = '';
  String recomendacionVenta = '';
  String detalleCompra = '';
  String detalleVenta = '';

  // Suponiendo que ya has calculado sma20, ema20 y rsi a partir de tu análisis
  if (ema20 > sma20 && rsi < 30) {
    recomendacionCompra = 'Compra recomendada.';
    detalleCompra =
        'La EMA 20 está por encima de la SMA 20 y el RSI está por debajo de 30, indicando una posible sobreventa. Esta situación sugiere que la acción puede estar undervaluada, lo que podría presentar una oportunidad de compra.';
  } else {
    recomendacionCompra = 'Compra no recomendada.';
    detalleCompra =
        'La EMA 20 por debajo de la SMA 20 puede indicar una tendencia bajista, y un RSI por encima de 30 no sugiere sobreventa. Estas condiciones podrían indicar que la acción no está en una posición favorable para la compra en este momento.';
  }

  if (ema20 < sma20 && rsi > 70) {
    recomendacionVenta = 'Venta recomendada.';
    detalleVenta =
        'La EMA 20 está por debajo de la SMA 20 y el RSI está por encima de 70, indicando una posible sobrecompra. Esta situación sugiere que la acción puede estar sobrevalorada, lo que podría presentar una oportunidad de venta.';
  } else {
    recomendacionVenta = 'Venta no recomendada.';
    detalleVenta =
        'La EMA 20 por encima de la SMA 20 puede indicar una tendencia alcista, y un RSI por debajo de 70 no sugiere sobrecompra. Estas condiciones podrían indicar que la acción no está en una posición favorable para la venta en este momento.';
  }

  return [
    Card(
      color: Colors.grey.shade200, // Fondo neutro
      child: ListTile(
        leading: Icon(Icons.trending_up,
            color: Colors.blue, size: 30), // Icono más grande
        title: Text('Media Móvil Simple (20 días)'),
        subtitle: Text('SMA 20: $sma20'),
        trailing: Tooltip(
          message:
              'La Media Móvil Simple (SMA) es el promedio de los precios de cierre de un activo durante un número específico de periodos.',
          child: Icon(Icons.info, size: 30), // Icono de información
        ),
      ),
    ),
    Card(
      color: Colors.grey.shade200, // Fondo neutro
      child: ListTile(
        leading: Icon(Icons.trending_up,
            color: Colors.blue, size: 30), // Icono más grande
        title: Text('Media Móvil Exponencial (20 días)'),
        subtitle: Text('EMA 20: $ema20'),
        trailing: Tooltip(
          message:
              'La Media Móvil Exponencial (EMA) es similar a la SMA, pero da más peso a los precios más recientes, lo que la hace más sensible a los cambios recientes en el precio.',
          child: Icon(Icons.info, size: 30), // Icono de información
        ),
      ),
    ),
    Card(
      color: rsi < 30
          ? Colors.green.shade200
          : rsi > 70
              ? Colors.red.shade200
              : Colors.grey.shade200,
      child: ListTile(
        leading: Icon(
            rsi < 30
                ? Icons.arrow_upward
                : rsi > 70
                    ? Icons.arrow_downward
                    : Icons.remove,
            color: rsi < 30
                ? Colors.green
                : rsi > 70
                    ? Colors.red
                    : Colors.yellow,
            size: 30),
        title: Text('Índice de Fuerza Relativa (14 días)'),
        subtitle: Text('RSI: $rsi'),
        trailing: Tooltip(
          message:
              'El Índice de Fuerza Relativa (RSI) es un indicador de momento que mide la velocidad y el cambio de los movimientos de precio. Un RSI por encima de 70 sugiere sobrecompra, mientras que un RSI por debajo de 30 sugiere sobreventa.',
          child: Icon(Icons.info, size: 30), // Icono de información
        ),
      ),
    ),
    Card(
      color: Colors.green.shade200,
      child: ExpansionTile(
        leading: Icon(
            recomendacionCompra.contains('Recomendada')
                ? Icons.attach_money
                : Icons.pan_tool,
            color: Colors.green,
            size: 30),
        title: Text(recomendacionCompra),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detalleCompra),
                SizedBox(
                    height: 10), // Espacio entre el texto y "Más Información"
                Tooltip(
                  message:
                      'Basado en el análisis de los indicadores, esta es una recomendación simplificada sobre la compra de la acción.',
                  child: Row(
                    children: [
                      Text('Más Información'),
                      Icon(Icons.info, size: 30), // Icono de información
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
        leading: Icon(
            recomendacionVenta.contains('Recomendada')
                ? Icons.attach_money
                : Icons.pan_tool,
            color: Colors.red,
            size: 30),
        title: Text(recomendacionVenta),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detalleVenta),
                SizedBox(
                    height: 10), // Espacio entre el texto y "Más Información"
                Tooltip(
                  message:
                      'Basado en el análisis de los indicadores, esta es una recomendación simplificada sobre la venta de la acción.',
                  child: Row(
                    children: [
                      Text('Más Información'),
                      Icon(Icons.info, size: 30), // Icono de información
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
