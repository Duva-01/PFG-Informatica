import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fl_chart/fl_chart.dart';  // Paquete para gráficos
import 'package:http/http.dart' as http;  // Paquete para hacer solicitudes HTTP

class MercadoResumenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: obtenerResumenMercado(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se espera la respuesta, mostrar un indicador de carga
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si hay un error, mostrar un mensaje de error
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Si la respuesta es exitosa, mostrar el resumen del mercado
          final resumenMercado = snapshot.data;
          return Card(
            child: ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Resumen del Mercado'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Índice IBEX 35: ${resumenMercado!['ibex_35']}'),
                  Text('Tasa EUR/USD: ${resumenMercado['eur_usd']}'),
                  // ... Añade más datos del resumen del mercado aquí
                ],
              ),
            ),
          );
        } else {
          // Cualquier otro caso, retornar un widget vacío o algún indicador de estado desconocido.
          return SizedBox();
        }
      },
    );
  }

  Future<Map<String, dynamic>> obtenerResumenMercado() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/resumen_mercado'));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load market summary');
    }
  }
}
