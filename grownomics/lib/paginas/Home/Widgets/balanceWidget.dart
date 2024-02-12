import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animate_do/animate_do.dart';
import 'package:grownomics/api/portfolioAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Widget de Tarjeta de Saldo que muestra información sobre el balance y transacciones del usuario
class BalanceCard extends StatefulWidget {
  final String userEmail; // Correo electrónico del usuario

  const BalanceCard({
    required this.userEmail, // Parámetro obligatorio: correo electrónico del usuario
  });

  @override
  _BalanceCardState createState() => _BalanceCardState(); // Crea el estado de la tarjeta de saldo
}

class _BalanceCardState extends State<BalanceCard> {
  late double balance = 0.0; // Saldo del usuario
  late int totalTransacciones = 0; // Total de transacciones del usuario
  late double totalDepositado = 0.0; // Total depositado por el usuario
  late double totalRetirado = 0.0; // Total retirado por el usuario

  @override
  void initState() {
    super.initState();
    cargarDatosCartera(); // Carga los datos de la cartera al iniciar el estado
  }

  // Método para cargar los datos de la cartera del usuario
  void cargarDatosCartera() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final emailObtenido = prefs.getString('userEmail') ?? widget.userEmail;
      final datosCartera = await obtenerCartera(emailObtenido); // Obtiene los datos de la cartera
      setState(() {
        balance = datosCartera['saldo']; // Actualiza el saldo
        totalDepositado = datosCartera['total_depositado']; // Actualiza el total depositado
        totalRetirado = datosCartera['total_retirado']; // Actualiza el total retirado
        totalTransacciones = datosCartera['total_transacciones']; // Actualiza el total de transacciones
      });
    } catch (e) {
      print("Error al cargar los datos de la cartera: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeInRight( // Widget de animación FadeInRight
      child: ClipRRect( // Widget de ClipRRect para aplicar bordes redondeados
        borderRadius: BorderRadius.circular(45.0), // Borde circular
        child: Container( // Contenedor de la tarjeta de saldo
          width: MediaQuery.of(context).size.width * 0.90, // Ancho del contenedor
          color: Color.fromARGB(255, 19, 60, 42), // Color de fondo del contenedor
          margin: EdgeInsets.symmetric(vertical: 10), // Margen vertical
          padding: EdgeInsets.all(20), // Padding interno
          child: Column( // Columna que contiene los widgets secundarios
            crossAxisAlignment: CrossAxisAlignment.center, // Alineación cruzada al centro
            children: <Widget>[
              Text( // Widget de texto para mostrar el saldo actual del usuario
                '\$${balance.toStringAsFixed(2)}', // Formato de texto: saldo con 2 decimales
                style: TextStyle(
                    color: Colors.green, // Color de texto verde
                    fontSize: 30, // Tamaño de fuente 30
                    fontWeight: FontWeight.bold), // Fuente en negrita
              ),
              Text( // Widget de texto para mostrar "Balance Actual"
                'Balance Actual', // Texto estático
                style: TextStyle(color: Colors.white, fontSize: 18), // Estilo de texto
              ),
              Divider( // Widget de línea divisoria
                color: Color(0xFF2F8B62), // Color de la línea divisoria
                thickness: 2.0, // Grosor de la línea
              ),
              Row( // Fila que contiene información detallada
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alineación principal: espacio entre elementos
                children: [
                  Column( // Columna para el total depositado
                    children: [
                      Text( // Widget de texto para mostrar el total depositado
                        '\$${totalDepositado.toStringAsFixed(2)}', // Formato de texto: total depositado con 2 decimales
                        style: TextStyle(
                            color: Colors.green, // Color de texto verde
                            fontSize: 17, // Tamaño de fuente 17
                            fontWeight: FontWeight.bold), // Fuente en negrita
                      ),
                      Text( // Widget de texto para mostrar "Total depositado"
                        'Total depositado', // Texto estático
                        style: TextStyle(color: Colors.white, fontSize: 13), // Estilo de texto
                      ),
                    ],
                  ),
                  Column( // Columna para el total retirado
                    children: [
                      Text( // Widget de texto para mostrar el total retirado
                        '\$${totalRetirado.toStringAsFixed(2)}', // Formato de texto: total retirado con 2 decimales
                        style: TextStyle(
                            color: Colors.green, // Color de texto verde
                            fontSize: 17, // Tamaño de fuente 17
                            fontWeight: FontWeight.bold), // Fuente en negrita
                      ),
                      Text( // Widget de texto para mostrar "Total Retirado"
                        'Total Retirado', // Texto estático
                        style: TextStyle(color: Colors.white, fontSize: 13), // Estilo de texto
                      ),
                    ],
                  ),
                  Column( // Columna para el número de transacciones
                    children: [
                      Text( // Widget de texto para mostrar el número de transacciones
                        '${totalTransacciones}', // Número de transacciones convertido a texto
                        style: TextStyle(
                            color: Colors.green, // Color de texto verde
                            fontSize: 17, // Tamaño de fuente 17
                            fontWeight: FontWeight.bold), // Fuente en negrita
                      ),
                      Text( // Widget de texto para mostrar "Nº Transacciones"
                        'Nº Transacciones', // Texto estático
                        style: TextStyle(color: Colors.white, fontSize: 13), // Estilo de texto
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
