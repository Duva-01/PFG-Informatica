import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  final ZoomDrawerController controller;
  final Function(int) onItemTapped;

  MenuScreen({required this.controller, required this.onItemTapped});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late String userEmail = "grownomicero@gmail.com"; // Valor predeterminado

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 39, 99, 72),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Grownomicero',
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/admin-profile.jpg'),
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(color: Color(0xFF2F8B62)),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(Icons.home, 'Inicio', 0),
                _buildMenuItem(Icons.show_chart, 'Cotizaciones', 1),
                _buildMenuItem(Icons.bar_chart, 'Análisis', 2),
                _buildMenuItem(Icons.account_balance_wallet, 'Cartera', 3),
                _buildMenuItem(Icons.library_books, 'Noticias', 4),
                _buildMenuItem(Icons.school, 'Aprendizaje', 5),
                _buildMenuItem(Icons.settings, 'Configuración', 6),
              ],
            ),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.white),
            title: Text('Salir', style: TextStyle(color: Colors.white)),
            onTap: () async {
              // Lógica para cerrar sesión
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.remove(
                  'isUserLoggedIn'); // Borrar el estado de inicio de sesión
              await prefs.remove('userEmail');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) =>
                      false); // Redirigir a la pantalla de inicio de sesión
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
