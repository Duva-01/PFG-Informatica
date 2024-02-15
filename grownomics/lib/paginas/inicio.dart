import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/api/authAPI.dart';
import 'package:grownomics/paginas/Analisis/analisisPage.dart';
import 'package:grownomics/paginas/Aprendizaje/learnPage.dart';
import 'package:grownomics/paginas/Cartera/portfolioPage.dart';
import 'package:grownomics/paginas/Configuracion/configPage.dart';

import 'package:grownomics/paginas/Home/homePage.dart';
import 'package:grownomics/paginas/Mercado/marketPage.dart';
import 'package:grownomics/paginas/Noticias/newsPage.dart';
import '../widgets/menu_controller.dart'; // Importa el controlador del menú personalizado
import 'package:shared_preferences/shared_preferences.dart'; // Importa el paquete de SharedPreferences para manejar las preferencias del usuario

final ZoomDrawerController controlador = ZoomDrawerController(); // Controlador del ZoomDrawer

class PantallaInicio extends StatefulWidget {
  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _indiceSeleccionado = 0; // índice de la página seleccionada
  late String correoElectronico = "grownomicero@gmail.com"; // Valor predeterminado del correo electrónico
  late String nombre = "Grownomicero"; // Valor predeterminado del nombre
  late String apellido = ""; // Valor predeterminado del apellido

  // Método llamado cuando se toca un ítem del menú
  void _alItemTocar(int indice) {
    setState(() {
      _indiceSeleccionado = indice; // actualizar el índice de la página seleccionada
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarUsuario(); // Cargar datos del usuario al iniciar
  }

  // Método para cargar los datos del usuario
  Future<void> _cargarUsuario() async {
    final preferencias = await SharedPreferences.getInstance(); // Obtener preferencias del usuario
    final emailObtenido = preferencias.getString('userEmail') ?? correoElectronico; // Obtener correo electrónico del usuario guardado en las preferencias

    try {
      final datos = await obtenerDatosUsuario(emailObtenido); // Obtener datos del usuario
      if (datos['nombre'] != null && datos['apellido'] != null) {
        // Si se obtienen nombre y apellido
        setState(() {
          correoElectronico = emailObtenido; // Actualizar correo electrónico
          nombre = datos['nombre']; // Actualizar nombre
          apellido = datos['apellido']; // Actualizar apellido
        });
      }
    } catch (e) {
      // Manejar errores al obtener datos del usuario
      print('Hubo un error al obtener los datos del usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      PaginaInicio(userEmail: correoElectronico), // Página de inicio
      PaginaMercado(userEmail: correoElectronico), // Página de mercado
      PaginaAnalisis(userEmail: correoElectronico), // Pagina de analisis
      PaginaCartera(userEmail: correoElectronico), // Página de cartera
      PaginaNoticias(), // Página de noticias
      PaginaAprendizaje(), // Página de aprendizaje
      PaginaConfiguracion(userEmail: correoElectronico, nombre: nombre, apellido: apellido) // Página de configuración con datos de usuario
    ];

    return ZoomDrawer(
      controller: controlador, // Controlador del ZoomDrawer
      mainScreen: paginas[_indiceSeleccionado], // Página principal que se muestra
      menuScreen: MenuScreen(controller: controlador, onItemTapped: _alItemTocar), // Menú lateral
      borderRadius: 24, // Radio de borde
      showShadow: true, // Mostrar sombra
      angle: 0.0, // Ángulo de rotación
      drawerShadowsBackgroundColor: Colors.grey, // Color de fondo de las sombras del cajón
      slideWidth: MediaQuery.of(context).size.width * 0.65, // Ancho del cajón deslizante
      menuBackgroundColor: Color.fromARGB(255, 67, 211, 149), // Color de fondo del menú
    );
  }
}
