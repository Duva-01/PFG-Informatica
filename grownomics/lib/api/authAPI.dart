import 'dart:convert';
import 'package:grownomics/modelos/Notificacion.dart';
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

// Función para actualizar la información de un usuario
Future<bool> actualizarUsuario(int id, String nombre, String apellido, String correo, String nuevaContrasena) async {
  final Uri url = Uri.parse('$baseUrl/auth/update_user'); // Endpoint para actualizar usuario

  try {
    // Preparar el cuerpo de la solicitud
    final body = {
      'id': id.toString(),
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
    };

    // Incluir la nueva contraseña solo si se ha proporcionado
    if (nuevaContrasena.isNotEmpty) {
      body['password'] = nuevaContrasena;
    }

    // Realizar la solicitud POST
    final respuesta = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Especificar el tipo de contenido como JSON
      },
      body: json.encode(body), // Codificar el cuerpo de la solicitud como JSON
    );

    // Verificar el código de estado de la respuesta
    if (respuesta.statusCode == 200) {
      // Decodificar la respuesta JSON
      final responseData = json.decode(respuesta.body);

      // Verificar el éxito de la operación
      if (responseData['success']) {
        return true; // Devolver verdadero si la actualización fue exitosa
      } else {
        // Opcionalmente, manejar mensajes de error específicos
        print('Error al actualizar usuario: ${responseData['message']}');
        return false; // Devolver falso si la actualización falló
      }
    } else {
      // Manejar otros códigos de estado
      print('Error: ${respuesta.statusCode}');
      return false;
    }
  } catch (e) {
    // Manejar excepciones de la solicitud
    print('Excepción al actualizar usuario: $e');
    return false;
  }
}

//------------------------------------------------------------------------------

// Función asíncrona para solicitar un restablecimiento de contraseña
Future<bool> solicitarResetPassword(String email) async {
  // Realiza una solicitud POST al endpoint correspondiente para solicitar restablecimiento de contraseña
  final response = await http.post(
    Uri.parse('$baseUrl/auth/reset_password_request'),
    headers: {'Content-Type': 'application/json'}, // Encabezados de la solicitud
    body: json.encode({'email': email}), // Cuerpo de la solicitud (correo electrónico codificado en JSON)
  );

  // Verifica si la solicitud fue exitosa (código de estado 200)
  if (response.statusCode == 200) {
    // Si el servidor responde con éxito, devuelve true
    return true; // Código de verificación enviado con éxito
  } else {
    // Si hay algún error en la respuesta, devuelve false
    return false; // Error al enviar el código de verificación
  }
}

// Función asíncrona para restablecer la contraseña
Future<bool> resetPassword(String email, String codigo, String nuevaPassword) async {
  // Realiza una solicitud POST al endpoint correspondiente para restablecer la contraseña
  final response = await http.post(
    Uri.parse('$baseUrl/auth/reset_password'),
    headers: {'Content-Type': 'application/json'}, // Encabezados de la solicitud
    body: json.encode({
      'email': email, // Correo electrónico
      'code': codigo, // Código de verificación
      'new_password': nuevaPassword, // Nueva contraseña
    }),
  );

  // Verifica si la solicitud fue exitosa (código de estado 200)
  if (response.statusCode == 200) {
    // Si el servidor responde con éxito, devuelve true
    return true; // Contraseña restablecida con éxito
  } else {
    // Si hay algún error en la respuesta, devuelve false
    return false; // Error al restablecer la contraseña
  }
}

//---------------------------------------------------------------------

Future<List<Notificacion>> obtenerNotificacionesUsuario(String correo) async {
  final Uri url = Uri.parse('$baseUrl/auth/get_notifications?email=$correo');
  final respuesta = await http.get(url);

  if (respuesta.statusCode == 200) {
    List<dynamic> body = json.decode(respuesta.body);
    List<Notificacion> notificaciones = body
        .map((dynamic item) => Notificacion.fromJson(item))
        .toList();
    return notificaciones;
  } else {
    throw "No se pudieron cargar las notificaciones.";
  }
}
