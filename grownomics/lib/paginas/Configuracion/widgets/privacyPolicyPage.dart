import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class PaginaPoliticaPrivacidad extends StatefulWidget {
  final String userEmail;
  PaginaPoliticaPrivacidad({required this.userEmail});

  @override
  _PaginaPoliticaPrivacidadState createState() =>
      _PaginaPoliticaPrivacidadState();
}

class _PaginaPoliticaPrivacidadState extends State<PaginaPoliticaPrivacidad> {
  bool _mostrarCastellano = true; // Variable para controlar el idioma mostrado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Política de Privacidad',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FadeInUp(
        child: SingleChildScrollView(
          child: Column(
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
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Política de Privacidad" : "Privacy Policy",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Introducción" : "Introduction",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Nuestra política de privacidad te ayudará a comprender qué información recopilamos en Grownomics, cómo la utiliza Grownomics y qué opciones tienes. Grownomics desarrolló la aplicación Grownomics como una aplicación gratuita. Este SERVICIO es proporcionado por Grownomics sin costo alguno y está destinado a ser utilizado tal cual. Si decides utilizar nuestro Servicio, aceptas la recopilación y el uso de la información de acuerdo con esta política. La Información Personal que recopilamos se utiliza para proporcionar y mejorar el Servicio. No utilizaremos ni compartiremos tu información con nadie, excepto como se describe en esta Política de Privacidad."
                        : "Our privacy policy will help you understand what information we collect at Grownomics, how Grownomics uses it, and what choices you have. Grownomics built the Grownomics app as a free app. This SERVICE is provided by Grownomics at no cost and is intended for use as is. If you choose to use our Service, then you agree to the collection and use of information in relation with this policy. The Personal Information that we collect are used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Recolección y Uso de la Información" : "Information Collection and Use",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Para una mejor experiencia mientras utilizas nuestro Servicio, es posible que te solicitemos que nos proporciones cierta información personalmente identificable, incluyendo pero no limitado al nombre de usuario, dirección de correo electrónico, género, ubicación, imágenes. La información que solicitamos será retenida por nosotros y utilizada como se describe en esta política de privacidad. La aplicación utiliza servicios de terceros que pueden recopilar información utilizada para identificarte."
                        : "For a better experience while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to users name, email address, gender, location, pictures. The information that we request will be retained by us and used as described in this privacy policy. The app does use third party services that may collect information used to identify you.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Cookies" : "Cookies",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Las cookies son archivos con una pequeña cantidad de datos que se utilizan comúnmente como identificadores únicos anónimos. Estos se envían a tu navegador desde el sitio web que visitas y se almacenan en la memoria interna de tu dispositivo. Este Servicio no utiliza estas 'cookies' explícitamente. Sin embargo, la aplicación puede utilizar código y bibliotecas de terceros que utilizan 'cookies' para recopilar información y mejorar sus servicios."
                        : "Cookies are files with small amount of data that is commonly used an anonymous unique identifier. These are sent to your browser from the website that you visit and are stored on your devices’s internal memory. This Services does not uses these 'cookies' explicitly. However, the app may use third party code and libraries that use 'cookies' to collection information and to improve their services.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Información de Ubicación" : "Location Information",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Algunos de los servicios pueden utilizar información de ubicación transmitida desde los teléfonos móviles de los usuarios. Solo utilizamos esta información dentro del alcance necesario para el servicio designado."
                        : "Some of the services may use location information transmitted from users' mobile phones. We only use this information within the scope necessary for the designated service.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Información del Dispositivo" : "Device Information",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Recopilamos información de tu dispositivo en algunos casos. La información se utilizará para la provisión de un mejor servicio y para prevenir actos fraudulentos. Además, dicha información no incluirá aquella que identifique al usuario individual."
                        : "We collect information from your device in some cases. The information will be used for providing a better service and preventing fraudulent acts. Moreover, such information will not include that which identifies the individual user.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Proveedores de Servicios" : "Service Providers",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Podemos emplear a empresas e individuos de terceros por las siguientes razones:\n\n- Para facilitar nuestro Servicio;\n- Para proporcionar el Servicio en nuestro nombre;\n- Para realizar servicios relacionados con el Servicio; o\n- Para ayudarnos a analizar cómo se utiliza nuestro Servicio.\n\nQueremos informar a los usuarios de este Servicio que estos terceros tienen acceso a tu Información Personal. El motivo es realizar las tareas asignadas en nuestro nombre. Sin embargo, están obligados a no divulgar ni utilizar la información para ningún otro propósito."
                        : "We may employ third-party companies and individuals for the following reasons:\n\n- To facilitate our Service;\n- To provide the Service on our behalf;\n- To perform Service-related services; or\n- To assist us in analyzing how our Service is used.\n\nWe want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Seguridad" : "Security",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Valoramos tu confianza al proporcionarnos tu Información Personal, por lo que nos esforzamos por utilizar medios comercialmente aceptables para protegerla. Pero recuerda que ningún método de transmisión a través de Internet o método de almacenamiento electrónico es 100% seguro y confiable, y no podemos garantizar su absoluta seguridad."
                        : "We value your trust in providing us with your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Privacidad de los Niños" : "Children's Privacy",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Este Servicio no está dirigido a personas menores de 13 años. No recopilamos intencionadamente información de identificación personal de niños menores de 13 años. En caso de que descubramos que un niño menor de 13 años nos ha proporcionado información personal, la eliminamos inmediatamente de nuestros servidores. Si eres padre o tutor y sabes que tu hijo nos ha proporcionado información personal, contáctanos para que podamos tomar las medidas necesarias."
                        : "This Service is not intended for individuals under the age of 13. We do not knowingly collect personal identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to take necessary action.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Cambios a esta Política de Privacidad" : "Changes to This Privacy Policy",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Podemos actualizar nuestra Política de Privacidad de vez en cuando. Por lo tanto, se te recomienda que revises esta página periódicamente para ver cualquier cambio. Te notificaremos cualquier cambio publicando la nueva Política de Privacidad en esta página. Estos cambios son efectivos inmediatamente, después de que se publiquen en esta página."
                        : "We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately, after they are posted on this page.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Divider(), // Separador
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano ? "Contáctanos" : "Contact Us",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _mostrarCastellano
                        ? "Si tienes alguna pregunta o sugerencia sobre nuestra Política de Privacidad, no dudes en contactarnos.\n\nInformación de Contacto:\nCorreo electrónico: martdiaz01.d@gmail.com"
                        : "If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.\n\nContact Information:\nEmail: martdiaz01.d@gmail.com",
                    textAlign: TextAlign.justify,
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
