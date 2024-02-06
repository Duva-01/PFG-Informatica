import 'package:flutter/material.dart';
import 'package:grownomics/api/authAPI.dart';
import 'package:grownomics/api/marketAPI.dart'; // Asegúrate de tener esta API implementada correctamente.
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grownomics/paginas/Mercado/pagina_accion.dart';

class MarketList extends StatefulWidget {
  final String userEmail;

  MarketList({required this.userEmail});

  @override
  _MarketListState createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  int page = 1;
  List<dynamic> acciones = [];
  bool _isLoading = false;
  bool cargarFavoritas = false;
  int idUsuario = 0;
  Set<int> favoritasIds = Set<int>();

  List<dynamic> accionesFiltradas = [];
  bool estaFiltrando = false;

  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerIdUsuario(widget.userEmail).then((id) {
      idUsuario = id;
      _loadFavoritas();
    });
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          0.9 * _scrollController.position.maxScrollExtent) {
        _loadData();
      }
    });
    _searchController.addListener(_filtrarAcciones);
  }

  void _loadData() async {
    if (!_isLoading) {
      setState(() => _isLoading = true);

      try {
        List<dynamic> newAcciones;
        if (cargarFavoritas) {
          newAcciones = await obtenerAccionesFavoritas(idUsuario);
        } else {
          newAcciones = await obtenerAcciones(page);
        }
        setState(() {
          acciones.addAll(newAcciones); // Aquí acciones es List<dynamic>
          page++;
        });
      } catch (e) {
        print(e);
      } finally {
        setState(() => _isLoading = false);
      }
    }
    if (!estaFiltrando) {
      accionesFiltradas = List.from(
          acciones); // Asegura que accionesFiltradas también se actualice cuando no estás filtrando.
    }
  }

  void _filtrarAcciones() {
    final query = _searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      estaFiltrando = true;
      accionesFiltradas = acciones.where((accion) {
        final nombreAccion = accion['name'].toLowerCase();
        return nombreAccion.contains(query);
      }).toList();
    } else {
      estaFiltrando = false;
      accionesFiltradas = List.from(acciones);
    }

    setState(() {});
  }

  Future<void> _loadFavoritas() async {
    try {
      var favoritas = await obtenerAccionesFavoritas(
          idUsuario); // Asegura que esta función devuelve una List<dynamic>
      setState(() {
        // Actualiza el Set de IDs de favoritas
        favoritasIds.clear();
        favoritas.forEach((accion) {
          favoritasIds.add(accion['id']);
        });
      });
    } catch (e) {
      print(
          e); // Considera manejar este error de manera más visible para el usuario
    }
  }

  Future<void> toggleFavorita(int accionId) async {
    setState(() => _isLoading = true);
    try {
      if (favoritasIds.contains(accionId)) {
        await eliminarAccionFavorita(idUsuario, accionId);
        favoritasIds.remove(accionId);
      } else {
        await agregarAccionFavorita(idUsuario, accionId);
        favoritasIds.add(accionId);
      }
      await _loadFavoritas(); // Recarga las favoritas para reflejar el cambio
    } catch (e) {
      print(
          e); // Considera manejar este error de manera más visible para el usuario
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Buscar por nombre',
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                },
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cargarFavoritas = false;
                  acciones.clear();
                  page = 1;
                  _loadData();
                });
              },
              child: Row(
                children: [
                  Text('Todos'),
                  Icon(Icons.assessment_rounded),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cargarFavoritas = true;
                  acciones.clear();
                  page = 1;
                  _loadData();
                });
              },
              child: Row(
                children: [
                  Text('Favoritas'),
                  Icon(Icons.star, color: Colors.yellow),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: estaFiltrando ? accionesFiltradas.length : acciones.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final accion = estaFiltrando ? accionesFiltradas[index] : acciones[index];
                    final bool isPositive = (accion?['change'] ?? 0) >= 0;
                    bool esFavorita = favoritasIds.contains(accion['id']);
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
                                  '${accion['ticker_symbol'] ?? 'Desconocido'}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              '${accion['name'] ?? 'Desconocido'}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${accion['current_price']?.toStringAsFixed(2) + '€' ?? 'Desconocido'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Cambio: ${accion['change']?.toStringAsFixed(2) ?? 'Desconocido'} '
                                  '(${accion['change_percent']?.toStringAsFixed(2) ?? 'Desconocido'}%)',
                                  style: TextStyle(
                                    color:
                                        isPositive ? Colors.green : Colors.red,
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
                                  onTap: () => toggleFavorita(accion['id']),
                                  child: Icon(
                                    Icons.star,
                                    color: esFavorita
                                        ? Colors.yellow
                                        : Colors.grey,
                                    size: 30,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetallesAccion(
                                            accion['ticker_symbol']!),
                                      ),
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filtrarAcciones);
    _scrollController.dispose();
    super.dispose();
  }
}
