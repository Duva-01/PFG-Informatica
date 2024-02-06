import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:5000';

Future<List<dynamic>> obtenerAcciones(int page, {int perPage = 10}) async {
  final Uri url = Uri.parse('$baseUrl/finance/popular_stocks_data?page=$page&per_page=$perPage');
  final respuesta = await http.get(url);
  
  if (respuesta.statusCode == 200) {

    List<dynamic> acciones = json.decode(respuesta.body);
    return acciones;
  } else {
    throw Exception('Falló la carga de las acciones');
  }
}

Future<List<dynamic>> obtenerAccionesFavoritas(int id_usuario) async {
  final Uri url = Uri.parse('$baseUrl/finance/acciones_favs?id_usuario=$id_usuario');
  final respuesta = await http.get(url);
  
  if (respuesta.statusCode == 200) {
    List<dynamic> accionesFavoritas = json.decode(respuesta.body);
    return accionesFavoritas;
  } else {
    throw Exception('Falló la carga de las acciones');
  }
}

Future<bool> agregarAccionFavorita(int idUsuario, int idAccion) async {
  final Uri url = Uri.parse('$baseUrl/finance/agregar_accion_fav');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'id_usuario': idUsuario,
      'id_accion': idAccion,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print('Error al agregar a favoritos: ${response.body}');
    return false;
  }
}

Future<bool> eliminarAccionFavorita(int idUsuario, int idAccion) async {
  final Uri url = Uri.parse('$baseUrl/finance/eliminar_accion_fav');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'id_usuario': idUsuario,
      'id_accion': idAccion,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print('Error al eliminar de favoritos: ${response.body}');
    return false;
  }
}
