import 'dart:convert';
import 'package:grownomics/modelos/NewsArticle.dart';
import 'package:http/http.dart' as http;

class NoticiasController {
  // Función asíncrona para obtener noticias basadas en una temática específica
  static Future<List<NewsArticle>> obtenerNoticias(String tematica) async {
    // Construye la URL con la temática proporcionada
    final Uri url = Uri.parse('http://10.0.2.2:5000/news/financial_news?tematica=$tematica');
    // Llama a la función privada _intentarSolicitud para realizar la solicitud HTTP
    return _intentarSolicitud(url);
  }

  // Función asíncrona para obtener noticias relacionadas con una acción específica
  static Future<List<NewsArticle>> obtenerNoticiasDeAcciones(String nombreAccion, String idioma) async {
    // Construye la URL con el nombre de la acción y el idioma proporcionados
    final Uri url = Uri.parse('http://10.0.2.2:5000/news/stock_news?nombreAccion=$nombreAccion&language=$idioma');
    // Llama a la función privada _intentarSolicitud para realizar la solicitud HTTP
    return _intentarSolicitud(url);
  }

  // Función privada asíncrona para realizar la solicitud HTTP con reintentos
  static Future<List<NewsArticle>> _intentarSolicitud(Uri url, {int reintentos = 10}) async {
    int intentos = 0;
    // Realiza un bucle mientras se hayan agotado los reintentos
    while (intentos < reintentos) {
      try {
        // Realiza una solicitud GET a la URL especificada con un encabezado de conexión y un tiempo de espera
        final response = await http.get(url, headers: {
          'Connection': 'keep-alive',
        }).timeout(Duration(seconds: 60));
        
        // Verifica si la respuesta tiene un código de estado exitoso (200)
        if (response.statusCode == 200) {
          // Decodifica el cuerpo de la respuesta y crea una lista de objetos NewsArticle
          List<dynamic> newsJson = json.decode(response.body);
          return newsJson.map((json) => NewsArticle.fromJson(json)).toList();
        } else {
          // Si hay algún error en la respuesta, lanza una excepción
          throw Exception('Error al cargar las noticias');
        }
      } catch (e) {
        // Si hay un error durante la solicitud, aumenta el contador de intentos
        intentos++;
        // Si se superan los reintentos, lanza una excepción indicando el fallo
        if (intentos >= reintentos) {
          throw Exception('Error al cargar las noticias después de $reintentos intentos');
        }
      }
    }
    // Teóricamente, este código no debería ser alcanzado debido al throw en el catch si se exceden los intentos
    return [];
  }
}
