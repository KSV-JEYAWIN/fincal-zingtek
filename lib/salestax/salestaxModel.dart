class SalesTax {
  int? id;
  double? netPrice;
  double? salesTaxRate;
  double? salesTaxAmount;
  double? totalPrice;
  String? datetime; // Add datetime field

  SalesTax({
    this.id,
    required this.netPrice,
    required this.salesTaxRate,
    required this.salesTaxAmount,
    required this.totalPrice,
    this.datetime, // Add datetime parameter
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'netPrice': netPrice,
      'salesTaxRate': salesTaxRate,
      'salesTaxAmount': salesTaxAmount,
      'totalPrice': totalPrice,
      'datetime': datetime, // Include datetime in the map
    };
  }

  SalesTax.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    netPrice = map['netPrice'];
    salesTaxRate = map['salesTaxRate'];
    salesTaxAmount = map['salesTaxAmount'];
    totalPrice = map['totalPrice'];
    datetime = map['datetime']; // Retrieve datetime from the map
  }
}
