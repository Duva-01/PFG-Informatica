import 'package:flutter/material.dart';

class DatosPerfilCard extends StatelessWidget {
  final double balance;
  final double profit;
  final double totalDeposited;
  final double totalWithdrawn;
  final int totalTransactions;

  DatosPerfilCard({
    required this.balance,
    required this.profit,
    required this.totalDeposited,
    required this.totalWithdrawn,
    required this.totalTransactions, required int totalTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Color.fromARGB(255, 19, 60, 42),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RESUMEN DE LA CARTERA",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: Color(0xFF2F8B62),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                children: [
                  InfoRow(title: "Balance", value: "\$${balance.toStringAsFixed(2)}"),
                  SizedBox(height: 8),
                  InfoRow(title: "Beneficio", value: "\$${profit.toStringAsFixed(2)}"),
                  SizedBox(height: 8),
                  InfoRow(title: "Total Depositado", value: "\$${totalDeposited.toStringAsFixed(2)}"),
                  SizedBox(height: 8),
                  InfoRow(title: "Total Retirado", value: "\$${totalWithdrawn.toStringAsFixed(2)}"),
                  SizedBox(height: 8),
                  InfoRow(title: "Total Transacciones", value: "$totalTransactions"),
                
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text("Depositar"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text("Retirar"),
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

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
