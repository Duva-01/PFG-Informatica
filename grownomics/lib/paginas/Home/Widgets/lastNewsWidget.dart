import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:grownomics/controladores/newsController.dart';
import 'package:grownomics/paginas/Noticias/newsPage.dart';
import 'package:grownomics/modelos/NewsArticle.dart';

// Widget de Tarjeta de Saldo que muestra información sobre el balance y transacciones del usuario
class UltimasNoticiasWidget extends StatefulWidget {
  final String userEmail; // Correo electrónico del usuario

  const UltimasNoticiasWidget({
    required this.userEmail, // Parámetro obligatorio: correo electrónico del usuario
  });

  @override
  _UltimasNoticiasWidgetState createState() =>
      _UltimasNoticiasWidgetState(); // Crea el estado de la tarjeta de saldo
}

class _UltimasNoticiasWidgetState extends State<UltimasNoticiasWidget> {
  late Future<List<NewsArticle>>
      futurasNoticias; // Futuro para almacenar la lista de noticias
  String tematicaSeleccionada = 'finanzas'; // Tema seleccionado por defecto

  @override
  void initState() {
    super.initState();
    futurasNoticias = NoticiasController.obtenerNoticias(
        tematicaSeleccionada); // Inicialización de la lista de noticias con el tema seleccionado
  }

  @override
  Widget build(BuildContext context) {
    return BounceInDown(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          // Define bordes redondeados en la parte inferior del widget
          bottomLeft: Radius.circular(65.0),
          bottomRight: Radius.circular(65.0),
        ),
        child: Container(
          //height: MediaQuery.of(context).size.height * 0.7,
          color: Color.fromARGB(255, 19, 60, 42),
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Últimas Noticias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.new_releases, color: Colors.white, size: 30)
                ],
              ),
              Divider(color: Colors.grey, thickness: 2.0),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: FutureBuilder<List<NewsArticle>>(
                  future: futurasNoticias,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Color(0xFF2F8B62),
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No hay noticias disponibles"));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          NewsArticle articulo = snapshot.data![index];
                          return _buildNewsTile(articulo);
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                // Padding alrededor del botón
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Padding horizontal
                child: Center(
                  // Centrar el botón
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 100.0)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaginaNoticias(),
                        ),
                      );
                    },
                    child: Text('Más noticias'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsTile(NewsArticle articulo) {
    // Tu implementación de cómo construir cada elemento de la lista
    return GestureDetector(
      child: Card(
        color: Color.fromARGB(255, 26, 86, 60),
        margin: EdgeInsets.all(10),
        elevation: 5,
        child: Column(
          children: [
            Image.network(
              articulo.urlToImage,
              fit: BoxFit.cover,
              height: 100,
              width: double.infinity,
            ), // Imagen de la noticia
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  articulo.title,
                  style: TextStyle(color: Colors.white),
                )), // Título de la noticia
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewArticulo(
              titulo: articulo.title,
              url: articulo.articleUrl, // URL del artículo de noticias
            ),
          ),
        ); // Navegación a la vista web del artículo de noticias
      },
    );
  }
}
