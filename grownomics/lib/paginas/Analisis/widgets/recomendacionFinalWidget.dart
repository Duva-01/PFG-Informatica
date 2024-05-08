import 'package:flutter/material.dart';
import 'package:grownomics/controladores/recomendationController.dart';
import 'package:grownomics/widgets/tituloWidget.dart';

class RecomendacionFinalWidget extends StatefulWidget {
  final String simboloAccion; // Símbolo de la acción
  final String correoElectronico;

  const RecomendacionFinalWidget(
      {Key? key, required this.simboloAccion, required this.correoElectronico})
      : super(key: key);

  @override
  _RecomendacionFinalWidgetState createState() =>
      _RecomendacionFinalWidgetState();
}

class _RecomendacionFinalWidgetState extends State<RecomendacionFinalWidget> {
  bool _isLoading = true;
  Map<String, dynamic>?
      recomendaciones; // Mapa para almacenar las recomendaciones

  @override
  void initState() {
    super.initState();
    obtenerRecomendaciones(); // Llamar a la función para obtener recomendaciones al inicializar el widget
  }

  void obtenerRecomendaciones() async {
    try {
      final resultado = await RecomendacionesController.obtenerAnalisisCompleto(
          widget.simboloAccion,
          widget
              .correoElectronico); // Obtener recomendaciones según el símbolo de la acción
      setState(() {
        recomendaciones = resultado;
        print(recomendaciones!['recomendacion_final']);
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener recomendaciones: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator(color: Color(0xFF2F8B62)))
        : Column(
            children: [
              buildTitulo("Recomendación final"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                widget.simboloAccion[
                                    0], // Primer letra del símbolo en grande
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.simboloAccion +
                                    " - " +
                                    "Precio: ${recomendaciones!['precio_actual'].toStringAsFixed(3)}€", // Símbolo completo
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.green[300]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Recomendación',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${recomendaciones!['recomendacion_final']['recomendacion']}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green
                                      .withOpacity(0.3), // Fondo verde clarillo
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green
                                          .withOpacity(0.5), // Sombra verde
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0,
                                          3), // Cambia la dirección de la sombra si lo deseas
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.attach_money,
                                      color: Colors.green), // Icono de compra
                                  title: Text(
                                    'Precio ideal recomendado de compra',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${recomendaciones!['recomendacion_final']['precio_compra_recomendado'].toStringAsFixed(3)}€',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red
                                      .withOpacity(0.3), // Fondo rojo clarillo
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red
                                          .withOpacity(0.5), // Sombra roja
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0,
                                          3), // Cambia la dirección de la sombra si lo deseas
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.monetization_on,
                                      color: Colors.red), // Icono de venta
                                  title: Text(
                                    'Precio ideal recomendado de venta',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 148, 32, 32),
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${recomendaciones!['recomendacion_final']['precio_venta_recomendado'].toStringAsFixed(3)}€',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              ExpansionTile(
  leading: Icon(Icons.info), // Icono de información para el título del ExpansionTile
  title: Text.rich(
    TextSpan(
      text: 'Explicación de la recomendación',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  children: [
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true, // Permite que la ListView ocupe solo el espacio necesario
        itemCount: recomendaciones!['recomendacion_final']['explicaciones'].length,
        itemBuilder: (context, index) {
          final explicacion = recomendaciones!['recomendacion_final']['explicaciones'][index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // Fondo grisáceo para cada ListTile
              border: Border.all(color: Colors.black), // Borde negro
              borderRadius: BorderRadius.circular(4), // Bordes ligeramente redondeados
            ),
            child: ListTile(
              leading: Icon(Icons.info_outline), // Icono de información para cada ListTile
              title: Text(explicacion),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(color: Colors.black), // Separador negro entre cada ListTile
      ),
    ),
  ],
),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
