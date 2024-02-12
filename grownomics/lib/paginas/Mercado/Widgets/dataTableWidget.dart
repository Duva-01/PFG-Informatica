// Importaciones de paquetes y bibliotecas necesarios
import 'package:animated_button_bar/animated_button_bar.dart'; // Paquete para botones animados
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart'; // Funciones relacionadas con el mercado
import 'package:grownomics/modelos/HistoricalData.dart'; // Modelo de datos históricos
import 'package:intl/intl.dart'; // Paquete para formatear fechas

// Widget para mostrar datos en forma de tabla
class WidgetTablaDatos extends StatefulWidget {
  final String symbol; // Símbolo del mercado financiero

  WidgetTablaDatos({required this.symbol}); // Constructor

  @override
  _EstadoWidgetTablaDatos createState() => _EstadoWidgetTablaDatos(); // Crea el estado del widget
}

class _EstadoWidgetTablaDatos extends State<WidgetTablaDatos> {
  String _intervalo = '1wk'; // Intervalo de tiempo inicial
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
    return Column(
      children: [
        // Sección para seleccionar el intervalo de tiempo
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: AnimatedButtonBar(
            radius: 8.0,
            padding: const EdgeInsets.all(8.0),
            children: [
              ButtonBarEntry(
                onTap: () {
                  setState(() {
                    _intervalo = '1wk'; // Intervalo de 1 semana
                    _cargarDatos(); // Carga los datos con el nuevo intervalo
                  });
                },
                child: Text('1 Semana'),
              ),
              ButtonBarEntry(
                onTap: () {
                  setState(() {
                    _intervalo = '1mo'; // Intervalo de 1 mes
                    _cargarDatos(); // Carga los datos con el nuevo intervalo
                  });
                },
                child: Text('1 Mes'),
              ),
              ButtonBarEntry(
                onTap: () {
                  setState(() {
                    _intervalo = '3mo'; // Intervalo de 3 meses
                    _cargarDatos(); // Carga los datos con el nuevo intervalo
                  });
                },
                child: Text('3 Meses'),
              ),
              ButtonBarEntry(
                onTap: () {
                  setState(() {
                    _intervalo = '1y'; // Intervalo de 1 año
                    _cargarDatos(); // Carga los datos con el nuevo intervalo
                  });
                },
                child: Text('1 Año'),
              ),
            ],
          ),
        ),
        // Sección para mostrar los datos en forma de tabla
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.green[200]!), // Color de fondo de los títulos de las columnas
            columnSpacing: 25.0, // Espaciado entre columnas
            columns: [
              DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))), // Columna de fecha
              DataColumn(label: Text('Apertura', style: TextStyle(fontWeight: FontWeight.bold))), // Columna de precio de apertura
              DataColumn(label: Text('Cierre', style: TextStyle(fontWeight: FontWeight.bold))), // Columna de precio de cierre
              DataColumn(label: Text('Alto', style: TextStyle(fontWeight: FontWeight.bold))), // Columna de precio máximo
              DataColumn(label: Text('Bajo', style: TextStyle(fontWeight: FontWeight.bold))), // Columna de precio mínimo
            ],
            rows: _datosHistoricos.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('yMd').format(item.date))), // Celda con la fecha formateada
                  DataCell(Text('${item.open.toStringAsFixed(2)}')), // Celda con el precio de apertura
                  DataCell(Text('${item.close.toStringAsFixed(2)}')), // Celda con el precio de cierre
                  DataCell(Text('${item.high.toStringAsFixed(2)}')), // Celda con el precio máximo
                  DataCell(Text('${item.low.toStringAsFixed(2)}')), // Celda con el precio mínimo
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
