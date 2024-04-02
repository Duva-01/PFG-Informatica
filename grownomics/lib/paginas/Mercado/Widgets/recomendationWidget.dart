import 'package:flutter/material.dart';
import 'package:grownomics/controladores/portfolioController.dart'; // Importa la API para obtener datos de la cartera
import 'package:grownomics/controladores/recomendationController.dart'; // Importa la API para obtener recomendaciones
import 'package:grownomics/modelos/RecomendacionEstrategia.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa un widget personalizado para el título

class WidgetRecomendacion extends StatefulWidget {
  final String simbolo; // Símbolo de trading
  final String correoElectronico; // Correo electrónico del usuario

  const WidgetRecomendacion({
    Key? key,
    required this.simbolo,
    required this.correoElectronico,
  }) : super(key: key);

  @override
  _WidgetRecomendacionState createState() => _WidgetRecomendacionState();
}

class _WidgetRecomendacionState extends State<WidgetRecomendacion> {
  Future<Map<String, dynamic>>?
      futuroRecomendacion; // Futuro de las recomendaciones
  List<RecomendacionEstrategia> estrategiasPrincipales =
      []; // Lista de estrategias principales
  late double balance = 0.0; // Saldo de la cartera del usuario
  int indiceSeleccionado = 0; // Índice seleccionado en la lista de estrategias
  bool _usuarioLogueado = false;

  @override
  void initState() {
    super.initState();
    // Carga las recomendaciones cuando se inicializa el estado del widget
    futuroRecomendacion =
        RecomendacionesController.obtenerRecomendacion(widget.simbolo, widget.correoElectronico)
            .then((value) {
      // Ordena las recomendaciones por el equity final
      var recomendaciones = value['recommendations'] as List;
      estrategiasPrincipales = recomendaciones
          .map((json) => RecomendacionEstrategia.fromJson(json))
          .toList(); // Mapea los datos a objetos RecomendacionEstrategia
      return value;
    }).catchError((error) {
      print("Error al cargar recomendaciones: $error");
    });
    _verificarUsuarioLogueado();
    cargarDatosCartera(); // Carga los datos de la cartera del usuario
  }

  // Método para verificar si el usuario está logueado
  void _verificarUsuarioLogueado() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuarioLogueado = prefs.getBool('isUserLoggedIn') ?? false;
    });
  }

  // Método para cargar los datos de la cartera
  void cargarDatosCartera() async {
    try {
      // Obtiene datos de la cartera y calcula el saldo
      final datosCartera = await CarteraController.obtenerCartera(widget.correoElectronico);

      setState(() {
        balance =
            datosCartera['saldo']; // Actualiza el saldo en el estado del widget
      });
    } catch (e) {
      // Maneja errores al cargar los datos de la cartera
      print("Error al cargar los datos de la cartera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futuroRecomendacion,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtienen las recomendaciones
          return Center(
              child: CircularProgressIndicator(color: Color(0xFF2F8B62)));
        } else if (snapshot.hasError) {
          // Maneja errores si la obtención de recomendaciones falla
          return Text('Error: ${snapshot.error}');
        } else {
          // Construye la interfaz de usuario cuando se obtienen las recomendaciones
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitulo(
                    'Top Estrategias para ${widget.simbolo}'), // Widget personalizado para el título
                DefaultTabController(
                  length: estrategiasPrincipales.length,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: TabBar(
                            isScrollable: true,
                            onTap: (index) {
                              setState(() {
                                indiceSeleccionado =
                                    index; // Actualiza el índice seleccionado
                              });
                            },
                            indicatorColor: Colors.black,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            tabs: estrategiasPrincipales
                                .map<Tab>(
                                  (estrategia) => Tab(
                                    text: estrategia
                                        .estrategia, // Nombre de la estrategia
                                  ),
                                )
                                .toList(),
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: TabBarView(
                          children: estrategiasPrincipales
                              .map<Widget>(
                                (estrategia) => construirTarjetaRecomendacion(
                                    estrategia), // Construye la tarjeta de recomendación para cada estrategia
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // Método para construir la tarjeta de recomendación
  Widget construirTarjetaRecomendacion(RecomendacionEstrategia recomendacion) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recomendacion.estrategia,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.blueGrey[800],
                thickness: 2,
                height: 20,
                indent: 16,
                endIndent: 16,
              ),
              SizedBox(height: 8),
              Text(
                '¿En qué consiste?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                recomendacion.descripcion,
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 8),
              if (recomendacion.equityFinal != null)
                _usuarioLogueado
                    ? Text(
                        'Balance actual: ${balance.toStringAsFixed(2)}€',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        'Balance actual: 10.000€',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
              Text(
                'Equity Final: ${recomendacion.equityFinal.toStringAsFixed(2)}€',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              if (recomendacion.retorno != null)
                Text(
                  'Retorno: ${recomendacion.retorno.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 10),
              Text(
                recomendacion.recomendacion,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
