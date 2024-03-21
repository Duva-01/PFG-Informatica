import 'package:flutter/material.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PrediccionesPreciosWidget extends StatelessWidget {
  final Map<String, dynamic> prediccionesPrecio;

  const PrediccionesPreciosWidget({
    Key? key,
    required this.prediccionesPrecio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar el locale en español
    initializeDateFormatting('es', null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitulo("Predicciones de precios (ARIMA)"),
        SizedBox(height: 10),
        for (int i = 0; i < prediccionesPrecio.length; i++) ...[
          if (i < 3)
            _buildPredictionItem(i),
        ],
        if (prediccionesPrecio.length > 3)
          ExpansionTile(
            title: Text(
              'Ver Más Predicciones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down,
            ),
            children: [
              for (int i = 3; i < prediccionesPrecio.length; i++)
                _buildPredictionItem(i),
            ],
          ),
      ],
    );
  }

  Widget _buildPredictionItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: _getColor(index),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DateFormat.yMMMMd('es').format(DateTime.parse(prediccionesPrecio.keys.toList()[index]))}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _getTextColor(index),
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${NumberFormat("#,##0.000").format(prediccionesPrecio.values.toList()[index])}€',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(index),
                ),
              ),
              SizedBox(height: 5),
              Text(
                _getTrendText(index),
                style: TextStyle(
                  fontSize: 14,
                  color: _getTextColor(index),
                ),
              ),
            ],
          ),
          Icon(
            _getIcon(index),
            size: 30,
            color: _getTextColor(index),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    if (index > 0) {
      return prediccionesPrecio.values.toList()[index] >
              prediccionesPrecio.values.toList()[index - 1]
          ? const Color.fromARGB(255, 23, 82, 25)
          : const Color.fromARGB(255, 92, 29, 24);
    } else {
      return Colors.grey;
    }
  }

  Color _getTextColor(int index) {
    if (index > 0) {
      return prediccionesPrecio.values.toList()[index] >
              prediccionesPrecio.values.toList()[index - 1]
          ? Color.fromARGB(255, 150, 245, 153)
          : Color.fromARGB(255, 252, 151, 143);
    } else {
      return Colors.white;
    }
  }

  String _getTrendText(int index) {
    if (index > 0) {
      return prediccionesPrecio.values.toList()[index] >
              prediccionesPrecio.values.toList()[index - 1]
          ? 'Aumenta'
          : 'Disminuye';
    } else {
      return '';
    }
  }

  IconData _getIcon(int index) {
    return index > 0
        ? prediccionesPrecio.values.toList()[index] >
                prediccionesPrecio.values.toList()[index - 1]
            ? Icons.arrow_upward
            : Icons.arrow_downward
        : Icons.horizontal_rule;
  }

  Color _getIconColor(int index) {
    return index > 0 ? Colors.white : Colors.grey;
  }
}
