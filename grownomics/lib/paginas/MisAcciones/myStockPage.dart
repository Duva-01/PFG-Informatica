import 'dart:math'; // Importa la biblioteca para generar números aleatorios
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart'; // Importa la biblioteca para gráficos
import 'package:flutter/material.dart'; // Importa la biblioteca Flutter
import 'package:flutter/widgets.dart'; // Importa la biblioteca de widgets de Flutter
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart'; // Importa la biblioteca para el menú deslizante
import 'package:grownomics/widgets/tituloWidget.dart'; // Importa el widget del título
import 'package:intl/intl.dart'; // Importa la biblioteca para formato de fechas
import 'package:grownomics/controladores/marketController.dart'; // Importa la API del mercado
import 'package:grownomics/controladores/portfolioController.dart'; // Importa la API de la cartera
import 'package:grownomics/modelos/Accion.dart'; // Importa el modelo de la acción

class PaginaMisAcciones extends StatefulWidget {
  final String userEmail;

  PaginaMisAcciones({required this.userEmail});

  @override
  _PaginaMisAccionesState createState() => _PaginaMisAccionesState();
}

class _PaginaMisAccionesState extends State<PaginaMisAcciones> {
  late Future<List<Accion>> _misAcciones;
  late Future<List<dynamic>> _transaccionesFuturas;

