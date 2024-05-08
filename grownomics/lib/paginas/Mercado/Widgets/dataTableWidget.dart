// Importaciones de paquetes y bibliotecas necesarios
import 'package:animated_button_bar/animated_button_bar.dart'; // Paquete para botones animados
import 'package:flutter/material.dart';
import 'package:grownomics/controladores/marketController.dart'; // Funciones relacionadas con el mercado
import 'package:grownomics/modelos/HistoricalData.dart'; // Modelo de datos históricos
import 'package:intl/intl.dart'; // Paquete para formatear fechas

// Widget para mostrar datos en forma de tabla
class WidgetTablaDatos extends StatefulWidget {
  final String simboloAccion; // Símbolo del mercado financiero

  WidgetTablaDatos({required this.simboloAccion}); // Constructor

  @override
  _EstadoWidgetTablaDatos createState() => _EstadoWidgetTablaDatos(); // Crea el estado del widget
}

class _EstadoWidgetTablaDatos extends State<WidgetTablaDatos> {
  String _intervalo = '1mo'; // Intervalo de tiempo inicial
  List<HistoricalData> _datosHistoricos = []; // Lista de datos históricos
  
  @override
void initState() {
  super.initState();
  if (mounted) { // Verificar si el widget está montado antes de cargar los datos
    _cargarDatos(); // Carga los datos históricos al iniciar el widget
  }
}


  // Función para cargar los datos históricos
  void _cargarDatos() async {
    final datos = await MercadoController.obtenerDatosHistoricos(widget.simboloAccion, _intervalo); // Obtiene los datos históricos del mercado
    setState(() {
      _datosHistoricos = datos; // Actualiza los datos históricos en el estado del widget
    });
  }
Widget build(BuildContext context) {

  double screenWidth = MediaQuery.of(context).size.width;
  double columnSpacing = screenWidth < 360 ? 10.0 : 25.0;  // Ajusta el espaciado según el ancho de la pantalla

  return ListView(
    children: [
      // Sección para seleccionar el intervalo de tiempo
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: AnimatedButtonBar(
          // Barra de botones animados para intervalos de tiempo
          radius: 8.0, // Radio de borde de los botones
          padding: const EdgeInsets.all(8.0), // Padding
          backgroundColor: Colors.white, // Color de fondo por defecto para todos los botones
          foregroundColor: Theme.of(context).primaryColor, // Color de texto por defecto para todos los botones

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
              ), // Texto del botón
            ),
          ],
        ),
      ),
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.green[200]!),
                columnSpacing: 25.0,
                columns: [
                  DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Apertura', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Cierre', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Alto', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Bajo', style: TextStyle(fontWeight: FontWeight.bold))),
                ].map((dataColumn) => DataColumn(
                  label: dataColumn.label,
                  onSort: (int columnIndex, bool ascending) {
                    // Implementa la función de ordenamiento si es necesario
                  }
                )).toList(),
                rows: _datosHistoricos.map((item) => DataRow(cells: [
                  DataCell(Text(DateFormat('yMd').format(item.date))),
                  DataCell(Text('${item.open.toStringAsFixed(2)}')),
                  DataCell(Text('${item.close.toStringAsFixed(2)}')),
                  DataCell(Text('${item.high.toStringAsFixed(2)}')),
                  DataCell(Text('${item.low.toStringAsFixed(2)}')),
                ])).toList(),
              ),
            ),
          );
        }
      ),
    ],
  );
}
}