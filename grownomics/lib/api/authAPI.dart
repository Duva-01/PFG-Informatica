import 'dart:convert';
import 'package:http/http.dart' as http;

// URL base para las solicitudes HTTP
const String baseUrl = 'http://10.0.2.2:5000';

// Función para obtener los datos de un usuario dado su correo electrónico
Future<Map<String, dynamic>> obtenerDatosUsuario(String correo) async {
  final Uri url = Uri.parse('$baseUrl/auth/get_user?email=$correo'); // URL para la solicitud de datos de usuario
  final respuesta = await http.get(url); // Realizar la solicitud GET

  if (respuesta.statusCode == 200) {
    final responseData = json.decode(respuesta.body); // Decodificar la respuesta JSON
    return responseData; // Devolver los datos del usuario
  } else {
    throw Exception('Falló la carga de los datos del usuario'); // Lanzar una excepción si falla la solicitud
  }
}

// Función para iniciar sesión de usuario
Future<bool> iniciarUsuario(String correo, String contrasena) async {
  print("Correo electrónico: $correo"); // Mostrar el correo electrónico en la consola
  print("Contraseña: $contrasena"); // Mostrar la contraseña en la consola

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'), // Endpoint para iniciar sesión
      body: {
        'email': correo,
        'password': contrasena,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body);
      if (data['success']) {
        // Inicio de sesión exitoso, proceder según corresponda
        return true;
      } else {
        // Mostrar mensaje de error usando data['message']
        return false;
      }
    } else {
      // Manejar otros códigos de estado o errores
      return false;
    }
  } catch (error) {
    // Manejar errores de conexión u otros errores
    print('Error: $error');
    return false;
  }
}

// Función para registrar un nuevo usuario
Future<bool> registrarUsuario(String nombre, String apellido, String correo, String contrasena) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'), // Endpoint para el registro
      body: {
        'nombre': nombre,
        'apellido': apellido,
        'email': correo,
        'password': contrasena,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Registro exitoso
      return true;
    } else {
      // Registro fallido
      return false;
    }
  } catch (error) {
    // Manejar errores de conexión u otros errores
    print('Error: $error');
    return false;
  }
}
