import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/api/authAPI.dart';

class PaginaCambiarClave extends StatefulWidget {
  @override
  _PaginaCambiarClaveState createState() => _PaginaCambiarClaveState();
}

class _PaginaCambiarClaveState extends State<PaginaCambiarClave> {
  // Variables para almacenar el correo electrónico, el código de verificación, la nueva contraseña y la confirmación de contraseña
  String _email = '';
  String _codigoVerificacion = '';
  String _nuevaClave = '';
  String _confirmarClave = '';
  // Variable para controlar la visibilidad del formulario de código de verificación y nueva contraseña
  bool _mostrarFormulario = false;
  // Variables para controlar la visibilidad de la nueva contraseña y la confirmación de contraseña
  bool _ocultarNuevaClave = true;
  bool _ocultarConfirmarClave = true;

  // Método para enviar el código de verificación al correo electrónico
  void _enviarCodigoVerificacion() async {
    bool enviado = await solicitarResetPassword(_email);
    if (enviado) {
      // Código enviado con éxito, mostrar formulario para ingresar código
      setState(() {
        _mostrarFormulario = true;
      });
    } else {
      // Mostrar mensaje de error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content:
              Text('Hubo un problema al enviar el código de verificación.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  // Método para cambiar la contraseña
  void _verificarYCambiarClave() async {
    if (_nuevaClave != _confirmarClave) {
      // Mostrar mensaje de que las contraseñas no coinciden
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Las contraseñas no coinciden.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }

    bool cambiada =
        await resetPassword(_email, _codigoVerificacion, _nuevaClave);
    if (cambiada) {
      // Contraseña cambiada con éxito, mostrar mensaje y navegar o cerrar
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Éxito'),
          content: Text('La contraseña se cambió correctamente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      // Mostrar mensaje de error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Hubo un problema al cambiar la contraseña.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cambiar contraseña',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Colors.black,
        elevation: 3,
      ),
      body: FadeInUp(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(), // Borde del campo de entrada
                  ),
                  keyboardType: TextInputType
                      .emailAddress, // Tipo de teclado para el campo de correo electrónico
          
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _enviarCodigoVerificacion,
                  child: Text('Enviar Código de Verificación'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors
                        .white), // Color del texto según el color primario del tema
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
                if (_mostrarFormulario) ...[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Código de Verificación',
                      border: OutlineInputBorder(), // Borde del campo de entrada
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _codigoVerificacion = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nueva Contraseña',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarNuevaClave
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarNuevaClave = !_ocultarNuevaClave;
                          });
                        },
                      ),
                    ),
                    obscureText: _ocultarNuevaClave,
                    onChanged: (value) {
                      setState(() {
                        _nuevaClave = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarConfirmarClave
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarConfirmarClave = !_ocultarConfirmarClave;
                          });
                        },
                      ),
                    ),
                    obscureText: _ocultarConfirmarClave,
                    onChanged: (value) {
                      setState(() {
                        _confirmarClave = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _verificarYCambiarClave,
                    child: Text('Cambiar Contraseña'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors
                          .white), // Color del texto según el color primario del tema
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
