import 'package:flutter/material.dart'; // Importar el paquete flutter material
import 'package:grownomics/api/portfolioAPI.dart'; // Importar API para información de cartera
import 'package:grownomics/modelos/Transaccion.dart';
import 'package:grownomics/paginas/Cartera/transactionsPage.dart'; // Importar página de transacciones
import 'package:intl/intl.dart'; // Importar paquete para formato de fechas

class ListaTransaccionWidget extends StatefulWidget {
  // Widget para mostrar la lista de transacciones
  final String userEmail; // Email del usuario

  ListaTransaccionWidget({required this.userEmail}); // Constructor

  @override
  _ListaTransaccionWidgetState createState() =>
      _ListaTransaccionWidgetState(); // Crear estado del widget
}

class _ListaTransaccionWidgetState extends State<ListaTransaccionWidget> {
  // Estado del widget
  late Future<List<Transaccion>>
      _transaccionesFuturas; // Futuro para obtener las transacciones

  @override
  void initState() {
    // Inicialización del estado
    super.initState(); // Llamar al método initState de la clase base
    _transaccionesFuturas = obtenerTransaccionesUsuario(widget.userEmail).then(
        (data) => data
            .map<Transaccion>((json) => Transaccion.fromJson(json))
            .toList()); // Obtener transacciones del usuario
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Últimas Transacciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
        ),
        Divider(
          color: Colors.blueGrey[800],
          thickness: 2,
          height: 20,
          indent: 16,
          endIndent: 16,
        ),
        SizedBox(height: 10),
        FutureBuilder<List<Transaccion>>(
          future: _transaccionesFuturas,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data!.sort((a, b) {
                return b.fecha.compareTo(a.fecha);
              });

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length.clamp(0, 5),
                itemBuilder: (context, index) {
                  var transaccion = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            transaccion.accion,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "${transaccion.tipo} - ${DateFormat('yyyy/MM/dd').format(transaccion.fecha)} - ${transaccion.cantidad} uds x ${transaccion.precio.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Text(
                            "Total: ${transaccion.valorTotal.toStringAsFixed(2)} €",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                          height: 0,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error al cargar transacciones");
            }
            return CircularProgressIndicator();
          },
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaginaTransaccion(userEmail: widget.userEmail)),
                );
              },
              child: Text('Ver Todas'),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
