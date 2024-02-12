import 'package:flutter/material.dart';
import 'package:grownomics/api/portfolioAPI.dart'; // Importación de API de cartera

class DatosPerfilCard extends StatefulWidget {
  // Atributos para mostrar datos del perfil y de la cartera
  final double balance;
  final double beneficio;
  final double totalDepositado;
  final double totalRetirado;
  final int totalTransacciones;
  final String userEmail;
  final Function onReload; // Función para recargar datos

  // Constructor
  DatosPerfilCard({
    required this.balance,
    required this.beneficio,
    required this.totalDepositado,
    required this.totalRetirado,
    required this.totalTransacciones,
    required this.userEmail,
    required this.onReload,
  });

  @override
  _DatosPerfilCardState createState() => _DatosPerfilCardState();
}

class _DatosPerfilCardState extends State<DatosPerfilCard> {
  
  // Método para mostrar el diálogo de operación (depósito o retiro)
  void _mostrarDialogoOperacion(bool esDeposito) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double cantidad = 0;
        return AlertDialog(
          title: Text(esDeposito ? 'Depositar en Cartera' : 'Retirar de Cartera'), // Título del diálogo
          content: TextField(
            onChanged: (value) {
              cantidad = double.tryParse(value) ?? 0; // Obtener la cantidad ingresada
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true), // Teclado numérico con decimales
            decoration: InputDecoration(hintText: esDeposito ? "Cantidad a depositar" : "Cantidad a retirar"), // Texto de sugerencia
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'), // Botón de cancelar
              onPressed: () => Navigator.of(context).pop(), // Cerrar el diálogo
            ),
            TextButton(
              child: Text(esDeposito ? 'Depositar' : 'Retirar'), // Botón de acción (depósito o retiro)
              onPressed: () async {
                // Realizar la operación de depósito o retiro
                bool result = esDeposito
                    ? await depositarCartera(widget.userEmail, cantidad)
                    : await retirarCartera(widget.userEmail, cantidad);
                if (result) {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  widget.onReload(); // Llamar a la función de recarga de datos
                } else {
                  // Manejar error si la operación no se realizó correctamente
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      margin: EdgeInsets.all(8.0), // Margen exterior
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de la tarjeta
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RESUMEN DE LA CARTERA", // Título del resumen de la cartera
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
            // Contenido de la tarjeta
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
                children: [
                  // Filas de información de la cartera
                  InfoRow(
                      title: "Balance",
                      value: "\$${widget.balance.toStringAsFixed(2)}"),
                  SizedBox(height: 8),
                  InfoRow(
                      title: "Beneficio",
                      value: "\$${widget.beneficio.toStringAsFixed(2)}"),
                  SizedBox(height: 8),
                  InfoRow(
                      title: "Total Depositado",
                      value: "\$${widget.totalDepositado.toStringAsFixed(2)}"),
                  SizedBox(height: 8),
                  InfoRow(
                      title: "Total Retirado",
                      value: "\$${widget.totalRetirado.toStringAsFixed(2)}"),
                  SizedBox(height: 8),
                  InfoRow(
                      title: "Total Transacciones",
                      value: "${widget.totalTransacciones}"),
                  // Botones para realizar operaciones (depósito o retiro)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _mostrarDialogoOperacion(true),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Color de fondo verde
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text("Depositar"), // Texto del botón
                        ),
                        ElevatedButton(
                          onPressed: () => _mostrarDialogoOperacion(false),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Color de fondo rojo
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text("Retirar"), // Texto del botón
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para mostrar una fila de información
class InfoRow extends StatelessWidget {
  final String title; // Título de la fila
  final String value; // Valor de la fila

  const InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white, // Color de texto blanco
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white70, // Color de texto blanco con opacidad
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
