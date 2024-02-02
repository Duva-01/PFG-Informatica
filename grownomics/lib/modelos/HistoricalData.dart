class HistoricalData {
  final DateTime date;
  final double open;
  final double close;
  final double high;
  final double low;

  HistoricalData(this.date, this.open, this.close, this.high, this.low);

  factory HistoricalData.fromJson(Map<String, dynamic> json) {
    return HistoricalData(
      DateTime.parse(json['date']),
      json['Open'],
      json['Close'],
      json['High'],
      json['Low'],
    );
  }
}