  @override
  void initState() {
    super.initState();
    // Obtiene las acciones del usuario y las transacciones asociadas
    _misAcciones = MercadoController.obtenerMisAcciones(widget.userEmail);
    _transaccionesFuturas = CarteraController.obtenerTransaccionesUsuario(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        ZoomDrawer.of(context); // Obtiene el controlador del menú deslizante
    return Scaffold(
      appBar: AppBar(
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          'Mis acciones', // Título de la aplicación
          style: TextStyle(
            color: Colors.white, // Color del texto blanco
          ),
        ),
        centerTitle: true, // Centra el título en la barra de aplicaciones
        leading: IconButton(
          // Widget de icono para el botón de menú deslizante
          icon: Icon(Icons.menu, color: Colors.white), // Icono de menú
          onPressed: () {
            controller
                ?.toggle(); // Abre o cierra el menú deslizante al presionar el botón
          },
        ),
        backgroundColor: Theme.of(context)
            .primaryColor, // Color de fondo de la AppBar según el color primario del tema
        shadowColor: Colors.black, // Color de la sombra
        elevation: 4, // Elevación de la AppBar
      ),
      body: FutureBuilder<List<Accion>>(
        future: _misAcciones, // Futuro para obtener las acciones del usuario
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Si se está esperando la conexión
            return Center(
                child:
                    CircularProgressIndicator(color: Color(0xFF2F8B62))); // Muestra un indicador de carga centrado
          } else if (snapshot.hasError) {
            // Si hay un error
            return Center(
                child: Text(
                    "Error al cargar las acciones")); // Muestra un mensaje de error
          } else if (!snapshot.hasData) {
            // Si no hay datos disponibles
            return Center(
                child: Text(
                    "No tienes acciones")); // Muestra un mensaje indicando que no hay acciones
          } else {
            // Si hay datos disponibles
            var chartData = buildPieChart(
                snapshot.data!); // Genera los datos para el gráfico circular
            double valorCartera = snapshot.data!.fold(
                0,
                (valor, accion) =>
                    valor +
                    (accion.precioActual *
                        accion
                            .accionesRestantes)); // Calcula el valor total de la cartera
            return FadeInUp(
              child: SingleChildScrollView(
                // Widget desplazable
                child: Column(
                  children: [
                    buildTitulo(
                        "Diversificación de la cartera"), // Widget del título "Diversificación de la cartera"
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: chartData['chart'], // Widget del gráfico circular
                    ),
                    buildLegend(
                        chartData['colors']), // Widget de la leyenda del gráfico
                    buildDiversificationExpansionTile(), // Widget del panel de expansión "¿Por qué es importante diversificar la cartera?"
                    buildTitulo(
                        "Acciones en Cartera"), // Widget del título "Acciones en Cartera"
                    buildValorCartera(
                        valorCartera), // Widget del valor actual de la cartera
                    ListView.builder(
                      // Constructor de la lista de acciones
                      shrinkWrap:
                          true, // Reduce el tamaño de la lista para que se ajuste al contenido
                      physics:
                          NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento de la lista
                      itemCount: snapshot
                          .data!.length, // Número de elementos en la lista
                      itemBuilder: (context, index) {
                        // Constructor de cada elemento de la lista
                        Accion accion = snapshot.data![index]; // Acción actual
                        return AccionWidget(
                          // Widget de la acción
                          accion: accion, // Acción actual
                          transaccionesFuturas:
                              _transaccionesFuturas, // Transacciones futuras
                          backgroundColor: Color.fromARGB(
                              255, 19, 60, 42), // Color de fondo del widget
                          textColor: Colors.white, // Color del texto del widget
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// Widget para mostrar el valor actual de la cartera
Widget buildValorCartera(double valorCartera) {
  return Container(
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
      color: Color.fromARGB(255, 19, 60, 42), // Color de fondo
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Sombra con opacidad
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        // Parte superior de la tarjeta
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "VALOR ACTUAL DE LA CARTERA", // Título
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(
                Icons.account_balance_wallet, // Icono de cartera
                color: Colors.white,
              ),
            ],
          ),
        ),
        // Parte inferior de la tarjeta
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          decoration: BoxDecoration(
            color: Color(0xFF2F8B62), // Color de fondo
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'Precio actual: ${valorCartera.toStringAsFixed(2)}€', // Valor actual de la cartera
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Construye el gráfico circular y la leyenda
Map<String, dynamic> buildPieChart(List<Accion> acciones) {
  List<PieChartSectionData> sections = []; // Secciones del gráfico
  Map<String, Color> colorMap = {}; // Mapeo de colores
  double totalValor = acciones.fold(
      0,
      (valor, accion) =>
          valor +
          (accion.precioActual *
              accion.accionesRestantes)); // Valor total de la cartera
  Random random = Random(); // Generador de números aleatorios

  acciones.forEach((accion) {
    double porcentaje = (accion.precioActual * accion.accionesRestantes) /
        totalValor; // Porcentaje de cada acción
    // Genera colores aleatorios
    Color color = Color.fromRGBO(
      128 + random.nextInt(64), // Componente rojo
      128 + random.nextInt(64), // Componente verde
      128 + random.nextInt(64), // Componente azul
      1,
    );
    // Agrega la sección al gráfico
    sections.add(PieChartSectionData(
        color: color,
        value: porcentaje * 100,
        title:
            '${(porcentaje * 100).toStringAsFixed(2)}%', // Porcentaje en el título
        radius: 50, // Radio de la sección
        titleStyle:
            TextStyle(fontSize: 12, color: Colors.white))); // Estilo del título
    colorMap[accion.nombre] = color; // Mapea el color a la acción
  });

  return {
    'chart': Container(
        height: 200,
        child: PieChart(PieChartData(
            sections: sections,
            sectionsSpace: 0,
            centerSpaceRadius: 40))), // Widget del gráfico
    'colors': colorMap, // Mapeo de colores
  };
}

// Construye la leyenda del gráfico
Widget buildLegend(Map<String, Color> colorMap) {
  return Wrap(
    children: colorMap.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 16,
                height: 16,
                color: entry.value,
                margin: const EdgeInsets.only(right: 8)),
            Text(entry.key), // Texto de la entrada
          ],
        ),
      );
    }).toList(),
  );
}

// Widget para el panel de expansión "¿Por qué es importante diversificar la cartera?"
Widget buildDiversificationExpansionTile() {
  return ExpansionTile(
    title: Text(
      '¿Por qué es importante diversificar la cartera?', // Título del panel
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic), // Estilo del texto
    ),
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explicación básica:", // Título
                  style: TextStyle(
                      fontWeight: FontWeight.bold), // Estilo del texto
                ),
                SizedBox(height: 8),
                Text(
                  "Diversificar la cartera es clave para reducir el riesgo. Al invertir en una variedad de activos, las pérdidas en una inversión pueden ser compensadas por ganancias en otras. Esto conduce a una variabilidad menor en el rendimiento total de la cartera a lo largo del tiempo.", // Descripción básica
                  textAlign: TextAlign.justify, // Alineación del texto
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explicación avanzada:", // Título
                  style: TextStyle(
                      fontWeight: FontWeight.bold), // Estilo del texto
                ),
                SizedBox(height: 8),
                Text(
                  "La diversificación es una técnica de gestión de riesgos que mezcla una amplia variedad de inversiones dentro de una cartera. Según la Teoría Moderna del Portafolio, formulada por Harry Markowitz, diversificar reduce el riesgo no sistemático de la cartera, ya que los eventos adversos afectan menos a una cartera diversificada.\n\nLa fórmula para calcular el riesgo total de una cartera diversificada es:\n\nRiesgo Total = Riesgo Sistemático + Riesgo No Sistemático\n\nDonde el riesgo no sistemático puede reducirse mediante la diversificación. Esta teoría propone que el riesgo sistemático (o de mercado) no puede eliminarse, pero el riesgo específico del activo (no sistemático) sí se puede reducir hasta cierto punto. En esencia, al diversificar, los inversores pueden alcanzar un 'punto óptimo' en el que el riesgo total de la cartera se minimiza para un determinado nivel de rendimiento esperado.", // Descripción avanzada
                  textAlign: TextAlign.justify, // Alineación del texto
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

// Widget para mostrar cada acción en la lista
class AccionWidget extends StatelessWidget {
  final Accion accion; // Acción
  final Future<List<dynamic>> transaccionesFuturas; // Transacciones futuras
  final Color backgroundColor; // Color de fondo
  final Color textColor; // Color del texto

  AccionWidget({
    required this.accion,
    required this.transaccionesFuturas,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Elevación de la tarjeta
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Márgenes
      color: backgroundColor, // Color de fondo
      child: Padding(
        padding: EdgeInsets.all(16), // Relleno interno
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              accion.nombre, // Nombre de la acción
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Nº de Acciones: ${accion.accionesRestantes}', // Número de acciones
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
                SizedBox(width: 16), // Espacio entre el texto y el círculo
                _buildTickerCodeCircle(accion
                    .codigoticker), // Widget del círculo con el código del ticker
              ],
            ),
            Text(
              'Precio Actual: ${accion.precioActual.toStringAsFixed(2)}€', // Precio actual
              style: TextStyle(
                  fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Divider(color: Theme.of(context).primaryColor), // Línea divisoria
            FutureBuilder<List<dynamic>>(
              future:
                  transaccionesFuturas, // Futuro para obtener las transacciones futuras
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var transacciones = snapshot.data!
                      .where((transaccion) =>
                          transaccion['accion'] == accion.nombre)
                      .toList(); // Filtra las transacciones por acción
                  return ExpansionTile(
                    title:
                        Text('Transacciones', // Título del panel de expansión
                            style: TextStyle(color: textColor)),
                    iconColor: Colors.white, // Color del ícono
                    collapsedIconColor:
                        Colors.white, // Color del ícono colapsado
                    children: [
                      ListView.builder(
                        shrinkWrap: true, // Reducción del tamaño de la lista
                        physics:
                            NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento de la lista
                        itemCount: transacciones
                            .length, // Número de elementos en la lista
                        itemBuilder: (context, index) {
                          var transaccion =
                              transacciones[index]; // Transacción actual
                          double valorTotal = double.parse(
                                  transaccion['cantidad'].toString()) *
                              double.parse(transaccion['precio']
                                  .toString()); // Calcula el valor total de la transacción
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Márgenes horizontales
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "${transaccion['tipo']} - ${DateFormat('yyyy/MM/dd').format(DateTime.parse(transaccion['fecha']))}", // Tipo de transacción y fecha
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${transaccion['cantidad']} uds x ${transaccion['precio'].toStringAsFixed(2)}", // Cantidad y precio de la transacción
                                    style: TextStyle(
                                        fontSize: 14, color: textColor),
                                  ),
                                  trailing: Text(
                                    "Total: ${valorTotal.toStringAsFixed(2)} €", // Valor total de la transacción
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: textColor.withAlpha(
                                      150), // Color de la línea divisoria
                                  thickness: 1, // Grosor de la línea divisoria
                                  height: 0,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(
                      "Error al cargar transacciones", // Mensaje de error
                      style: TextStyle(color: textColor));
                } else {
                  return CircularProgressIndicator(); // Indicador de carga
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget para el círculo con el código del ticker
  Widget _buildTickerCodeCircle(String tickerCode) {
    return Container(
      width: 80, // Ancho del círculo
      height: 80, // Altura del círculo
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Forma del círculo
        color: Colors.white, // Color de fondo
      ),
      child: Center(
        child: Text(
          tickerCode, // Texto dentro del círculo
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Color del texto
          ),
        ),
      ),
    );
  }
}
