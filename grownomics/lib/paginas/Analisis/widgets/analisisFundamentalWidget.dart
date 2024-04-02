import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:grownomics/controladores/recomendationController.dart';
import 'package:grownomics/paginas/Analisis/widgets/terminosDescripciones.dart';
import 'package:grownomics/widgets/tituloWidget.dart';

class AnalisisFundamentalWidget extends StatefulWidget {
  final String simboloAccion;

  const AnalisisFundamentalWidget({
    Key? key,
    required this.simboloAccion,
  }) : super(key: key);

  @override
  _AnalisisFundamentalWidgetState createState() =>
      _AnalisisFundamentalWidgetState();
}

class _AnalisisFundamentalWidgetState extends State<AnalisisFundamentalWidget> {
  bool _isLoading = true;
  Map<String, dynamic>? _analisisFundamental;

  @override
  void initState() {
    super.initState();
    _cargarAnalisisFundamental();
  }

  void _cargarAnalisisFundamental() async {
    try {
      final analisis = await RecomendacionesController.obtenerAnalisisFundamental(widget.simboloAccion);
      setState(() {
        _analisisFundamental = analisis;
        
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener el análisis fundamental: $e");
      setState(() => _isLoading = false);
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
                buildTitulo("Indicadores Principales"),
                ..._buildPrincipalesWidgets(),
                buildTitulo("Último Balance"),
                _buildSectionWidget(
                  "Último Balance",
                  ['Invested Capital', 'Current Debt', 'Capital Stock'],
                  terminosTraducidosBalance,
                  descripcionesBalance,
                ),
                buildTitulo("Últimos Ingresos"),
                _buildSectionWidget(
                  "Últimos Ingresos",
                  ['Net Income', 'Basic EPS', 'Cost Of Revenue'],
                  terminosTraducidosIngresos,
                  descripcionesIngresos,
                  
                ),
              ],
            ),
          ),
      );
}


  List<Widget> _buildPrincipalesWidgets() {
    List<Widget> widgets = [];
    terminosTraducidosPrincipales.forEach((key, value) {
      if (_analisisFundamental != null &&
          _analisisFundamental!.containsKey(key) &&
          _analisisFundamental![key] != 'N/A' &&
          _analisisFundamental![key] != 0) {
        widgets.add(
          ExpansionTile(
            title: Text(value),
            subtitle: Text(_analisisFundamental![key].toString()),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(descripcionesPrincipales[key] ?? ''),
              ),
            ],
          ),
        );
      }
    });
    return widgets;
  }

  Widget _buildSectionWidget(String sectionTitle,List<String> clavesDirectas, 
  Map<String, String> terminosTraducidos, Map<String, String> descripciones) {

    List<Widget> widgetsDirectos = [];
    List<Widget> widgetsExpandidos = [];

    _analisisFundamental![sectionTitle].forEach((key, value) {
      if (clavesDirectas.contains(key)) {
        widgetsDirectos.add(
          ExpansionTile(
            title: Text(terminosTraducidos[key] ?? key),
            subtitle: Text(value.toString() + "€"),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(descripciones[key] ?? ''),
              ),
            ],
          ),
        );
      } else {
        widgetsExpandidos.add(
          ExpansionTile(
            title: Text(terminosTraducidos[key] ?? key),
            subtitle: Text(value.toString() + "€"),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(descripciones[key] ?? ''),
              ),
            ],
          ),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widgetsDirectos,
        ExpansionTile(
          title: Text(
            "Más detalles de $sectionTitle",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          iconColor: Theme.of(context).primaryColor,
          children: widgetsExpandidos,
          tilePadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          initiallyExpanded: false,
        )
      ],
    );
  }
}
