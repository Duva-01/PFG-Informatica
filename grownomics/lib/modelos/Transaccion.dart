class Transaccion {
  final String accion;
  final String tipo;
  final DateTime fecha;
  final int cantidad;
  final double precio;

  Transaccion({
    required this.accion,
    required this.tipo,
    required this.fecha,
    required this.cantidad,
    required this.precio,
  });

  double get valorTotal => cantidad * precio;

  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      accion: json['accion'],
      tipo: json['tipo'],
      fecha: DateTime.parse(json['fecha']),
      cantidad: json['cantidad'],
      precio: double.parse(json['precio'].toString()),
    );
  }
}
