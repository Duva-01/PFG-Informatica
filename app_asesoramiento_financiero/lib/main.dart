import 'package:app_asesoramiento_financiero/paginas/pagina_inicio.dart';
import 'package:app_asesoramiento_financiero/paginas/Mercado/pagina_mercado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import 'widgets/menu_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,  // Color primario verde
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

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
