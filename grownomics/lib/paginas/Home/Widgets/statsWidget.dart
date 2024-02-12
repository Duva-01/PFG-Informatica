import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animate_do/animate_do.dart';

class StatsGrid extends StatefulWidget {
  @override
  _StatsGridState createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid> {
  @override
  Widget build(BuildContext context) {
    return BounceInDown( // Widget de animación BounceInDown
      child: ClipRRect( // Widget de ClipRRect para aplicar bordes redondeados
        borderRadius: BorderRadius.only( // Bordes redondeados en la parte inferior
          bottomLeft: Radius.circular(15.0), // Borde inferior izquierdo
          bottomRight: Radius.circular(15.0), // Borde inferior derecho
        ),
        child: Container( // Contenedor de la rejilla de estadísticas
          color: Color.fromARGB(255, 19, 60, 42), // Color de fondo del contenedor
          child: Column( // Columna que contiene los widgets secundarios
            crossAxisAlignment: CrossAxisAlignment.start, // Alineación cruzada al inicio
            children: [
              Padding( // Espaciado interior con relleno
                padding: const EdgeInsets.all(8.0),
                child: Row( // Fila que contiene el título y el ícono
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alineación principal: espacio entre elementos
                  children: [
                    Text( // Widget de texto para mostrar "Mis Estadísticas"
                      'Mis Estadísticas', // Texto estático
                      style: TextStyle(
                        color: Colors.white, // Color de texto blanco
                        fontSize: 24, // Tamaño de fuente 24
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.query_stats, color: Colors.white, size: 30) // Ícono de estadísticas
                  ],
                ),
              ),
              Divider( // Widget de línea divisoria
                color: Colors.grey, // Color de la línea divisoria
                thickness: 2.0, // Grosor de la línea
                indent: 20.0, // Ajusta el espacio izquierdo del Divider
                endIndent: 20.0, // Ajusta el espacio derecho del Divider
              ),
              Container( // Contenedor para la rejilla de estadísticas
                height: MediaQuery.of(context).size.height * 0.3, // Altura del contenedor (30% de la altura de la pantalla)
                child: GridView.count( // Rejilla de cuadrícula con recuento fijo de elementos
                  physics: NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento dentro de la rejilla
                  crossAxisCount: 2, // Número de elementos en el eje transversal
                  childAspectRatio: 2, // Relación de aspecto de los elementos
                  children: <Widget>[
                    StatCard( // Widget de tarjeta de estadísticas para el registro de operaciones
                      title: 'Registro de Operaciones', // Título de la tarjeta
                      amount: '\$4689.56', // Monto de operaciones
                      iconData: Icons.article_outlined, // Ícono de la tarjeta
                      color: Colors.green, // Color de la tarjeta
                    ),
                    StatCard( // Widget de tarjeta de estadísticas para ganancias totales
                      title: 'Ganancias Totales', // Título de la tarjeta
                      amount: '\$2998.32', // Monto de ganancias
                      iconData: Icons.stacked_line_chart_sharp, // Ícono de la tarjeta
                      color: Colors.green, // Color de la tarjeta
                    ),
                    StatCard( // Widget de tarjeta de estadísticas para pérdidas totales
                      title: 'Pérdidas Totales', // Título de la tarjeta
                      amount: '\$726.38', // Monto de pérdidas
                      iconData: Icons.trending_down_sharp, // Ícono de la tarjeta
                      color: Colors.red, // Color de la tarjeta
                    ),
                    StatCard( // Widget de tarjeta de estadísticas para operaciones de empate totales
                      title: 'Operaciones de Empate Totales', // Título de la tarjeta
                      amount: '\$964.86', // Monto de operaciones de empate
                      iconData: Icons.compare_arrows_outlined, // Ícono de la tarjeta
                      color: Colors.orange, // Color de la tarjeta
                    ),
                    // ... Resto de las tarjetas de estadísticas
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget de tarjeta de estadísticas que muestra un título, un monto y un ícono
class StatCard extends StatelessWidget {
  final String title; // Título de la tarjeta de estadísticas
  final String amount; // Monto mostrado en la tarjeta de estadísticas
  final IconData iconData; // Icono de la tarjeta de estadísticas
  final Color color; // Color del ícono de la tarjeta de estadísticas

  const StatCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.iconData,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( // Contenedor de la tarjeta de estadísticas
      color: Color.fromARGB(255, 19, 60, 42), // Color de fondo del contenedor
      margin: const EdgeInsets.all(12.0), // Margen externo
      padding: const EdgeInsets.all(12.0), // Relleno interno
      child: Row( // Fila que contiene el ícono y el texto
        children: <Widget>[
          Icon(iconData, color: color, size: 40), // Ícono de la tarjeta con el color proporcionado
          SizedBox(width: 12), // Espaciado horizontal
          Expanded( // Widget expandido para el texto
            child: Column( // Columna que contiene los widgets secundarios
              crossAxisAlignment: CrossAxisAlignment.start, // Alineación cruzada al inicio
              children: <Widget>[
                AutoSizeText( // Widget de texto con tamaño automático
                  title, // Título de la tarjeta
                  style: TextStyle(
                    color: Color.fromARGB(255, 230, 230, 230), // Color de texto blanco
                    fontSize: 13, // Tamaño de fuente 13
                    fontWeight: FontWeight.bold, // Fuente en negrita
                  ),
                  maxLines: 2, // Número máximo de líneas
                ),
                AutoSizeText( // Widget de texto con tamaño automático
                  amount, // Monto mostrado en la tarjeta
                  style: TextStyle(
                    color: color, // Color del texto
                    fontSize: 18, // Tamaño de fuente 18
                    fontWeight: FontWeight.bold, // Fuente en negrita
                  ),
                  maxLines: 1, // Número máximo de líneas
                  minFontSize: 10, // Tamaño mínimo de fuente
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
