import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      child: Container(
        margin: const EdgeInsets.all(0),
        color: Color.fromARGB(255, 30, 92, 65),
        height: MediaQuery.of(context).size.height * 0.30,
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2,
          children: <Widget>[
            StatCard(
              title: 'Registro de Operaciones',
              amount: '\$4689.56',
              iconData: Icons.article_outlined,
              color: Colors.green, // Color verde para operaciones de registro
            ),
            StatCard(
              title: 'Operaciones Ganadoras Totales',
              amount: '\$2998.32',
              iconData: Icons.stacked_line_chart_sharp,
              color: Colors.green, // Color verde para operaciones ganadoras
            ),
            StatCard(
              title: 'Operaciones Perdedoras Totales',
              amount: '\$726.38',
              iconData: Icons.trending_down_sharp,
              color: Colors.red, // Color rojo para operaciones perdedoras
            ),
            StatCard(
              title: 'Operaciones de Empate Totales',
              amount: '\$964.86',
              iconData: Icons.compare_arrows_outlined,
              color: Colors.orange, // Color naranja para operaciones de empate
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData iconData;
  final Color color; // Nuevo atributo para el color del icono

  const StatCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.iconData,
    required this.color, // Añadido el color como argumento
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 30, 92, 65),
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          Icon(iconData, color: color, size: 40), // Usar el color proporcionado
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  title,
                  style: TextStyle(
                    color: Color.fromARGB(255, 230, 230, 230),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    
                  ),
                  maxLines: 2,
                ),
                AutoSizeText(
                  amount,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  minFontSize: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
