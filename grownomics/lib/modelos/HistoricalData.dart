class HistoricalData {
  final DateTime date;
  final double open;
  final double close;
  final double high;
  final double low;
  final double volume; // Nuevo atributo para el volumen

  HistoricalData({
    required this.date,
    required this.open,
    required this.close,
    required this.high,
    required this.low,
    required this.volume, // Incluye el volumen aquí
  });

  factory HistoricalData.fromJson(Map<String, dynamic> json) {
    // Asegúrate de que las claves coincidan exactamente con cómo están en tu JSON
    return HistoricalData(
      date: DateTime.parse(json['date']), // Asumiendo que json['date'] es una cadena de texto de fecha
      open: json['Open'].toDouble(),
      close: json['Close'].toDouble(),
      high: json['High'].toDouble(),
      low: json['Low'].toDouble(),
      volume: json['Volume'].toDouble(), // Incluye el volumen aquí
    );
  }
}
