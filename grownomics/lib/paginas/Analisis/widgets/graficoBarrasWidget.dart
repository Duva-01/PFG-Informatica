import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:grownomics/modelos/HistoricalData.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:intl/intl.dart';

class GraficoBarrasCandlestick extends StatelessWidget {
  final List<HistoricalData> datosHistoricos;
  final List<double> lineasSoporte;
  final List<double> lineasResistencia;
  final List<double> sma20;
  final List<double> sma50;

  GraficoBarrasCandlestick({
    Key? key,
    required this.datosHistoricos,
    required this.lineasSoporte,
    required this.lineasResistencia,
    required this.sma20,
    required this.sma50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: GraficoBarrasWidget(
            datosHistoricos: datosHistoricos,
            lineasSoporte: lineasSoporte,
            lineasResistencia: lineasResistencia,
          ),
        ),
        buildTablaDatos("Soportes y Resistencias", "Soportes", lineasSoporte, "Resistencias", lineasResistencia),
        buildTitulo("Gráfico lineas SMA20-SMA50"),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: GraficoLinealWidget(
            datosHistoricos: datosHistoricos,
            sma20: sma20,
            sma50: sma50,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildLegend(context),
        ),
        buildTablaDatos("Datos SMA20-SMA50", "SMA20", sma20, "SMA50", sma50),

      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(context, "SMA 20", Colors.yellow),
        SizedBox(width: 10),
        _legendItem(context, "SMA 50", Colors.orange),
        SizedBox(width: 10),
        _legendItem(context, "Precio de acción", Colors.blue),
      ],
    );
  }

  Widget _legendItem(BuildContext context, String text, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text(text),
      ],
    );
  }

  Widget buildTablaDatos(String titulo, String nombre1, List<double> datos1, String nombre2, List<double> datos2){
    return ExpansionTile(
        title: Text(titulo),
        children: [
            DataTable(
                columns: [DataColumn(label: Text(nombre1))],
                rows: datos1.map<DataRow>((dato) {
                    return DataRow(cells: [DataCell(Text(dato.toStringAsFixed(2)))]);
                }).toList(),
            ),
            SizedBox(height: 10), // Espacio entre las tablas
            DataTable(
                columns: [DataColumn(label: Text(nombre2))],
                rows: datos2.map<DataRow>((dato) {
                    return DataRow(cells: [DataCell(Text(dato.toStringAsFixed(2)))]);
                }).toList(),
            ),
        ],
    );
  }
}

class GraficoBarrasWidget extends StatelessWidget {
  final List<HistoricalData> datosHistoricos;
  final List<double> lineasSoporte;
  final List<double> lineasResistencia;

  GraficoBarrasWidget({
    Key? key,
    required this.datosHistoricos,
    required this.lineasSoporte,
    required this.lineasResistencia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxY = datosHistoricos.map((e) => e.high).reduce(max);
    double minY = datosHistoricos.map((e) => e.low).reduce(min);

    return Container(
      margin: EdgeInsets.all(10),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: (maxY - minY) / 4,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 10));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0 ||
                      value.toInt() == (datosHistoricos.length / 2).toInt() ||
                      value == datosHistoricos.length - 1) {
                    return Text(
                        DateFormat('MMM dd')
                            .format(datosHistoricos[value.toInt()].date),
                        style: TextStyle(fontSize: 10));
                  } else {
                    return Text("");
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: true),
          barGroups: datosHistoricos.asMap().entries.map((entry) {
            int index = entry.key;
            HistoricalData data = entry.value;
            double baseLine = data.open > data.close ? data.open : data.close;
            double barWidth = data.open > data.close
                ? data.open - data.close
                : data.close - data.open;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: baseLine + barWidth,
                  fromY: baseLine,
                  color: data.open > data.close ? Colors.red : Colors.green,
                  width: 4,
                ),
              ],
            );
          }).toList(),
          extraLinesData: ExtraLinesData(
            extraLinesOnTop: true,
            horizontalLines: [
              ...lineasSoporte.map((y) => HorizontalLine(
                    y: y,
                    color: Colors.blue,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (line) =>
                          'Soporte: ${line.y.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    ),
                  )),
              ...lineasResistencia.map((y) => HorizontalLine(
                    y: y,
                    color: Colors.red,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (line) =>
                          'Resistencia: ${line.y.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
class GraficoLinealWidget extends StatelessWidget {
  final List<double> sma20;
  final List<double> sma50;
  final List<HistoricalData> datosHistoricos;

  GraficoLinealWidget({
    Key? key,
    required this.sma20,
    required this.sma50,
    required this.datosHistoricos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxY = datosHistoricos.map((e) => e.high).reduce(max);
    double minY = datosHistoricos.map((e) => e.low).reduce(min);

    List<FlSpot> sma20Spots = sma20
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
    List<FlSpot> sma50Spots = sma50
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();

    List<FlSpot> preciosAccionSpots = datosHistoricos
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.close))
        .toList();

    return Container(
      margin: EdgeInsets.all(10),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: (maxY - minY) / 4,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 10));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0 ||
                      value.toInt() == (datosHistoricos.length / 2).toInt() ||
                      value == datosHistoricos.length - 1) {
                    return Text(
                        DateFormat('MMM dd')
                            .format(datosHistoricos[value.toInt()].date),
                        style: TextStyle(fontSize: 10));
                  } else {
                    return Text("");
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: sma20Spots,
              isCurved: true,
              color: Colors.yellow,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: sma50Spots,
              isCurved: true,
              color: Colors.orange,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: preciosAccionSpots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],

          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipRoundedRadius: 8,
              fitInsideVertically: true,
              fitInsideHorizontally: true,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  if (touchedSpot.barIndex == 0) {
                    return LineTooltipItem(
                      'SMA 20: ${touchedSpot.y.toStringAsFixed(2)}',
                      TextStyle(color: Colors.yellow),
                    );
                  } else if (touchedSpot.barIndex == 1) {
                    return LineTooltipItem(
                      'SMA 50: ${touchedSpot.y.toStringAsFixed(2)}',
                      TextStyle(color: Colors.orange),
                    );
                  } else {
                    return LineTooltipItem(
                      'Precio: ${touchedSpot.y.toStringAsFixed(2)}',
                      TextStyle(color: Colors.blue),
                    );
                  }
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}

