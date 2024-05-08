import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/controladores/userController.dart';
import 'package:grownomics/paginas/Analisis/analisisPage.dart';
import 'package:grownomics/paginas/Aprendizaje/learnPage.dart';
import 'package:grownomics/paginas/Cartera/portfolioPage.dart';
import 'package:grownomics/paginas/Configuracion/configPage.dart';

import 'package:grownomics/paginas/Home/homePage.dart';
import 'package:grownomics/paginas/Mercado/marketPage.dart';
import 'package:grownomics/paginas/MisAcciones/myStockPage.dart';
import 'package:grownomics/paginas/Noticias/newsPage.dart';
import 'package:grownomics/socketService.dart';
import '../widgets/menu_controller.dart'; // Importa el controlador del menú personalizado
import 'package:shared_preferences/shared_preferences.dart'; // Importa el paquete de SharedPreferences para manejar las preferencias del usuario

final ZoomDrawerController controlador = ZoomDrawerController(); // Controlador del ZoomDrawer

class PantallaInicio extends StatefulWidget {
  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _indiceSeleccionado = 0;
  late Future<void> _cargaInicial;
  String correoElectronico = '';
  String nombre = '';
  String apellido = '';

  late SocketService _socketService;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _socketService = SocketService(); 
    _cargaInicial = _cargarUsuario();
  }

  @override
  void dispose() {
    _socketService.disconnect();
    setState(() {
      _isConnected = false;
    });
    super.dispose();
  }

  Future<void> _cargarUsuario() async {
    final preferencias = await SharedPreferences.getInstance();
    final isUserLoggedIn = preferencias.getBool('isUserLoggedIn') ?? false;

    if (isUserLoggedIn) {
      final emailObtenido = preferencias.getString('userEmail');
      if (emailObtenido != null) {
        try {
          final datos = await UsuarioController.obtenerDatosUsuario(emailObtenido);
          if (datos != null && datos['nombre'] != null && datos['apellido'] != null) {
            setState(() {
              correoElectronico = emailObtenido;
              nombre = datos['nombre'];
              apellido = datos['apellido'];
            });
            _socketService.connectAndListen(correoElectronico);
            _isConnected = true;
          }
        } catch (e) {
          print('Hubo un error al obtener los datos del usuario: $e');
        }
      }
    } else {
      print('El usuario no ha iniciado sesión');
    }
  }

  // Método llamado cuando se toca un ítem del menú
  void _alItemTocar(int indice) {
    setState(() {
      _indiceSeleccionado = indice; // actualizar el índice de la página seleccionada
    });
  }

 
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _cargaInicial,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // Mostrar un indicador de carga mientras los datos se están cargando
          );
        } else {
            final paginas = [
              PaginaInicio(userEmail: correoElectronico), // Página de inicio
              PaginaAnalisis(userEmail: correoElectronico), // Pagina de analisis
              PaginaCartera(userEmail: correoElectronico), // Página de cartera
              PaginaMisAcciones(userEmail: correoElectronico), // Página de mis acciones
              PaginaNoticias(), // Página de noticias
              PaginaAprendizaje(), // Página de aprendizaje
              PaginaConfiguracion(userEmail: correoElectronico, nombre: nombre, apellido: apellido) // Página de configuración con datos de usuario
            ];

            return ZoomDrawer(
              controller: controlador, // Controlador del ZoomDrawer
              mainScreen: paginas[_indiceSeleccionado], // Página principal que se muestra
              menuScreen: MenuScreen(controller: controlador, onItemTapped: _alItemTocar, socketService: _socketService), // Menú lateral
              borderRadius: 24, // Radio de borde
              showShadow: true, // Mostrar sombra
              angle: 0.0, // Ángulo de rotación
              drawerShadowsBackgroundColor: Colors.grey, // Color de fondo de las sombras del cajón
              slideWidth: MediaQuery.of(context).size.width * 0.65, // Ancho del cajón deslizante
              menuBackgroundColor: Color.fromARGB(255, 67, 211, 149), // Color de fondo del menú
            );
        }
      },
    );
  }
}