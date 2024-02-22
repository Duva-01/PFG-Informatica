import 'package:flutter/material.dart';
import 'package:grownomics/api/portfolioAPI.dart'; // Importa la API para obtener datos de la cartera
import 'package:grownomics/api/recomendationAPI.dart'; // Importa la API para obtener recomendaciones
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
  Future<Map<String, dynamic>>? futuroRecomendacion; // Futuro de las recomendaciones
  Map<String, dynamic>? indicadoresEconomicos; // Indicadores económicos
  int indiceSeleccionado = 0; // Índice seleccionado en la lista de estrategias
  List<dynamic> estrategiasPrincipales = []; // Lista de estrategias principales
  late double balance = 0.0; // Saldo de la cartera del usuario

  bool _usuarioLogueado = false;

  @override
  void initState() {
    super.initState();
    // Carga las recomendaciones cuando se inicializa el estado del widget
    futuroRecomendacion = obtenerRecomendacion(widget.simbolo, widget.correoElectronico).then((value) {
      // Ordena las recomendaciones por el equity final
      var recomendaciones = value['recommendations'] as List;
      recomendaciones.sort((a, b) => b['equity_final'].compareTo(a['equity_final']));
      estrategiasPrincipales = recomendaciones.toList(); // Guarda las estrategias ordenadas
      return value;
    }).catchError((error) {
      print("Error al cargar recomendaciones: $error");
    });
    _verificarUsuarioLogueado();
    cargarIndicadoresEconomicos(); // Carga los indicadores económicos
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
      final datosCartera = await obtenerCartera(widget.correoElectronico);
      
      setState(() {
        balance = datosCartera['saldo']; // Actualiza el saldo en el estado del widget
      });
    } catch (e) {
      // Maneja errores al cargar los datos de la cartera
      print("Error al cargar los datos de la cartera: $e");
    }
  }

  // Método para cargar los indicadores económicos
  void cargarIndicadoresEconomicos() async {
    try {
      final indicadores = await obtenerIndicadoresEconomicos(widget.simbolo);
      setState(() {
        indicadoresEconomicos = indicadores; // Actualiza los indicadores económicos en el estado del widget
      });
    } catch (e) {
      print("Error al cargar los indicadores económicos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futuroRecomendacion,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtienen las recomendaciones
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Maneja errores si la obtención de recomendaciones falla
          return Text('Error: ${snapshot.error}');
        } else {
          // Construye la interfaz de usuario cuando se obtienen las recomendaciones
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitulo("Indicadores Económicos"), // Widget personalizado para el título
                if (indicadoresEconomicos != null)
                  ..._construirSeccionIndicadoresEconomicos(), // Construye la sección de indicadores económicos
                buildTitulo('Top Estrategias para ${widget.simbolo}'), // Widget personalizado para el título
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
                                indiceSeleccionado = index; // Actualiza el índice seleccionado
                              });
                            },
                            indicatorColor: Colors.black,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            
                            tabs: estrategiasPrincipales.map<Tab>(
                              (estrategia) => Tab(
                                text: estrategia['estrategia'], // Nombre de la estrategia
                              ),
                            ).toList(),
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
                          children: estrategiasPrincipales.map<Widget>(
                            (estrategia) => construirTarjetaRecomendacion(estrategia), // Construye la tarjeta de recomendación para cada estrategia
                          ).toList(),
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
  Widget construirTarjetaRecomendacion(Map<String, dynamic> recomendacion) {
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
                recomendacion['estrategia'],
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
                recomendacion['descripcion'],
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 8),
              if (recomendacion.containsKey('equity_final'))
                _usuarioLogueado ? 
                Text(
                  'Balance actual: ${balance.toStringAsFixed(2)}€',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ) :
                Text(
                  'Balance actual: 10.000€',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              Text(
                'Equity Final: ${recomendacion['equity_final'].toStringAsFixed(2)}€',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              if (recomendacion.containsKey('retorno'))
                Text(
                  'Retorno: ${recomendacion['retorno'].toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 10),
              Text(
                recomendacion['recomendacion'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Lista de iconos para los indicadores económicos
  final List<IconData> _iconList = [
    Icons.trending_up,
    Icons.show_chart,
    Icons.trending_down,
    Icons.attach_money,
    Icons.euro_symbol,
    Icons.monetization_on,
    Icons.money,
    Icons.compare_arrows,
    Icons.swap_horiz,
    Icons.timeline,
    Icons.equalizer,
    Icons.insert_chart,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.business,
  ];

  // Lista de colores para los iconos de los indicadores económicos
  final List<Color> _iconColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
  ];

  // Método para construir la sección de indicadores económicos
  List<Widget> _construirSeccionIndicadoresEconomicos() {
    Map<String, dynamic> descripciones = indicadoresEconomicos?['descriptions'] ?? {};
    Map<String, dynamic> indicadores = indicadoresEconomicos?['indicators'] ?? {};

    List<Widget> lista = [];
    List<Widget> indicadoresSecundarios = [];

    List<MapEntry<String, dynamic>> entradas = indicadores.entries.toList().reversed.toList();

    entradas.asMap().forEach((indice, entrada) {
      String clave = entrada.key;
      dynamic valor = entrada.value;
      String descripcion = descripciones[clave] ?? 'No hay descripción disponible';
      IconData iconoDatos = _iconList[indice % _iconList.length];
      Color colorIcono = _iconColors[indice % _iconColors.length];

      if (clave == 'SMA' || clave == 'RSI' || clave == 'EMA') {
        // Indicadores principales
        lista.add(
          Card(
            color: Colors.grey.shade200,
            child: ListTile(
              leading: Icon(iconoDatos, color: colorIcono, size: 30),
              title: Text(clave),
              subtitle: Text('$clave: $valor'),
              trailing: Tooltip(
                message: descripcion,
                child: Icon(Icons.info, size: 30),
              ),
            ),
          ),
        );
      } else {
        // Indicadores secundarios
        indicadoresSecundarios.add(
          Card(
            color: Colors.grey.shade200,
            child: ListTile(
              leading: Icon(iconoDatos, color: colorIcono, size: 30),
              title: Text(clave),
              subtitle: Text('$clave: $valor'),
              trailing: Tooltip(
                message: descripcion,
                child: Icon(Icons.info, size: 30),
              ),
            ),
          ),
        );
      }
    });

    // Si hay indicadores secundarios, los mostramos dentro de un ExpansionTile
    if (indicadoresSecundarios.isNotEmpty) {
      lista.add(
        ExpansionTile(
          title: Text('Indicadores adicionales'),
          children: indicadoresSecundarios,
        ),
      );
    }

    return lista;
  }
}
