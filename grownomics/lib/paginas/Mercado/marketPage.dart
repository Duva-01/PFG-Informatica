import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Mercado/Widgets/categoryButtonWidget.dart';
import 'package:grownomics/paginas/Mercado/Widgets/marketListWidget.dart';

import './pagina_accion.dart';

class PaginaMercado extends StatefulWidget {
  @override
  _PaginaMercadoState createState() => _PaginaMercadoState();
}

class _PaginaMercadoState extends State<PaginaMercado> {
  
  Map<String, dynamic> acciones = {};
  TextEditingController _searchController = TextEditingController();
  Set<String> accionesFavoritas = Set<String>();

  

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
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar por nombre',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                ),
              ),
            ),
            CategoriesSection(
              accionesFavoritas: accionesFavoritas,
              toggleFavorite: (tickerSymbol) {
                setState(() {
                  if (accionesFavoritas.contains(tickerSymbol)) {
                    accionesFavoritas.remove(tickerSymbol);
                  } else {
                    accionesFavoritas.add(tickerSymbol);
                  }
                });
              },
            ),
            MarketList( 
              accionesFavoritas: accionesFavoritas,
              toggleFavorite: (tickerSymbol) {
                setState(() {
                  if (accionesFavoritas.contains(tickerSymbol)) {
                    accionesFavoritas.remove(tickerSymbol);
                  } else {
                    accionesFavoritas.add(tickerSymbol);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
