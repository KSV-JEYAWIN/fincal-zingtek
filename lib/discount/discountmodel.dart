
class Discount {
  int? id;
  double originalPrice;
  double discountPercentage;
  double discountedPrice;
  double amountSaved;
  DateTime dateTime;

  Discount({
    this.id,
    required this.originalPrice,
    required this.discountPercentage,
    required this.discountedPrice,
    required this.amountSaved,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'discountedPrice': discountedPrice,
      'amountSaved': amountSaved,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id'],
      originalPrice: map['originalPrice'],
      discountPercentage: map['discountPercentage'],
      discountedPrice: map['discountedPrice'],
      amountSaved: map['amountSaved'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
