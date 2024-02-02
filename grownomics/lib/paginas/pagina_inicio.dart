import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fl_chart/fl_chart.dart';  // Paquete para gráficos
import 'package:http/http.dart' as http;

import '../widgets/mercado_resumen_widget.dart';  // Paquete para hacer solicitudes HTTP

class PaginaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = ZoomDrawer.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('App Asesoramiento Financiero'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller?.toggle();
          },
        ),
      ),
      body: SingleChildScrollView(  // ScrollView para permitir desplazamiento si el contenido es largo
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Widget para visión general del mercado
              MercadoResumenWidget(),

              // Espacio entre widgets
              SizedBox(height: 20),

              // Gráfico de rendimiento financiero
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Rendimiento Financiero',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            // ... Configuración del gráfico
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Espacio entre widgets
              SizedBox(height: 20),

              // Acceso rápido a asesoramiento o análisis
              Card(
                child: ListTile(
                  leading: Icon(Icons.assessment),
                  title: Text('Análisis Rápido'),
                  subtitle: Text('Obtén un análisis financiero rápido'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navegar a la página de análisis
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

