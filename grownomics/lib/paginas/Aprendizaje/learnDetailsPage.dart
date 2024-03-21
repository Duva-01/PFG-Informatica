import 'package:flutter/material.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

class PaginaDetallesAprendizaje extends StatelessWidget {
  final String title; // Título del artículo
  final String markdownContent; // Contenido del artículo en Markdown

  const PaginaDetallesAprendizaje({
    Key? key,
    required this.title,
    required this.markdownContent,
  }) : super(key: key);

  String ajustarMarkdown(String texto) {
  String textoAjustado = texto.replaceAll(r'\n', '\n');
  return textoAjustado;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Colors.black,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: MarkdownViewer(
            ajustarMarkdown(markdownContent),
            enableTaskList: true, // Habilita o deshabilita las características según tus necesidades
          ),
        ),
      ),
    );
  }
}
