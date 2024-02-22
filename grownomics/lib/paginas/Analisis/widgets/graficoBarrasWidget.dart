import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grownomics/modelos/HistoricalData.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:intl/intl.dart';

class CandlestickBarChart extends StatelessWidget {
  final List<HistoricalData> historicalData;
  final double supportLine;
  final double resistanceLine;

  CandlestickBarChart({
    Key? key,
    required this.historicalData,
    required this.supportLine,
    required this.resistanceLine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTitulo("Grafico"),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                // Gráfico de barras para simular las velas japonesas
                BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: historicalData.map((e) => e.high).reduce(max),
                    minY: historicalData.map((e) => e.low).reduce(min),
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(show: false),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: historicalData.asMap().entries.map((entry) {
                      int index = entry.key;
                      HistoricalData data = entry.value;
            
                      double baseLine = data.open > data.close ? data.open : data.close;
                      double barWidth = data.open > data.close ? data.open - data.close : data.close - data.open;
            
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
                  ),
                ),
                // Líneas de soporte y resistencia
                LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      // Línea de soporte
                      LineChartBarData(
                        spots: [
                          FlSpot(0, supportLine),
                          FlSpot(historicalData.length.toDouble() - 1, supportLine)
                        ],
                        isCurved: false,
                        color: Colors.blue,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: false),
                      ),
                      // Línea de resistencia
                      LineChartBarData(
                        spots: [
                          FlSpot(0, resistanceLine),
                          FlSpot(historicalData.length.toDouble() - 1, resistanceLine)
                        ],
                        isCurved: false,
                        color: Colors.orange,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
