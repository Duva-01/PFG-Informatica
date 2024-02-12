import 'dart:convert'; // Importar el paquete para codificación y decodificación JSON
import 'package:grownomics/modelos/HistoricalData.dart'; // Importar el modelo de datos históricos
import 'package:http/http.dart' as http; // Importar el paquete para realizar solicitudes HTTP

// URL base para las solicitudes al servidor
const String baseUrl = 'http://10.0.2.2:5000';

// Función para obtener una lista de acciones populares desde el servidor
Future<List<dynamic>> obtenerAcciones(int page, {int perPage = 10}) async {
  final Uri url = Uri.parse('$baseUrl/finance/popular_stocks_data?page=$page&per_page=$perPage'); // Construir la URL para obtener datos de acciones populares
  final respuesta = await http.get(url); // Realizar una solicitud GET para obtener datos de acciones populares
  
  if (respuesta.statusCode == 200) { // Si la solicitud fue exitosa
    List<dynamic> acciones = json.decode(respuesta.body); // Decodificar la respuesta JSON y almacenar los datos de acciones en una lista dinámica
    return acciones; // Devolver la lista de acciones
  } else { // Si la solicitud falló
    throw Exception('Falló la carga de las acciones'); // Lanzar una excepción indicando el fallo en la carga de las acciones
  }
}

// Función para obtener las acciones favoritas de un usuario desde el servidor
Future<List<dynamic>> obtenerAccionesFavoritas(int id_usuario) async {
  final Uri url = Uri.parse('$baseUrl/finance/acciones_favs?id_usuario=$id_usuario'); // Construir la URL para obtener las acciones favoritas de un usuario
  final respuesta = await http.get(url); // Realizar una solicitud GET para obtener las acciones favoritas
  
  if (respuesta.statusCode == 200) { // Si la solicitud fue exitosa
    List<dynamic> accionesFavoritas = json.decode(respuesta.body); // Decodificar la respuesta JSON y almacenar las acciones favoritas en una lista dinámica
    return accionesFavoritas; // Devolver la lista de acciones favoritas
  } else { // Si la solicitud falló
    throw Exception('Falló la carga de las acciones'); // Lanzar una excepción indicando el fallo en la carga de las acciones
  }
}

// Función para agregar una acción a las favoritas en el servidor
Future<bool> agregarAccionFavorita(int idUsuario, int idAccion) async {
  final Uri url = Uri.parse('$baseUrl/finance/agregar_accion_fav'); // Construir la URL para agregar una acción a las favoritas
  final response = await http.post( // Realizar una solicitud POST para agregar una acción a las favoritas
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8', // Especificar el tipo de contenido JSON
    },
    body: jsonEncode({ // Codificar los datos del cuerpo de la solicitud como JSON
      'id_usuario': idUsuario,
      'id_accion': idAccion,
    }),
  );

  if (response.statusCode == 200) { // Si la solicitud fue exitosa
    return true; // Devolver verdadero indicando que la acción se agregó a las favoritas correctamente
  } else { // Si la solicitud falló
    print('Error al agregar a favoritos: ${response.body}'); // Imprimir el mensaje de error en la consola
    return false; // Devolver falso indicando que hubo un error al agregar la acción a las favoritas
  }
}

// Función para eliminar una acción de las favoritas en el servidor
Future<bool> eliminarAccionFavorita(int idUsuario, int idAccion) async {
  final Uri url = Uri.parse('$baseUrl/finance/eliminar_accion_fav'); // Construir la URL para eliminar una acción de las favoritas
  final response = await http.post( // Realizar una solicitud POST para eliminar una acción de las favoritas
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8', // Especificar el tipo de contenido JSON
    },
    body: jsonEncode({ // Codificar los datos del cuerpo de la solicitud como JSON
      'id_usuario': idUsuario,
      'id_accion': idAccion,
    }),
  );

  if (response.statusCode == 200) { // Si la solicitud fue exitosa
    return true; // Devolver verdadero indicando que la acción se eliminó de las favoritas correctamente
  } else { // Si la solicitud falló
    print('Error al eliminar de favoritos: ${response.body}'); // Imprimir el mensaje de error en la consola
    return false; // Devolver falso indicando que hubo un error al eliminar la acción de las favoritas
  }
}

// Función para obtener datos históricos de una acción desde el servidor
Future<List<HistoricalData>> obtenerDatosHistoricos(String symbol, String interval) async {
  final Uri url = Uri.parse('http://10.0.2.2:5000/finance/historical_data?symbol=$symbol&interval=$interval'); // Construir la URL para obtener datos históricos de una acción
  final response = await http.get(url); // Realizar una solicitud GET para obtener datos históricos de una acción
  
  if (response.statusCode == 200) { // Si la solicitud fue exitosa
    Map<String, dynamic> jsonData = json.decode(response.body); // Decodificar la respuesta JSON y almacenar los datos en un mapa
    List<HistoricalData> dataList = jsonData.entries.map((entry) { // Mapear cada entrada del mapa a un objeto HistoricalData
      return HistoricalData.fromJson({ // Crear un objeto HistoricalData a partir de los datos
        'date': entry.key,
        'Open': entry.value['Open'],
        'Close': entry.value['Close'],
        'High': entry.value['High'],
        'Low': entry.value['Low'],
        'Volume': entry.value['Volume'],
      });
    }).toList(); // Convertir el iterable a una lista
    return dataList; // Devolver la lista de datos históricos
  } else { // Si la solicitud falló
    throw Exception('Failed to load historical data'); // Lanzar una excepción indicando el fallo en la carga de los datos históricos
  }
}
