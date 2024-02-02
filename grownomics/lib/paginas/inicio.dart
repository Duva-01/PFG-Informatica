import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Mercado/pagina_mercado.dart';
import 'package:grownomics/paginas/pagina_inicio.dart';

import '../widgets/menu_controller.dart';

final ZoomDrawerController controller = ZoomDrawerController();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;  // índice de la página seleccionada

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // actualizar el índice de la página seleccionada
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [PaginaInicio(), PaginaMercado()];  // lista de páginas

    return ZoomDrawer(
      controller: controller,
      mainScreen: pages[_selectedIndex],  // mostrar la página seleccionada
      menuScreen: MenuScreen(controller: controller, onItemTapped: _onItemTapped),
      borderRadius: 24,
      showShadow: true,
      angle: 0.0,
      drawerShadowsBackgroundColor: Colors.grey,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: Colors.green,
    );
  }
}
