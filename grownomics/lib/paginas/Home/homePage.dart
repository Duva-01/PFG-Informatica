import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Home/Widgets/balanceWidget.dart';
import 'package:grownomics/paginas/Home/Widgets/statsWidget.dart';
import 'package:grownomics/paginas/Home/Widgets/transactionWidget.dart';
import '../../widgets/mercado_resumen_widget.dart';

// Widget de la página de inicio que muestra el resumen del usuario
class PaginaInicio extends StatefulWidget {
  final String userEmail; // Correo electrónico del usuario
  PaginaInicio({required this.userEmail}); // Constructor con parámetro obligatorio
  
  @override
  _PaginaInicioState createState() => _PaginaInicioState(); // Crea el estado de la página de inicio
}

class _PaginaInicioState extends State<PaginaInicio> { // Estado de la página de inicio
  
  @override
  Widget build(BuildContext context) { // Método para construir la interfaz de usuario de la página de inicio
    final controller = ZoomDrawer.of(context); // Controlador para manejar el ZoomDrawer
    
    return Scaffold( // Devuelve un Scaffold que proporciona la estructura básica de la página
      appBar: AppBar( // Barra de aplicaciones en la parte superior de la página
        title: Text('Grownomics'), // Título de la aplicación
        centerTitle: true, // Centra el título en la barra de aplicaciones
        leading: IconButton( // Botón de menú en el lado izquierdo de la barra de aplicaciones
          icon: Icon(Icons.menu), // Icono de menú
          onPressed: () { // Manejador de eventos cuando se presiona el botón de menú
            controller?.toggle(); // Alterna el estado del ZoomDrawer (abre/cierra)
          },
        ),
      ),
      body: SingleChildScrollView( // Permite desplazarse hacia arriba y hacia abajo dentro de la página si es necesario
        child: Container( // Contenedor principal de la página de inicio
          color: Color.fromARGB(255, 39, 99, 72), // Color de fondo del contenedor
          child: Column( // Columna que contiene los widgets secundarios
            children: [
              StatsGrid(), // Widget para mostrar estadísticas
              BalanceCard(userEmail: widget.userEmail), // Widget para mostrar el saldo del usuario
              TransaccionesCard(), // Widget para mostrar las transacciones recientes del usuario
            ],
          ),
        ),
      ),
    );
  }
}
