import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import './pagina_accion.dart';

class PaginaMercado extends StatefulWidget {
  @override
  _PaginaMercadoState createState() => _PaginaMercadoState();
}

class _PaginaMercadoState extends State<PaginaMercado> {
  int page = 1;
  Map<String, dynamic> acciones = {};
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  void _loadData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      final newAcciones = await obtenerAcciones(page);
      if (newAcciones != null) {
        final filteredAcciones = Map<String, dynamic>.fromIterable(
          newAcciones.entries.where((entry) => entry.value["error"] == null),
          key: (entry) => entry.key,
          value: (entry) => entry.value,
        );
        if (mounted) {
          setState(() {
            acciones.addAll(filteredAcciones);
            page++;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> obtenerAcciones(int page) async {
    final respuesta = await http.get(Uri.parse(
        'http://10.0.2.2:5000/popular_stocks_data?page=$page&per_page=10'));
    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      throw Exception('Falló la carga de las acciones');
    }
  }

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
      body: ListView.builder(
        
        controller: _scrollController,
        itemCount: (acciones?.length ?? 0) + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {

          
          if (index == acciones.length) {
            return Center(child: CircularProgressIndicator());
          }
          final tickerSymbol = acciones?.keys.elementAt(index);
          final accion = acciones?[tickerSymbol];
          final bool isPositive = (accion?['change'] ?? 0) >= 0;

          
          return Container(
            
            color: Colors.grey[200],
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetallesAccion(tickerSymbol!)),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown,
                    child: Text(
                      ((tickerSymbol?.length ?? 0) >= 2
                              ? tickerSymbol?.substring(0, 2)
                              : tickerSymbol) ??
                          '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('${accion?['name'] ?? 'Desconocido'}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Precio: ${accion?['current_price']?.toStringAsFixed(2) ?? 'Desconocido'}',
                      ),
                      Text(
                        'Cambio: ${accion?['change']?.toStringAsFixed(2) ?? 'Desconocido'} '
                        '(${accion?['change_percent']?.toStringAsFixed(2) ?? 'Desconocido'}%)',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.green[800],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
