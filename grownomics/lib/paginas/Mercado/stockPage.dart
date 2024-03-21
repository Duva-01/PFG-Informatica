import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart'; // Importa las funciones relacionadas con el mercado
import 'package:grownomics/api/portfolioAPI.dart'; // Importa las funciones relacionadas con el portafolio
import 'package:grownomics/paginas/Mercado/Widgets/chartWidget.dart'; // Importa el widget de gráfica
import 'package:grownomics/paginas/Mercado/Widgets/dataTableWidget.dart'; // Importa el widget de tabla de datos
import 'package:grownomics/paginas/Mercado/Widgets/infoWidget.dart'; // Importa el widget de información
import 'package:grownomics/paginas/Mercado/Widgets/recomendationWidget.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../modelos/HistoricalData.dart'; // Importa el modelo de datos históricos

class DetallesAccion extends StatefulWidget {
  final String symbol; // Símbolo de la acción
  final String correoElectronico; // Correo electrónico del usuario

  DetallesAccion({required this.symbol, required this.correoElectronico});

  @override
  _DetallesAccionEstado createState() => _DetallesAccionEstado();
}

// Enumeración para representar los diferentes modos de visualización
enum ModoVisualizacion {
  Grafica,
  TablaDatos,
}

class _DetallesAccionEstado extends State<DetallesAccion> {
  String _intervalo =
      '1wk'; // Intervalo de tiempo para cargar los datos históricos
  List<HistoricalData> _datosHistoricos = []; // Lista de datos históricos
  ModoVisualizacion _modoVisualizacion =
      ModoVisualizacion.Grafica; // Modo de visualización inicial

  bool _usuarioLogueado = false;

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogueado();
    _cargarDatos();
  }

  // Método para verificar si el usuario está logueado
  void _verificarUsuarioLogueado() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuarioLogueado = prefs.getBool('isUserLoggedIn') ?? false;
    });
  }

  // Método para cargar los datos históricos desde la API
  void _cargarDatos() async {
    final datos = await obtenerDatosHistoricos(widget.symbol,
        _intervalo); // Obtiene los datos históricos para el símbolo y el intervalo especificados
    setState(() {
      _datosHistoricos = datos; // Actualiza los datos históricos en el estado
    });
  }

  // Método para alternar entre la visualización de gráfica y la visualización de tabla de datos
  void _alternarModoVisualizacion() {
    setState(() {
      _modoVisualizacion = _modoVisualizacion == ModoVisualizacion.Grafica
          ? ModoVisualizacion.TablaDatos
          : ModoVisualizacion.Grafica;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determina el icono a mostrar en función del modo de visualización actual
    IconData icono = _modoVisualizacion == ModoVisualizacion.Grafica
        ? Icons.table_view // Icono para cuando se muestra la gráfica
        : Icons.show_chart; // Icono para cuando se muestra la tabla

    return Scaffold(
      appBar: AppBar(
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          widget.symbol,
          style: TextStyle(
            color: Colors.white, // Color del texto blanco
          ),
        ), // Título de la aplicación
        centerTitle: true, // Centra el título en la barra de aplicaciones
        backgroundColor: Theme.of(context)
            .primaryColor, // Color de fondo de la AppBar según el color primario del tema
        shadowColor: Colors.black,
        elevation: 4,
        leading: IconButton(
          // Widget de icono para el botón de retroceso
          icon: Icon(Icons.arrow_back,
              color: Colors.white), // Icono de flecha hacia atrás
          onPressed: () {
            // Manejador de eventos cuando se presiona el botón de retroceso
            Navigator.of(context).pop(); // Volver atrás en la navegación
          },
        ),
        actions: [
          IconButton(
            icon: Icon(icono, color: Colors.white),
            onPressed: _alternarModoVisualizacion,
          ),
        ],
      ),
      body: _datosHistoricos == null || _datosHistoricos.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Muestra un indicador de carga si no hay datos históricos disponibles
          : SingleChildScrollView(
              child: _modoVisualizacion == ModoVisualizacion.Grafica
                  ? Column(
                      children: [
                        WidgetGrafico(
                            symbol: widget
                                .symbol), // Muestra la gráfica para el símbolo de la acción
                        WidgetInfo(
                            symbol: widget
                                .symbol), // Muestra la información relacionada con la acción
                        WidgetRecomendacion(
                            simbolo: widget.symbol,
                            correoElectronico: widget.correoElectronico),

                        if (_usuarioLogueado) ...[
                          buildTitulo('Acciones sobre ${widget.symbol}'),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    _mostrarDialogoTransaccion(true),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                    TextStyle(
                                        fontSize:
                                            20), // Tamaño de fuente más grande
                                  ),
                                ),
                                child: Text(
                                    "Comprar"), // Botón para comprar acciones
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    _mostrarDialogoTransaccion(false),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                    TextStyle(
                                        fontSize:
                                            20), // Tamaño de fuente más grande
                                  ),
                                ),
                                child: Text(
                                    "Vender"), // Botón para vender acciones
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ],
                    )
                  : WidgetTablaDatos(
                      simboloAccion: widget
                          .symbol), // Muestra la tabla de datos para el símbolo de la acción
            ),
    );
  }

  // Método para mostrar un diálogo de transacción (compra o venta de acciones)
  void _mostrarDialogoTransaccion(bool esCompra) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int cantidad = 0; // Cantidad de acciones a comprar o vender
        // Obtiene el último precio de cierre de la lista de datos históricos
        double precio =
            _datosHistoricos.isNotEmpty ? _datosHistoricos.last.close : 0.0;

        return AlertDialog(
          title: Text(esCompra ? "Comprar Acción" : "Vender Acción"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "Precio: \$${precio.toStringAsFixed(2)}"), // Muestra el precio actual de la acción
              TextField(
                decoration: InputDecoration(hintText: "Cantidad"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  cantidad = int.tryParse(value) ??
                      0; // Actualiza la cantidad ingresada
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text(esCompra ? "Comprar" : "Vender"),
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo primero
                if (esCompra) {
                  // Realiza la compra de acciones
                  bool resultado = await comprarAccion(widget.correoElectronico,
                      widget.symbol, precio, cantidad);
                  if (resultado) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Compra realizada con éxito"))); // Muestra un mensaje de éxito
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Error al realizar la compra"))); // Muestra un mensaje de error
                  }
                } else {
                  // Realiza la venta de acciones
                  bool resultado = await venderAccion(widget.correoElectronico,
                      widget.symbol, precio, cantidad);
                  if (resultado) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Venta realizada con éxito"))); // Muestra un mensaje de éxito
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Error al realizar la venta"))); // Muestra un mensaje de error
                  }
                }
                // Considera llamar a cargarDatosCartera() u otra función para actualizar los datos mostrados en el portafolio del usuario
              },
            ),
          ],
        );
      },
    );
  }
}
