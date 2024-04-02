import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/controladores/portfolioController.dart';
import 'package:grownomics/modelos/Transaccion.dart';
import 'package:grownomics/paginas/Cartera/transactionsPage.dart';
import 'package:intl/intl.dart';

class TransaccionesCard extends StatefulWidget {
  final String userEmail;

  TransaccionesCard({required this.userEmail});

  @override
  _TransaccionesCardState createState() => _TransaccionesCardState();
}

class _TransaccionesCardState extends State<TransaccionesCard> {
  late Future<List<Transaccion>>
      _transaccionesFuturas; // Futuro para obtener las transacciones

  @override
  void initState() {
    // Inicialización del estado
    super.initState(); // Llamar al método initState de la clase base
    _transaccionesFuturas = CarteraController.obtenerTransaccionesUsuario(widget.userEmail).then(
        (data) => data
            .map<Transaccion>((json) => Transaccion.fromJson(json))
            .toList()); // Obtener transacciones del usuario
  }

  @override
  Widget build(BuildContext context) {
    return BounceInUp(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45.0),
          topRight: Radius.circular(45.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 19, 60, 42),
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Ultimas Transacciones',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.call_to_action_rounded,
                      color: Colors.white, size: 30)
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 2.0,
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _transaccionesFuturas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length > 5
                            ? 5
                            : snapshot.data!
                                .length, // Mostrar solo las últimas 5 transacciones
                        itemBuilder: (context, index) {
                          var transaccion = snapshot.data![index];

                          return ListTile(
                            title: Text(
                              transaccion.accion,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "${transaccion.tipo} - ${DateFormat('yyyy/MM/dd').format(transaccion.fecha)} - ${transaccion.cantidad} uds x ${transaccion.precio.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Text(
                              "Total: ${transaccion.valorTotal.toStringAsFixed(2)} €",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Text("No hay datos");
                    }
                  },
                ),
              ),
              Padding(
                // Padding alrededor del botón
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Padding horizontal
                child: Center(
                  // Centrar el botón
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 100.0)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaginaTransaccion(
                            userEmail: widget.userEmail,
                          ),
                        ),
                      );
                    },
                    child: Text('Ver Todas'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
