import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:grownomics/modelos/Notificacion.dart';

class UsuarioController {
  // URL base para las solicitudes HTTP
  //static const String baseUrl = 'http://10.0.2.2:5000';
  static const String baseUrl = 'http://143.47.44.251:5000';

  // Función para obtener los datos de un usuario dado su correo electrónico
  static Future<Map<String, dynamic>> obtenerDatosUsuario(String correo) async {
    final Uri url = Uri.parse('$baseUrl/auth/get_user?email=$correo');
    final respuesta = await http.get(url, headers: {'X-App-Usage': 'true'});

    if (respuesta.statusCode == 200) {
      final responseData = json.decode(respuesta.body);
      return responseData;
    } else {
      throw Exception('Falló la carga de los datos del usuario');
    }
  }

  // Función para iniciar sesión de usuario
  static Future<bool> iniciarUsuario(String correo, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: {'email': correo, 'password': contrasena},
        headers: {'X-App-Usage': 'true'}
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        if (data['success']) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  // Función para registrar un nuevo usuario
  static Future<bool> registrarUsuario(String nombre, String apellido, String correo, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        body: {'nombre': nombre, 'apellido': apellido, 'email': correo, 'password': contrasena},
        headers: {'X-App-Usage': 'true'}
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  // Función para actualizar la información de un usuario
  static Future<bool> actualizarUsuario(int id, String nombre, String apellido, String correo, String nuevaContrasena) async {
    final Uri url = Uri.parse('$baseUrl/auth/update_user');

    try {
      final body = {
        'id': id.toString(),
        'nombre': nombre,
        'apellido': apellido,
        'correo': correo,
      };

      if (nuevaContrasena.isNotEmpty) {
        body['password'] = nuevaContrasena;
      }

      final respuesta = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'X-App-Usage': 'true'},
        body: json.encode(body),
      );

      if (respuesta.statusCode == 200) {
        final responseData = json.decode(respuesta.body);
        if (responseData['success']) {
          return true;
        } else {
          print('Error al actualizar usuario: ${responseData['message']}');
          return false;
        }
      } else {
        print('Error: ${respuesta.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al actualizar usuario: $e');
      return false;
    }
  }

  // Función asíncrona para solicitar un restablecimiento de contraseña
  static Future<bool> solicitarResetPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset_password_request'),
      headers: {'Content-Type': 'application/json', 'X-App-Usage': 'true'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Función asíncrona para restablecer la contraseña
  static Future<bool> resetPassword(String email, String codigo, String nuevaPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset_password'),
      headers: {'Content-Type': 'application/json', 'X-App-Usage': 'true'},
      body: json.encode({
        'email': email,
        'code': codigo,
        'new_password': nuevaPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Función para obtener las notificaciones de un usuario
  static Future<List<Notificacion>> obtenerNotificacionesUsuario(String correo) async {
    final Uri url = Uri.parse('$baseUrl/auth/get_notifications?email=$correo');
    final respuesta = await http.get(url, headers: {'X-App-Usage': 'true'});

    if (respuesta.statusCode == 200) {
      List<dynamic> body = json.decode(respuesta.body);
      List<Notificacion> notificaciones = body.map((dynamic item) => Notificacion.fromJson(item)).toList();
      return notificaciones;
    } else {
      throw "No se pudieron cargar las notificaciones.";
    }
  }
}
