class CompoundInterest {
  int? id;
  double? principalAmount;
  double? interestRate;
  double? timePeriod;
  String? compoundFrequency;
  double? compoundInterest;
  String? datetime;

  CompoundInterest({
    this.id,
    this.principalAmount,
    this.interestRate,
    this.timePeriod,
    this.compoundFrequency,
    this.compoundInterest,
    this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'principal_amount': principalAmount,
      'interest_rate': interestRate,
      'time_period': timePeriod,
      'compound_frequency': compoundFrequency,
      'compound_interest': compoundInterest,
      'datetime': datetime,
    };
  }

  factory CompoundInterest.fromMap(Map<String, dynamic> map) {
    return CompoundInterest(
      id: map['id'],
      principalAmount: map['principal_amount'],
      interestRate: map['interest_rate'],
      timePeriod: map['time_period'],
      compoundFrequency: map['compound_frequency'],
      compoundInterest: map['compound_interest'],
      datetime: map['datetime'],
    );
  }
}
