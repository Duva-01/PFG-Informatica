// Importaciones necesarias
import 'dart:convert'; // Importa el paquete 'dart:convert' para manejar la codificación y decodificación JSON
import 'package:grownomics/modelos/Articulo.dart'; // Importa el modelo de datos de Articulo.dart
import 'package:http/http.dart' as http; // Importa el paquete 'http' para realizar solicitudes HTTP

class ArticuloController {
  // URL base para las solicitudes HTTP
  //static const String baseUrl = 'http://10.0.2.2:5000';
  static const String baseUrl = 'http://143.47.44.251:5000';

  // Función asíncrona para obtener todos los artículos
  static Future<List<Articulo>> obtenerArticulos() async {
    // Construye la URL para la solicitud GET
    final url = Uri.parse('$baseUrl/articles/get_articles');
    // Realiza la solicitud GET y espera la respuesta
    final respuesta = await http.get(url);

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (respuesta.statusCode == 200) {
      // Decodifica el cuerpo de la respuesta JSON en una lista de objetos dinámicos
      List<dynamic> body = jsonDecode(respuesta.body);
      // Mapea cada objeto dinámico a un objeto Articulo y crea una lista de Articulo
      List<Articulo> articulos = body
        .map((dynamic item) => Articulo.fromJson(item))
        .toList();
      // Devuelve la lista de artículos
      return articulos;
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción
      throw Exception('No se pudieron cargar los artículos');
    }
  }

  // Función asíncrona para obtener un artículo por su ID
  static Future<Articulo> obtenerArticuloPorId(int id) async {
    // Construye la URL para la solicitud GET con el ID proporcionado
    final url = Uri.parse('$baseUrl/articles/get_article/$id');
    // Realiza la solicitud GET y espera la respuesta
    final respuesta = await http.get(url);

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (respuesta.statusCode == 200) {
      // Decodifica el cuerpo de la respuesta JSON en un objeto Map<String, dynamic>
      Map<String, dynamic> json = jsonDecode(respuesta.body);
      // Convierte el objeto JSON en un objeto Articulo
      Articulo articulo = Articulo.fromJson(json);
      // Devuelve el artículo obtenido
      return articulo;
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción
      throw Exception('No se pudo cargar el artículo con ID $id');
    }
  }
}
