class StockModel {
  final String symbol;
  final String name;
  double price;
  double change;
  List<double> history;
  final double high, low, open, close;
  final int volume;
  final String marketCap;

  StockModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.history,
    required this.high,
    required this.low,
    required this.open,
    required this.close,
    required this.volume,
    required this.marketCap,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      history: (json['history'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      open: (json['open'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: json['volume'],
      marketCap: json['marketCap'],
    );
  }
}