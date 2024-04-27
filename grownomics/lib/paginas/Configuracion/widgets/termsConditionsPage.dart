import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class PaginaTerminosCondiciones extends StatefulWidget {
  final String userEmail;
  PaginaTerminosCondiciones({required this.userEmail});

  @override
  _PaginaTerminosCondicionesState createState() =>
      _PaginaTerminosCondicionesState();
}

class _PaginaTerminosCondicionesState extends State<PaginaTerminosCondiciones> {
  bool _mostrarCastellano = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Términos y Condiciones',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _mostrarCastellano = true; // Cambiar a español
                        });
                      },
                      child: Text(
                        'Español',
                        style: TextStyle(
                          color: _mostrarCastellano
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _mostrarCastellano = false; // Cambiar a inglés
                        });
                      },
                      child: Text(
                        'Inglés',
                        style: TextStyle(
                          color: !_mostrarCastellano
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    _mostrarCastellano
                        ? "Términos y Condiciones"
                        : "Terms and Conditions",
                    textAlign: TextAlign.center, // Centra el texto del título
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.center,
                child: Text(
                  _mostrarCastellano
                      ? '''Bienvenido a nuestra aplicación. Si continúas utilizando esta aplicación, aceptas cumplir y estar sujeto a los siguientes términos y condiciones de uso, que junto con nuestra política de privacidad rigen la relación de Grownomics contigo en relación con esta aplicación. Si no estás de acuerdo con alguna parte de estos términos y condiciones, por favor no uses nuestra aplicación.

El uso de esta aplicación está sujeto a las siguientes condiciones de uso:

- El contenido de las páginas de esta aplicación es solo para tu información general y uso. Está sujeto a cambios sin previo aviso.
- Ni nosotros ni terceros proporcionamos ninguna garantía en cuanto a la precisión, puntualidad, rendimiento, integridad o idoneidad de la información y los materiales encontrados o ofrecidos en esta aplicación para un propósito particular. 
- Reconoces que dicha información y materiales pueden contener inexactitudes o errores y excluimos expresamente la responsabilidad por cualquier inexactitud o error en la máxima medida permitida por la ley.
- El uso de cualquier información o material en esta aplicación es bajo tu propio riesgo, por lo cual no seremos responsables. Será tu propia responsabilidad asegurarte de que cualquier producto, servicio o información disponible a través de esta aplicación satisfaga tus necesidades específicas.

El uso no autorizado de esta aplicación puede dar lugar a una reclamación por daños y / o ser un delito penal.

Todas las marcas comerciales reproducidas en esta aplicación, que no son propiedad del operador, son reconocidas en la aplicación.

El uso de esta aplicación y cualquier disputa que surja de dicho uso está sujeto a las leyes de España.

Reservamos el derecho de cambiar estos términos y condiciones de vez en cuando. Los cambios tendrán efecto inmediatamente después de que se publiquen en esta aplicación.

Si tienes alguna pregunta sobre estos términos y condiciones, contáctanos.'''
                      : '''Welcome to our application. If you continue to use this application, you are agreeing to comply with and be bound by the following terms and conditions of use, which together with our privacy policy govern Grownomics's relationship with you in relation to this application. If you disagree with any part of these terms and conditions, please do not use our application.

The use of this application is subject to the following terms of use:

- The content of the pages of this application is for your general information and use only. It is subject to change without notice.
- Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness, or suitability of the information and materials found or offered on this application for any particular purpose. 
- You acknowledge that such information and materials may contain inaccuracies or errors, and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.
- Your use of any information or materials on this application is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services, or information available through this application meet your specific requirements.

Unauthorized use of this application may give rise to a claim for damages and/or be a criminal offense.

All trademarks reproduced in this application, which are not the property of the operator, are acknowledged on the application.

Your use of this application and any dispute arising out of such use of the application is subject to the laws of Spain.

We reserve the right to change these terms and conditions from time to time. Changes will take effect immediately upon their posting on this application.

If you have any questions about these terms and conditions, please contact us.
''',
                  textAlign: TextAlign.justify, // Justifica el texto
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
