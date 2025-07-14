class CryptoCoin {
  final String symbol;
  final String name;
  final String fullName;
  final String icon;
  final double rate;
  final double changePct;
  final double change;
  final double volume;
  final double high;
  final double low;
  final double cap;

  CryptoCoin({
    required this.symbol,
    required this.name,
    required this.fullName,
    required this.icon,
    required this.rate,
    required this.changePct,
    required this.change,
    required this.volume,
    required this.high,
    required this.low,
    required this.cap,
  });

  factory CryptoCoin.fromJson(Map<String, dynamic> json) {
    return CryptoCoin(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      icon: json['icon'] as String,
      rate: (json['rate'] as num).toDouble(),
      changePct: (json['change_pct'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      cap: (json['cap'] as num).toDouble(),
    );
  }

  get marketCap => null;
} 