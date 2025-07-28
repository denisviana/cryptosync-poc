class CryptoTicker {
  final String symbol;
  final String name;
  final double price;
  final double percentChange;
  final DateTime lastUpdated;

  CryptoTicker({
    required this.symbol,
    required this.name,
    required this.price,
    required this.percentChange,
    required this.lastUpdated,
  });
}
