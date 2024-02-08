import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class PaginaConfiguracion extends StatefulWidget {
  @override
  _PaginaConfiguracionState createState() => _PaginaConfiguracionState();
}

class _PaginaConfiguracionState extends State<PaginaConfiguracion> {
  bool _notificacionesActivadas = false;
  bool _modoOscuroActivado = false;

  @override
  Widget build(BuildContext context) {
    final controller = ZoomDrawer.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle();
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("David Martinez Diaz"),
            accountEmail: Text("Ajustes de Cuenta"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "D",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text('Editar Perfil'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Acción para editar perfil
            },
          ),
          ListTile(
            title: Text('Cambiar contraseña'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Acción para cambiar contraseña
            },
          ),
          SwitchListTile(
            title: Text('Activar notificaciones'),
            value: _notificacionesActivadas,
            onChanged: (bool valor) {
              setState(() {
                _notificacionesActivadas = valor;
              });
            },
          ),
          SwitchListTile(
            title: Text('Modo oscuro'),
            value: _modoOscuroActivado,
            onChanged: (bool valor) {
              setState(() {
                _modoOscuroActivado = valor;
              });
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Más información', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text('Sobre nosotros'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Acción para sobre nosotros
            },
          ),
          ListTile(
            title: Text('Política de Privacidad'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Acción para política de privacidad
            },
          ),
          ListTile(
            title: Text('Términos y Condiciones'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Acción para términos y condiciones
            },
          ),
        ],
      ),
    );
  }
}
