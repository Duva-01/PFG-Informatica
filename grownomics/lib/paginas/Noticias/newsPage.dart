import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:grownomics/api/newsAPI.dart';
import 'package:grownomics/modelos/newsArticle.dart';

class PaginaNoticias extends StatefulWidget {
  @override
  _PaginaNoticiasState createState() => _PaginaNoticiasState();
}

class _PaginaNoticiasState extends State<PaginaNoticias> {
  late Future<List<NewsArticle>> futureNewsArticles;
  List<NewsArticle> filteredArticles = [];
  List<String> tematicas = [
    'Finanzas',
    'Economía',
    'Inversiones',
    'Bolsa de Valores',
    'Negocios',
    'Tecnología',
    'Criptomonedas'
  ];
  String tematicaSeleccionada = 'finanzas';

  @override
  void initState() {
    super.initState();
    futureNewsArticles = obtenerNoticias(tematicaSeleccionada);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ZoomDrawer.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias Financieras'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar noticias',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                filterArticles(value);
              },
            ),
          ),
          SizedBox(
  height: 40, // Altura de la lista horizontal
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: tematicas.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ChoiceChip(
          label: Text(tematicas[index]),
          selected: tematicaSeleccionada == tematicas[index].toLowerCase(),
          onSelected: (bool selected) {
            setState(() {
              tematicaSeleccionada = tematicas[index].toLowerCase();
              futureNewsArticles = obtenerNoticias(tematicaSeleccionada);
            });
          },
          backgroundColor: tematicaSeleccionada == tematicas[index].toLowerCase()
              ? Color(0xFF124E2E) // Color seleccionado
              : Color(0xFF2F8B62), // Color no seleccionado
          selectedColor: Color(0xFF124E2E), // Color de fondo cuando seleccionado
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
            'Mas Populares',
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
              future: futureNewsArticles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No hay noticias disponibles"));
                } else {
                  List<NewsArticle> articles = snapshot.data!;
                  return ListView.builder(
                    itemCount: filteredArticles.isNotEmpty
                        ? filteredArticles.length
                        : articles.length,
                    itemBuilder: (context, index) {
                      NewsArticle article = filteredArticles.isNotEmpty
                          ? filteredArticles[index]
                          : articles[index];
                      return GestureDetector(
                        child: Card(
                          margin: EdgeInsets.all(10),
                          elevation: 5,
                          child: Column(
                            children: [
                              Image.network(
                                article.urlToImage,
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                              ListTile(
                                title: Text(article.title),
                                subtitle: Text(
                                  article.description,
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
                              builder: (context) => ArticleWebView(
                                title: article.title,
                                url: article.articleUrl,
                              ),
                            ),
                          );
                        },
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

  void filterArticles(String query) async {
  List<NewsArticle> articles = await futureNewsArticles;
  setState(() {
    if (query.isNotEmpty) {
      filteredArticles = articles
          .where((article) =>
              article.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredArticles = [];
    }
  });
}

}

class ArticleWebView extends StatelessWidget {
  final String url;
  final String title;

  ArticleWebView({required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = ZoomDrawer.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
