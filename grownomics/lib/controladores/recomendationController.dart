import 'dart:convert';
import 'package:http/http.dart' as http;

class RecomendacionesController {
  //static const String baseUrl = 'http://10.0.2.2:5000'; // URL base para las solicitudes HTTP
  static const String baseUrl = 'http://143.47.44.251:5000';
  // Función para obtener recomendaciones de trading
  static Future<Map<String, dynamic>> obtenerRecomendacion(String simbolo, String correo) async {
    final uri = Uri.parse('$baseUrl/recommendations/$simbolo'); // Construye la URI para la solicitud POST
    final respuesta = await http.post( // Realiza la solicitud HTTP POST
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': correo}), // Cuerpo de la solicitud codificado en JSON
    );

    if (respuesta.statusCode == 200) { // Verifica el código de estado de la respuesta
      return json.decode(respuesta.body); // Decodifica el cuerpo de la respuesta y devuelve un mapa
    } else {
      throw Exception('Error al cargar la recomendación'); // Lanza una excepción si la solicitud falla
    }
  }

  // Función para obtener indicadores económicos
  static Future<Map<String, dynamic>> obtenerIndicadoresEconomicos(String simbolo) async {
    final uri = Uri.parse('$baseUrl/recommendations/indicators/$simbolo'); // Construye la URI para la solicitud GET
    final respuesta = await http.get(uri); // Realiza la solicitud HTTP GET

    if (respuesta.statusCode == 200) { // Verifica el código de estado de la respuesta
      return json.decode(respuesta.body); // Decodifica el cuerpo de la respuesta y devuelve un mapa
    } else {
      throw Exception('Error al cargar los indicadores económicos'); // Lanza una excepción si la solicitud falla
    }
  }

  // Función para obtener el análisis técnico de un símbolo específico
  static Future<Map<String, dynamic>> obtenerAnalisisTecnico(String simbolo, String intervalo) async {
    final uri = Uri.parse('$baseUrl/recommendations/analisis_tecnico/$simbolo?intervalo=$intervalo'); // Construye la URI para la solicitud GET, incluyendo el intervalo como parámetro de consulta
    final respuesta = await http.get(uri); // Realiza la solicitud HTTP GET

    if (respuesta.statusCode == 200) { // Verifica el código de estado de la respuesta
      final resultado = json.decode(respuesta.body); // Si la solicitud fue exitosa, decodifica el cuerpo de la respuesta
      return resultado;
    } else {
      throw Exception('Error al obtener el análisis técnico para el símbolo $simbolo'); // Si la solicitud falló, lanza una excepción con el mensaje de error
    }
  }

  // Función para obtener el análisis fundamental de una acción
  static Future<Map<String, dynamic>> obtenerAnalisisFundamental(String simbolo) async {
    final uri = Uri.parse('$baseUrl/recommendations/analisis_fundamental/$simbolo');
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      throw Exception('Error al obtener el análisis fundamental para $simbolo');
    }
  }

  // Asegúrate de incluir el email como un parámetro de la función
  static Future<Map<String, dynamic>> obtenerAnalisisCompleto(String simbolo, String email) async {
    final uri = Uri.parse('$baseUrl/recommendations/analisis_completo/$simbolo?email=$email'); // Incluye el email como un parámetro de consulta en la URI
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      throw Exception('Error al obtener el análisis completo para $simbolo');
    }
  }

  // Función para obtener los códigos de ticker de todas las acciones
  static Future<List<String>> obtenerCodigosTicker() async {
    final uri = Uri.parse('$baseUrl/recommendations/simbolos-acciones'); // Construye la URI para la solicitud GET
    final respuesta = await http.get(uri); // Realiza la solicitud HTTP GET

    if (respuesta.statusCode == 200) { // Verifica el código de estado de la respuesta
      final Map<String, dynamic> datos = json.decode(respuesta.body); // Si la solicitud fue exitosa, decodifica el cuerpo de la respuesta
      final List<String> codigosTicker = List<String>.from(datos['codigos_ticker']); // Convierte la lista dinámica en una lista de strings
      return codigosTicker;
    } else {
      throw Exception('Error al cargar los códigos de ticker de las acciones'); // Si la solicitud falló, lanza una excepción con el mensaje de error
    }
  }
}
