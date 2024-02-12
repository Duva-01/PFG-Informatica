import 'package:animated_button_bar/animated_button_bar.dart'; // Importa el paquete para botones animados
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart'; // Importa las funciones relacionadas con el mercado
import 'package:grownomics/modelos/HistoricalData.dart'; // Importa el modelo de datos históricos
import 'package:grownomics/widgets/indicadores_economicos.dart';
import 'package:intl/intl.dart'; // Importa el paquete para formatear fechas

// Widget para mostrar información y recomendaciones basadas en datos históricos
class WidgetInfo extends StatefulWidget {
  final String symbol; // Símbolo del mercado financiero

  WidgetInfo({required this.symbol}); // Constructor

  @override
  _EstadoWidgetInfo createState() => _EstadoWidgetInfo(); // Crea el estado del widget
}

class _EstadoWidgetInfo extends State<WidgetInfo> {
  String _intervalo = '3mo'; // Intervalo de tiempo inicial
  List<HistoricalData> _datosHistoricos = []; // Lista de datos históricos

  @override
  void initState() {
    super.initState();
    _cargarDatos(); // Carga los datos históricos al iniciar el widget
  }

  // Función para cargar los datos históricos
  void _cargarDatos() async {
    final datos = await obtenerDatosHistoricos(widget.symbol, _intervalo); // Obtiene los datos históricos del mercado
    setState(() {
      _datosHistoricos = datos; // Actualiza los datos históricos en el estado del widget
    });
  }

