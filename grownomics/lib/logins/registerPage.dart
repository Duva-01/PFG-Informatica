import 'package:flutter/material.dart';
import 'package:grownomics/api/authAPI.dart';
import 'dart:math';

import 'package:grownomics/paginas/inicio.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40.0),
              Text(
                'Crear una cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 60.0),
              Text(
                'Introduzca su nombre completo:',
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle:
                      FontStyle.italic, // Esto agrega la cursiva (itálica)
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),

              Text(
                'Introduzca sus apellidos:',
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle:
                      FontStyle.italic, // Esto agrega la cursiva (itálica)
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5.0),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              Text(
                'Introduzca su correo:',
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle:
                      FontStyle.italic, // Esto agrega la cursiva (itálica)
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              Text(
                'Introduzca su contraseña:',
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle:
                      FontStyle.italic, // Esto agrega la cursiva (itálica)
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                obscureText: true,
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                child: Text('Registrarse'),
                onPressed: () async {
                  final name = _nameController.text;
                  final surname = _surnameController.text;
                  final email = _emailController.text;
                  final password = _passwordController.text;

                  final loginSuccessful =
                      await registerUser(name, surname, email, password);

                  if (loginSuccessful) {
                    // Inicio de sesión exitoso, redirige a la página de inicio
                    Navigator.of(context).pushNamed('/home');
                  } else {
                    // Inicio de sesión fallido, muestra un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Inicio de sesión fallido. Verifica tus credenciales.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
              TextButton(
                child: Text('¿Ya tienes una cuenta? Inicia sesión'),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/login'); // Navega a la página de registro
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
