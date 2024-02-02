import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Home/Widgets/balanceWidget.dart';
import 'package:grownomics/paginas/Home/Widgets/statsWidget.dart';
import '../../widgets/mercado_resumen_widget.dart'; 


class PaginaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = ZoomDrawer.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Grownomics'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle();
          },
        ),
      ),
      body: SingleChildScrollView(
        
        child: Container(
          color: Color(0xFF2F8B62),
          child: Column(
              children: [
                StatsGrid(),
                BalanceCard(),
                ActionButtons(),
                MercadoResumenWidget(),
                
                SizedBox(height: 10),
                TransactionCard(),
                SizedBox(height: 10),
        
                // Espacio entre widgets
                SizedBox(height: 20),
        
                // Acceso rápido a asesoramiento o análisis
                Card(
                  child: ListTile(
                    leading: Icon(Icons.assessment),
                    title: Text('Análisis Rápido'),
                    subtitle: Text('Obtén un análisis financiero rápido'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navegar a la página de análisis
                    },
                  ),
                ),
        
                Container(
                  height:
                      300, // Establece la altura deseada para LatestTransactions
                  child: LatestTransactions(),
                ),
              ],
            ),
        ),
        ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ActionButton(
          icon: Icons.account_balance_wallet,
          label: 'DEPOSIT',
        ),
        ActionButton(
          icon: Icons.account_balance_wallet,
          label: 'WITHDRAW',
        ),
        ActionButton(
          icon: Icons.account_balance_wallet,
          label: 'PRACTICE',
        ),
        ActionButton(
          icon: Icons.account_balance_wallet,
          label: 'TRADE NOW',
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // Background color
            onPrimary: Colors.black, // Foreground (text/icon) color
            shape: CircleBorder(),
            padding: EdgeInsets.all(24),
          ),
          onPressed: () {
            // Implement your onPressed functionality here
          },
          child: Icon(icon, size: 30),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}


class TransactionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(Icons.call_made, color: Colors.green),
                Text('DEPOSIT', style: TextStyle(color: Colors.green)),
              ],
            ),
            Column(
              children: <Widget>[
                Icon(Icons.call_received, color: Colors.red),
                Text('WITHDRAW', style: TextStyle(color: Colors.red)),
              ],
            ),
            // Add more transaction types here
          ],
        ),
      ),
    );
  }
}

class LatestTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.account_balance_wallet, color: Colors.white),
            title: Text('Transaction $index',
                style: TextStyle(color: Colors.white)),
            subtitle:
                Text('Details here', style: TextStyle(color: Colors.grey)),
            trailing: Text('\$100', style: TextStyle(color: Colors.green)),
          );
        },
      ),
    );
  }
}
