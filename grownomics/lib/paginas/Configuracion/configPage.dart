import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class PaginaConfiguracion extends StatefulWidget {
  // Atributos de la clase
  final String userEmail;
  final String nombre;
  final String apellido;

  // Constructor
  PaginaConfiguracion(
      {required this.userEmail, required this.nombre, required this.apellido});

  @override
  _PaginaConfiguracionState createState() => _PaginaConfiguracionState();
}

class _PaginaConfiguracionState extends State<PaginaConfiguracion> {
  // Estado para el estado de las notificaciones
  bool _notificacionesActivadas = false;

  // Estado para el modo oscuro
  bool _modoOscuroActivado = false;

  @override
  Widget build(BuildContext context) {
    // Obtener el controlador del ZoomDrawer
    final controller = ZoomDrawer.of(context);

    return Scaffold(
      appBar: AppBar(
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
            ListTile(
              // Elemento de lista para editar perfil
              title: Text('Editar Perfil'), // Título
              trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
              onTap: () {
                // Acción para editar perfil
              },
            ),
            ListTile(
              // Elemento de lista para cambiar contraseña
              title: Text('Cambiar contraseña'), // Título
              trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
              onTap: () {
                // Acción para cambiar contraseña
              },
            ),
            SwitchListTile(
              title: Text(
                'Activar notificaciones',
                style: TextStyle(color: Colors.black), // Color de la etiqueta
              ),
              value: _notificacionesActivadas,
              activeColor:
                  Theme.of(context).primaryColor, // Color cuando está activo
              inactiveTrackColor:
                  Colors.grey, // Color de la pista cuando está inactivo
              onChanged: (bool valor) {
                setState(() {
                  _notificacionesActivadas = valor;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                'Modo oscuro',
                style: TextStyle(color: Colors.black), // Color de la etiqueta
              ),
              value: _modoOscuroActivado,
              inactiveTrackColor: Colors.grey,
              activeColor: Theme.of(context)
                  .primaryColor, // Color principal de la aplicación
              onChanged: (bool valor) {
                setState(() {
                  _modoOscuroActivado = valor;
                });
              },
            ),
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
              // Elemento de lista para mostrar información sobre nosotros
              title: Text('Sobre nosotros'), // Título
              trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
              onTap: () {
                // Acción para sobre nosotros
              },
            ),
            ListTile(
              // Elemento de lista para mostrar la política de privacidad
              title: Text('Política de Privacidad'), // Título
              trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
              onTap: () {
                // Acción para política de privacidad
              },
            ),
            ListTile(
              // Elemento de lista para mostrar los términos y condiciones
              title: Text('Términos y Condiciones'), // Título
              trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
              onTap: () {
                // Acción para términos y condiciones
              },
            ),
          ],
        ),
      ),
    );
  }
}
