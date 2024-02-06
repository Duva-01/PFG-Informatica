import 'package:flutter/material.dart';

class TransaccionesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                Icon(Icons.call_to_action_rounded, color: Colors.white, size: 30)
              ],
            ),
            Divider(
              color: Colors.grey, // Cambia el color del Divider si es necesario
              thickness: 2.0, // Ajusta el grosor del Divider
            ),
            Container(
              height:
                  200, // Define una altura fija para la lista de transacciones
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading:
                        Icon(Icons.account_balance_wallet, color: Colors.white),
                    title: Text('Transaction $index',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text('Details here',
                        style: TextStyle(color: Colors.grey)),
                    trailing:
                        Text('\$100', style: TextStyle(color: Colors.green)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
