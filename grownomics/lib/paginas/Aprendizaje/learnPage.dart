import 'package:flutter/material.dart'; // Importar el paquete flutter material
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart'; // Importar paquete para cajón de navegación
import 'package:grownomics/paginas/Aprendizaje/learnDetailsPage.dart'; // Importar página de detalles de aprendizaje

class PaginaAprendizaje extends StatefulWidget { // Página principal de aprendizaje
  @override
  _PaginaAprendizajeState createState() => _PaginaAprendizajeState(); // Crear estado de la página
}

class _PaginaAprendizajeState extends State<PaginaAprendizaje> { // Estado de la página
  final List<String> tematicas = [ // Lista de temáticas disponibles
    'Introducción a las Finanzas',
    'Inversiones',
    'Economía',
    'Criptomonedas',
    'Análisis de Mercado',
    'Planificación Financiera',
  ];
  String? tematicaSeleccionada; // Temática seleccionada

  @override
  void initState() { // Inicialización del estado
    super.initState(); // Llamar al método initState de la clase base
    tematicaSeleccionada = tematicas.first; // Asignar la primera temática por defecto
  }

  @override
  Widget build(BuildContext context) { // Construir la página
    final controller = ZoomDrawer.of(context); // Obtener el controlador del cajón de navegación

    return Scaffold( // Estructura básica de la página
      appBar: AppBar( // Barra de aplicación
        title: Text('Aprendizaje de Finanzas'), // Título de la barra
        leading: IconButton( // Botón de menú lateral
          icon: Icon(Icons.menu), // Icono del botón
          onPressed: () { // Acción al presionar el botón
            controller?.toggle(); // Alternar el cajón de navegación
          },
        ),
      ),
      body: Column( // Columna principal
        crossAxisAlignment: CrossAxisAlignment.stretch, // Alinear elementos al inicio horizontalmente
        children: [
          SingleChildScrollView( // Widget para permitir el desplazamiento horizontal
            scrollDirection: Axis.horizontal, // Dirección de desplazamiento horizontal
            child: Row( // Fila de elementos
              children: tematicas.map((tematica) { // Mapear cada temática a un widget de botón
                return Padding( // Widget para aplicar padding alrededor del botón
                  padding: EdgeInsets.symmetric(horizontal: 8.0), // Padding horizontal
                  child: ElevatedButton( // Botón elevado para cada temática
                    onPressed: () { // Acción al presionar el botón
                      setState(() { // Actualizar el estado para reflejar la temática seleccionada
                        tematicaSeleccionada = tematica; // Asignar la temática seleccionada
                      });
                    },
                    style: ButtonStyle( // Estilo del botón
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) { // Resolver el color del botón basado en el estado
                        return tematicaSeleccionada == tematica ? Color(0xFF124E2E) : Color(0xFF2F8B62)!; // Color del botón dependiendo de si está seleccionado o no
                      }),
                    ),
                    child: Text(tematica), // Texto del botón
                  ),
                );
              }).toList(), // Convertir el resultado del mapeo a una lista
            ),
          ),
          Expanded( // Widget expandido para llenar el espacio restante
            child: ListView( // Lista de elementos
              children: tematicaSeleccionada != null ? _buildArticulosList() : [], // Construir la lista de artículos basados en la temática seleccionada
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildArticulosList() { // Método para construir la lista de artículos
    
    return List<Widget>.generate(10, (index) { // Generar una lista de 10 widgets
      return Card( // Widget de tarjeta para cada artículo
        child: ListTile( // Widget de elemento de lista para mostrar información del artículo
          title: Text('Artículo $index sobre $tematicaSeleccionada'), // Título del artículo
          subtitle: Text( // Subtítulo del artículo
              'Descripción del artículo $index sobre $tematicaSeleccionada'), // Descripción del artículo
          onTap: () { // Acción al presionar el elemento de lista (navegar a la página de detalles del artículo)
            // Navegar a la página de detalle del artículo
            Navigator.push( // Método para navegar a una nueva ruta
              context,
              MaterialPageRoute( // Constructor de ruta para la navegación
                builder: (context) => PaginaDetallesAprendizaje( // Constructor de la página de detalles del artículo
                    title: "Artículo $index", // Título del artículo
                    description:
                        "Detalles del artículo $index sobre $tematicaSeleccionada"), // Descripción del artículo
              ),
            );
          },
        ),
      );
    });
  }
}
