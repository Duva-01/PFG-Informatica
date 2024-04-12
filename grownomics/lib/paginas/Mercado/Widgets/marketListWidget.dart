import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart'; // Importa el paquete de Flutter para crear interfaces de usuario
import 'package:grownomics/controladores/userController.dart'; // Importa la API de autenticación
import 'package:grownomics/controladores/marketController.dart'; // Importa la API del mercado
import 'package:grownomics/paginas/Analisis/analisisAccionPage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa el paquete para manejar preferencias compartidas
import 'package:grownomics/paginas/Mercado/stockPage.dart'; // Importa la página de detalles de acciones del mercado

class ListaMercado extends StatefulWidget {
  // Define una clase StatefulWidget llamada ListaMercado
  final String
      correoElectronico; // Declara una variable final para almacenar el correo electrónico

  ListaMercado(
      {required this.correoElectronico}); // Constructor de la clase que recibe un parámetro obligatorio

  @override
  _ListaMercadoEstado createState() =>
      _ListaMercadoEstado(); // Método que devuelve una instancia de _ListaMercadoEstado
}

class _ListaMercadoEstado extends State<ListaMercado> {
  int pagina = 1; // Variable para el número de página de la lista de acciones
  List<dynamic> acciones = []; // Lista para almacenar las acciones del mercado
  bool _cargando = false; // Variable para controlar si se están cargando datos
  bool cargarFavoritas =
      false; // Variable para indicar si se están cargando acciones favoritas
  int idUsuario = 0; // Variable para almacenar el ID del usuario
  Set<int> idsFavoritas = Set<
      int>(); // Conjunto para almacenar los IDs de las acciones favoritas del usuario

  List<dynamic> accionesFiltradas =
      []; // Lista para almacenar las acciones filtradas según la búsqueda
  bool filtrando =
      false; // Variable para indicar si se está aplicando un filtro de búsqueda

