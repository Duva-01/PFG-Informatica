class Accion {
  final String nombre;
  final String codigoticker;
  final int accionesRestantes;
  final double precioActual;

  Accion({
    required this.nombre,
    required this.codigoticker,
    required this.accionesRestantes,
    required this.precioActual,
  });

  factory Accion.fromJson(Map<String, dynamic> json) {
    return Accion(
      nombre: json['nombre'] as String,
      codigoticker: json['codigoticker'] as String,
      accionesRestantes: json['acciones_restantes'] as int,
      precioActual: (json['precio_actual'] as num).toDouble(),
    );
  }
}
