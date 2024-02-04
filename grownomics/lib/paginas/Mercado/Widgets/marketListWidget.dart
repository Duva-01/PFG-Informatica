import 'package:flutter/material.dart';
import 'package:grownomics/api/authAPI.dart';
import 'package:grownomics/paginas/Mercado/pagina_accion.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/marketAPI.dart';


class MarketList extends StatefulWidget {
  final Set<String> accionesFavoritas;
  final Function(String) toggleFavorite;
  final bool cargarFavoritas;

  MarketList({
    required this.accionesFavoritas,
    required this.toggleFavorite,
    this.cargarFavoritas = false,
  });

  @override
  _MarketListState createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  int page = 1;
  Map<String, dynamic> acciones = {};
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late String userEmail = "grownomicero@gmail.com";

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? userEmail;
    });
  }
  
 void _loadData() async {
  if (!_isLoading) {
    setState(() => _isLoading = true);

    Map<String, dynamic> newAcciones;
    if (widget.cargarFavoritas) {
      // Cargar acciones favoritas
      int idUsuario = await obtenerIdUsuario(userEmail);
      newAcciones = await obtenerAccionesFavoritas(idUsuario);
    } else {
      // Cargar todas las acciones
      newAcciones = await obtenerAcciones(page);
    }
      if (newAcciones != null) {
        final filteredAcciones = Map<String, dynamic>.fromIterable(
          newAcciones.entries.where((entry) => entry.value["error"] == null),
          key: (entry) => entry.key,
          value: (entry) => entry.value,
        );
        if (mounted) {
          setState(() {
            acciones.addAll(filteredAcciones);
            page++;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          0.7 * _scrollController.position.maxScrollExtent) {
        _loadData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accionesList =
        acciones.values.toList(); // Convierte el mapa de acciones en una lista

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: _isLoading &&
              acciones
                  .isEmpty // Mostrar indicador de carga solo si acciones están vacías
          ? Center(
              // Muestra el indicador de carga en el centro de la pantalla
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: accionesList.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                final accion = accionesList[index];
                final tickerSymbol = acciones.keys.elementAt(index);
                final bool isPositive = (accion?['change'] ?? 0) >= 0;

                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {},
                        leading: Container(
                          width: 100,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFF2F8B62),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              '${accion?['ticker_symbol'] ?? 'Desconocido'}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          '${accion?['name'] ?? 'Desconocido'}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${accion?['current_price']?.toStringAsFixed(2) + '€' ?? 'Desconocido'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cambio: ${accion?['change']?.toStringAsFixed(2) ?? 'Desconocido'} '
                              '(${accion?['change_percent']?.toStringAsFixed(2) ?? 'Desconocido'}%)',
                              style: TextStyle(
                                color: isPositive ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.toggleFavorite(tickerSymbol!);
                              },
                              child: Icon(
                                Icons.star,
                                color: widget.accionesFavoritas
                                        .contains(tickerSymbol)
                                    ? Colors.yellow
                                    : null,
                                size: 30,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetallesAccion(tickerSymbol!)),
                                );
                              },
                              child: Text(
                                'Ver',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.green[800],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
