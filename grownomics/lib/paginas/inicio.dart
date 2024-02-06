import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Cartera/pagina_cartera.dart';

import 'package:grownomics/paginas/Home/homePage.dart';
import 'package:grownomics/paginas/Mercado/marketPage.dart';
import '../widgets/menu_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ZoomDrawerController controller = ZoomDrawerController();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;  // índice de la página seleccionada
  late String userEmail = "grownomicero@gmail.com"; // Valor predeterminado

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // actualizar el índice de la página seleccionada
    });
  }

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
    final pages = [PaginaInicio(userEmail: userEmail), PaginaMercado(userEmail: userEmail), PaginaCartera(), PaginaCartera(), PaginaCartera(), PaginaCartera(), PaginaCartera()];

    return ZoomDrawer(
      controller: controller,
      mainScreen: pages[_selectedIndex],  // mostrar la página seleccionada
      menuScreen: MenuScreen(controller: controller, onItemTapped: _onItemTapped),
      borderRadius: 24,
      showShadow: true,
      angle: 0.0,
      drawerShadowsBackgroundColor: Colors.grey,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: Color.fromARGB(255, 67, 211, 149),
    );
  }
}
