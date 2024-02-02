import 'package:flutter/material.dart';
import 'package:grownomics/api/authAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isRememberMeChecked = false;
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
                      value: _isRememberMeChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isRememberMeChecked = value!;
                        });
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
                  if (_isRememberMeChecked) {
                    // Guarda la preferencia de recordar al usuario
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isUserLoggedIn', true);
                    await prefs.setString('userEmail', email);

                  }
                  // Inicio de sesión exitoso, redirige a la página de inicio
                  Navigator.of(context).pushReplacementNamed('/home');
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
