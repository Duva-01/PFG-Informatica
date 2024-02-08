import 'package:flutter/material.dart';

class TransactionsListWidget extends StatelessWidget {
  final List<String> transactions;

  TransactionsListWidget({required this.transactions});

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
        ListView.builder(
          shrinkWrap: true, // Importante para que funcione dentro de Column
          physics: NeverScrollableScrollPhysics(), // Para evitar el scroll dentro de otro scroll
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Título",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Subtítulo",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      "Cantidad",
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
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                // Acción para ver todas las transacciones
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
