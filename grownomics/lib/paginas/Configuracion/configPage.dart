import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grownomics/paginas/Configuracion/widgets/aboutUsPage.dart';
import 'package:grownomics/paginas/Configuracion/widgets/editProfilePage.dart';
import 'package:grownomics/paginas/Configuracion/widgets/privacyPolicyPage.dart';
import 'package:grownomics/paginas/Configuracion/widgets/termsConditionsPage.dart';
import 'package:grownomics/paginas/Mercado/Widgets/chartWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginaConfiguracion extends StatefulWidget {
  final String userEmail;
  final String nombre;
  final String apellido;

  PaginaConfiguracion({
    required this.userEmail,
    required this.nombre,
    required this.apellido,
  });

  @override
  _PaginaConfiguracionState createState() => _PaginaConfiguracionState();
}

class _PaginaConfiguracionState extends State<PaginaConfiguracion> {
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
    final isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
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
    final controller = ZoomDrawer.of(context);

    return Scaffold(
      appBar: AppBar(
        key: Key('AppBarConfiguracion'),
        title: Text(
          'Configuracion',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            controller?.toggle();
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Colors.black,
        elevation: 4,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              accountName: Text(
                '${widget.nombre} ${widget.apellido}',
                style: TextStyle(fontSize: 20),
              ),
              accountEmail: Text("Ajustes de Cuenta"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.nombre.isNotEmpty ? widget.nombre[0] : '',
                  style: TextStyle(fontSize: 40.0, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            if (_isUserLoggedIn) ...[
              ListTile(
                key: Key('EditarPerfil'),
                title: Text('Editar Perfil'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaginaEditarPerfil(userEmail: widget.userEmail)),
                  );
                },
              ),
              SwitchListTile(
                key: Key('ToggleNotificaciones'),
                title: Text(
                  'Mostrar notificaciones',
                  style: TextStyle(color: Colors.black),
                ),
                value: _notificacionesActivadas,
                activeColor: Theme.of(context).primaryColor,
                inactiveTrackColor: Colors.grey,
                onChanged: (bool valor) {
                  setState(() {
                    _updateNotificationsPreference(valor);
                  });
                },
              ),
            ],
            Divider(
              color: const Color.fromARGB(255, 221, 216, 216),
              thickness: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Más información',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              key: Key('SobreNosotros'),
              title: Text('Sobre nosotros'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaSobreNosotros(userEmail: widget.userEmail)),
                );
              },
            ),
            ListTile(
              title: Text('Política de Privacidad'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaPoliticaPrivacidad(userEmail: widget.userEmail)),
                );
              },
            ),
            ListTile(
              title: Text('Términos y Condiciones'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaTerminosCondiciones(userEmail: widget.userEmail)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
