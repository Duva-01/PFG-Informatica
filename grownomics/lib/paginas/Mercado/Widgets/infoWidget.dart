import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart'; // Importa las funciones relacionadas con el mercado
import 'package:grownomics/modelos/HistoricalData.dart'; // Importa el modelo de datos históricos
import 'package:grownomics/widgets/tituloWidget.dart';
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
              buildTitulo("Información sobre la gráfica"),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: _generarInformacion(_datosHistoricos), // Genera los widgets de información
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

  
}
