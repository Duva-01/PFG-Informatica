import 'package:flutter/material.dart'; // Importar el paquete flutter material
import 'package:grownomics/api/portfolioAPI.dart'; // Importar API para información de cartera
import 'package:intl/intl.dart'; // Importar paquete para formato de fechas

class PaginaTransaccion extends StatefulWidget { // Página para mostrar todas las transacciones
  final String userEmail; // Email del usuario

  PaginaTransaccion({required this.userEmail}); // Constructor

  @override
  _PaginaTransaccionState createState() => _PaginaTransaccionState(); // Crear estado de la página
}

class _PaginaTransaccionState extends State<PaginaTransaccion> { // Estado de la página
  late Future<List<dynamic>> _transaccionesFuturas; // Futuro para obtener las transacciones

  @override
  void initState() { // Inicialización del estado
    super.initState(); // Llamar al método initState de la clase base
    _transaccionesFuturas = obtenerTransaccionesUsuario(widget.userEmail); // Obtener transacciones del usuario
  }

  @override
  Widget build(BuildContext context) { // Construir la página
    return Scaffold( // Estructura básica de la página
      appBar: AppBar(
    // Barra de aplicaciones en la parte superior de la página
    title: Text(
      "Todas mis transacciones",
      style: TextStyle(
        color: Colors.white, // Color del texto blanco
      ),
    ), // Título de la aplicación
    centerTitle: true, // Centra el título en la barra de aplicaciones
    backgroundColor:
        Theme.of(context).primaryColor, // Color de fondo de la AppBar según el color primario del tema
    shadowColor: Colors.black,
    elevation: 4,
    leading: IconButton(
      // Widget de icono para el botón de retroceso
      icon: Icon(Icons.arrow_back, color: Colors.white), // Icono de flecha hacia atrás
      onPressed: () {
        // Manejador de eventos cuando se presiona el botón de retroceso
        Navigator.of(context).pop(); // Volver atrás en la navegación
      },
    ),
  ),
      body: FutureBuilder<List<dynamic>>( // Constructor futuro para construir basado en datos futuros
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
    );
  }
}
