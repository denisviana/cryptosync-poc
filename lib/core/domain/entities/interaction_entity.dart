class Interaction {
  final int? id;
  final String type;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  Interaction({
    required this.type,
    required this.payload,
    required this.timestamp,
    this.id,
  });
}