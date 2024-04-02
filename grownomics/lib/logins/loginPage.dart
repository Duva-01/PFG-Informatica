import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/controladores/userController.dart';
import 'package:grownomics/logins/resetPasswordPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginaInicioSesion extends StatefulWidget {
  @override
  _PaginaInicioSesionState createState() => _PaginaInicioSesionState();
}

class _PaginaInicioSesionState extends State<PaginaInicioSesion> {
  TextEditingController _controladorCorreo = TextEditingController();
  TextEditingController _controladorContrasena = TextEditingController();
  bool _estaRecordado = false;
  bool _ocultarClave = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlipInY(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.asset(
                        'assets/images/grownomics_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      key: Key('correoField'),
                      controller: _controladorCorreo,
                      decoration: InputDecoration(
                        labelText: 'Correo / ID Usuario',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      key: Key('contrasenaField'),
                      controller: _controladorContrasena,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _ocultarClave
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _ocultarClave = !_ocultarClave;
                            });
                          },
                        ),
                      ),
                      obscureText: _ocultarClave,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              focusColor: Theme.of(context).primaryColor,
                              activeColor: Theme.of(context).primaryColor,
                              hoverColor: Theme.of(context).primaryColor,
                              value: _estaRecordado,
                              onChanged: (bool? value) {
                                setState(() {
                                  _estaRecordado = value!;
                                });
                              },
                            ),
                            Text('Recordarme'),
                          ],
                        ),
                        TextButton(
                          child: Text(
                            'Olvidé mi contraseña',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaginaCambiarClave()),
                            );
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      key: Key('botonIniciarSesion'),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: _iniciarSesion,
                      child: Text('Iniciar sesión'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: _irARegistro,
                      child: Text('¿Nuevo en Grownomics? Registrate'),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text('------------- o -------------'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: _saltarInicioSesion,
                      child: Text('Saltar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Función para manejar el inicio de sesión
  Future<void> _iniciarSesion() async {
    final correo = _controladorCorreo.text; // Obtener el correo electrónico ingresado
    final contrasena =
        _controladorContrasena.text; // Obtener la contraseña ingresada

    final inicioSesionExitoso = await UsuarioController.iniciarUsuario(
      correo,
      contrasena,
    ); // Intentar iniciar sesión con las credenciales proporcionadas

    if (inicioSesionExitoso) {
      final preferencias =
          await SharedPreferences.getInstance(); // Obtener las preferencias del usuario
      await preferencias.setString(
          'userEmail', correo); // Guardar el correo electrónico del usuario
      await preferencias.setBool(
          'isUserLoggedIn', true); // Guardar la preferencia de recordar al usuario

      if (_estaRecordado) {
        // Si se selecciona recordar al usuario
        await preferencias.setBool(
            'isUserRemember', true); // Guardar la preferencia de recordar al usuario
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
  }

  // Función para manejar la navegación a la página de registro
  void _irARegistro() {
    Navigator.of(context).pushNamed('/registrar');
  }

  // Función para manejar la navegación a la página de inicio sin iniciar sesión
  void _saltarInicioSesion() {
    Navigator.of(context).pushNamed('/home');
  }
}
