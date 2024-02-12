import 'package:flutter/material.dart'; // Importar el paquete flutter/material.dart para usar widgets de Flutter
import 'package:grownomics/api/authAPI.dart'; // Importar el API de autenticación (asegúrate de tener el import correcto)
import 'package:shared_preferences/shared_preferences.dart'; // Importar el paquete shared_preferences para manejar preferencias del usuario

// Widget de la página de inicio de sesión
class PaginaInicioSesion extends StatefulWidget {
  @override
  _PaginaInicioSesionState createState() => _PaginaInicioSesionState();
}

class _PaginaInicioSesionState extends State<PaginaInicioSesion> {
  TextEditingController _controladorCorreo = TextEditingController(); // Controlador para el campo de correo electrónico
  TextEditingController _controladorContrasena = TextEditingController(); // Controlador para el campo de contraseña

  bool _estaRecordado = false; // Variable para controlar si se recuerda al usuario

  @override
  Widget build(BuildContext context) {
    // Construir el scaffold de la página de inicio de sesión
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0), // Espaciado interno de 20
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Alinear los elementos horizontalmente al estiramiento
          children: <Widget>[
            Expanded(
              child: Image.asset(
                'assets/images/grownomics_logo.png', // Imagen del logo de Grownomics
                fit: BoxFit.contain, // Ajustar la imagen al contenido del contenedor
              ),
            ),
            SizedBox(height: 20.0), // Espaciado vertical de 20
            TextFormField(
              controller: _controladorCorreo, // Asignar el controlador al campo de correo electrónico
              decoration: InputDecoration(
                labelText: 'Correo / ID Usuario', // Etiqueta del campo de correo electrónico
                border: OutlineInputBorder(), // Borde del campo de entrada
              ),
              keyboardType: TextInputType.emailAddress, // Tipo de teclado para el campo de correo electrónico
            ),
            SizedBox(height: 10.0), // Espaciado vertical de 10
            TextFormField(
              controller: _controladorContrasena, // Asignar el controlador al campo de contraseña
              decoration: InputDecoration(
                labelText: 'Contraseña', // Etiqueta del campo de contraseña
                border: OutlineInputBorder(), // Borde del campo de entrada
                suffixIcon: Icon(Icons.visibility_off), // Icono para ocultar la contraseña
              ),
              obscureText: true, // Ocultar el texto de la contraseña
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinear los elementos horizontalmente con espacio entre ellos
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _estaRecordado, // Valor del checkbox para recordar al usuario
                      onChanged: (bool? value) {
                        setState(() {
                          _estaRecordado = value!; // Actualizar el estado de recordar al usuario
                        });
                      },
                    ),
                    Text('Recordarme'), // Texto para recordar al usuario
                  ],
                ),
                TextButton(
                  child: Text('Olvidé mi contraseña'), // Texto del botón para olvidar la contraseña
                  onPressed: () {
                    // Lógica para recuperar la contraseña
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: Text('Iniciar sesión'), // Texto del botón de inicio de sesión
              onPressed: () async {
                final correo = _controladorCorreo.text; // Obtener el correo electrónico ingresado
                final contrasena = _controladorContrasena.text; // Obtener la contraseña ingresada

                final inicioSesionExitoso = await iniciarUsuario(correo, contrasena); // Intentar iniciar sesión con las credenciales proporcionadas

                if (inicioSesionExitoso) {
                  final preferencias = await SharedPreferences.getInstance(); // Obtener las preferencias del usuario
                  await preferencias.setString('userEmail', correo); // Guardar el correo electrónico del usuario

                  if (_estaRecordado) {
                    // Si se selecciona recordar al usuario
                    await preferencias.setBool('isUserLoggedIn', true); // Guardar la preferencia de recordar al usuario
                  }

                  // Inicio de sesión exitoso, redirigir a la página de inicio
                  Navigator.of(context).pushReplacementNamed('/home');
                } else {
                  // Inicio de sesión fallido, mostrar un mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Inicio de sesión fallido. Verifica tus credenciales.'), // Mensaje de error
                      duration: Duration(seconds: 3), // Duración del mensaje de error
                    ),
                  );
                }
              },
            ),
            TextButton(
              child: Text('¿Nuevo en Grownomics? Registrate'), // Texto del botón para registrarse
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/registrar'); // Navegar a la página de registro al presionar el botón
              },
            ),
            Align(
              alignment: Alignment.center, // Alinear al centro
              child: Text('------------- o -------------'), // Texto separador
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Alinear los elementos horizontalmente al centro
              children: [
                IconButton(
                  icon: Icon(Icons.g_translate), // Icono para iniciar sesión con Google
                  onPressed: () {
                    // Lógica para iniciar sesión con Google
                  },
                ),
                IconButton(
                  icon: Icon(Icons.facebook), // Icono para iniciar sesión con Facebook
                  onPressed: () {
                    // Lógica para iniciar sesión con Facebook
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera), // Icono para iniciar sesión con otra plataforma
                  onPressed: () {
                    // Lógica para iniciar sesión con otra plataforma
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
