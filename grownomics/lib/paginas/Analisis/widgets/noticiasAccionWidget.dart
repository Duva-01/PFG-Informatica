import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/api/marketAPI.dart';
import 'package:grownomics/api/newsAPI.dart'; 
import 'package:grownomics/modelos/NewsArticle.dart';
import 'package:grownomics/paginas/Noticias/newsPage.dart';
import 'package:grownomics/widgets/tituloWidget.dart';

class NoticiasAccionWidget extends StatefulWidget {
  final String simboloAccion;
  final String correoElectronico;

  const NoticiasAccionWidget({
    Key? key,
    required this.simboloAccion,
    required this.correoElectronico,
  }) : super(key: key);

  @override
  _NoticiasAccionWidgetState createState() => _NoticiasAccionWidgetState();
}

class _NoticiasAccionWidgetState extends State<NoticiasAccionWidget> {
  // Inicializa futurasNoticias con un Future vacío que devuelve una lista vacía
  Future<List<NewsArticle>> futurasNoticias = Future.value([]);

  bool _isLoading = true;
  Map<String, dynamic> resumen = {};

  @override
  void initState() {
    super.initState();
    _cargarTodo();
  }

  void _cargarTodo() async {
    await Future.wait([
      _cargarResumenAccion(),
    ]);
    await _cargarNoticiasAccion(); // Asegura que futurasNoticias se inicialice después de cargar el resumen
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _cargarResumenAccion() async {
    try {
      resumen = await obtenerDatosAccion(widget.simboloAccion);
    } catch (e) {
      print("Error al cargar el resumen de la acción: $e");
    }
  }

  Future<void> _cargarNoticiasAccion() async {
    try {
      // Suponiendo que obtenerNoticiasDeAcciones es una función asíncrona que devuelve un Future
      // Se debe asegurar que resumen contenga la clave "nombre" con el valor correcto
      futurasNoticias = obtenerNoticiasDeAcciones(widget.simboloAccion, "es");
    } catch (e) {
      print("Error al cargar noticias de la acción: $e");
      // Si hay un error, futurasNoticias puede devolver una lista vacía para evitar errores de ejecución
      futurasNoticias = Future.value([]);
    }
  }

  @override
Widget build(BuildContext context) {
  return _isLoading
      ? Center(child: CircularProgressIndicator())
      : Column(
          children: [
            buildTitulo("Noticias para ${widget.simboloAccion}"),
            Expanded( // Agregar Expanded aquí
              child: SingleChildScrollView(
                child: FutureBuilder<List<NewsArticle>>(
                  future: futurasNoticias,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF2F8B62)));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              "Error al cargar las noticias: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No hay noticias disponibles"));
                    } else {
                      List<NewsArticle> articulos = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap:
                            true, // Importante para evitar errores de renderizado en Columnas o ListViews anidadas
                        physics:
                            NeverScrollableScrollPhysics(), // Evita el scroll dentro de este ListView
                        itemCount: articulos.length,
                        itemBuilder: (context, index) {
                          NewsArticle articulo = articulos[index];
                          return FadeInUp(
                            child: GestureDetector(
                              child: Card(
                                margin: EdgeInsets.all(10),
                                elevation: 5,
                                child: Column(
                                  children: [
                                    articulo.urlToImage != null
                                        ? Image.network(
                                            articulo.urlToImage!,
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: double.infinity,
                                          )
                                        : SizedBox(
                                            height:
                                                200), // Muestra una imagen o un espacio si no hay imagen
                                    ListTile(
                                      title: Text(articulo.title),
                                      subtitle: Text(
                                        articulo.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                // Navegación a la vista web del artículo de noticias
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewArticulo(
                                      titulo: articulo.title,
                                      url: articulo.articleUrl,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
}
}
