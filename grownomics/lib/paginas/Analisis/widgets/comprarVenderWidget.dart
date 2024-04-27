import 'package:flutter/material.dart';
import 'package:grownomics/controladores/marketController.dart';
import 'package:grownomics/controladores/portfolioController.dart';
import 'package:grownomics/modelos/Accion.dart';
import 'package:grownomics/modelos/HistoricalData.dart';

class ComprarVenderWidget extends StatefulWidget {
  final String simboloAccion;
  final String correoElectronico;

  ComprarVenderWidget({
    required this.simboloAccion,
    required this.correoElectronico,
  });

  @override
  _ComprarVenderWidgetState createState() => _ComprarVenderWidgetState();
}

class _ComprarVenderWidgetState extends State<ComprarVenderWidget> {
  int cantidad = 0; // Cantidad de acciones a comprar o vender
  double precio = 0.0;
  TextEditingController _textFieldController = TextEditingController();
  late double balance = 0.0;
  late int accionesRestantes =
      0; // Acciones restantes de la acción seleccionada

  Map<String, dynamic> resumen = {};

  @override
  void initState() {
    super.initState();
    _cargarDatosCartera();
    _cargarAccionesUsuario();
    _cargarResumenAccion();
  }

  // Método para cargar los datos de la cartera del usuario
  void _cargarDatosCartera() async {
    try {
      final datosCartera =
          await CarteraController.obtenerCartera(widget.correoElectronico);
      setState(() {
        balance = datosCartera['saldo'];
      });
    } catch (e) {
      print("Error al cargar los datos de la cartera: $e");
    }
  }

    Future<void> _cargarResumenAccion() async {
    try {
      resumen = await MercadoController.obtenerDatosAccion(widget.simboloAccion);
      setState(() {
        precio = resumen['current_price'];
      print("El precio de la accion es " + precio.toString());
      });
    } catch (e) {
      print("Error al cargar el resumen de la acción: $e");
    }
  }

  // Método para cargar las acciones del usuario y obtener las acciones restantes de la acción seleccionada
  void _cargarAccionesUsuario() async {
    try {
      final List<Accion> acciones =
          await MercadoController.obtenerMisAcciones(widget.correoElectronico);
      Accion? accionSeleccionada;
      for (var accion in acciones) {
        if (accion.codigoticker == widget.simboloAccion) {
          accionSeleccionada = accion;
          break;
        }
      }
      if (accionSeleccionada != null) {
        setState(() {
          accionesRestantes = accionSeleccionada!.accionesRestantes;
        });
      } else {
        // Si no se encuentra ninguna acción coincidente, establece accionesRestantes en 0
        setState(() {
          accionesRestantes = 0;
        });
      }
    } catch (e) {
      print("Error al cargar las acciones del usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.8,
      builder: (_, controller) => Material(
        elevation: 4,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          topRight: Radius.circular(60.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60.0),
              topRight: Radius.circular(60.0),
            ),
          ),
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 50,
                ),
                SizedBox(height: 16),
                Text(
                  "¿Qué desea realizar?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Saldo de mi cartera: ${balance.toStringAsFixed(2)}€",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  "Precio actual de la acción: ${precio.toStringAsFixed(2)}€",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  "Nº de acciones en Cartera: $accionesRestantes",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    hintText: "Cantidad",
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      cantidad = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Total: ${(cantidad * precio).toStringAsFixed(2)}€",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: cantidad <= 0
                          ? null
                          : () async {
                              bool resultado =
                                  await CarteraController.comprarAccion(
                                widget.correoElectronico,
                                widget.simboloAccion,
                                precio,
                                cantidad,
                              );
                              if (resultado) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Compra realizada con éxito"),
                                  ),
                                );
                                setState(() {
                                  cantidad = 0; // Restablece la cantidad a cero
                                });
                                _textFieldController
                                    .clear(); // Restablece el valor del TextField a cero
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Error al realizar la compra"),
                                  ),
                                );
                              }
                            },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            cantidad <= 0 ? Colors.grey : Colors.green),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(16),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      child: Text("Comprar"),
                    ),
                    ElevatedButton(
                      onPressed: cantidad <= 0
                          ? null
                          : () async {
                              bool resultado =
                                  await CarteraController.venderAccion(
                                widget.correoElectronico,
                                widget.simboloAccion,
                                precio,
                                cantidad,
                              );
                              if (resultado) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Venta realizada con éxito"),
                                  ),
                                );
                                setState(() {
                                  cantidad = 0; // Restablece la cantidad a cero
                                });
                                _textFieldController
                                    .clear(); // Restablece el valor del TextField a cero
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error al realizar la venta"),
                                  ),
                                );
                              }
                            },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            cantidad <= 0 ? Colors.grey : Colors.red),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(16),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      child: Text("Vender"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
