import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Home/Widgets/balanceWidget.dart';
import 'package:grownomics/paginas/Home/Widgets/favoritesWidget.dart';
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
          color: Color.fromARGB(255, 39, 99, 72),
          child: Column(
            children: [
              StatsGrid(),
              BalanceCard(),
              FavoriteCard(),
            ],
          ),
        ),
      ),
    );
  }
}

