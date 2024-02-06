import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Mercado/Widgets/marketListWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stockPage.dart';

class PaginaMercado extends StatefulWidget {

  final String userEmail;
  PaginaMercado({required this.userEmail});

  @override
  _PaginaMercadoState createState() => _PaginaMercadoState();
}

class _PaginaMercadoState extends State<PaginaMercado> {

  @override
  Widget build(BuildContext context) {
    final controller = ZoomDrawer.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotizaciones'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MarketList(userEmail: widget.userEmail) // Usando widget.userEmail

          ],
        ),
      ),
    );
  }
}
