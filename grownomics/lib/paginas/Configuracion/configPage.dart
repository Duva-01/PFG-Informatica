import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Configuracion/widgets/aboutUsPage.dart';
import 'package:grownomics/paginas/Configuracion/widgets/editProfilePage.dart';
import 'package:grownomics/paginas/Configuracion/widgets/privacyPolicyPage.dart';
import 'package:grownomics/paginas/Configuracion/widgets/termsConditionsPage.dart';
import 'package:grownomics/paginas/Mercado/Widgets/chartWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginaConfiguracion extends StatefulWidget {
  // Atributos de la clase
  final String userEmail;
  final String nombre;
  final String apellido;

  // Constructor
  PaginaConfiguracion({
    required this.userEmail,
    required this.nombre,
    required this.apellido,
  });

  @override
  _PaginaConfiguracionState createState() => _PaginaConfiguracionState();
}

class _PaginaConfiguracionState extends State<PaginaConfiguracion> {
  
  // Estado para el estado de las notificaciones
  bool _notificacionesActivadas = false;
  bool _isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
    final isNotificationsEnabled =
        prefs.getBool('notificationsEnabled') ?? false;
    // Usa setState para actualizar _isUserLoggedIn y reconstruir la UI
    setState(() {
      _isUserLoggedIn = isLoggedIn;
      _notificacionesActivadas = isNotificationsEnabled;
    });
  }

  _updateNotificationsPreference(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificacionesActivadas = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el controlador del ZoomDrawer
    final controller = ZoomDrawer.of(context);

    return Scaffold(
      appBar: AppBar(
        key: Key('AppBarConfiguracion'),
        // Barra de aplicaciones en la parte superior de la página
        title: Text(
          'Configuracion',
          style: TextStyle(
            color: Colors.white, // Color del texto blanco
          ),
        ), // Título de la aplicación
        centerTitle: true, // Centra el título en la barra de aplicaciones
        leading: IconButton(
          // Botón de menú en el lado izquierdo de la barra de aplicaciones
          icon: Icon(Icons.menu, color: Colors.white), // Icono de menú
          onPressed: () {
            // Manejador de eventos cuando se presiona el botón de menú
            controller
                ?.toggle(); // Alterna el estado del ZoomDrawer (abre/cierra)
          },
        ),
        backgroundColor: Theme.of(context)
            .primaryColor, // Color de fondo de la AppBar según el color primario del tema

        shadowColor: Colors.black,
        elevation: 4,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          // Cuerpo de la página, una lista desplazable
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, // Color de fondo rojo
              ),
              // Encabezado de la cuenta del usuario
              accountName: Text(
                // Nombre y apellido del usuario
                widget.nombre + " " + widget.apellido,
                style: TextStyle(fontSize: 20),
              ),
              accountEmail:
                  Text("Ajustes de Cuenta"), // Texto de ajustes de cuenta
              currentAccountPicture: CircleAvatar(
                // Imagen de perfil del usuario
                backgroundColor: Colors.white,
                child: Text(
                  // Inicial del nombre del usuario como imagen de perfil
                  widget.nombre[0],
                  style: TextStyle(
                      fontSize: 40.0, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            if (_isUserLoggedIn) ...[
              ListTile(
                key: Key('EditarPerfil'),
                // Elemento de lista para editar perfil
                title: Text('Editar Perfil'), // Título
                trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
                onTap: () {
                  // Acción para política de privacidad
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaginaEditarPerfil(userEmail: widget.userEmail)),
                  );
                },
              ),
              SwitchListTile(
                key: Key('ToggleNotificaciones'),
                title: Text(
                  'Mostrar notificaciones',
                  style: TextStyle(color: Colors.black), // Color de la etiqueta
                ),
                value: _notificacionesActivadas,
                activeColor:
                    Theme.of(context).primaryColor, // Color cuando está activo
                inactiveTrackColor:
                    Colors.grey, // Color de la pista cuando está inactivo
                onChanged: (bool valor) {
                  setState(() {
                    _updateNotificationsPreference(valor);
                  });
                },
              ),
            ],
            Divider(
              color: const Color.fromARGB(255, 221, 216, 216), // Color gris
              thickness: 1.0, // Grosor de 2 píxeles
            ),
            Padding(
              // Espaciado interno
              padding: const EdgeInsets.all(8.0),
              child: Text('Más información',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)), // Texto adicional
            ),
            ListTile(
              key: Key('SobreNosotros'),
              // Elemento de lista para mostrar información sobre nosotros
              title: Text('Sobre nosotros'), // Título
              trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
              onTap: () {
                // Acción para sobre nosotros
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaginaSobreNosotros(userEmail: widget.userEmail)),
                );
              },
            ),
            ListTile(
              // Elemento de lista para mostrar la política de privacidad
              title: Text('Política de Privacidad'), // Título
              trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
              onTap: () {
                // Acción para política de privacidad
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaginaPoliticaPrivacidad(
                          userEmail: widget.userEmail)),
                );
              },
            ),
            ListTile(
              // Elemento de lista para mostrar los términos y condiciones
              title: Text('Términos y Condiciones'), // Título
              trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
              onTap: () {
                // Acción para términos y condiciones
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaginaTerminosCondiciones(
                          userEmail: widget.userEmail)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
