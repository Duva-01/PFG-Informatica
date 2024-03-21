import 'package:flutter/material.dart';
import 'package:grownomics/widgets/tituloWidget.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl para formatear fechas
import 'package:grownomics/api/authAPI.dart';
import 'package:grownomics/modelos/Notificacion.dart';

class PaginaNotificaciones extends StatefulWidget {
  final String correo;

  PaginaNotificaciones({required this.correo});

  @override
  _PaginaNotificacionesState createState() => _PaginaNotificacionesState();
}

class _PaginaNotificacionesState extends State<PaginaNotificaciones> {
  late Future<List<Notificacion>> futureNotificaciones;

  @override
  void initState() {
    super.initState();
    futureNotificaciones = obtenerNotificacionesUsuario(widget.correo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notificaciones',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<Notificacion>>(
        future: futureNotificaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen las notificaciones
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las notificaciones')); // Muestra un mensaje de error si hay un error al obtener las notificaciones
          } else if (snapshot.hasData) {
            // Organizar las notificaciones por día
            Map<String, List<Notificacion>> groupedNotificaciones = {};
            snapshot.data!.forEach((notificacion) {
              final fechaString = notificacion.fecha.split(' ')[0]; // Extraer solo la fecha
              final fecha = DateTime.parse(fechaString);
              final fechaFormateada = DateFormat('dd MMMM yyyy', 'es').format(fecha); // Formatear la fecha
              groupedNotificaciones.putIfAbsent(fechaFormateada, () => []).add(notificacion); // Agrupar las notificaciones por fecha formateada
            });

            return ListView.builder(
              itemCount: groupedNotificaciones.length,
              itemBuilder: (context, index) {
                final fecha = groupedNotificaciones.keys.elementAt(index); // Obtener la fecha del grupo
                final notificaciones = groupedNotificaciones[fecha]!; // Obtener las notificaciones del grupo
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTitulo("$fecha") // Mostrar la fecha como título
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.green), // Separador entre las notificaciones
                      itemCount: notificaciones.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: Text(
                              notificaciones[index].mensaje,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Estilo del mensaje de la notificación
                            ),
                            subtitle: Text(
                              notificaciones[index].fecha,
                              style: TextStyle(color: Colors.white), // Estilo de la fecha de la notificación
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(child: Text('No hay notificaciones')); // Muestra un mensaje si no hay notificaciones
          }
        },
      ),
    );
  }
}
