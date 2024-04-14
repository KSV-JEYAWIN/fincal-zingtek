class ProfitMargin {
  final int? id;
  final double costPrice;
  final double sellingPrice;
  final int unitsSold;
  final double profitAmount;
  final double profitPercentage;
  final DateTime dateTime;

  ProfitMargin({
    this.id,
    required this.costPrice,
    required this.sellingPrice,
    required this.unitsSold,
    required this.profitAmount,
    required this.profitPercentage,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'unitsSold': unitsSold,
      'profitAmount': profitAmount,
      'profitPercentage': profitPercentage,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory ProfitMargin.fromMap(Map<String, dynamic> map) {
    try {
      return ProfitMargin(
        id: map['id'],
        costPrice: map['costPrice'] != null ? map['costPrice'].toDouble() : 0.0,
        sellingPrice:
            map['sellingPrice'] != null ? map['sellingPrice'].toDouble() : 0.0,
        unitsSold: map['unitsSold'] != null ? map['unitsSold'] : 0,
        profitAmount:
            map['profitAmount'] != null ? map['profitAmount'].toDouble() : 0.0,
        profitPercentage: map['profitPercentage'] != null
            ? map['profitPercentage'].toDouble()
            : 0.0,
        dateTime: DateTime.parse(map['dateTime']),
      );
    } catch (e) {
      // Handle parsing errors
      print('Error parsing date: $e');
      return ProfitMargin(
        id: map['id'],
        costPrice: map['costPrice'] != null ? map['costPrice'].toDouble() : 0.0,
        sellingPrice:
            map['sellingPrice'] != null ? map['sellingPrice'].toDouble() : 0.0,
        unitsSold: map['unitsSold'] != null ? map['unitsSold'] : 0,
        profitAmount:
            map['profitAmount'] != null ? map['profitAmount'].toDouble() : 0.0,
        profitPercentage: map['profitPercentage'] != null
            ? map['profitPercentage'].toDouble()
            : 0.0,
        dateTime: DateTime.now(), // Use current date as fallback
      );
    }
  }
}
