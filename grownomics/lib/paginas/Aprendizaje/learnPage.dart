import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/controladores/articlesController.dart'; // Importa el API para obtener los artículos
import 'package:grownomics/modelos/Articulo.dart'; // Importa el modelo de datos del artículo
import 'package:grownomics/paginas/Aprendizaje/Widgets/tutorialPage.dart'; // Importa la página de tutorial
import 'package:grownomics/paginas/Aprendizaje/learnDetailsPage.dart'; // Importa la página de detalles del artículo

class PaginaAprendizaje extends StatefulWidget {
  @override
  _PaginaAprendizajeState createState() =>
      _PaginaAprendizajeState(); // Crea el estado de la página de aprendizaje
}

class _PaginaAprendizajeState extends State<PaginaAprendizaje> {
  final List<String> tematicas = [
    'Manual de Uso',
    'Introducción a las Finanzas',
    'Inversiones',
    'Economía'
  ]; // Lista de temáticas
  Map<String, List<Articulo>> articulosPorSeccion =
      {}; // Mapa de artículos por sección

  @override
  void initState() {
    super.initState();
    cargarArticulos(); // Carga los artículos al inicializar la página
  }

  void cargarArticulos() async {
    List<Articulo> articulosObtenidos = 
        await ArticuloController.obtenerArticulos(); // Obtiene los artículos del API

    // Agrupa los artículos por sección
    for (var articulo in articulosObtenidos) {
      articulosPorSeccion.update(
          articulo.seccion, (list) => list..add(articulo),
          ifAbsent: () => [articulo]);
    }

    setState(() {});
  }

  String mapearTematicaASeccion(String? tematica) {
    // Mapea la temática a la sección correspondiente
    switch (tematica) {
      case 'Introducción a las Finanzas':
        return 'IntroFinanzas';
      case 'Inversiones':
        return 'Inversion';
      case 'Economía':
        return 'Economia';
      default:
        return 'IntroFinanzas';
    }
  }

  // Construye el widget de la tarjeta de artículo
  Widget _buildArticleCard(Articulo articulo) {
    return InkWell(
      onTap: () {
        // Navega a la página de detalles del artículo al hacer clic en la tarjeta
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaginaDetallesAprendizaje(
              title: articulo.titulo,
              markdownContent: articulo.contenido,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(articulo.imageUrl,
                  fit: BoxFit.cover), // Imagen del artículo
              SizedBox(height: 8),
              Text(
                articulo.titulo, // Título del artículo
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                articulo.resumen, // Resumen del artículo
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        ZoomDrawer.of(context); // Controlador para manejar el ZoomDrawer

    return DefaultTabController(
      length: tematicas.length, // Número de pestañas en el TabBar
      child: Scaffold(
        appBar: AppBar(
          // Barra de aplicaciones en la parte superior de la página
          title: Text(
            'Aprendizaje',
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
          shadowColor: Colors.black, // Color de la sombra
          backgroundColor: Theme.of(context)
              .primaryColor, // Color de fondo de la AppBar según el color primario del tema
          bottom: TabBar(
            // Añade el TabBar al fondo de la AppBar
            isScrollable: true, // Permite que los tabs sean desplazables
            tabs: tematicas
                .map((tematica) => Tab(text: tematica))
                .toList(), // Genera las pestañas a partir de la lista de temáticas
            indicatorColor: Colors.white, // Color del indicador
            labelColor: Colors.white, // Color del texto del tab seleccionado
            unselectedLabelColor:
                Colors.green[200], // Color del texto del tab no seleccionado
          ),
        ),
        body: TabBarView(
          // Contenido de las pestañas

          children: tematicas.map((tematica) {
            if (tematica == 'Manual de Uso') {
              return PaginaTutorial(); // Devuelve la página de tutorial si la temática es "Manual de Uso"
            } else {
              List<Articulo>? articulosDeSeccion = articulosPorSeccion[
                  mapearTematicaASeccion(
                      tematica)]; // Obtiene los artículos de la sección correspondiente
              return articulosDeSeccion != null
                  ? ListView(
                      // Devuelve una ListView con los artículos si existen
                      children: articulosDeSeccion
                          .map((articulo) => _buildArticleCard(articulo))
                          .toList(),
                    )
                  : Center(
                      child: Text(
                          'No hay artículos disponibles')); // Muestra un mensaje si no hay artículos disponibles
            }
          }).toList(),
        ),
      ),
    );
  }
}
