class RecomendacionEstrategia {
  final String estrategia;
  final String descripcion;
  final double equityFinal;
  final double retorno;
  final String recomendacion;

  RecomendacionEstrategia({
    required this.estrategia,
    required this.descripcion,
    required this.equityFinal,
    required this.retorno,
    required this.recomendacion,
  });

  factory RecomendacionEstrategia.fromJson(Map<String, dynamic> json) {
    return RecomendacionEstrategia(
      estrategia: json['estrategia'] as String,
      descripcion: json['descripcion'] as String,
      equityFinal: json['equity_final'].toDouble(),
      retorno: json.containsKey('retorno') ? json['retorno'].toDouble() : 0.0,
      recomendacion: json['recomendacion'] as String,
    );
  }
}
