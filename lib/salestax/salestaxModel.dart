class SalesTax {
  int? id;
  double? netPrice;
  double? salesTaxRate;
  double? salesTaxAmount;
  double? totalPrice;
  String? datetime;
  bool? isSelected; // Add isSelected property

  SalesTax({
    this.id,
    required this.netPrice,
    required this.salesTaxRate,
    required this.salesTaxAmount,
    required this.totalPrice,
    this.datetime,
    this.isSelected = false, // Initialize isSelected to false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'netPrice': netPrice,
      'salesTaxRate': salesTaxRate,
      'salesTaxAmount': salesTaxAmount,
      'totalPrice': totalPrice,
      'datetime': datetime,
    };
  }

  SalesTax.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    netPrice = map['netPrice'];
    salesTaxRate = map['salesTaxRate'];
    salesTaxAmount = map['salesTaxAmount'];
    totalPrice = map['totalPrice'];
    datetime = map['datetime'];
  }
}
