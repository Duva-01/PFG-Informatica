import 'package:flutter/material.dart';

class PaginaTutorial extends StatefulWidget {
  @override
  _PaginaTutorialState createState() => _PaginaTutorialState();
}

class _PaginaTutorialState extends State<PaginaTutorial> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezado del manual de uso
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Manual de uso: Grownomics',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              
            ),
          ),
          // Explicación inicial
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Bienvenido a Grownomics, la aplicación que te ayuda a gestionar tus inversiones de forma inteligente. A continuación, te guiamos paso a paso sobre cómo utilizar todas las funcionalidades que ofrece la aplicación.',
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          // Widget para representar el Inicio de Sesión y Registro
          _buildSection(
            title: '1.1. Inicio de Sesión y Registro',
            description:
                'Para comenzar a utilizar la aplicación, no necesitas iniciar sesión con tu cuenta existente o registrarte si eres un nuevo usuario. Ambas pantallas cuentan con formularios diseñados para facilitar el acceso a la aplicación y la recopilación de información sobre el nuevo usuario. Sin embargo, ten en cuenta que algunas funcionalidades avanzadas pueden estar limitadas si decides no iniciar sesión.',
            imagePaths: [
              'assets/images/login.png',
              'assets/images/register.png',
            ],
          ),
          _buildSection(
            title: '1.2. Recuperación de Contraseña',
            description:
                '¿Olvidaste tu contraseña? No te preocupes. En Grownomics, ofrecemos un proceso sencillo para recuperar tu contraseña perdida. Simplemente solicita cambiar tu contraseña y te enviaremos un código de verificación a tu correo electrónico. Una vez que verifiquemos que eres tú, podrás rellenar un formulario para cambiar tu contraseña y recuperar el acceso a tu cuenta. ¡Así de fácil!',
            imagePaths: [
              'assets/images/password.png',
            ],
          ),

          // Widget para representar la Página Principal (Home)
          _buildSection(
            title: '2. Página Principal (Home)',
            description:
                'La página principal muestra elementos importantes de manera intuitiva. Incluye una barra de navegación en la parte superior para acceder al menú principal, seguida de información relevante del perfil del usuario, como su nombre y saldo acumulado en sus simulaciones financieras. También presenta secciones para acciones marcadas como favoritas, acciones con revalorización significativa y noticias financieras.',
            imagePaths: [
              'assets/images/inicio.png',
              'assets/images/menu.png',
            ],
          ),
          // Widget para representar la Página de Acciones
          _buildSection(
            title: '3.1 Página de Acciones',
            description:
                'En esta página, puedes ver un listado de acciones organizadas por aquellas seleccionadas como favoritas por cada usuario. Junto a cada acción, se muestra un indicador porcentual para reflejar cómo ha variado el valor de cada acción. También puedes seleccionar o deseleccionar acciones como favoritas y acceder a información detallada sobre cada una.',
            imagePaths: [
              'assets/images/acciones.png',
            ],
          ),
          // Widget para representar la Página de Acción Específica
          _buildSection(
            title: '3.2. Página de Acción Específica',
            description:
                'Una vez dentro de la página de una acción específica, puedes ver información más precisa y completa, incluido un gráfico que muestra la evolución del valor de la acción. También recibes análisis de la acción, recomendaciones teóricas y botones para comprar o vender.',
            imagePaths: [
              'assets/images/detallesAccion1.png',
              'assets/images/detallesAccion2.png',
            ],
          ),

          // Widget para representar la Página de Cartera y Operaciones
          _buildSection(
            title: '4. Página de Cartera y Operaciones',
            description:
                'Accede a un resumen detallado de tu desempeño financiero virtual en la página de cartera y operaciones. Aquí podrás ver tu saldo actual, un historial de tus últimas operaciones y explorar en profundidad cada una de ellas. Asi como recargar o retirar tu saldo virtual para poder realizar todas las transacciones que desees y ver tu rendimiento.',
            imagePaths: [
              'assets/images/cartera.png',
            ],
          ),

          // Widget para representar la Página de mis acciones
          _buildSection(
            title: '5. Página de Mis Acciones',
            description:
                'En la Página de Mis Acciones, podrás obtener un análisis detallado de la diversificación de tu cartera, así como comprender por qué es importante diversificar para reducir tu riesgo financiero. Además, podrás ver el valor actual de tus acciones y revisar un listado completo de tus acciones, junto con las transacciones realizadas con cada una de ellas. ¡Mantente al tanto de tu rendimiento financiero y toma decisiones informadas para maximizar tus inversiones!',
            imagePaths: [
              'assets/images/misAcciones.png',
            ],
          ),

          // Widget para representar la Página de Noticias
          _buildSection(
            title: '6. Página de Noticias',
            description:
                'Mantente al día con las últimas novedades y eventos del ámbito financiero en la página de noticias. Aquí encontrarás noticias financieras actuales y relevantes seleccionadas cuidadosamente para su importancia y relevancia en el mercado.',
            imagePaths: [
              'assets/images/noticias.png',
            ],
          ),
          // Widget para representar la Página de Aprendizaje
          _buildSection(
            title: '7. Página de Aprendizaje',
            description:
                'En la página de aprendizaje, encontrarás lecciones enfocadas en distintos aspectos del mundo financiero y video tutoriales detallados para guiarte a través de las diversas funcionalidades de la aplicación.',
            imagePaths: [
              'assets/images/aprendizaje.png',
            ],
          ),

          // Widget para representar la Página de Configuración
          _buildSection(
            title: '8. Página de Configuración',
            description:
                'Personaliza tu experiencia en la aplicación en la página de configuración. Aquí podrás editar detalles de tu perfil, cambiar tu contraseña, activar o desactivar las notificaciones, y obtener más información sobre la aplicación.',
            imagePaths: [
              'assets/images/configuracion.png',
            ],
          ),
        ],
      ),
    );
  }

  // Función para construir cada sección del manual de uso
  Widget _buildSection({
  required String title,
  String description = '',
  required List<String> imagePaths,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final imageCount = imagePaths.length;
  
  // Define el ancho máximo de las imágenes cuando hay dos
  double maxImageWidth = screenWidth / 2.5;
  double maxImageWidthOne = screenWidth / 1.2;
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          description,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 20.0),
        // Muestra las imágenes en una fila si hay dos, de lo contrario, muestra una sola imagen
        Row(
          mainAxisAlignment: imageCount == 2 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
          children: imagePaths.map((imagePath) {
            return SizedBox(
              width: imageCount == 2 ? maxImageWidth : maxImageWidthOne,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20.0),
        Divider(),
        
      ],
    ),
  );
}


}
