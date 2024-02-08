import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Cartera/widgets/balanceHistoryWidget.dart';
import 'package:grownomics/paginas/Cartera/widgets/profileCardWidget.dart';
import 'package:grownomics/paginas/Cartera/widgets/transactionListWidget.dart';

class PaginaCartera extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final controller = ZoomDrawer.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartera'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          
          child: Column(
            children: [
              DatosPerfilCard(balance: 100, profit: 100, totalTransaction: 100, totalDeposited: 100, totalTransactions: 100, totalWithdrawn: 100, ),
              BalanceHistoryWidget(),
              TransactionsListWidget(transactions: ["Hola", "Jeje"]),
            ],
          ),
        ),
      ),
    );
  }
}