  @override
  Widget build(BuildContext context) {
    return _datosHistoricos == null || _datosHistoricos.isEmpty
        ? Center(child: CircularProgressIndicator()) // Muestra un indicador de carga si no hay datos
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
                  children: _generarInformacion(_datosHistoricos), // Genera los widgets de información
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
                  children: _generarRecomendaciones(_datosHistoricos), // Genera los widgets de recomendaciones
                ),
              ),
            ],
          );
  }

  // Función para generar los widgets de información
  List<Widget> _generarInformacion(List<HistoricalData> datos) {
    final double inicio = datos.first.close;
    final double fin = datos.last.close;
    final String tendencia = inicio < fin ? 'ascendente' : 'descendente'; // Determina la tendencia

    final double cambioPorcentual = ((fin - inicio) / inicio) * 100; // Calcula el cambio porcentual

    final double volatilidad = datos.fold(0.0, (double previous, current) {
      final diferencia = current.close - inicio;
      return previous + diferencia * diferencia;
    }) /
        datos.length; // Calcula la volatilidad

    final List<String> puntosDeInflexionInfo = [];
    int puntosDeInflexion = 0;
    for (int index = 1; index < datos.length - 1; index++) {
      final anterior = datos[index - 1].close;
      final current = datos[index].close;
      final siguiente = datos[index + 1].close;
      if ((current > anterior && current > siguiente) || (current < anterior && current < siguiente)) {
        puntosDeInflexion++;
        puntosDeInflexionInfo.add(
            '${DateFormat('yMd').format(datos[index].date)}: ${current.toStringAsFixed(2)}');
      }
    }

    return [
      Card(
        color: Colors.grey.shade200, // Fondo neutro
        child: ListTile(
          leading: Icon(
            tendencia == 'ascendente' ? Icons.trending_up : Icons.trending_down, // Icono de tendencia ascendente o descendente
            color: tendencia == 'ascendente' ? Colors.green : Colors.red,
            size: 30, // Icono más grande
          ),
          title: Text('Tendencia $tendencia'),
          subtitle: Text('Cambio porcentual: ${cambioPorcentual.toStringAsFixed(2)}%'),
          trailing: Tooltip(
            message: 'Una tendencia ascendente indica que el precio de la acción está aumentando, mientras que una tendencia descendente indica que está disminuyendo.',
            child: Icon(Icons.info, size: 30), // Icono de información
          ),
        ),
      ),
      Card(
        color: Colors.grey.shade200, // Fondo neutro
        child: ListTile(
          leading: Icon(Icons.show_chart, color: Colors.yellow, size: 30), // Icono más grande
          title: Text('Volatilidad'),
          subtitle: Text('La volatilidad de la acción es ${volatilidad.toStringAsFixed(2)}'),
          trailing: Tooltip(
            message: 'La volatilidad representa la variabilidad del precio de una acción en un período de tiempo específico.',
            child: Icon(Icons.info, size: 30), // Icono de información
          ),
        ),
      ),
      Card(
        color: Colors.grey.shade200, // Fondo neutro
        child: ExpansionTile(
          leading: Icon(Icons.change_history, color: Colors.blue, size: 30), // Icono más grande
          title: Text('Puntos de Inflexión'),
          subtitle: Text('$puntosDeInflexion puntos de inflexión identificados.'),
          trailing: Tooltip(
            message: 'Los puntos de inflexión representan donde el precio de la acción cambió de dirección. Estos puntos pueden ser útiles para identificar tendencias y posibles puntos de entrada o salida.',
            child: Icon(Icons.info, size: 30), // Cambiado a `info_outline` para consistencia
          ),
          children: [
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

  // Función para generar los widgets de recomendaciones
  List<Widget> _generarRecomendaciones(List<HistoricalData> datos) {
    List<double> preciosCierre = datos.map((e) => e.close).toList();

    double sma20 = calcularSMA(preciosCierre, 20); // Calcula la media móvil simple (20 días)
    double ema20 = calcularEMA(preciosCierre, 20); // Calcula la media móvil exponencial (20 días)
    double rsi = calcularRSI(preciosCierre, 14); // Calcula el índice de fuerza relativa (14 días)

    String recomendacionCompra = '';
    String recomendacionVenta = '';
    String detalleCompra = '';
    String detalleVenta = '';

    // Determina las recomendaciones de compra y venta basadas en el análisis
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
        color: Colors.grey.shade200, // Fondo neutro
        child: ListTile(
          leading: Icon(Icons.trending_up, color: Colors.blue, size: 30), // Icono más grande
          title: Text('Media Móvil Simple (20 días)'),
          subtitle: Text('SMA 20: $sma20'),
          trailing: Tooltip(
            message: 'La Media Móvil Simple (SMA) es el promedio de los precios de cierre de un activo durante un número específico de periodos.',
            child: Icon(Icons.info, size: 30), // Icono de información
          ),
        ),
      ),
      Card(
        color: Colors.grey.shade200, // Fondo neutro
        child: ListTile(
          leading: Icon(Icons.trending_up, color: Colors.blue, size: 30), // Icono más grande
          title: Text('Media Móvil Exponencial (20 días)'),
          subtitle: Text('EMA 20: $ema20'),
          trailing: Tooltip(
            message: 'La Media Móvil Exponencial (EMA) es similar a la SMA, pero da más peso a los precios más recientes, lo que la hace más sensible a los cambios recientes en el precio.',
            child: Icon(Icons.info, size: 30), // Icono de información
          ),
        ),
      ),
      Card(
        color: rsi < 30 ? Colors.green.shade200 : rsi > 70 ? Colors.red.shade200 : Colors.grey.shade200, // Fondo basado en el RSI
        child: ListTile(
          leading: Icon(rsi < 30 ? Icons.arrow_upward : rsi > 70 ? Icons.arrow_downward : Icons.remove, color: rsi < 30 ? Colors.green : rsi > 70 ? Colors.red : Colors.yellow, size: 30),
          title: Text('Índice de Fuerza Relativa (14 días)'),
          subtitle: Text('RSI: $rsi'),
          trailing: Tooltip(
            message: 'El Índice de Fuerza Relativa (RSI) es un indicador de momento que mide la velocidad y el cambio de los movimientos de precio. Un RSI por encima de 70 sugiere sobrecompra, mientras que un RSI por debajo de 30 sugiere sobreventa.',
            child: Icon(Icons.info, size: 30), // Icono de información
          ),
        ),
      ),
      Card(
        color: Colors.green.shade200, // Fondo verde para recomendaciones de compra
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
                  SizedBox(height: 10), // Espacio entre el texto y "Más Información"
                  Tooltip(
                    message: 'Basado en el análisis de los indicadores, esta es una recomendación simplificada sobre la compra de la acción.',
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
        color: Colors.red.shade200, // Fondo rojo para recomendaciones de venta
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
                  SizedBox(height: 10), // Espacio entre el texto y "Más Información"
                  Tooltip(
                    message: 'Basado en el análisis de los indicadores, esta es una recomendación simplificada sobre la venta de la acción.',
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
}
