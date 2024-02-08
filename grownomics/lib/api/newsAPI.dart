import 'dart:convert';
import 'package:grownomics/modelos/newsArticle.dart';
import 'package:http/http.dart' as http;

Future<List<NewsArticle>> obtenerNoticias() async {

    final Uri url = Uri.parse('http://10.0.2.2:5000/news/financial_news');
    final response = await http.get(url, headers: {
  'Connection': 'keep-alive',
}).timeout(Duration(seconds: 30)); 


    if (response.statusCode == 200) {
      List<dynamic> newsJson = json.decode(response.body);
      return newsJson.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las noticias financieras');
    }
  }