  ScrollController _controladorScroll =
      ScrollController(); // Controlador para el desplazamiento de la lista
  TextEditingController _controladorBusqueda =
      TextEditingController(); // Controlador para el campo de búsqueda
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogueadoYcargarDatos();
    _controladorScroll.addListener(_scrollListener);
    _controladorBusqueda.addListener(_filtrarAcciones);
  }

  Future<void> _verificarUsuarioLogueadoYcargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;

    if (isUserLoggedIn) {
      UsuarioController.obtenerDatosUsuario(widget.correoElectronico).then((datos) {
        if (mounted) {
          setState(() {
            idUsuario = datos['id'];
          });
          _cargarFavoritas();
        }
      });
    }
    _cargarDatos();
  }

  void _cargarDatos() async {
    // Método para cargar los datos de las acciones del mercado
    if (!_cargando) {
      // Verifica si no se están cargando datos actualmente
      setState(() => _cargando =
          true); // Actualiza el estado para indicar que se están cargando datos

      try {
        // Maneja posibles errores durante la carga de datos
        List<dynamic>
            nuevasAcciones; // Declara una lista para almacenar las nuevas acciones cargadas
        if (cargarFavoritas) {
          // Verifica si se deben cargar solo las acciones favoritas
          nuevasAcciones = await MercadoController.obtenerAccionesFavoritas(
              idUsuario); // Obtiene las acciones favoritas del usuario
        } else {
          // Si no se están cargando acciones favoritas
          nuevasAcciones = await MercadoController.obtenerAcciones(
              pagina); // Obtiene las acciones del mercado de acuerdo a la página actual
        }
        setState(() {
          // Actualiza el estado del widget con las nuevas acciones cargadas
          acciones.addAll(
              nuevasAcciones); // Agrega las nuevas acciones a la lista de acciones
          pagina++; // Incrementa el número de página para cargar más datos en la próxima llamada
        });
      } catch (e) {
        // Captura y maneja cualquier error durante la carga de datos
        print(e); // Imprime el error en la consola
      } finally {
        // Se ejecuta después del bloque try o catch, independientemente de si ocurrió un error o no
        setState(() => _cargando =
            false); // Actualiza el estado para indicar que se ha completado la carga de datos
      }
    }
    if (!filtrando) {
      // Verifica si no se está aplicando un filtro de búsqueda
      accionesFiltradas = List.from(
          acciones); // Actualiza la lista de acciones filtradas con todas las acciones
    }
  }

  void _filtrarAcciones() {
    // Método para filtrar las acciones según el texto de búsqueda
    final consulta = _controladorBusqueda.text
        .toLowerCase(); // Obtiene el texto de búsqueda en minúsculas

    if (consulta.isNotEmpty) {
      // Verifica si la consulta de búsqueda no está vacía
      filtrando =
          true; // Actualiza la variable para indicar que se está aplicando un filtro de búsqueda
      accionesFiltradas = acciones.where((accion) {
        // Filtra las acciones basadas en el nombre
        final nombreAccion = accion['name']
            .toLowerCase(); // Obtiene el nombre de la acción en minúsculas
        return nombreAccion.contains(
            consulta); // Devuelve true si el nombre de la acción contiene la consulta de búsqueda
      }).toList(); // Convierte el resultado a una lista
    } else {
      // Si la consulta de búsqueda está vacía
      filtrando =
          false; // Actualiza la variable para indicar que no se está aplicando un filtro de búsqueda
      accionesFiltradas = List.from(
          acciones); // Actualiza la lista de acciones filtradas con todas las acciones
    }

    setState(
        () {}); // Actualiza el estado del widget para reflejar los cambios en las acciones filtradas
  }

  Future<void> _cargarFavoritas() async {
    // Método para cargar las acciones favoritas del usuario
    try {
      // Maneja posibles errores durante la carga de las acciones favoritas
      var favoritas = await MercadoController.obtenerAccionesFavoritas(
          idUsuario); // Obtiene las acciones favoritas del usuario
      setState(() {
        // Actualiza el estado del widget con las acciones favoritas obtenidas
        idsFavoritas.clear(); // Limpia el conjunto de IDs de acciones favoritas
        favoritas.forEach((accion) {
          // Itera sobre cada acción favorita
          idsFavoritas.add(
              accion['id']); // Agrega el ID de la acción favorita al conjunto
        });
      });
    } catch (e) {
      // Captura y maneja cualquier error durante la carga de las acciones favoritas
      print(e); // Imprime el error en la consola
    }
  }

  Future<void> alternarFavorita(int idAccion) async {
    // Método para alternar el estado de una acción como favorita o no favorita
    setState(() => _cargando =
        true); // Actualiza el estado para indicar que se está realizando la alternancia de favorita

    try {
      // Maneja posibles errores durante la alternancia de favorita
      if (idsFavoritas.contains(idAccion)) {
        // Verifica si la acción ya está marcada como favorita
        await MercadoController.eliminarAccionFavorita(idUsuario,
            idAccion); // Elimina la acción de la lista de favoritas del usuario
        idsFavoritas.remove(
            idAccion); // Remueve el ID de la acción de las acciones favoritas
      } else {
        // Si la acción no está marcada como favorita
        await MercadoController.agregarAccionFavorita(idUsuario,
            idAccion); // Agrega la acción a la lista de favoritas del usuario
        idsFavoritas.add(
            idAccion); // Agrega el ID de la acción a las acciones favoritas
      }
      await _cargarFavoritas(); // Recarga las acciones favoritas para reflejar el cambio
    } catch (e) {
      // Captura y maneja cualquier error durante la alternancia de favorita
      print(e); // Imprime el error en la consola
    } finally {
      // Se ejecuta después del bloque try o catch, independientemente de si ocurrió un error o no
      setState(() => _cargando =
          false); // Actualiza el estado para indicar que se ha completado la alternancia de favorita
    }
  }

  void _scrollListener() {
    if (_controladorScroll.position.pixels >=
        0.9 * _controladorScroll.position.maxScrollExtent) {
      _cargarDatos();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Método que construye la interfaz de usuario de la lista de mercado
    return Column(
      // Devuelve un widget Column que contiene todos los elementos de la interfaz de usuario
      children: [
        // Lista de widgets hijos dentro del Column
        Container(
          // Widget contenedor para el campo de búsqueda
          padding: EdgeInsets.all(
              10), // Añade un espacio de relleno de 10 en todos los lados del contenedor
          child: TextField(
            // Widget TextField para ingresar texto de búsqueda
            controller:
                _controladorBusqueda, // Asigna el controlador para manejar el campo de búsqueda
            decoration: InputDecoration(
              // Configuración de decoración para el campo de búsqueda
              labelText: 'Buscar por nombre', // Etiqueta del campo de búsqueda
              suffixIcon: IconButton(
                // Ícono de botón para borrar el texto de búsqueda
                icon:
                    Icon(Icons.clear), // Ícono para borrar el texto de búsqueda
                onPressed: () {
                  // Función que se ejecuta cuando se presiona el botón de borrar
                  _controladorBusqueda
                      .clear(); // Borra el texto del campo de búsqueda
                },
              ),
            ),
          ),
        ),
        Row(
          // Widget Row para alinear los botones de filtrado
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Alinea los botones de manera uniforme en el espacio disponible
          children: [
            // Lista de widgets hijos dentro del Row
            ElevatedButton(
              // Botón elevado para mostrar todas las acciones
              onPressed: () {
                // Función que se ejecuta cuando se presiona el botón
                setState(() {
                  // Actualiza el estado del widget al presionar el botón
                  cargarFavoritas =
                      false; // Cambia la bandera para cargar todas las acciones
                  acciones.clear(); // Limpia la lista de acciones
                  pagina = 1; // Reinicia el contador de páginas a 1
                  _cargarDatos(); // Carga los datos de las acciones
                });
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors
                    .white), // Color del texto según el color primario del tema
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
              ),

              child: Row(
                // Widget Row para alinear el texto e ícono del botón
                children: [
                  // Lista de widgets hijos dentro del Row
                  Text(
                      'Todos'), // Texto del botón para mostrar todas las acciones
                  Icon(Icons
                      .assessment_rounded), // Ícono del botón para mostrar todas las acciones
                ],
              ),
            ),
            if (isUserLoggedIn)
              ElevatedButton(
                // Botón elevado para mostrar solo las acciones favoritas
                onPressed: () {
                  // Función que se ejecuta cuando se presiona el botón
                  setState(() {
                    // Actualiza el estado del widget al presionar el botón
                    cargarFavoritas =
                        true; // Cambia la bandera para cargar solo las acciones favoritas
                    acciones.clear(); // Limpia la lista de acciones
                    pagina = 1; // Reinicia el contador de páginas a 1
                    _cargarDatos(); // Carga los datos de las acciones
                  });
                },

                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors
                      .white), // Color del texto según el color primario del tema
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                ),

                child: Row(
                  // Widget Row para alinear el texto e ícono del botón
                  children: [
                    // Lista de widgets hijos dentro del Row
                    Text(
                        'Favoritas'), // Texto del botón para mostrar solo las acciones favoritas
                    Icon(Icons.star,
                        color: Colors
                            .yellow), // Ícono del botón para mostrar solo las acciones favoritas
                  ],
                ),
              ),
          ],
        ),
        Container(
          // Widget contenedor para la lista de acciones del mercado
          height: MediaQuery.of(context).size.height *
              0.7, // Establece la altura del contenedor al 70% del alto de la pantalla
          child: _cargando // Verifica si se están cargando datos
              ? Center(
                  child: CircularProgressIndicator(
                      color: Color(
                          0xFF2F8B62))) // Muestra un indicador de carga si se están cargando datos
              : ListView.builder(
                  // Constructor de lista para construir una lista de widgets de manera eficiente
                  itemCount:
                      filtrando // Verifica si se está aplicando un filtro de búsqueda
                          ? accionesFiltradas
                              .length // Usa la longitud de la lista de acciones filtradas
                          : acciones
                              .length, // Usa la longitud de la lista de acciones sin filtrar
                  controller:
                      _controladorScroll, // Asigna el controlador de desplazamiento a la lista
                  itemBuilder: (context, index) {
                    // Función que se llama para construir cada elemento de la lista
                    final accion =
                        filtrando // Verifica si se está aplicando un filtro de búsqueda
                            ? accionesFiltradas[
                                index] // Usa la acción filtrada en la posición index
                            : acciones[
                                index]; // Usa la acción sin filtrar en la posición index
                    final bool esPositivo = (accion?['change'] ?? 0) >=
                        0; // Verifica si el cambio de la acción es positivo
                    bool esFavorita = idsFavoritas.contains(
                        accion['id']); // Verifica si la acción es favorita
                    return FadeInUp(
                      child: Container(
                        // Widget contenedor para cada elemento de la lista
                        margin: EdgeInsets.only(
                            top:
                                10), // Establece un margen en la parte superior del contenedor
                        child: Column(
                          // Widget Column para alinear los elementos en una columna vertical
                          children: [
                            // Lista de widgets hijos dentro del Column
                            ListTile(
                              // Widget ListTile para mostrar cada acción en la lista
                              onTap:
                                  () {}, // Función que se ejecuta al hacer clic en la acción
                              leading: Container(
                                // Widget contenedor para el elemento líder (izquierda) de la lista
                                width:
                                    100, // Establece el ancho del contenedor líder
                                height:
                                    60, // Establece la altura del contenedor líder
                                decoration: BoxDecoration(
                                  // Configuración de decoración para el contenedor líder
                                  color: Color(
                                      0xFF2F8B62), // Color de fondo del contenedor líder
                                  borderRadius: BorderRadius.circular(
                                      30), // Establece bordes redondeados
                                ),
                                child: Center(
                                  // Widget Center para alinear el texto en el centro del contenedor líder
                                  child: Text(
                                    // Widget Text para mostrar el símbolo de la acción
                                    '${accion['ticker_symbol'] ?? 'Desconocido'}', // Obtiene el símbolo de la acción o muestra 'Desconocido'
                                    style: TextStyle(
                                      // Estilo de texto para el símbolo de la acción
                                      color: Colors.white, // Color del texto
                                      fontWeight: FontWeight
                                          .bold, // Establece el peso del texto como negrita
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                // Widget Text para mostrar el nombre de la acción
                                '${accion['name'] ?? 'Desconocido'}', // Obtiene el nombre de la acción o muestra 'Desconocido'
                                style: TextStyle(
                                  // Estilo de texto para el nombre de la acción
                                  color: Colors.black, // Color del texto
                                  fontWeight: FontWeight
                                      .bold, // Establece el peso del texto como negrita
                                ),
                              ),
                              subtitle: Column(
                                // Widget Column para alinear los subtítulos en una columna vertical
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Alinea los subtítulos a la izquierda
                                children: [
                                  // Lista de widgets hijos dentro del Column
                                  Text(
                                    // Widget Text para mostrar el precio actual de la acción
                                    '${accion['current_price']?.toStringAsFixed(2) + '€' ?? 'Desconocido'}', // Obtiene el precio actual de la acción o muestra 'Desconocido'
                                    style: TextStyle(
                                      // Estilo de texto para el precio actual de la acción
                                      fontWeight: FontWeight
                                          .bold, // Establece el peso del texto como negrita
                                    ),
                                  ),
                                  Text(
                                    // Widget Text para mostrar el cambio de la acción
                                    'Cambio: ${accion['change']?.toStringAsFixed(2) ?? 'Desconocido'} ' // Obtiene el cambio de la acción o muestra 'Desconocido'
                                    '(${accion['change_percent']?.toStringAsFixed(2) ?? 'Desconocido'}%)', // Obtiene el cambio porcentual de la acción o muestra 'Desconocido'
                                    style: TextStyle(
                                      // Estilo de texto para el cambio de la acción
                                      color: esPositivo
                                          ? Colors.green
                                          : Colors
                                              .red, // Establece el color del texto según el cambio positivo o negativo
                                      fontWeight: FontWeight
                                          .bold, // Establece el peso del texto como negrita
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                // Widget Row para alinear los elementos secundarios (derecha) de la lista
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Alinea los elementos secundarios de manera uniforme en el espacio disponible
                                mainAxisSize: MainAxisSize
                                    .min, // Establece el tamaño principal como mínimo
                                children: [
                                  // Lista de widgets hijos dentro del Row
                                  GestureDetector(
                                    // Widget GestureDetector para detectar gestos en el ícono de favorito
                                    onTap: () => alternarFavorita(accion[
                                        'id']), // Función que se ejecuta al hacer clic en el ícono de favorito
                                    child: Icon(
                                      // Widget Icon para mostrar el ícono de favorito
                                      Icons
                                          .star, // Ícono de estrella para indicar una acción favorita
                                      color: esFavorita
                                          ? Colors.yellow
                                          : Colors
                                              .grey, // Establece el color del ícono según la acción sea favorita o no
                                      size: 30, // Establece el tamaño del ícono
                                    ),
                                  ),
                                  ElevatedButton(
                                    // Botón elevado para ver detalles de la acción
                                    onPressed: () {
                                      // Función que se ejecuta al presionar el botón
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AnalisisAccionPage(
                                            simboloAccion:
                                                accion['ticker_symbol'],
                                            correoElectronico:
                                                widget.correoElectronico,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty
                                          .all<Color>(Colors
                                              .white), // Color del texto según el color primario del tema
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Text(
                                      // Widget Text para mostrar el texto del botón
                                      'Ver', // Texto del botón para ver detalles de la acción
                                      style: TextStyle(
                                        // Estilo de texto para el texto del botón
                                        color: Colors.white, // Color del texto
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              // Widget Divider para agregar una línea divisoria entre cada elemento de la lista
                              thickness:
                                  2, // Establece el grosor de la línea divisoria
                              color: Colors.green[
                                  800], // Establece el color de la línea divisoria
                            ),
                          ],
                        ),
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
    // Método que se llama al eliminar el widget del árbol de widgets
    _controladorBusqueda.removeListener(
        _filtrarAcciones); // Elimina el listener del campo de búsqueda para evitar fugas de memoria
    _controladorScroll
        .dispose(); // Libera los recursos del controlador de desplazamiento
    super.dispose(); // Llama al método dispose de la clase padre
  }
}
