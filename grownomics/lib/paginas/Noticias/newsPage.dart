// Importaciones
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:grownomics/controladores/newsController.dart'; 
import 'package:grownomics/modelos/NewsArticle.dart'; 

class PaginaNoticias extends StatefulWidget {
  @override
  _PaginaNoticiasState createState() => _PaginaNoticiasState();
}

class _PaginaNoticiasState extends State<PaginaNoticias> {
  late Future<List<NewsArticle>>
      futurasNoticias; // Futuro para almacenar la lista de noticias
  List<NewsArticle> articulosFiltrados =
      []; // Lista de artículos de noticias filtrados
  List<String> tematicas = [
    // Lista de temas de noticias
    'Finanzas',
    'Economía',
    'Inversiones',
    'Bolsa de Valores',
    'Negocios',
    'Tecnología',
    'Criptomonedas'
  ];
  String tematicaSeleccionada = 'finanzas'; // Tema seleccionado por defecto

  @override
  void initState() {
    super.initState();
    futurasNoticias = NoticiasController.obtenerNoticias(
        tematicaSeleccionada); // Inicialización de la lista de noticias con el tema seleccionado
  }

  @override
  Widget build(BuildContext context) {
    final controlador =
        ZoomDrawer.of(context); // Controlador para el cajón de navegación
    return Scaffold(
      appBar: AppBar(
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          'Noticias Financieras',
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
            controlador
                ?.toggle(); // Alterna el estado del ZoomDrawer (abre/cierra)
          },
        ),
        backgroundColor: Theme.of(context)
            .primaryColor, // Color de fondo de la AppBar según el color primario del tema

        shadowColor: Colors.black,
        elevation: 4,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText:
                    'Buscar noticias', // Etiqueta para el campo de búsqueda
                prefixIcon: Icon(Icons.search), // Icono de búsqueda
                border:
                    OutlineInputBorder(), // Estilo del borde del campo de búsqueda
              ),
              onChanged: (value) {
                filtrarArticulos(
                    value); // Función para filtrar los artículos de noticias según la consulta
              },
            ),
          ),
          SizedBox(
            height: 40, // Altura de la lista horizontal de temas de noticias
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tematicas.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(tematicas[index]), // Texto del tema de noticias
                    selected: tematicaSeleccionada ==
                        tematicas[index]
                            .toLowerCase(), // Verifica si el tema está seleccionado
                    onSelected: (bool selected) {
                      setState(() {
                        tematicaSeleccionada = tematicas[index]
                            .toLowerCase(); // Actualiza el tema seleccionado
                        futurasNoticias = NoticiasController.obtenerNoticias(
                            tematicaSeleccionada); // Obtiene las noticias del nuevo tema seleccionado
                      });
                    },
                    backgroundColor:
                        tematicaSeleccionada == tematicas[index].toLowerCase()
                            ? Color(0xFF124E2E) // Color seleccionado
                            : Color(0xFF2F8B62), // Color no seleccionado
                    selectedColor:
                        Color(0xFF124E2E), // Color de fondo cuando seleccionado
                    labelStyle: TextStyle(
                      color: Colors.white, // Color del texto
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Noticias de $tematicaSeleccionada', // Título de la sección de noticias más populares
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          Divider(
            color: Colors.blueGrey[800],
            thickness: 2,
            height: 20,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(
            child: FutureBuilder<List<NewsArticle>>(
              future: futurasNoticias,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF2F8B62))); // Muestra un indicador de carga mientras se obtienen las noticias
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          "Error: ${snapshot.error}")); // Muestra un mensaje de error si ocurre un error al obtener las noticias
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(
                          "No hay noticias disponibles")); // Muestra un mensaje si no hay noticias disponibles
                } else {
                  List<NewsArticle> articulos =
                      snapshot.data!; // Lista de noticias obtenidas
                  return ListView.builder(
                    itemCount: articulosFiltrados.isNotEmpty
                        ? articulosFiltrados.length
                        : articulos.length,
                    itemBuilder: (context, index) {
                      NewsArticle articulo = articulosFiltrados.isNotEmpty
                          ? articulosFiltrados[index]
                          : articulos[
                              index]; // Obtiene el artículo de noticias actual
                      return FadeInUp(
                        child: GestureDetector(
                          child: Card(
                            margin: EdgeInsets.all(10),
                            elevation: 5,
                            child: Column(
                              children: [
                                Image.network(
                                  articulo.urlToImage,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: double.infinity,
                                ), // Imagen de la noticia
                                ListTile(
                                  title: Text(
                                      articulo.title), // Título de la noticia
                                  subtitle: Text(
                                    articulo
                                        .description, // Descripción de la noticia
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewArticulo(
                                  titulo: articulo.title,
                                  url: articulo
                                      .articleUrl, // URL del artículo de noticias
                                ),
                              ),
                            ); // Navegación a la vista web del artículo de noticias
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void filtrarArticulos(String consulta) async {
    List<NewsArticle> articulos =
        await futurasNoticias; // Lista de noticias obtenidas
    setState(() {
      if (consulta.isNotEmpty) {
        articulosFiltrados = articulos
            .where((articulo) =>
                articulo.title.toLowerCase().contains(consulta.toLowerCase()))
            .toList(); // Filtra los artículos de noticias según la consulta de búsqueda
      } else {
        articulosFiltrados = [];
      }
    });
  }
}

class WebViewArticulo extends StatelessWidget {
  final String url;
  final String titulo;

  WebViewArticulo({required this.url, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final controlador =
        ZoomDrawer.of(context); // Controlador para el cajón de navegación
    return Scaffold(
      appBar: AppBar(
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          titulo,
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
      ),
      body: WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
