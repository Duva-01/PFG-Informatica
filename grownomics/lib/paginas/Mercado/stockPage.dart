import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:grownomics/paginas/Mercado/Widgets/chartWidget.dart';
import 'package:grownomics/paginas/Mercado/Widgets/dataTableWidget.dart';
import 'package:grownomics/paginas/Mercado/Widgets/infoWidget.dart';
import '../../modelos/HistoricalData.dart';

class DetallesAccion extends StatefulWidget {
  final String symbol;

  DetallesAccion(this.symbol);

  @override
  _DetallesAccionState createState() => _DetallesAccionState();
}

enum DisplayMode {
  Chart,
  DataTable,
}

class _DetallesAccionState extends State<DetallesAccion> {
  String _interval = '1wk';
  List<HistoricalData> _historicalData = [];
  DisplayMode _displayMode = DisplayMode.Chart;

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

  void _toggleDisplayMode() {
    setState(() {
      _displayMode = _displayMode == DisplayMode.Chart
          ? DisplayMode.DataTable
          : DisplayMode.Chart;
    });
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData = _displayMode == DisplayMode.Chart
        ? Icons.table_view // Icono para cuando se muestra la gráfica
        : Icons.show_chart; // Icono para cuando se muestra la tabla

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
        actions: [
          IconButton(
            icon: Icon(iconData),
            onPressed: _toggleDisplayMode,
          ),
        ],
      ),
      body: _historicalData == null || _historicalData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: _displayMode == DisplayMode.Chart
                  ? Column(
                      children: [
                        ChartWidget(symbol: widget.symbol),
                        InfoWidget(symbol: widget.symbol)    
                          ],
                    )
                  : DataTableWidget(symbol: widget.symbol),
            ),
    );
  }
}