import 'dart:math';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:intl/intl.dart';
import '../../../modelos/HistoricalData.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:k_chart/flutter_k_chart.dart';

enum ChartType { line, candle }

class ChartWidget extends StatefulWidget {
  final String symbol;

  ChartWidget({required this.symbol});

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  String _interval = '1wk'; // Puedes inicializar con el valor que desees
  List<HistoricalData> _historicalData = [];
  ChartType _chartType = ChartType.candle;

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _chartType = ChartType.candle),
              child: Text('Gráfico de Velas'),
              style: ElevatedButton.styleFrom(
                primary: _chartType == ChartType.candle
                    ? Color(0xFF2F8B62)
                    : Colors.grey,
              ),
            ),
            SizedBox(width: 10), // Espaciador entre botones

            ElevatedButton(
              onPressed: () => setState(() => _chartType = ChartType.line),
              child: Text('Gráfico de Línea'),
              style: ElevatedButton.styleFrom(
                primary: _chartType == ChartType.line
                    ? Color(0xFF2F8B62)
                    : Colors.grey,
              ),
            ),
          ],
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            height: 300, // Establece la altura de la tabla
            child: _historicalData == null || _historicalData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : _chartType == ChartType.line
                    ? buildChart(_historicalData)
                    : buildCandleChart(_historicalData),
          ),
        ),
      ],
    );
  }
}

Widget buildChart(List<HistoricalData> data) {
  final double minY =
      (data.map((e) => e.low).reduce((a, b) => a < b ? a : b)).floorToDouble();
  final double maxY =
      (data.map((e) => e.high).reduce((a, b) => a > b ? a : b)).ceilToDouble();
  final double midY = ((minY + maxY) / 2).roundToDouble();

  final int midXIndex = (data.length / 2).floor();

  return LineChart(
    LineChartData(
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
            if (index == data.length - 1) {
              final date = data[index].date;
              return DateFormat('Md').format(date);
            }

            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            if (value == minY || value == maxY) {
              return value.toInt().toString();
            } else if (value == midY) {
              return "AVG" + value.toInt().toString();
            }
            return '';
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 4),
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
          colors: [Colors.green],
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            colors: [
              Color(0xFF2F8B62).withOpacity(0.6),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildCandleChart(List<HistoricalData> data) {
  List<KLineEntity> kLineData = [];

  for (var historicalData in data) {
    double volume = historicalData.volume ?? 1.0;
    KLineEntity entity = KLineEntity.fromCustom(
      time: historicalData.date.millisecondsSinceEpoch,
      open: historicalData.open,
      high: historicalData.high,
      low: historicalData.low,
      close: historicalData.close,
      vol: volume,
    );
    kLineData.add(entity);
  }

  DataUtil.calculate(kLineData);
  ChartColors chartColors = ChartColors()
        ..bgColor = [
          Colors.white,
          Colors.white
        ] // Establece el color de fondo a blanco
        ..defaultTextColor =
            Colors.black // Asegura que el texto sea visible sobre fondo blanco
        ..gridColor =
            Colors.grey[300]! // Color de la línea de la cuadrícula más suave
        ..ma5Color = Colors
            .blueAccent // Ajusta los colores de las líneas MA para asegurar visibilidad
        ..ma10Color = Colors.orange
        ..ma30Color = Colors.purple
        ..upColor = Colors.green // Color para precios en aumento
        ..dnColor = Colors.red // Color para precios en descenso

      ;

  ChartStyle chartStyle = ChartStyle()
    ..topPadding = 30.0
    ..bottomPadding = 20.0
    ..childPadding = 12.0
    ..candleWidth = 8.5
    ..candleLineWidth = 1.5
    ..volWidth = 8.5
    ..macdWidth = 3.0
    ..vCrossWidth = 8.5
    ..hCrossWidth = 0.5;
  return KChartWidget(
    kLineData,
    chartStyle,
    chartColors,
    isTrendLine: false, // Ajusta según necesidad
    xFrontPadding: 100,
    mainState: MainState.NONE,
    secondaryState: SecondaryState.NONE,
    onSecondaryTap: () {},
    volHidden: false,
    isLine: false,
    isTapShowInfoDialog: true,
    hideGrid: false,
    isChinese: false,
    showNowPrice: true,
    showInfoDialog: true,
    materialInfoDialog: true,

    timeFormat: TimeFormat.YEAR_MONTH_DAY,
    fixedLength: 2,
    maDayList: [5, 10, 20],
    flingTime: 600,
    flingRatio: 0.5,
    flingCurve: Curves.decelerate,
    isOnDrag: (bool onDrag) {},
    verticalTextAlignment: VerticalTextAlignment.right,
  );
}
