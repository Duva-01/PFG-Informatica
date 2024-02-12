import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/api/portfolioAPI.dart';
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
  // Variables para almacenar datos de la cartera
  late double balance = 0.0;
  late double beneficio = 0.0;
  late int totalTransacciones = 0;
  late double totalDepositado = 0.0;
  late double totalRetirado = 0.0;
  late List<String> transactions = [""];

  @override
  void initState() {
    super.initState();
    // Cargar datos de la cartera al inicializar el estado
    cargarDatosCartera();
  }

  // Método para cargar los datos de la cartera
  void cargarDatosCartera() async {
    try {
      // Obtener datos de la cartera y calcular el beneficio
      final datosCartera = await obtenerCartera(widget.userEmail);
      final beneficioCalculado = await calcularBeneficio(widget.userEmail);
      // Actualizar el estado con los datos obtenidos
      setState(() {
        balance = datosCartera['saldo'];
        beneficio = beneficioCalculado;
        totalDepositado = datosCartera['total_depositado'];
        totalRetirado = datosCartera['total_retirado'];
        totalTransacciones = datosCartera['total_transacciones'];
      });
    } catch (e) {
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
        title: Text('Cartera'), // Título de la página
        leading: IconButton( // Botón de menú en la barra de navegación
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle(); // Activar/desactivar el menú lateral
          },
        ),
      ),
      body: SingleChildScrollView( // Cuerpo de la página, desplazable verticalmente
        child: Column( // Columna que contiene los widgets secundarios
          children: [
            // Tarjeta de perfil que muestra información del usuario y la cartera
            DatosPerfilCard(
              userEmail: widget.userEmail,
              balance: balance,
              beneficio: beneficio,
              totalDepositado: totalDepositado,
              totalRetirado: totalRetirado,
              totalTransacciones: totalTransacciones,
              onReload: cargarDatosCartera, // Función de recarga de datos
            ),
            // Widget de historial de balance
            HistorialWidget(userEmail: widget.userEmail),
            // Widget de lista de transacciones
            ListaTransaccionWidget(userEmail: widget.userEmail),
          ],
        ),
      ),
    );
  }
}
