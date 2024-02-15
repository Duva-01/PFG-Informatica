import 'dart:convert'; // Importar el paquete para codificación y decodificación JSON
import 'package:grownomics/modelos/newsArticle.dart'; // Importar el modelo de artículo de noticias
import 'package:http/http.dart' as http; // Importar el paquete para realizar solicitudes HTTP

// Función asincrónica para obtener noticias basadas en una temática
Future<List<NewsArticle>> obtenerNoticias(String tematica) async {
  
  final Uri url = Uri.parse('http://10.0.2.2:5000/news/financial_news?tematica=$tematica'); // Construir la URL para obtener noticias financieras basadas en la temática
  final response = await http.get(url, headers: {
    'Connection': 'keep-alive', // Encabezado de conexión para mantener la conexión abierta
  }).timeout(Duration(seconds: 60)); // Establecer un tiempo límite de 30 segundos para la solicitud

  if (response.statusCode == 200) { // Si la solicitud fue exitosa
    List<dynamic> newsJson = json.decode(response.body); // Decodificar la respuesta JSON y almacenar las noticias en una lista dinámica
    return newsJson.map((json) => NewsArticle.fromJson(json)).toList(); // Mapear cada elemento JSON a un objeto NewsArticle y devolver una lista de noticias
  } else { // Si la solicitud falló
    throw Exception('Error al cargar las noticias financieras'); // Lanzar una excepción indicando el fallo en la carga de las noticias financieras
  }
}
