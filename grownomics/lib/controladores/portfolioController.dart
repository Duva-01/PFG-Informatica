import 'dart:convert';
import 'package:http/http.dart' as http;

class CarteraController {
  static const String baseUrl = 'http://10.0.2.2:5000'; // URL base para las solicitudes al servidor

  // Función asincrónica para obtener la cartera del usuario
  static Future<Map<String, dynamic>> obtenerCartera(String userEmail) async {
    final response = await http.get(Uri.parse('$baseUrl/portfolio/get_portfolio?email=$userEmail')); // Realizar una solicitud GET para obtener la cartera del usuario
    if (response.statusCode == 200) { // Si la solicitud fue exitosa
      return json.decode(response.body); // Decodificar la respuesta JSON y devolverla como un mapa dinámico
    } else { // Si la solicitud falló
      throw Exception('Failed to load portfolio'); // Lanzar una excepción indicando el fallo en la carga de la cartera
    }
  }

  // Función asincrónica para depositar fondos en la cartera del usuario
  static Future<bool> depositarCartera(String userEmail, double cantidad) async {
    final response = await http.post( // Realizar una solicitud POST para depositar fondos en la cartera del usuario
      Uri.parse('$baseUrl/portfolio/deposit_portfolio'), // URL para depositar fondos
      headers: {'Content-Type': 'application/json'}, // Encabezados de la solicitud
      body: jsonEncode({'email': userEmail, 'cantidad': cantidad}), // Cuerpo de la solicitud codificado en formato JSON
    );
    return response.statusCode == 200; // Devolver true si la solicitud fue exitosa (código de estado 200)
  }

  // Función asincrónica para retirar fondos de la cartera del usuario
  static Future<bool> retirarCartera(String userEmail, double cantidad) async {
    final response = await http.post( // Realizar una solicitud POST para retirar fondos de la cartera del usuario
      Uri.parse('$baseUrl/portfolio/withdraw_portfolio'), // URL para retirar fondos
      headers: {'Content-Type': 'application/json'}, // Encabezados de la solicitud
      body: jsonEncode({'email': userEmail, 'cantidad': cantidad}), // Cuerpo de la solicitud codificado en formato JSON
    );
    return response.statusCode == 200; // Devolver true si la solicitud fue exitosa (código de estado 200)
  }

  // Función asincrónica para comprar una acción en la cartera del usuario
  static Future<bool> comprarAccion(String userEmail, String symbol, double precio, int cantidad) async {
    final response = await http.post( // Realizar una solicitud POST para comprar una acción en la cartera del usuario
      Uri.parse('$baseUrl/portfolio/buy_stock'), // URL para comprar una acción
      headers: {'Content-Type': 'application/json'}, // Encabezados de la solicitud
      body: jsonEncode({ // Cuerpo de la solicitud codificado en formato JSON
        'email': userEmail,
        'symbol': symbol,
        'precio': precio,
        'cantidad': cantidad,
      }),
    );
    return response.statusCode == 200; // Devolver true si la solicitud fue exitosa (código de estado 200)
  }

  // Función asincrónica para vender una acción de la cartera del usuario
  static Future<bool> venderAccion(String userEmail, String symbol, double precio, int cantidad) async {
    final response = await http.post( // Realizar una solicitud POST para vender una acción de la cartera del usuario
      Uri.parse('$baseUrl/portfolio/sell_stock'), // URL para vender una acción
      headers: {'Content-Type': 'application/json'}, // Encabezados de la solicitud
      body: jsonEncode({ // Cuerpo de la solicitud codificado en formato JSON
        'email': userEmail,
        'symbol': symbol,
        'precio': precio,
        'cantidad': cantidad,
      }),
    );
    return response.statusCode == 200; // Devolver true si la solicitud fue exitosa (código de estado 200)
  }

  // Función asincrónica para obtener las transacciones del usuario
  static Future<List<dynamic>> obtenerTransaccionesUsuario(String userEmail) async {
    final Uri url = Uri.parse('$baseUrl/portfolio/get_user_transactions?email=$userEmail'); // Construir la URL para obtener las transacciones del usuario
    final response = await http.get(url); // Realizar una solicitud GET para obtener las transacciones del usuario

    if (response.statusCode == 200) { // Si la solicitud fue exitosa
      List<dynamic> transacciones = json.decode(response.body); // Decodificar la respuesta JSON y almacenar las transacciones en una lista
      return transacciones; // Devolver la lista de transacciones
    } else { // Si la solicitud falló
      throw Exception('Error al cargar las transacciones'); // Lanzar una excepción indicando el fallo en la carga de las transacciones
    }
  }

  // Función asincrónica para calcular el beneficio del usuario
  static Future<double> calcularBeneficio(String userEmail) async {
    final List<dynamic> transacciones = await obtenerTransaccionesUsuario(userEmail); // Obtener las transacciones del usuario

    double balance = 0.0; // Inicializar el balance a 0

    for (var transaccion in transacciones) { // Iterar a través de las transacciones
      if (transaccion['tipo'] == 'compra') { // Si la transacción es una compra
        balance -= transaccion['cantidad'] * transaccion['precio']; // Restar el costo de la compra al balance
      } else if (transaccion['tipo'] == 'venta') { // Si la transacción es una venta
        balance += transaccion['cantidad'] * transaccion['precio']; // Sumar los ingresos de la venta al balance
      }
    }

    return balance; // Devolver el balance final como el beneficio (o pérdida si es negativo)
  }
}
