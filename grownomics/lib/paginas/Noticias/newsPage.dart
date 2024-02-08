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

  @override
  void initState() {
    super.initState();
    futureNewsArticles = obtenerNoticias();
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
      body: FutureBuilder<List<NewsArticle>>(
        future: futureNewsArticles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleWebView(title: article.title, url: article.articleUrl))),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 24, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0.0, 15),
                          blurRadius: 10.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            article.title,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            article.description,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            article.urlToImage,
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[700]!),
                                  ),
                                );
                              }
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Image.asset("assets/images/logo.png");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
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
