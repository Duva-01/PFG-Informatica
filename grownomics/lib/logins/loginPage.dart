import 'package:flutter/material.dart';
import 'package:grownomics/api/authAPI.dart';
import 'package:grownomics/paginas/pagina_inicio.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Image.asset(
                'assets/images/grownomics_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo / ID Usuario',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off),
              ),
              obscureText: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (bool? value) {
                        // Manejar cambio
                      },
                    ),
                    Text('Recordarme'),
                  ],
                ),
                TextButton(
                  child: Text('Olvidé mi contraseña'),
                  onPressed: () {
                    // Lógica para recuperar contraseña
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: Text('Iniciar sesión'),
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;

                final loginSuccessful = await loginUser(email, password);

                if (loginSuccessful) {
                  // Inicio de sesión exitoso, redirige a la página de inicio
                  Navigator.of(context).pushNamed(
                      '/home');
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
              child: Text('¿Nuevo en Grownomics? Registrate'),
              onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/register'); // Navega a la página de registro
                },
            ),
            Align(
              alignment: Alignment.center,
              child: Text('------------- o -------------'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.g_translate),
                  onPressed: () {
                    // Lógica para iniciar sesión con Google
                  },
                ),
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () {
                    // Lógica para iniciar sesión con Facebook
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera),
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
