import 'package:flutter/material.dart';
import 'dart:math';

import 'package:grownomics/paginas/inicio.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/images/grownomics_logo.png"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Text(
                'Bienvenido a Grownomics',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'El lugar para aprender y crecer economicamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 20.0),
              // Botón para iniciar sesión
              ElevatedButton(
                child: Text('Iniciar sesión'),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/login'); // Navega a la página de inicio de sesión
                },
              ),
              SizedBox(height: 10.0),
              // Botón para registrarse
              OutlinedButton(
                child: Text('Registrarse'),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/register'); // Navega a la página de registro
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
