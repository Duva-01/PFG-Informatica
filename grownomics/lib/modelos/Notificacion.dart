class Notificacion {
  final int id;
  final String mensaje;
  final String fecha;

  Notificacion({
    required this.id,
    required this.mensaje,
    required this.fecha,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'] as int,
      mensaje: json['mensaje'] as String,
      fecha: json['fecha'] as String,
    );
  }
}
