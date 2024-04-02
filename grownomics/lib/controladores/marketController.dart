import 'dart:convert'; // Importar el paquete para codificación y decodificación JSON
import 'package:http/http.dart' as http; // Importar el paquete para realizar solicitudes HTTP
import 'package:grownomics/modelos/Accion.dart';
import 'package:grownomics/modelos/HistoricalData.dart'; // Importar el modelo de datos históricos

class MercadoController {
  // URL base para las solicitudes al servidor
  static const String baseUrl = 'http://10.0.2.2:5000';

  // Función para obtener una lista de acciones populares desde el servidor
  static Future<List<dynamic>> obtenerAcciones(int page, {int perPage = 10}) async {
    final Uri url = Uri.parse('$baseUrl/finance/popular_stocks_data?page=$page&per_page=$perPage');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      List<dynamic> acciones = json.decode(respuesta.body);
      return acciones;
    } else {
      throw Exception('Falló la carga de las acciones');
    }
  }

  // Función para obtener los datos de una sola acción
  static Future<Map<String, dynamic>> obtenerDatosAccion(String tickerSymbol) async {
    final Uri url = Uri.parse('$baseUrl/finance/stock_data/$tickerSymbol');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosAccion = json.decode(respuesta.body);
      return datosAccion;
    } else {
      throw Exception('Falló la carga de datos para la acción $tickerSymbol');
    }
  }

  // Función para obtener las acciones favoritas de un usuario desde el servidor
  static Future<List<dynamic>> obtenerAccionesFavoritas(int id_usuario) async {
    final Uri url = Uri.parse('$baseUrl/finance/acciones_favs?id_usuario=$id_usuario');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      List<dynamic> accionesFavoritas = json.decode(respuesta.body);
      return accionesFavoritas;
    } else {
      throw Exception('Falló la carga de las acciones');
    }
  }

  // Función para agregar una acción a las favoritas en el servidor
  static Future<bool> agregarAccionFavorita(int idUsuario, int idAccion) async {
    final Uri url = Uri.parse('$baseUrl/finance/agregar_accion_fav');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'id_usuario': idUsuario, 'id_accion': idAccion}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al agregar a favoritos: ${response.body}');
      return false;
    }
  }

  // Función para eliminar una acción de las favoritas en el servidor
  static Future<bool> eliminarAccionFavorita(int idUsuario, int idAccion) async {
    final Uri url = Uri.parse('$baseUrl/finance/eliminar_accion_fav');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'id_usuario': idUsuario, 'id_accion': idAccion}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al eliminar de favoritos: ${response.body}');
      return false;
    }
  }

  // Función para obtener datos históricos de una acción desde el servidor
  static Future<List<HistoricalData>> obtenerDatosHistoricos(String symbol, String interval) async {
    final Uri url = Uri.parse('http://10.0.2.2:5000/finance/historical_data?symbol=$symbol&interval=$interval');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<HistoricalData> dataList = jsonData.entries.map((entry) {
        return HistoricalData.fromJson({
          'date': entry.key,
          'Open': entry.value['Open'],
          'Close': entry.value['Close'],
          'High': entry.value['High'],
          'Low': entry.value['Low'],
          'Volume': entry.value['Volume'],
        });
      }).toList();
      return dataList;
    } else {
      throw Exception('Failed to load historical data');
    }
  }

  //----------------- Pagina de mis acciones -----------------

  // Función para obtener las acciones del usuario
  static Future<List<Accion>> obtenerMisAcciones(String email) async {
    final uri = Uri.parse('$baseUrl/finance/acciones_usuario?email=$email');
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      List<dynamic> listaAcciones = json.decode(respuesta.body);
      return listaAcciones.map<Accion>((json) => Accion.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener mis acciones');
    }
  }

  //----------------- Pagina de inicio -----------------

  // Función para obtener resumen de mercado
  static Future<Map<String, dynamic>> obtenerResumenMercado() async {
    final uri = Uri.parse('$baseUrl/finance/resumen_mercado');
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      throw Exception('Error al obtener el resumen del mercado');
    }
  }
}
