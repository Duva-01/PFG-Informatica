import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:5000';

Future<bool> loginUser(String email, String password) async {
  print("Email: $email"); // Muestra el correo electrónico en la consola
  print("Password: $password"); // Muestra la contraseña en la consola

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/login'), // Endpoint para el inicio de sesión
      body: {
        'email': email,
        'password': password,
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

Future<bool> registerUser(String name, String surname, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register'), // Endpoint para el registro
      body: {
        'username': name,
        'apellido': surname,
        'email': email,
        'password': password,
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
