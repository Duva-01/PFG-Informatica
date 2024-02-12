import 'package:flutter/material.dart'; // Importar el paquete flutter material

class PaginaDetallesAprendizaje extends StatelessWidget { // Página de detalles de aprendizaje
  final String title; // Título del artículo
  final String description; // Descripción del artículo

  const PaginaDetallesAprendizaje({ // Constructor
    Key? key, // Llave opcional para identificar el widget
    required this.title, // Título requerido del artículo
    required this.description, // Descripción requerida del artículo
  }) : super(key: key); // Llamar al constructor de la clase base con la llave

  @override
  Widget build(BuildContext context) { // Construir la página
    return Scaffold( // Estructura básica de la página
      appBar: AppBar( // Barra de aplicación
        title: Text(title), // Título de la barra basado en el título del artículo
      ),
      body: Padding( // Widget para aplicar padding alrededor del contenido principal
        padding: const EdgeInsets.all(16.0), // Padding de 16 en todos los lados
        child: Column( // Columna de elementos
          crossAxisAlignment: CrossAxisAlignment.start, // Alinear los elementos al inicio horizontalmente
          children: [
            Text( // Widget de texto para mostrar el título del artículo
              title, // Título del artículo
              style: TextStyle( // Estilo del texto
                fontSize: 24, // Tamaño de la fuente
                fontWeight: FontWeight.bold, // Peso de la fuente
              ),
            ),
            SizedBox(height: 16), // Espacio vertical de 16
            Text( // Widget de texto para mostrar la descripción del artículo
              description, // Descripción del artículo
              style: TextStyle( // Estilo del texto
                fontSize: 18, // Tamaño de la fuente
              ),
            ),
          ],
        ),
      ),
    );
  }
}
