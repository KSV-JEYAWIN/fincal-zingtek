class Tip {
  int? id;
  double billAmount;
  double tipPercentage;
  int numberOfPersons;
  double tipAmount;
  double totalAmount;
  double amountPerPerson;
  String datetime;

  Tip({
    this.id,
    required this.billAmount,
    required this.tipPercentage,
    required this.numberOfPersons,
    required this.tipAmount,
    required this.totalAmount,
    required this.amountPerPerson,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bill_amount': billAmount,
      'tip_percentage': tipPercentage,
      'number_of_persons': numberOfPersons,
      'tip_amount': tipAmount,
      'total_amount': totalAmount,
      'amount_per_person': amountPerPerson,
      'datetime': datetime,
    };
  }

  factory Tip.fromMap(Map<String, dynamic> map) {
    return Tip(
      id: map['id'],
      billAmount: map['bill_amount'],
      tipPercentage: map['tip_percentage'],
      numberOfPersons: map['number_of_persons'],
      tipAmount: map['tip_amount'],
      totalAmount: map['total_amount'],
      amountPerPerson: map['amount_per_person'],
      datetime: map['datetime'],
    );
  }
}
