class ScanResultModel {
  final int score;
  final String classification;
  final String scamType;
  final String riskLabel;
  final List<String> reasons;

  ScanResultModel({
    required this.classification,
    required this.reasons,
    required this.riskLabel,
    required this.scamType,
    required this.score
  });

  factory ScanResultModel.fromJSON(Map<String, dynamic> json) {
    return ScanResultModel(
        classification: json['classification'],
        reasons: List<String>.from(json['reasons']),
        riskLabel: json['riskLevel'],
        scamType: json['scamType'],
        score: json['score']);
  }
}