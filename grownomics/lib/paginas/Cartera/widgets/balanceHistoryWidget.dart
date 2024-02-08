import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BalanceHistoryWidget extends StatefulWidget {
  @override
  _BalanceHistoryWidgetState createState() => _BalanceHistoryWidgetState();
}

class _BalanceHistoryWidgetState extends State<BalanceHistoryWidget> {
  String _interval = '1wk';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Historial',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
        ),
        Divider(
          color: Colors.blueGrey[800],
          thickness: 2,
          height: 20,
          indent: 16,
          endIndent: 16,
        ),
        AnimatedButtonBar(
          radius: 8.0,
          padding: const EdgeInsets.all(8.0),
          children: [
            ButtonBarEntry(
              onTap: () => setState(() => _interval = '1wk'),
              child: Text('1 Week'),
            ),
            ButtonBarEntry(
              onTap: () => setState(() => _interval = '1mo'),
              child: Text('1 Month'),
            ),
            ButtonBarEntry(
              onTap: () => setState(() => _interval = '3mo'),
              child: Text('3 Months'),
            ),
            ButtonBarEntry(
              onTap: () => setState(() => _interval = '1y'),
              child: Text('1 Year'),
            ),
          ],
        ),
        SizedBox(height: 20),
        // Gráfica con líneas de cuadrícula
        Container(
          height: 200,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: LineChart(
            sampleData(),
          ),
        ),
      ],
    );
  }

  LineChartData sampleData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        verticalInterval: 1.0, // Intervalo entre líneas verticales
        horizontalInterval: 5.0, // Intervalo entre líneas horizontales
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[300]!,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey[300]!,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 1),
            FlSpot(1, 3),
            FlSpot(2, 10),
            // Añade más puntos aquí según tu necesidad
          ],
          isCurved: true,
          colors: [Colors.blue],
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }
}
