import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/widgets/tituloWidget.dart'; // Asegúrate de que este widget exista y esté correctamente implementado.

class PaginaSobreNosotros extends StatefulWidget {
  final String userEmail;

  PaginaSobreNosotros({required this.userEmail});

  @override
  _PaginaSobreNosotrosState createState() => _PaginaSobreNosotrosState();
}

class _PaginaSobreNosotrosState extends State<PaginaSobreNosotros> {
  bool _mostrarCastellano = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre Nosotros', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FadeInUp(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLanguageSwitcher(),
                Divider(),
                buildTitulo("David Martínez Díaz"),
                buildPersonaCard(
                  _mostrarCastellano ? textoPresentacionDavidCastellano : textoPresentacionDavidIngles,
                  'assets/images/david-profile.jpg',
                ),
                Divider(),
                buildTitulo("Jose Manuel Zurita López"),
                buildPersonaCard(
                  _mostrarCastellano ? textoPresentacionJoseCastellano : textoPresentacionJoseIngles,
                  'assets/images/admin-profile.jpg',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => setState(() => _mostrarCastellano = true),
          child: Text('Español', style: TextStyle(color: _mostrarCastellano ? Theme.of(context).primaryColor : Colors.black)),
        ),
        TextButton(
          onPressed: () => setState(() => _mostrarCastellano = false),
          child: Text('Inglés', style: TextStyle(color: !_mostrarCastellano ? Theme.of(context).primaryColor : Colors.black)),
        ),
      ],
    );
  }

  Widget buildPersonaCard(String descripcion, String imagenPerfil) {
  return Card(
    elevation: 5,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    color: Theme.of(context).primaryColor,
    child: Padding(
      padding: const EdgeInsets.all(12.0), // Aumenta el espacio dentro de la tarjeta
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // Añade un borde redondeado a la imagen
            child: Image.asset(
              imagenPerfil,
              width: 120, // Aumenta el ancho de la imagen
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16), // Añade espacio entre la imagen y el texto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                descripcion,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  String get textoPresentacionDavidCastellano => "Estudiante del doble grado en Ingeniería Informática y Administración y Dirección de Empresas. Especializado en la rama de la Ingenieria Software. \nCorreo: \nmartdiaz01.d@gmail.com";
  String get textoPresentacionDavidIngles => "Final-year student, double degree in Computer Engineering and Business Administration. Passionate about programming and tech. Exploring projects to enhance skills. \nEmail: \nmartdiaz01.d@gmail.com";
  String get textoPresentacionJoseCastellano => "José Manuel Zurita López es un distinguido Catedrático de Universidad en el Departamento de Ciencias de la Computación e Inteligencia Artificial en la E.T.S. de Ingenierías Informática y de Telecomunicación en Granada. ";
  String get textoPresentacionJoseIngles => "José Manuel Zurita López is a distinguished University Professor in the Department of Computer Science and Artificial Intelligence at the School of Computer Engineering and Telecommunications in Granada.";
}
