import 'dart:convert';
import 'package:http/http.dart' as http;

// URL base para las solicitudes HTTP
const String baseUrl = 'http://10.0.2.2:5000';

// Función para obtener recomendaciones de trading
Future<Map<String, dynamic>> obtenerRecomendacion(String simbolo, String correo) async {
  // Construye la URI para la solicitud POST
  final uri = Uri.parse('$baseUrl/recommendations/$simbolo');
  // Realiza la solicitud HTTP POST
  final respuesta = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({'email': correo}), // Cuerpo de la solicitud codificado en JSON
  );

  // Verifica el código de estado de la respuesta
  if (respuesta.statusCode == 200) {
    return json.decode(respuesta.body); // Decodifica el cuerpo de la respuesta y devuelve un mapa
  } else {
    throw Exception('Error al cargar la recomendación'); // Lanza una excepción si la solicitud falla
  }
}

// Función para obtener indicadores económicos
Future<Map<String, dynamic>> obtenerIndicadoresEconomicos(String simbolo) async {
  // Construye la URI para la solicitud GET
  final uri = Uri.parse('$baseUrl/recommendations/indicators/$simbolo');
  // Realiza la solicitud HTTP GET
  final respuesta = await http.get(uri);

  // Verifica el código de estado de la respuesta
  if (respuesta.statusCode == 200) {
    return json.decode(respuesta.body); // Decodifica el cuerpo de la respuesta y devuelve un mapa
  } else {
    throw Exception('Error al cargar los indicadores económicos'); // Lanza una excepción si la solicitud falla
  }
}

// Función para obtener el análisis técnico de un símbolo específico
Future<Map<String, dynamic>> obtenerAnalisisTecnico(String simbolo, {String intervalo = '1y'}) async {
  // Construye la URI para la solicitud GET, incluyendo el intervalo como parámetro de consulta
  final uri = Uri.parse('$baseUrl/recommendations/analisis_tecnico/$simbolo?intervalo=$intervalo');
  
  // Realiza la solicitud HTTP GET
  final respuesta = await http.get(uri);

  // Verifica el código de estado de la respuesta
  if (respuesta.statusCode == 200) {
    // Si la solicitud fue exitosa, decodifica el cuerpo de la respuesta
    return json.decode(respuesta.body);
  } else {
    // Si la solicitud falló, lanza una excepción con el mensaje de error
    throw Exception('Error al obtener el análisis técnico para el símbolo $simbolo');
  }
}

// Función para obtener los códigos de ticker de todas las acciones
Future<List<String>> obtenerCodigosTicker() async {
  // Construye la URI para la solicitud GET
  final uri = Uri.parse('$baseUrl/recommendations/simbolos-acciones');

  // Realiza la solicitud HTTP GET
  final respuesta = await http.get(uri);

  // Verifica el código de estado de la respuesta
  if (respuesta.statusCode == 200) {
    // Si la solicitud fue exitosa, decodifica el cuerpo de la respuesta
    final Map<String, dynamic> datos = json.decode(respuesta.body);
    // Convierte la lista dinámica en una lista de strings
    final List<String> codigosTicker = List<String>.from(datos['codigos_ticker']);
    return codigosTicker;
  } else {
    // Si la solicitud falló, lanza una excepción con el mensaje de error
    throw Exception('Error al cargar los códigos de ticker de las acciones');
  }
}