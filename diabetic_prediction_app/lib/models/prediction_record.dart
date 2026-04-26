class PredictionRecord {
  final int? id;
  final String imagePath;
  final String resultLabel;
  final double confidence;
  final DateTime timestamp;

  PredictionRecord({
    this.id,
    required this.imagePath,
    required this.resultLabel,
    required this.confidence,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'resultLabel': resultLabel,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PredictionRecord.fromMap(Map<String, dynamic> map) {
    return PredictionRecord(
      id: map['id'],
      imagePath: map['imagePath'],
      resultLabel: map['resultLabel'],
      confidence: map['confidence'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
