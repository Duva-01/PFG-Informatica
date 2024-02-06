import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:grownomics/modelos/HistoricalData.dart';
import 'package:intl/intl.dart';
class DataTableWidget extends StatefulWidget {
  final String symbol;

  DataTableWidget({required this.symbol});

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
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
    return Column(
      children: [
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.green[200]!), // Color de fondo de los títulos de las columnas
            columnSpacing: 25.0, // Espaciado entre columnas
            columns: [
              DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Apertura', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Cierre', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Alto', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Bajo', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: _historicalData.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('yMd').format(item.date))),
                  DataCell(Text('${item.open.toStringAsFixed(2)}')),
                  DataCell(Text('${item.close.toStringAsFixed(2)}')),
                  DataCell(Text('${item.high.toStringAsFixed(2)}')),
                  DataCell(Text('${item.low.toStringAsFixed(2)}')),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
