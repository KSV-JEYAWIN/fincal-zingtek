// cagrModel.dart

class CAGRModel {
  final int id;
  final double initialInvestment;
  final double finalInvestment;
  final double duration;
  final double cagr;
  final String dateTime;

  CAGRModel({
    required this.id,
    required this.initialInvestment,
    required this.finalInvestment,
    required this.duration,
    required this.cagr,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'initialInvestment': initialInvestment,
      'finalInvestment': finalInvestment,
      'duration': duration,
      'cagr': cagr,
      'dateTime': dateTime,
    };
  }
}
