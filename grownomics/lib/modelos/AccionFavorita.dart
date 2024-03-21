class AccionFavorita {
  final String nombre;
  final double precioActual;
  final double cambio;
  final double porcentajeCambio;
  final String simboloTicker;

  AccionFavorita({
    required this.nombre,
    required this.precioActual,
    required this.cambio,
    required this.porcentajeCambio,
    required this.simboloTicker,
  });

  factory AccionFavorita.fromJson(Map<String, dynamic> json) {
    return AccionFavorita(
      nombre: json['name'] ?? 'Desconocido',
      precioActual: json['current_price']?.toDouble() ?? 0.0,
      cambio: json['change']?.toDouble() ?? 0.0,
      porcentajeCambio: json['change_percent']?.toDouble() ?? 0.0,
      simboloTicker: json['ticker_symbol'] ?? '',
    );
  }
}
