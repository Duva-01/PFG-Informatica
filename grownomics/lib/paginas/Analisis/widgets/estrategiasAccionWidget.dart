import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/paginas/Analisis/widgets/prediccionesPrecioWidget.dart';
import 'package:grownomics/paginas/Analisis/widgets/recomendacionFinalWidget.dart';
import 'package:grownomics/paginas/Mercado/Widgets/recomendationWidget.dart';
import 'package:intl/intl.dart'; // Importar el paquete intl para formatear fechas
import 'package:grownomics/controladores/recomendationController.dart';
import 'package:grownomics/widgets/tituloWidget.dart';



class EstrategiasAccionWidget extends StatefulWidget {
  final String simboloAccion;
  final String correoElectronico;

  const EstrategiasAccionWidget({
    Key? key,
    required this.simboloAccion,
    required this.correoElectronico
  }) : super(key: key);

  @override
  _EstrategiasAccionWidgetState createState() => _EstrategiasAccionWidgetState();
}

class _EstrategiasAccionWidgetState extends State<EstrategiasAccionWidget> {
  bool _isLoading = true;
  Map<String, dynamic>? recomendaciones;

  @override
  void initState() {
    super.initState();
    obtenerRecomendaciones();
  }

  void obtenerRecomendaciones() async {
    try {
      final resultado = await RecomendacionesController.obtenerAnalisisCompleto(widget.simboloAccion, widget.correoElectronico);
      setState(() {
        recomendaciones = resultado;
        print(recomendaciones!['predicciones_precio']);
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
        : FadeInUp(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  if (recomendaciones != null) ...[
                    WidgetRecomendacion(simbolo: widget.simboloAccion, correoElectronico: widget.correoElectronico),
                    PrediccionesPreciosWidget(prediccionesPrecio: recomendaciones!['predicciones_precio']),
                  ] else
                    Text('No se pudo cargar la información'),
                ],
              ),
            ),
        );
  }
}


