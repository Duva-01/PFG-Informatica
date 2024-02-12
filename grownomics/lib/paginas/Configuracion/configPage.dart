import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class PaginaConfiguracion extends StatefulWidget {
  // Atributos de la clase
  final String userEmail;
  final String nombre;
  final String apellido;
  
  // Constructor
  PaginaConfiguracion({required this.userEmail, required this.nombre, required this.apellido});

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
        title: Text('Configuración'), // Título de la página
        leading: IconButton( // Botón de menú en la barra de navegación
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle(); // Activar/desactivar el menú lateral
          },
        ),
      ),
      body: ListView( // Cuerpo de la página, una lista desplazable
        children: <Widget>[
          UserAccountsDrawerHeader( // Encabezado de la cuenta del usuario
            accountName: Text( // Nombre y apellido del usuario
              widget.nombre + " " + widget.apellido,
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text("Ajustes de Cuenta"), // Texto de ajustes de cuenta
            currentAccountPicture: CircleAvatar( // Imagen de perfil del usuario
              backgroundColor: Colors.white,
              child: Text( // Inicial del nombre del usuario como imagen de perfil
                widget.nombre[0],
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile( // Elemento de lista para editar perfil
            title: Text('Editar Perfil'), // Título
            trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
            onTap: () {
              // Acción para editar perfil
            },
          ),
          ListTile( // Elemento de lista para cambiar contraseña
            title: Text('Cambiar contraseña'), // Título
            trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
            onTap: () {
              // Acción para cambiar contraseña
            },
          ),
          SwitchListTile( // Interruptor de lista para activar/desactivar notificaciones
            title: Text('Activar notificaciones'), // Título
            value: _notificacionesActivadas, // Estado del interruptor
            onChanged: (bool valor) {
              setState(() {
                _notificacionesActivadas = valor; // Actualizar el estado de las notificaciones
              });
            },
          ),
          SwitchListTile( // Interruptor de lista para activar/desactivar el modo oscuro
            title: Text('Modo oscuro'), // Título
            value: _modoOscuroActivado, // Estado del interruptor
            onChanged: (bool valor) {
              setState(() {
                _modoOscuroActivado = valor; // Actualizar el estado del modo oscuro
              });
            },
          ),
          Divider(), // Separador
          Padding( // Espaciado interno
            padding: const EdgeInsets.all(8.0),
            child: Text('Más información', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)), // Texto adicional
          ),
          ListTile( // Elemento de lista para mostrar información sobre nosotros
            title: Text('Sobre nosotros'), // Título
            trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
            onTap: () {
              // Acción para sobre nosotros
            },
          ),
          ListTile( // Elemento de lista para mostrar la política de privacidad
            title: Text('Política de Privacidad'), // Título
            trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
            onTap: () {
              // Acción para política de privacidad
            },
          ),
          ListTile( // Elemento de lista para mostrar los términos y condiciones
            title: Text('Términos y Condiciones'), // Título
            trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha
            onTap: () {
              // Acción para términos y condiciones
            },
          ),
        ],
      ),
    );
  }
}
