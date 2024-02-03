import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:5000';

Future<Map<String, dynamic>> obtenerAcciones(int page) async {
    final respuesta = await http.get(Uri.parse(
        '$baseUrl/popular_stocks_data?page=$page&per_page=8'));
    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      throw Exception('Falló la carga de las acciones');
    }
  }