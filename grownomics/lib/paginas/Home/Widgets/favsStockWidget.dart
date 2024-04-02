import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:grownomics/controladores/userController.dart';
import 'package:grownomics/controladores/marketController.dart';
import 'package:grownomics/modelos/AccionFavorita.dart';
import 'package:grownomics/paginas/Analisis/analisisAccionPage.dart';

class AccionesFavoritasWidget extends StatefulWidget {
  final String userEmail;

  const AccionesFavoritasWidget({required this.userEmail});

  @override
  _AccionesFavoritasWidgetState createState() =>
      _AccionesFavoritasWidgetState();
}

class _AccionesFavoritasWidgetState extends State<AccionesFavoritasWidget> {
  List<AccionFavorita> accionesFavoritas = [];

  @override
  void initState() {
    super.initState();
    _cargarFavoritas();
  }

  Future<void> _cargarFavoritas() async {
    try {
      var datos = await UsuarioController.obtenerDatosUsuario(widget.userEmail);
      int idUsuario = datos['id'];

      var favoritasJson = await MercadoController.obtenerAccionesFavoritas(idUsuario);
      if (mounted) {
        setState(() {
          accionesFavoritas = favoritasJson
              .map<AccionFavorita>((json) => AccionFavorita.fromJson(json))
              .toList();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          color: Color.fromARGB(255, 19, 60, 42),
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Acciones Favoritas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.star, color: Colors.yellow, size: 30)
                ],
              ),
              Divider(color: Colors.grey, thickness: 2.0),
              if (accionesFavoritas.isEmpty)
                Text('No tienes acciones favoritas.',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(
                height: 200, // Definir una altura fija para el ListView.builder
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: accionesFavoritas.length,
                  itemBuilder: (context, index) =>
                      _buildAccionTile(accionesFavoritas[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccionTile(AccionFavorita accion) {
    return Column(
      children: [
        ListTile(
          // Widget ListTile para mostrar cada acción en la lista
          onTap: () {}, // Función que se ejecuta al hacer clic en la acción

          title: Text(
            // Widget Text para mostrar el nombre de la acción
            '${accion.nombre ?? 'Desconocido'}', // Obtiene el nombre de la acción o muestra 'Desconocido'
            style: TextStyle(
              // Estilo de texto para el nombre de la acción
              color: Colors.white, // Color del texto
              fontWeight:
                  FontWeight.bold, // Establece el peso del texto como negrita
            ),
          ),
          subtitle: Column(
            // Widget Column para alinear los subtítulos en una columna vertical
            crossAxisAlignment: CrossAxisAlignment
                .start, // Alinea los subtítulos a la izquierda
            children: [
              // Lista de widgets hijos dentro del Column
              Text(
                // Widget Text para mostrar el precio actual de la acción
                '${accion.precioActual.toStringAsFixed(2)}€', // Obtiene el precio actual de la acción o muestra 'Desconocido', // Obtiene el precio actual de la acción o muestra 'Desconocido'
                style: TextStyle(
                    // Estilo de texto para el precio actual de la acción
                    fontWeight: FontWeight
                        .bold, // Establece el peso del texto como negrita
                    color: Colors.grey[400]),
              ),
              Text(
                // Widget Text para mostrar el cambio de la acción
                'Cambio: ${accion.cambio.toStringAsFixed(2)} ' // Obtiene el cambio de la acción o muestra 'Desconocido'
                '(${accion.porcentajeCambio.toStringAsFixed(2)}%)', // Obtiene el cambio porcentual de la acción o muestra 'Desconocido'
                style: TextStyle(
                  // Estilo de texto para el cambio de la acción
                  color: accion.cambio >= 0
                      ? Colors.green
                      : Colors
                          .red, // Establece el color del texto según el cambio positivo o negativo
                  fontWeight: FontWeight
                      .bold, // Establece el peso del texto como negrita
                ),
              ),
            ],
          ),
          trailing: Row(
            // Widget Row para alinear los elementos secundarios (derecha) de la lista
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Alinea los elementos secundarios de manera uniforme en el espacio disponible
            mainAxisSize:
                MainAxisSize.min, // Establece el tamaño principal como mínimo
            children: [
              // Lista de widgets hijos dentro del Row

              ElevatedButton(
                // Botón elevado para ver detalles de la acción
                onPressed: () {
                  // Función que se ejecuta al presionar el botón
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnalisisAccionPage(
                        simboloAccion: accion.simboloTicker,
                        correoElectronico: widget.userEmail,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors
                      .white), // Color del texto según el color primario del tema
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                ),
                child: Text(
                  // Widget Text para mostrar el texto del botón
                  'Ver', // Texto del botón para ver detalles de la acción
                  style: TextStyle(
                    // Estilo de texto para el texto del botón
                    color: Colors.white, // Color del texto
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
