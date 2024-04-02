import 'package:animated_button_bar/animated_button_bar.dart'; // Importar paquete para botones animados
import 'package:flutter/material.dart'; // Importar el paquete flutter material
import 'package:fl_chart/fl_chart.dart'; // Importar paquete para gráficos
import 'package:grownomics/controladores/marketController.dart'; // Importar API para información de mercado
import 'package:grownomics/controladores/portfolioController.dart'; // Importar API para información de cartera
import 'package:intl/intl.dart'; // Importar paquete para formato de fechas

class HistorialWidget extends StatefulWidget {
  final String userEmail;

  HistorialWidget({required this.userEmail});

  @override
  _HistorialWidgetState createState() => _HistorialWidgetState();
}

class _HistorialWidgetState extends State<HistorialWidget> {
  String _intervalo = '1wk'; // Intervalo inicial para el historial
  AnimatedButtonController _controller = AnimatedButtonController();

  @override
  void initState() {
    // Inicialización del estado
    super.initState(); // Llamar al método initState de la clase base
  }

  @override
  Widget build(BuildContext context) {
    // Construir el widget
    return Column(
      // Columna principal
      crossAxisAlignment:
          CrossAxisAlignment.start, // Alineación del contenido al principio
      children: [
        Container(
          // Contenedor para el título
          margin: const EdgeInsets.only(top: 10), // Margen superior
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Padding horizontal
          child: Text(
            // Texto del título
            'Historial', // Texto
            style: TextStyle(
              // Estilo del texto
              fontSize: 20, // Tamaño de fuente
              fontWeight: FontWeight.bold, // Peso de la fuente
              color: Colors.blueGrey[800], // Color del texto
            ),
          ),
        ),
        Divider(
          // Divisor
          color: Colors.blueGrey[800], // Color
          thickness: 2, // Grosor
          height: 20, // Altura
          indent: 16, // Sangría izquierda
          endIndent: 16, // Sangría derecha
        ),
        AnimatedButtonBar(
          // Barra de botones animados para intervalos de tiempo
          radius: 8.0, // Radio de borde de los botones
          padding: const EdgeInsets.all(8.0), // Padding
          backgroundColor:
              Colors.white, // Color de fondo por defecto para todos los botones
          foregroundColor: Theme.of(context)
              .primaryColor, // Color de texto por defecto para todos los botones

          children: [
            ButtonBarEntry(
              // Entrada para el botón de 1 semana
              onTap: () {
                // Acción al hacer tap
                setState(() {
                  // Actualizar estado
                  _intervalo = '1wk'; // Cambiar intervalo a 1 semana
                });
              },
              child: Text(
                '1 Semana',
                style: TextStyle(
                  color: _intervalo == '1wk' ? Colors.white : Colors.black,
                ),
              ),
            ),
            ButtonBarEntry(
              // Entrada para el botón de 1 mes
              onTap: () {
                // Acción al hacer tap
                setState(() {
                  // Actualizar estado
                  _intervalo = '1mo'; // Cambiar intervalo a 1 mes
                });
              },
              child: Text(
                '1 mes',
                style: TextStyle(
                  color: _intervalo == '1mo' ? Colors.white : Colors.black,
                ),
              ), // Texto del botón
            ),
            ButtonBarEntry(
              // Entrada para el botón de 3 meses
              onTap: () {
                // Acción al hacer tap
                setState(() {
                  // Actualizar estado
                  _intervalo = '3mo'; // Cambiar intervalo a 3 meses
                });
              },
              child: Text(
                '3 meses',
                style: TextStyle(
                  color: _intervalo == '3mo' ? Colors.white : Colors.black,
                ),
              ), // Texto del botón
            ),
            ButtonBarEntry(
              // Entrada para el botón de 1 año
              onTap: () {
                // Acción al hacer tap
                setState(() {
                  // Actualizar estado
                  _intervalo = '1y'; // Cambiar intervalo a 1 año
                });
              },
              child: Text(
                '1 año',
                style: TextStyle(
                  color: _intervalo == '1y' ? Colors.white : Colors.black,
                ),
              ), // Texto del botón
            ),
          ],
        ),
        SizedBox(height: 20), // Espacio vertical
        FutureBuilder<List<dynamic>>(
          // Constructor futuro para construir basado en datos futuros
          future: CarteraController.obtenerTransaccionesUsuario(widget
              .userEmail), // Futuro para obtener transacciones del usuario
          builder: (context, snapshot) {
            // Constructor de contenido basado en el estado del futuro
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Si está cargando
              return Center(
                  child:
                      CircularProgressIndicator()); // Mostrar indicador de carga centrado
            } else if (snapshot.hasError) {
              // Si hay un error
              return Text(
                  'Error al cargar datos: ${snapshot.error}'); // Mostrar mensaje de error
            } else if (snapshot.hasData) {
              // Si hay datos disponibles
              return _buildChart(
                  snapshot.data!); // Construir gráfico con los datos
            } else {
              // Si no hay datos
              return Text(
                  "No hay datos disponibles"); // Mostrar mensaje de no hay datos
            }
          },
        ),
      ],
    );
  }

  Widget _buildChart(List<dynamic> transactions) {
    // Método para construir el gráfico

    // Si no hay transacciones, retorna un gráfico o widget vacío
    if (transactions.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Text("No hay datos históricos para mostrar"),
      );
    }

    double maxBalance = double.negativeInfinity; // Balance máximo inicial
    double minBalance = double.infinity; // Balance mínimo inicial
    List<FlSpot> spots = []; // Lista de puntos en el gráfico
    List<String> xAxisTitles = []; // Títulos para el eje X

    // Calcular el balance y encontrar el máximo y mínimo
    double balance = 0.0; // Balance inicial

    for (var i = 0; i < transactions.length; i++) {
      // Iterar sobre las transacciones
      var transaction = transactions[i]; // Transacción actual
      if (transaction['tipo'] == 'compra') {
        // Si es una compra
        balance -= transaction['cantidad'] *
            transaction['precio']; // Restar al balance
      } else {
        // Si es una venta
        balance +=
            transaction['cantidad'] * transaction['precio']; // Sumar al balance
      }
      maxBalance = balance > maxBalance
          ? balance
          : maxBalance; // Actualizar balance máximo
      minBalance = balance < minBalance
          ? balance
          : minBalance; // Actualizar balance mínimo
      spots.add(FlSpot(i.toDouble() + 1, balance)); // Añadir punto al gráfico

      // Añadir las fechas al eje X
      if (i == 0 ||
          i == transactions.length ~/ 2 ||
          i == transactions.length - 1) {
        // Si es la primera, la del medio o la última
        xAxisTitles.add(DateFormat('yyyy/MM/dd').format(
            DateTime.parse(transaction['fecha']))); // Añadir fecha al eje X
      } else {
        // Si no
        xAxisTitles.add(''); // Dejar vacío
      }
    }

    // Asegurarnos de que el primer punto sea en 0.0
    if (transactions.isNotEmpty) {
      // Si hay transacciones
      if (spots[0].y != 0.0) {
        // Si el primer punto no es en 0.0
        spots.insert(0, FlSpot(0, 0.0)); // Insertar punto en 0.0
        xAxisTitles.insert(0, ""); // Insertar título vacío para la fecha
      }
    }

    // Configuración de los títulos en los ejes
    FlTitlesData titlesData = FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 80,
          interval: ((maxBalance - minBalance) / 5).ceil().toDouble(),
          getTitlesWidget: (double value, TitleMeta meta) {
            if (value == 0.0) {
              return Text('');
            } else if (value == maxBalance) {
              return Text('Max: ${maxBalance.toStringAsFixed(2)}');
            } else if (value == minBalance) {
              return Text('Min: ${minBalance.toStringAsFixed(2)}');
            }
            return Text('');
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            int index = value.toInt();
            if (index == 0 ||
                index == (xAxisTitles.length ~/ 2) ||
                index == xAxisTitles.length - 1) {
              return Text(xAxisTitles[index]);
            }
            return SizedBox(); // Retorna un widget vacío para ocultar los otros títulos
          },
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          getTitlesWidget: (double value, TitleMeta meta) {
            return SizedBox(); // Retorna un widget vacío para ocultar los otros títulos
          },
        ),
      ),
    );

    // Construir el gráfico
    return Container(
      // Contenedor del gráfico
      padding: EdgeInsets.all(10), // Padding
      height: MediaQuery.of(context).size.height * 0.3, // Altura
      width: MediaQuery.of(context).size.width, // Ancho
      child: LineChart(
        // Gráfico de líneas
        LineChartData(
          // Datos del gráfico de líneas
          gridData: FlGridData(show: true), // Datos de la cuadrícula
          titlesData: titlesData, // Datos de los títulos
          borderData: FlBorderData(show: true), // Datos del borde
          lineBarsData: [
            // Datos de las barras de líneas
            LineChartBarData(
              // Datos de la barra de líneas
              spots: spots, // Puntos del gráfico
              isCurved: true, // Curva suavizada
              color: Colors.green, // Color de la línea
              barWidth: 5, // Ancho de la línea
              isStrokeCapRound: true, // Extremo redondeado
              dotData: FlDotData(show: true), // Datos de los puntos
              belowBarData:
                  BarAreaData(show: true), // Datos del área debajo de la línea
            ),
          ],
        ),
      ),
    );
  }
}
