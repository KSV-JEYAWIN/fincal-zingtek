class VATData {
  int? id;
  double netPrice;
  double vatPercentage;
  double vatAmount;
  double totalPrice;
  String dateTime; // New field for combined date and time
  bool isSelected; // New property for selection

  VATData({
    this.id,
    required this.netPrice,
    required this.vatPercentage,
    required this.vatAmount,
    required this.totalPrice,
    required this.dateTime,
    this.isSelected = false, // Initialize isSelected to false
  });

  // Convert VATData object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'netPrice': netPrice,
      'vatPercentage': vatPercentage,
      'vatAmount': vatAmount,
      'totalPrice': totalPrice,
      'dateTime': dateTime,
    };
  }

  // Convert a Map to a VATData object
  factory VATData.fromMap(Map<String, dynamic> map) {
    return VATData(
      id: map['id'],
      netPrice: map['netPrice'],
      vatPercentage: map['vatPercentage'],
      vatAmount: map['vatAmount'],
      totalPrice: map['totalPrice'],
      dateTime: map['dateTime'],
    );
  }
}
