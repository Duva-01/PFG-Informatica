import 'package:flutter/material.dart'; // Importar el paquete flutter material
import 'package:grownomics/api/portfolioAPI.dart'; // Importar API para información de cartera
import 'package:grownomics/paginas/Cartera/transactionsPage.dart'; // Importar página de transacciones
import 'package:intl/intl.dart'; // Importar paquete para formato de fechas

class ListaTransaccionWidget extends StatefulWidget { // Widget para mostrar la lista de transacciones
  final String userEmail; // Email del usuario

  ListaTransaccionWidget({required this.userEmail}); // Constructor

  @override
  _ListaTransaccionWidgetState createState() => _ListaTransaccionWidgetState(); // Crear estado del widget
}

class _ListaTransaccionWidgetState extends State<ListaTransaccionWidget> { // Estado del widget
  late Future<List<dynamic>> _transaccionesFuturas; // Futuro para obtener las transacciones

  @override
  void initState() { // Inicialización del estado
    super.initState(); // Llamar al método initState de la clase base
    _transaccionesFuturas = obtenerTransaccionesUsuario(widget.userEmail); // Obtener transacciones del usuario
  }

  @override
  Widget build(BuildContext context) { // Construir el widget
    return Column( // Columna principal
      crossAxisAlignment: CrossAxisAlignment.start, // Alineación del contenido al principio
      children: [
        Container( // Contenedor para el título
          margin: const EdgeInsets.only(top: 30), // Margen superior
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal
          child: Text( // Texto del título
            'Últimas Transacciones', // Texto
            style: TextStyle( // Estilo del texto
              fontSize: 20, // Tamaño de fuente
              fontWeight: FontWeight.bold, // Peso de la fuente
              color: Colors.blueGrey[800], // Color del texto
            ),
          ),
        ),
        Divider( // Divisor
          color: Colors.blueGrey[800], // Color
          thickness: 2, // Grosor
          height: 20, // Altura
          indent: 16, // Sangría izquierda
          endIndent: 16, // Sangría derecha
        ),
        SizedBox(height: 10), // Espacio vertical
        FutureBuilder<List<dynamic>>( // Constructor futuro para construir basado en datos futuros
          future: _transaccionesFuturas, // Futuro para obtener transacciones
          builder: (context, snapshot) { // Constructor de contenido basado en el estado del futuro
            if (snapshot.hasData) { // Si hay datos disponibles
              // Ordenar las transacciones por fecha de forma descendente
              snapshot.data!.sort((a, b) { // Ordenar las transacciones
                DateTime fechaA = DateTime.parse(a['fecha']); // Convertir fecha de transacción a DateTime
                DateTime fechaB = DateTime.parse(b['fecha']); // Convertir fecha de transacción a DateTime
                return fechaB.compareTo(fechaA); // Ordenar descendente
              });

              return ListView.builder( // Constructor de lista con elementos generados bajo demanda
                shrinkWrap: true, // Reducir el tamaño de la lista para que se ajuste al contenido
                physics: NeverScrollableScrollPhysics(), // Deshabilitar el desplazamiento
                itemCount: snapshot.data!.length.clamp(0, 5), // Limitar el número de elementos a mostrar a 5
                itemBuilder: (context, index) { // Constructor de cada elemento de la lista
                  var transaccion = snapshot.data![index]; // Transacción actual
                  double valorTotal = double.parse(transaccion['cantidad'].toString()) * double.parse(transaccion['precio'].toString()); // Calcular el valor total de la transacción
                  return Padding( // Padding alrededor del elemento de la lista
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal
                    child: Column( // Columna de elementos
                      children: [
                        ListTile( // Elemento de lista con título, subtítulo y contenido secundario
                          title: Text( // Título de la transacción
                            transaccion['accion'], // Nombre de la acción
                            style: TextStyle( // Estilo del texto
                              fontWeight: FontWeight.bold, // Peso de la fuente
                              fontSize: 16, // Tamaño de la fuente
                            ),
                          ),
                          subtitle: Text( // Subtítulo de la transacción
                            "${transaccion['tipo']} - ${DateFormat('yyyy/MM/dd').format(DateTime.parse(transaccion['fecha']))} - ${transaccion['cantidad']} uds x ${transaccion['precio'].toStringAsFixed(2)}", // Detalles de la transacción
                            style: TextStyle(fontSize: 14), // Estilo del texto
                          ),
                          trailing: Text( // Contenido secundario al final del elemento
                            "Total: ${valorTotal.toStringAsFixed(2)} €", // Valor total de la transacción
                            style: TextStyle( // Estilo del texto
                              fontWeight: FontWeight.bold, // Peso de la fuente
                              fontSize: 16, // Tamaño de la fuente
                            ),
                          ),
                        ),
                        Divider( // Divisor entre elementos de la lista
                          color: Colors.grey[300], // Color
                          thickness: 1, // Grosor
                          height: 0, // Altura
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) { // Si hay un error
              return Text("Error al cargar transacciones"); // Mostrar mensaje de error
            }
            return CircularProgressIndicator(); // Mostrar indicador de carga
          },
        ),
        SizedBox(height: 10), // Espacio vertical
        Padding( // Padding alrededor del botón
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal
          child: Center( // Centrar el botón
            child: ElevatedButton( // Botón elevado
            style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors
                          .white), // Color del texto según el color primario del tema
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
              onPressed: () { // Acción al hacer tap en el botón
                Navigator.push( // Navegar a la página de transacciones
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaginaTransaccion(userEmail: widget.userEmail)), // Constructor de la página de transacciones
                );
              },
              child: Text('Ver Todas'), // Texto del botón
            ),
          ),
        ),
        SizedBox(height: 10), // Espacio vertical
      ],
    );
  }
}
