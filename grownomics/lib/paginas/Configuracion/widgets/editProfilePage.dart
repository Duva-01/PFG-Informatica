import 'package:flutter/material.dart';
import 'package:grownomics/controladores/userController.dart';
import 'package:grownomics/loadingPage.dart';

class PaginaEditarPerfil extends StatefulWidget {
  final String userEmail;

  PaginaEditarPerfil({required this.userEmail});

  @override
  _PaginaEditarPerfilState createState() => _PaginaEditarPerfilState();
}

class _PaginaEditarPerfilState extends State<PaginaEditarPerfil> {
  int _usuarioId = 0;

  TextEditingController _controladorCorreo = TextEditingController();
  TextEditingController _controladorPassword = TextEditingController();
  TextEditingController _controladorNombre = TextEditingController();
  TextEditingController _controladorApellido = TextEditingController();
  var datosUsuario;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    datosUsuario = await UsuarioController.obtenerDatosUsuario(widget.userEmail);
    if (datosUsuario != null) {
      setState(() {
        _usuarioId = datosUsuario['id'];
        _controladorCorreo.text = datosUsuario['email'] ?? '';
        _controladorNombre.text = datosUsuario['nombre'] ?? '';
        _controladorApellido.text = datosUsuario['apellido'] ?? '';
        _cargando = false;
      });
    }
  }

  void _guardarCambios() async {
    // Usar el ID del usuario para la actualización
    bool exito = await UsuarioController.actualizarUsuario(
      _usuarioId,
      _controladorNombre.text,
      _controladorApellido.text,
      _controladorCorreo.text,
      _controladorPassword.text,
    );
    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil actualizado con éxito')));

      // Espera 2 segundos después de mostrar el SnackBar
      await Future.delayed(Duration(seconds: 1));

      // Navega a PaginaCarga y elimina todas las pantallas anteriores de la pila
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => PaginaCarga()),
        ModalRoute.withName('/'), // Asegúrate de que esta ruta esté definida en tu MaterialApp o CupertinoApp
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar perfil')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Perfil',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _cargando
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Nombre',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _controladorNombre,
                        decoration: InputDecoration(
                          labelText: 'Ingrese su nombre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Apellido',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _controladorApellido,
                        decoration: InputDecoration(
                          labelText: 'Ingrese su apellido',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Correo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _controladorCorreo,
                        decoration: InputDecoration(
                          labelText: 'Ingrese su correo',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        enabled: false, // Esto deshabilita la edición del campo
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Nueva Contraseña',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _controladorPassword,
                        decoration: InputDecoration(
                          labelText: 'Ingrese su nueva contraseña',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.visibility_off),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Color del texto según el color primario del tema
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: _guardarCambios,
                        child: Text(
                            'Guardar cambios y Reiniciar'), // Texto del botón de inicio de sesión
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
