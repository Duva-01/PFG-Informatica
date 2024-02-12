import 'package:flutter/material.dart';
import 'package:grownomics/api/authAPI.dart'; // Importar el API de autenticación
import 'dart:math'; // Importar la biblioteca 'dart:math'

import 'package:grownomics/paginas/inicio.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar la página de inicio

// Widget para la página de registro
class PaginaRegistro extends StatefulWidget {
  @override
  _PaginaRegistroState createState() => _PaginaRegistroState();
}

class _PaginaRegistroState extends State<PaginaRegistro> {
  // Controladores para los campos de texto
  final TextEditingController _controladorNombre = TextEditingController();
  final TextEditingController _controladorApellido = TextEditingController();
  final TextEditingController _controladorCorreo = TextEditingController();
  final TextEditingController _controladorContrasena = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Construir el scaffold de la página de registro
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.all(20.0), // Añadir relleno alrededor del contenido
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Alinear los elementos horizontalmente al estiramiento
            children: <Widget>[
              SizedBox(height: 40.0), // Espaciado vertical de 40
              Text(
                'Crear una cuenta', // Título de la página
                textAlign: TextAlign.center, // Alinear el texto al centro
                style: TextStyle(
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 60.0), // Espaciado vertical de 60
              Text(
                'Introduzca su nombre completo:', // Instrucción para introducir el nombre completo
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic, // Estilo cursiva para el texto
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5.0), // Espaciado vertical de 5
              TextFormField(
                controller:
                    _controladorNombre, // Asignar el controlador al campo de texto para el nombre
                decoration: InputDecoration(
                  labelText: 'Nombre', // Etiqueta del campo de texto
                  border: OutlineInputBorder(), // Borde del campo de texto
                ),
                keyboardType: TextInputType
                    .emailAddress, // Tipo de teclado para el campo de texto
              ),
              SizedBox(height: 20.0), // Espaciado vertical de 20
              Text(
                'Introduzca sus apellidos:', // Instrucción para introducir los apellidos
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic, // Estilo cursiva para el texto
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5.0), // Espaciado vertical de 5
              TextFormField(
                controller:
                    _controladorApellido, // Asignar el controlador al campo de texto para los apellidos
                decoration: InputDecoration(
                  labelText: 'Apellidos', // Etiqueta del campo de texto
                  border: OutlineInputBorder(), // Borde del campo de texto
                ),
                keyboardType: TextInputType
                    .emailAddress, // Tipo de teclado para el campo de texto
              ),
              SizedBox(height: 20.0), // Espaciado vertical de 20
              Text(
                'Introduzca su correo:', // Instrucción para introducir el correo
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic, // Estilo cursiva para el texto
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5.0), // Espaciado vertical de 5
              TextFormField(
                controller:
                    _controladorCorreo, // Asignar el controlador al campo de texto para el correo
                decoration: InputDecoration(
                  labelText: 'Correo', // Etiqueta del campo de texto
                  border: OutlineInputBorder(), // Borde del campo de texto
                ),
                keyboardType: TextInputType
                    .emailAddress, // Tipo de teclado para el campo de texto
              ),
              SizedBox(height: 20.0), // Espaciado vertical de 20
              Text(
                'Introduzca su contraseña:', // Instrucción para introducir la contraseña
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic, // Estilo cursiva para el texto
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5.0), // Espaciado vertical de 5
              TextFormField(
                controller:
                    _controladorContrasena, // Asignar el controlador al campo de texto para la contraseña
                decoration: InputDecoration(
                  labelText: 'Contraseña', // Etiqueta del campo de texto
                  border: OutlineInputBorder(), // Borde del campo de texto
                  suffixIcon: Icon(
                      Icons.visibility_off), // Icono para ocultar la contraseña
                ),
                obscureText: true, // Ocultar el texto de la contraseña
              ),
              SizedBox(height: 40.0), // Espaciado vertical de 40
              ElevatedButton(
                child: Text('Registrarse'), // Texto del botón de registro
                onPressed: () async {
                  final nombre =
                      _controladorNombre.text; // Obtener el nombre ingresado
                  final apellido = _controladorApellido
                      .text; // Obtener los apellidos ingresados
                  final correo =
                      _controladorCorreo.text; // Obtener el correo ingresado
                  final contrasena = _controladorContrasena
                      .text; // Obtener la contraseña ingresada

                  final registroExitoso = await registrarUsuario(
                      nombre,
                      apellido,
                      correo,
                      contrasena); // Intentar registrar al usuario

                  if (registroExitoso) {
                    final preferencias = await SharedPreferences
                        .getInstance(); // Obtener las preferencias del usuario
                    await preferencias.setString('userEmail',
                        correo); // Guardar el correo electrónico del usuario

                    await preferencias.setBool('isUserLoggedIn',
                        true); // Guardar la preferencia de recordar al usuario

                    // Registro exitoso, redirigir a la página de inicio
                    Navigator.of(context).pushNamed('/home');
                  } else {
                    // Registro fallido, mostrar un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Registro fallido. Verifica tus credenciales.'), // Mensaje de error
                        duration: Duration(
                            seconds: 3), // Duración del mensaje de error
                      ),
                    );
                  }
                },
              ),
              TextButton(
                child: Text(
                    '¿Ya tienes una cuenta? Inicia sesión'), // Texto del botón para iniciar sesión
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/iniciar_sesion'); // Navegar a la página de inicio de sesión al presionar el botón
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
