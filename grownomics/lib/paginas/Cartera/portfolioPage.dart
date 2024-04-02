import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/controladores/portfolioController.dart';
import 'package:grownomics/modelos/Cartera.dart'; // Importa el modelo de la cartera
import 'package:grownomics/paginas/Cartera/widgets/balanceHistoryWidget.dart';
import 'package:grownomics/paginas/Cartera/widgets/profileCardWidget.dart';
import 'package:grownomics/paginas/Cartera/widgets/transactionListWidget.dart';

class PaginaCartera extends StatefulWidget {
  // Atributo de correo electrónico del usuario
  final String userEmail;

  // Constructor
  PaginaCartera({required this.userEmail});

  @override
  _PaginaCarteraState createState() => _PaginaCarteraState();
}

class _PaginaCarteraState extends State<PaginaCartera> {
  // Variable para almacenar datos de la cartera
  late Cartera cartera;
  // Variable para almacenar el beneficio
  late double beneficio = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Cargar datos de la cartera al inicializar el estado
    cargarDatosCartera();
  }

  // Método para cargar los datos de la cartera
  void cargarDatosCartera() async {
    try {
      // Obtener datos de la cartera
      final datosCartera = await CarteraController.obtenerCartera(widget.userEmail);
      // Convertir los datos a un objeto de tipo Cartera
      final carteraDatos = Cartera.fromJson(datosCartera);
      // Calcular el beneficio
      final beneficioCalculado = await CarteraController.calcularBeneficio(widget.userEmail);
      // Actualizar el estado con los datos de la cartera y el beneficio obtenidos
      setState(() {
        cartera = carteraDatos;
        beneficio = beneficioCalculado;
        isLoading = false; // Indica que la carga ha terminado
      });
    } catch (e) {
      setState(() {
        isLoading =
            false; // Asegura que isLoading se actualice incluso si hay un error
      });
      // Manejar errores al cargar los datos de la cartera
      print("Error al cargar los datos de la cartera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el controlador del ZoomDrawer
    final controller = ZoomDrawer.of(context);
    // Devolver el widget de la página
    return Scaffold(
      appBar: AppBar(
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          'Cartera',
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
        backgroundColor: Theme.of(context)
            .primaryColor, // Color de fondo de la AppBar según el color primario del tema

        shadowColor: Colors.black,
        elevation: 4,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Color(
                      0xFF2F8B62))) // Muestra el indicador de carga si isLoading es true
          : SingleChildScrollView(
              // Cuerpo de la página, desplazable verticalmente
              child: Column(
                // Columna que contiene los widgets secundarios
                children: [
                  // Tarjeta de perfil que muestra información del usuario y la cartera
                  BounceInDown(
                    child: DatosPerfilCard(
                      userEmail: widget.userEmail,
                      cartera: cartera, // Pasar la cartera al widget
                      beneficio: beneficio, // Pasar el beneficio al widget
                      onReload:
                          cargarDatosCartera, // Función de recarga de datos
                    ),
                  ),
                  // Widget de historial de balance
                  FadeInUp(child: HistorialWidget(userEmail: widget.userEmail)),
                  // Widget de lista de transacciones
                  FadeInUp(
                      child:
                          ListaTransaccionWidget(userEmail: widget.userEmail)),
                ],
              ),
            ),
    );
  }
}
