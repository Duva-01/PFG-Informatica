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
        color: Color.fromARGB(255, 19, 60, 42),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Mis Estadísticas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  Icon(Icons.query_stats, color: Colors.white, size: 30)
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 2.0,
              indent: 20.0, // Ajusta el espacio izquierdo del Divider
              endIndent: 20.0, // Ajusta el espacio derecho del Divider
            ),
            Container(
              // Se puede ajustar la altura según el contenido y el diseño
              height: MediaQuery.of(context).size.height * 0.3,
              
              child: GridView.count(
                physics:
                    NeverScrollableScrollPhysics(), // para deshabilitar el scroll dentro del GridView
                crossAxisCount: 2,
                childAspectRatio: 2,
                children: <Widget>[
                  StatCard(
                    title: 'Registro de Operaciones',
                    amount: '\$4689.56',
                    iconData: Icons.article_outlined,
                    color: Colors.green,
                  ),
                  StatCard(
                    title: 'Ganancias Totales',
                    amount: '\$2998.32',
                    iconData: Icons.stacked_line_chart_sharp,
                    color: Colors.green,
                  ),
                  StatCard(
                    title: 'Pérdidas Totales',
                    amount: '\$726.38',
                    iconData: Icons.trending_down_sharp,
                    color: Colors.red,
                  ),
                  StatCard(
                    title: 'Operaciones de Empate Totales',
                    amount: '\$964.86',
                    iconData: Icons.compare_arrows_outlined,
                    color: Colors.orange,
                  ),
                  // ... Resto de StatCard
                ],
              ),
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
      color: Color.fromARGB(255, 19, 60, 42),
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
                    fontSize: 13,
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
