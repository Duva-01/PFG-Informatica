import 'package:grownomics/controladores/userController.dart';
import 'package:grownomics/modelos/Notificacion.dart';

class MockUsuarioController implements UsuarioController {
  // Simula un comportamiento de éxito o fallo para el inicio de sesión
  @override
  Future<bool> iniciarUsuario(String correo, String contrasena) async {
    if (correo == "david@gmail.com" && contrasena == "clave123") {
      return true; // Simula un inicio de sesión exitoso
    } else {
      return false; // Simula un fallo en el inicio de sesión
    }
  }

  @override
  Future<bool> registrarUsuario(String nombre, String apellido, String correo, String contrasena) async {
    // Simula un registro exitoso
    return true;
  }

  @override
  Future<bool> actualizarUsuario(int id, String nombre, String apellido, String correo, String nuevaContrasena) async {
    // Simula una actualización exitosa del usuario
    return true;
  }

  @override
  Future<bool> solicitarResetPassword(String email) async {
    // Simula una solicitud exitosa de restablecimiento de contraseña
    return true;
  }

  @override
  Future<bool> resetPassword(String email, String codigo, String nuevaPassword) async {
    // Simula un restablecimiento de contraseña exitoso
    return true;
  }

  @override
  Future<List<Notificacion>> obtenerNotificacionesUsuario(String correo) async {
    // Devuelve una lista simulada de notificaciones para el usuario
    return [
      Notificacion(id: 0, mensaje: "Notificación de prueba", fecha: "22/10/2024"),
    ];
  }

  @override
  Future<Map<String, dynamic>> obtenerDatosUsuario(String correo) async {
    // Simula la obtención de datos del usuario
    return {
      "nombre": "Usuario de Prueba",
      "correo": correo,
    };
  }
}
