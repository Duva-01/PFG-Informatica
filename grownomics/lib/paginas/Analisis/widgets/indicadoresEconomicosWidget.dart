import 'package:flutter/material.dart';
import 'package:grownomics/api/recomendationAPI.dart';
import 'package:grownomics/widgets/tituloWidget.dart'; // Asegúrate de importar el archivo adecuado con la definición de indicadores económicos

class IndicadoresEconomicosWidget extends StatefulWidget {
  final String simbolo;

  IndicadoresEconomicosWidget({Key? key, required this.simbolo}) : super(key: key);

  @override
  _IndicadoresEconomicosWidgetState createState() => _IndicadoresEconomicosWidgetState();
}

class _IndicadoresEconomicosWidgetState extends State<IndicadoresEconomicosWidget> {
  Map<String, dynamic>? indicadoresEconomicos;

  @override
  void initState() {
    super.initState();
    cargarIndicadoresEconomicos();
  }

  // Método para cargar los indicadores económicos
  void cargarIndicadoresEconomicos() async {
    try {
      final indicadores = await obtenerIndicadoresEconomicos(widget.simbolo);
      setState(() {
        indicadoresEconomicos = indicadores; // Actualiza los indicadores económicos en el estado del widget
      });
    } catch (e) {
      print("Error al cargar los indicadores económicos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitulo("Indicadores Económicos"), // Widget personalizado para el título
          if (indicadoresEconomicos != null) ..._construirSeccionIndicadoresEconomicos(),
        ],
      ),
    );
  }

  // Lista de iconos para los indicadores económicos
  final List<IconData> _iconList = [
    Icons.trending_up,
    Icons.show_chart,
    Icons.trending_down,
    Icons.attach_money,
    Icons.euro_symbol,
    Icons.monetization_on,
    Icons.money,
    Icons.compare_arrows,
    Icons.swap_horiz,
    Icons.timeline,
    Icons.equalizer,
    Icons.insert_chart,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.business,
  ];

  // Lista de colores para los iconos de los indicadores económicos
  final List<Color> _iconColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
  ];

  // Método para construir la sección de indicadores económicos
  List<Widget> _construirSeccionIndicadoresEconomicos() {
    Map<String, dynamic> descripciones = indicadoresEconomicos?['descriptions'] ?? {};
    Map<String, dynamic> indicadores = indicadoresEconomicos?['indicators'] ?? {};

    List<Widget> lista = [];
    List<Widget> indicadoresSecundarios = [];

    List<MapEntry<String, dynamic>> entradas = indicadores.entries.toList().reversed.toList();

    entradas.asMap().forEach((indice, entrada) {
      String clave = entrada.key;
      dynamic valor = entrada.value;
      String descripcion = descripciones[clave] ?? 'No hay descripción disponible';
      IconData iconoDatos = _iconList[indice % _iconList.length];
      Color colorIcono = _iconColors[indice % _iconColors.length];

      if (clave == 'SMA' || clave == 'RSI' || clave == 'EMA') {
        // Indicadores principales
        lista.add(
          Card(
            color: Colors.grey.shade200,
            child: ListTile(
              leading: Icon(iconoDatos, color: colorIcono, size: 30),
              title: Text(clave),
              subtitle: Text('$clave: $valor'),
              trailing: Tooltip(
                message: descripcion,
                child: Icon(Icons.info, size: 30),
              ),
            ),
          ),
        );
      } else {
        // Indicadores secundarios
        indicadoresSecundarios.add(
          Card(
            color: Colors.grey.shade200,
            child: ListTile(
              leading: Icon(iconoDatos, color: colorIcono, size: 30),
              title: Text(clave),
              subtitle: Text('$clave: $valor'),
              trailing: Tooltip(
                message: descripcion,
                child: Icon(Icons.info, size: 30),
              ),
            ),
          ),
        );
      }
    });

    // Si hay indicadores secundarios, los mostramos dentro de un ExpansionTile
    if (indicadoresSecundarios.isNotEmpty) {
      lista.add(
        ExpansionTile(
          title: Text('Indicadores adicionales'),
          children: indicadoresSecundarios,
        ),
      );
    }

    return lista;
  }
}
