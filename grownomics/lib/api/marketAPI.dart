import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:5000';

Future<Map<String, dynamic>> obtenerAcciones(int page, {int perPage = 10}) async {
  final Uri url = Uri.parse('$baseUrl/finance/popular_stocks_data?page=$page&per_page=$perPage');
  final respuesta = await http.get(url);
  
  if (respuesta.statusCode == 200) {
    print(respuesta.body);
    return json.decode(respuesta.body);
  } else {
    throw Exception('Falló la carga de las acciones');
  }
}

Future<Map<String, dynamic>> obtenerAccionesFavoritas(int id_usuario) async {
  final Uri url = Uri.parse('$baseUrl/finance/acciones_favs?id=$id_usuario');
  final respuesta = await http.get(url);
  
  if (respuesta.statusCode == 200) {
    print(respuesta.body);
    return json.decode(respuesta.body);
  } else {
    throw Exception('Falló la carga de las acciones');
  }
}

//
/*

Tengo que crear una funcion para obtener la id del usuario a traves de su correo
*/