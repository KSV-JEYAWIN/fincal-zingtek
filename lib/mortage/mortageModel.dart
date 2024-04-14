class MortgageData {
  int? id;
  double loanAmount;
  double interestRate;
  double loanDuration;
  double monthlyEMI;
  double totalAmountPayable;
  double interestAmount;
  String dateTime;

  MortgageData({
    this.id,
    required this.loanAmount,
    required this.interestRate,
    required this.loanDuration,
    required this.monthlyEMI,
    required this.totalAmountPayable,
    required this.interestAmount,
    String? dateTime,
  }) : dateTime = dateTime ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'loanAmount': loanAmount,
      'interestRate': interestRate,
      'loanDuration': loanDuration,
      'monthlyEMI': monthlyEMI,
      'totalAmountPayable': totalAmountPayable,
      'interestAmount': interestAmount,
      'dateTime': dateTime,
    };
  }

  factory MortgageData.fromMap(Map<String, dynamic> map) {
    return MortgageData(
      id: map['id'],
      loanAmount: map['loanAmount'] ?? 0.0,
      interestRate: map['interestRate'] ?? 0.0,
      loanDuration: map['loanDuration'] ?? 0.0,
      monthlyEMI: map['monthlyEMI'] ?? 0.0,
      totalAmountPayable: map['totalAmountPayable'] ?? 0.0,
      interestAmount: map['interestAmount'] ?? 0.0,
      dateTime: map['dateTime'] ?? DateTime.now().toIso8601String(),
    );
  }
}
