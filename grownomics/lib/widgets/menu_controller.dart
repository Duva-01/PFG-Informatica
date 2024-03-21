import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/api/authAPI.dart'; // Importa las funciones relacionadas con la autenticación desde una API
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences para manejar datos persistentes

class MenuScreen extends StatefulWidget {
  final ZoomDrawerController controller;
  final Function(int) onItemTapped;

  MenuScreen({required this.controller, required this.onItemTapped});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late String userEmail =
      "grownomicero@gmail.com"; // Correo electrónico predeterminado
  late String nombre = "Grownomicero"; // Nombre predeterminado
  late String apellido = ""; // Apellido predeterminado
  bool _isUserLoggedIn = false; // Estado de inicio de sesión predeterminado

  @override
  void initState() {
    super.initState();
    _loadUser(); // Cargar los datos del usuario al inicializar el estado del widget
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _isUserLoggedIn = prefs.getBool('isUserLoggedIn') ??
        false; // Obtener el estado de inicio de sesión de SharedPreferences

    if (_isUserLoggedIn) {
      final emailObtenido = prefs.getString('userEmail');
      if (emailObtenido != null) {
        try {
          final datos = await obtenerDatosUsuario(
              emailObtenido); // Obtener datos del usuario utilizando el correo electrónico guardado
          if (datos['nombre'] != null && datos['apellido'] != null) {
            setState(() {
              userEmail = emailObtenido;
              nombre = datos['nombre'];
              apellido = datos['apellido'];
            });
          }
        } catch (e) {
          print('Hubo un error al obtener los datos del usuario: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 39, 99, 72),
      child: Column(
        children: [
          Container(
            width: double.infinity, // Establece el ancho al máximo posible
            color: Color(0xFF2F8B62), // Color de fondo
            padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16), // Añade relleno alrededor de los elementos
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Alinea los elementos a la izquierda
              children: [
                CircleAvatar(
                  radius: 60.0, // Ajusta el tamaño del avatar
                  backgroundImage: AssetImage(
                      'assets/images/profile.gif'), // Imagen de fondo
                ),
                SizedBox(height: 12), // Espacio entre la imagen y el texto
                Text(
                  "$nombre $apellido", // Mostrar nombre y apellido
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  userEmail, // Mostrar correo electrónico
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(Icons.home, 'Inicio', 0),
                _buildMenuItem(Icons.bar_chart, 'Análisis', 1),
                if (_isUserLoggedIn) ...[
                  _buildMenuItem(Icons.account_balance_wallet, 'Cartera', 2),
                  _buildMenuItem(Icons.show_chart, 'Mis acciones', 3),
                ],
                _buildMenuItem(Icons.library_books, 'Noticias', 4),
                _buildMenuItem(Icons.school, 'Aprendizaje', 5),
                _buildMenuItem(Icons.settings, 'Configuración', 6),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Theme.of(context).primaryColor,
          ),
          ListTile(
            leading: Icon(_isUserLoggedIn ? Icons.exit_to_app : Icons.login,
                color: Colors.white),
            title: Text(_isUserLoggedIn ? 'Salir' : 'Iniciar sesión',
                style: TextStyle(color: Colors.white)),
            onTap: () async {
              if (_isUserLoggedIn) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove(
                    'isUserLoggedIn'); // Eliminar el estado de inicio de sesión
                await prefs
                    .remove('userEmail'); // Eliminar el correo electrónico
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/iniciar_sesion',
                    (Route<dynamic> route) =>
                        false); // Redirigir a la pantalla de inicio de sesión
              } else {
                Navigator.of(context).pushNamed(
                    '/iniciar_sesion'); // Navegar a la pantalla de inicio de sesión
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () {
        widget.onItemTapped(index);
        widget.controller.close!();
      },
    );
  }
}
