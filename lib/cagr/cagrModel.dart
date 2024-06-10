class CAGRModel {
  final int id;
  final double initialInvestment;
  final double finalInvestment;
  final double duration;
  final double cagr;
  final String dateTime;
  bool isSelected; // Add isSelected property

  CAGRModel({
    required this.id,
    required this.initialInvestment,
    required this.finalInvestment,
    required this.duration,
    required this.cagr,
    required this.dateTime,
    this.isSelected = false, // Default value for isSelected
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'initialInvestment': initialInvestment,
      'finalInvestment': finalInvestment,
      'duration': duration,
      'cagr': cagr,
      'dateTime': dateTime,
      'isSelected': isSelected ? 1 : 0, // Convert boolean to integer for SQLite
    };
  }
}
