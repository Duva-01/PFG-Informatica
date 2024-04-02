import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Importa el paquete para animaciones
import 'package:grownomics/controladores/marketController.dart'; // Importa el archivo que contiene las funciones para obtener datos del mercado

class ResumenMercadoWidget extends StatefulWidget {
  final String userEmail;

  const ResumenMercadoWidget({
    required this.userEmail,
  });

  @override
  _ResumenMercadoWidgetState createState() => _ResumenMercadoWidgetState();
}

class _ResumenMercadoWidgetState extends State<ResumenMercadoWidget> {
  Future<Map<String, dynamic>>? resumenMercado; // Futuro que almacenará el resumen del mercado

  @override
  void initState() {
    super.initState();
    resumenMercado = MercadoController.obtenerResumenMercado(); // Llama a la función para obtener el resumen del mercado cuando se inicializa el widget
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUpBig( // Aplica una animación de rebote hacia abajo al contenido del widget
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          margin: EdgeInsets.only(bottom: 10),
          color: Color.fromARGB(255, 19, 60, 42), // Color de fondo del contenedor
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Resumen del Mercado', // Título del resumen del mercado
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.query_stats, color: Colors.white, size: 30) // Icono para representar estadísticas del mercado
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 2.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: resumenMercado,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Muestra un indicador de carga mientras se espera la respuesta del resumen del mercado
                    return Center(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              color: Color(0xFF2F8B62),
                            )));
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    // Muestra un mensaje de error si ocurre un problema al cargar los datos
                    return Center(
                        child: Text(
                      "Error al cargar el resumen del mercado",
                      style: TextStyle(color: Colors.white),
                    ));
                  } else {
                    // Si se reciben los datos correctamente, muestra las secciones de índices y sectores
                    final datos = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildIndicesSection(datos['indices']), // Construye la sección de índices
                          SizedBox(height: 20),
                          _buildSectoresSection(datos['sectores'], // Construye la sección de sectores con su sentimiento de mercado
                              datos['sentimiento_mercado'], context),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir la sección de índices
  Widget _buildIndicesSection(Map<String, dynamic> indices) {
    List<Widget> list = [];
    indices.forEach((key, value) {
      // Formatea el cambio y el precio actual
      String changeFormatted = value['change'].toStringAsFixed(4);
      String priceFormatted = value['current_price'].toStringAsFixed(2);
      double percentChange = value['percent_change'];
      // Establece el color del texto según si el cambio es positivo o negativo
      Color textColor = percentChange >= 0 ? Colors.green : Colors.red;

      list.add(ListTile(
        title: Text(
          key,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text(
              'Precio actual: ',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '$priceFormatted',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Text(
              'Cambio: ',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '$changeFormatted%',
              style: TextStyle(
                  color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(top: 10, left: 20),
            child: Text('Principales Índices:', // Título de la sección de índices
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
        Divider(),
        ...list,
      ],
    );
  }

  // Método para construir la sección de sectores
  Widget _buildSectoresSection(Map<String, dynamic> sectores,
      String sentimientoMercado, BuildContext context) {
    List<Widget> list = [];
    sectores.forEach((key, value) {
      // Formatea el valor del sector
      String sectorFormatted =  value.toStringAsFixed(2);
      // Establece el color del texto según si el valor del sector es positivo o negativo
      Color textColor = value >= 0 ? Colors.green : Colors.red;

      list.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              "Sector de la " + key,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  'Cambio: ',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  '$sectorFormatted%',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    // Divide la lista en dos para mostrar dos sectores en cada columna
    int halfLength = (list.length / 2).ceil();
    List<Widget> column1 = list.sublist(0, halfLength);
    List<Widget> column2 = list.sublist(halfLength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Text(
            'Sectores en movimiento:', // Título de la sección de sectores
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: column1,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: column2,
              ),
            ),
          ],
        ),
        SizedBox(
            height:
                10), // Espaciado entre la sección de sectores y el ListTile del sentimiento del mercado
        ListTile(
          title: Text(
            'Sentimiento del Mercado', // Título del sentimiento del mercado
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            sentimientoMercado, // Muestra el sentimiento del mercado
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.info), // Icono de información para mostrar detalles del sentimiento del mercado
            color: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Más Información', // Título del diálogo de información
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'El sentimiento del mercado indica la tendencia general del mercado financiero.', // Información sobre el sentimiento del mercado
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Positivo:', // Descripción del sentimiento positivo
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Indica que hay optimismo en el mercado, con tendencia alcista. En este escenario, se recomienda considerar mantener las inversiones a largo plazo y buscar oportunidades para comprar activos que se espera que continúen su tendencia alcista.', // Detalles sobre el sentimiento positivo
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Negativo:', // Descripción del sentimiento negativo
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Indica que hay pesimismo en el mercado, con tendencia bajista. En esta situación, se aconseja precaución y considerar la posibilidad de vender activos si es necesario para proteger las inversiones. También puede ser prudente buscar activos que se consideren refugios seguros.', // Detalles sobre el sentimiento negativo
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Neutro:', // Descripción del sentimiento neutro
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Indica que no hay una clara tendencia en el mercado. En este caso, se recomienda realizar un análisis más detallado de cada activo antes de tomar decisiones de inversión. Puede ser un momento para diversificar la cartera y considerar estrategias de inversión a corto plazo.', // Detalles sobre el sentimiento neutro
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cerrar'), // Botón para cerrar el diálogo
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

