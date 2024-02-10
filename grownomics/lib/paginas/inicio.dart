import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/api/authAPI.dart';
import 'package:grownomics/paginas/Aprendizaje/learnPage.dart';
import 'package:grownomics/paginas/Cartera/portfolioPage.dart';
import 'package:grownomics/paginas/Configuracion/configPage.dart';

import 'package:grownomics/paginas/Home/homePage.dart';
import 'package:grownomics/paginas/Mercado/marketPage.dart';
import 'package:grownomics/paginas/Noticias/newsPage.dart';
import '../widgets/menu_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ZoomDrawerController controller = ZoomDrawerController();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // índice de la página seleccionada
  late String userEmail = "grownomicero@gmail.com"; // Valor predeterminado
  late String nombre = "Grownomicero";
  late String apellido = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // actualizar el índice de la página seleccionada
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final emailObtenido = prefs.getString('userEmail') ?? userEmail;

    try {
      final datos = await obtenerDatosUsuario(emailObtenido);
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      PaginaInicio(userEmail: userEmail),
      PaginaMercado(userEmail: userEmail),
      PaginaCartera(),
      PaginaCartera(),
      PaginaNoticias(),
      PaginaAprendizaje(),
      PaginaConfiguracion(userEmail: userEmail, nombre: nombre, apellido: apellido)
    ];

    return ZoomDrawer(
      controller: controller,
      mainScreen: pages[_selectedIndex],
      menuScreen:
          MenuScreen(controller: controller, onItemTapped: _onItemTapped),
      borderRadius: 24,
      showShadow: true,
      angle: 0.0,
      drawerShadowsBackgroundColor: Colors.grey,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: Color.fromARGB(255, 67, 211, 149),
    );
  }
}
