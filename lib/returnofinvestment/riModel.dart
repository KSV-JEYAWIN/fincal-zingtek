class InvestmentData {
  int? id;
  double investedAmount;
  double amountReturned;
  double annualPeriod;
  double totalGain;
  double returnOfInvestment;
  double simpleAnnualGrowthRate;
  DateTime? dateTime;

  InvestmentData({
    this.id,
    required this.investedAmount,
    required this.amountReturned,
    required this.annualPeriod,
    required this.totalGain,
    required this.returnOfInvestment,
    required this.simpleAnnualGrowthRate,
    this.dateTime,
  });

  factory InvestmentData.fromMap(Map<String, dynamic> map) {
    return InvestmentData(
      id: map['id'],
      investedAmount: map['investedAmount'],
      amountReturned: map['amountReturned'],
      annualPeriod: map['annualPeriod'],
      totalGain: map['totalGain'],
      returnOfInvestment: map['returnOfInvestment'],
      simpleAnnualGrowthRate: map['simpleAnnualGrowthRate'],
      dateTime:
          map['dateTime'] != null ? DateTime.parse(map['dateTime']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'investedAmount': investedAmount,
      'amountReturned': amountReturned,
      'annualPeriod': annualPeriod,
      'totalGain': totalGain,
      'returnOfInvestment': returnOfInvestment,
      'simpleAnnualGrowthRate': simpleAnnualGrowthRate,
      'dateTime': dateTime != null ? dateTime!.toIso8601String() : null,
    };
  }
}
