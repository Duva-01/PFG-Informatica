class Cartera {
  final double saldo;
  final int totalTransacciones;
  final double totalDepositado;
  final double totalRetirado;

  Cartera({
    required this.saldo,
    required this.totalTransacciones,
    required this.totalDepositado,
    required this.totalRetirado,
  });

  factory Cartera.fromJson(Map<String, dynamic> json) {
    return Cartera(
      saldo: json['saldo']?.toDouble() ?? 0.0,
      totalTransacciones: json['total_transacciones']?.toInt() ?? 0,
      totalDepositado: json['total_depositado']?.toDouble() ?? 0.0,
      totalRetirado: json['total_retirado']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saldo': saldo,
      'total_transacciones': totalTransacciones,
      'total_depositado': totalDepositado,
      'total_retirado': totalRetirado,
    };
  }
}
