import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Aprendizaje/learnDetailsPage.dart';

class PaginaAprendizaje extends StatefulWidget {
  @override
  _PaginaAprendizajeState createState() => _PaginaAprendizajeState();
}

class _PaginaAprendizajeState extends State<PaginaAprendizaje> {
  final List<String> tematicas = [
    'Introducción a las Finanzas',
    'Inversiones',
    'Economía',
    'Criptomonedas',
    'Análisis de Mercado',
    'Planificación Financiera',
  ];
  String? tematicaSeleccionada;

  @override
  void initState() {
    super.initState();
    tematicaSeleccionada = tematicas.first;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ZoomDrawer.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Aprendizaje de Finanzas'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle();
          },
        ),
      ),
      body: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    // Menú lateral con las opciones de temáticas
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tematicas.map((tematica) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  tematicaSeleccionada = tematica;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  return tematicaSeleccionada == tematica ? Color(0xFF124E2E) : Color(0xFF2F8B62)!;
                }),
              ),
              child: Text(tematica),
            ),
          );
        }).toList(),
      ),
    ),
    // Contenedor de artículos
    Expanded(
      child: ListView(
        children: tematicaSeleccionada != null ? _buildArticulosList() : [],
      ),
    ),
  ],
),

    );
  }

  List<Widget> _buildArticulosList() {
    // Aquí deberías tener una forma de obtener los artículos basados en la temática seleccionada
    // Por ahora, solo devolveremos widgets de ejemplo
    return List<Widget>.generate(10, (index) {
      return Card(
        child: ListTile(
          title: Text('Artículo $index sobre $tematicaSeleccionada'),
          subtitle: Text(
              'Descripción del artículo $index sobre $tematicaSeleccionada'),
          onTap: () {
            // Navegar a la página de detalle del artículo
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaginaDetallesAprendizaje(
                    title: "Artículo $index",
                    description:
                        "Detalles del artículo $index sobre $tematicaSeleccionada"),
              ),
            );
          },
        ),
      );
    });
  }
}
