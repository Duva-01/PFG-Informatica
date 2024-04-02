import 'package:flutter/material.dart';
import 'package:grownomics/controladores/portfolioController.dart';
import 'package:grownomics/modelos/Transaccion.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:intl/intl.dart';

class PaginaTransaccion extends StatefulWidget {
  final String userEmail;

  PaginaTransaccion({required this.userEmail});

  @override
  _PaginaTransaccionState createState() => _PaginaTransaccionState();
}

class _PaginaTransaccionState extends State<PaginaTransaccion> {
  late Future<List<Transaccion>> _transaccionesFuturas;

  @override
  void initState() {
    super.initState();
    _transaccionesFuturas = CarteraController.obtenerTransaccionesUsuario(widget.userEmail)
        .then((data) => data.map<Transaccion>((json) => Transaccion.fromJson(json)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Todas mis transacciones",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Colors.black,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Transaccion>>(
        future: _transaccionesFuturas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Transaccion> transaccionesOrdenadas = snapshot.data!;
            transaccionesOrdenadas.sort((a, b) => b.fecha.compareTo(a.fecha));

            // Agrupar las transacciones por fecha
            Map<String, List<Transaccion>> groupedTransacciones = {};
            transaccionesOrdenadas.forEach((transaccion) {
              final fechaString = DateFormat('dd MMMM yyyy', 'es').format(transaccion.fecha);
              groupedTransacciones.putIfAbsent(fechaString, () => []).add(transaccion);
            });

            return ListView.builder(
              itemCount: groupedTransacciones.length,
              itemBuilder: (context, index) {
                final fecha = groupedTransacciones.keys.elementAt(index);
                final transacciones = groupedTransacciones[fecha]!;

                return Column(
                  children: [
                    ListTile(
                      title: buildTitulo("$fecha"),
                      onTap: () {}, // Si deseas agregar alguna acción al tocar la fecha
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: transacciones.length,
                      itemBuilder: (context, index) {
                        Transaccion transaccion = transacciones[index];

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
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("Error al cargar transacciones");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
