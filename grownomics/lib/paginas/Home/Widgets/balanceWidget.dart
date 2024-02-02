import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(45.0), // Ajusta el radio según tu preferencia
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        color: Color.fromARGB(255, 30, 92, 65),
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '\$5896.36',
              style: TextStyle(
                  color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              'Balance Actual',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Divider(
              color: Color(0xFF2F8B62), // Cambia el color del Divider
              thickness: 2.0, // Ajusta el grosor del Divider
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '\$5896.36',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total depositado',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '\$5896.36',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total Retirado',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '\133',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Nº Transacciones',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
