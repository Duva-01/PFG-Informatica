import 'dart:async'; // Importar el paquete dart:async para usar temporizadores
import 'package:flutter/material.dart'; // Importar el paquete flutter/material.dart para usar widgets de Flutter
import 'package:grownomics/logins/welcomePage.dart'; // Importar la página de bienvenida
import 'package:grownomics/paginas/inicio.dart'; // Importar la página de inicio (asegúrate de tener el import correcto para HomeScreen)
import 'package:shared_preferences/shared_preferences.dart'; // Importar shared_preferences para manejar preferencias compartidas
import 'package:animate_do/animate_do.dart'; // Importar animate_do para agregar animaciones
import 'package:loading_indicator/loading_indicator.dart'; // Importar loading_indicator para mostrar un indicador de carga

// Widget de la página de carga
class PaginaCarga extends StatefulWidget {
  @override
  _PaginaCargaState createState() => _PaginaCargaState();
}

class _PaginaCargaState extends State<PaginaCarga> {
  @override
  void initState() {
    super.initState();
    inicializar(); // Inicializar la página de carga al crear el estado
  }

  // Método para inicializar la página de carga
  void inicializar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Obtener las preferencias compartidas
    bool isUserRemember = prefs.getBool('isUserRemember') ?? false; // Verificar si el usuario ha iniciado sesión anteriormente
    bool isSkipped = prefs.getBool('isSkipped') ?? false; // Verificar si el usuario ha iniciado sesión anteriormente
    // Temporizador para esperar 5 segundos antes de redirigir al usuario
    Timer(Duration(seconds: 5), () {
      if (isUserRemember || isSkipped) {
        // Si el usuario está "recordado", redirigir directamente al Inicio
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PantallaInicio()));
      } else {
        // Si el usuario no está "recordado", llevar al usuario a la página de bienvenida
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => PaginaBienvenida(),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child), // Agregar una transición de desvanecimiento
            transitionDuration: Duration(milliseconds: 1000), // Duración de la transición
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construir el widget de la página de carga
    return FlipInY(
      child: Container(
        child: Container(
          margin: EdgeInsets.all(20),
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 50,
            height: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.lineScale, // Tipo de indicador de carga
              colors: const [Color(0xFF2F8B62)], // Colores del indicador de carga
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white, // Color de fondo blanco
          image: DecorationImage(
            
            image: AssetImage("assets/images/grownomics_logo.png"), // Imagen de fondo del logo de Grownomics
            fit: BoxFit.fitWidth, // Ajustar la imagen al ancho del contenedor
          ),
        ),
      ),
    );
  }
}
