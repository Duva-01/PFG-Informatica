// Media Móvil Simple
import 'dart:math';

double calcularSMA(List<double> precios, int periodo) {
  final int total = precios.length;
  final int startIdx = max(0, total - periodo);  // asegura que startIdx sea al menos 0
  final double sum = precios.sublist(startIdx).reduce((a, b) => a + b);
  return sum / (total - startIdx);
}


// Media Móvil Exponencial
double calcularEMA(List<double> precios, int periodo) {
  double ema = precios.first;
  final double multiplier = 2.0 / (periodo + 1);
  for (int i = 1; i < precios.length; i++) {
    ema = ((precios[i] - ema) * multiplier) + ema;
  }
  return ema;
}

// Índice de Fuerza Relativa
double calcularRSI(List<double> precios, int periodo) {
  List<double> ganancias = [];
  List<double> perdidas = [];

  for (int i = 1; i < precios.length; i++) {
    final double cambio = precios[i] - precios[i - 1];
    if (cambio > 0) {
      ganancias.add(cambio);
    } else {
      perdidas.add(cambio.abs());
    }
  }

  final double avgGanancia = ganancias.reduce((a, b) => a + b) / periodo;
  final double avgPerdida = perdidas.reduce((a, b) => a + b) / periodo;

  final double rs = avgGanancia / avgPerdida;
  return 100 - (100 / (1 + rs));
}
