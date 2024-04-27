import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Home/Widgets/balanceWidget.dart';
import 'package:grownomics/paginas/Home/Widgets/favsStockWidget.dart';
import 'package:grownomics/paginas/Home/Widgets/lastNewsWidget.dart';
import 'package:grownomics/paginas/Home/Widgets/marketSummaryWidget.dart';
import 'package:grownomics/paginas/Home/Widgets/notificationPage.dart';
import 'package:grownomics/paginas/Home/Widgets/transactionWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Widget de la página de inicio que muestra el resumen del usuario
class PaginaInicio extends StatefulWidget {
  final String userEmail; // Correo electrónico del usuario
  PaginaInicio(
      {required this.userEmail}); // Constructor con parámetro obligatorio

  @override
  _PaginaInicioState createState() =>
      _PaginaInicioState(); // Crea el estado de la página de inicio
}

class _PaginaInicioState extends State<PaginaInicio> {
  bool _isUserLoggedIn = false;
  
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;

    setState(() {
      _isUserLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Método para construir la interfaz de usuario de la página de inicio
    final controller =
        ZoomDrawer.of(context); // Controlador para manejar el ZoomDrawer

    return Scaffold(
      // Devuelve un Scaffold que proporciona la estructura básica de la página
      appBar: AppBar(
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          'Grownomics',
          style: TextStyle(
            color: Colors.white, // Color del texto blanco
          ),
        ), // Título de la aplicación
        centerTitle: true, // Centra el título en la barra de aplicaciones
        leading: IconButton(
          // Botón de menú en el lado izquierdo de la barra de aplicaciones
          icon: Icon(Icons.menu, color: Colors.white), // Icono de menú
          onPressed: () {
            // Manejador de eventos cuando se presiona el botón de menú
            controller
                ?.toggle(); // Alterna el estado del ZoomDrawer (abre/cierra)
          },
        ),

        actions: [
          if (_isUserLoggedIn) ...[
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PaginaNotificaciones(correo: widget.userEmail),
                ));
              },
            ),
          ],
        ],

        backgroundColor: Theme.of(context)
            .primaryColor, // Color de fondo de la AppBar según el color primario del tema
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 39, 99, 72), // Color de fondo del contenedor
        child: SingleChildScrollView(
          // Permite desplazarse hacia arriba y hacia abajo dentro de la página si es necesario
          child: Container(
            // Contenedor principal de la página de inicio

            child: Column(
              // Columna que contiene los widgets secundarios
              children: [
                UltimasNoticiasWidget(
                  userEmail: widget.userEmail,
                ),
                ResumenMercadoWidget(
                  userEmail: widget.userEmail,
                ), // Widget para mostrar estadísticas

                if (_isUserLoggedIn) ...[
                  BalanceCard(userEmail: widget.userEmail),
                  AccionesFavoritasWidget(userEmail: widget.userEmail),
                  Container(
                    height: 400,
                    child: TransaccionesCard(userEmail: widget.userEmail),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
