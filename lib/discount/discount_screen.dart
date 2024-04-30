import 'package:flutter/material.dart';
import 'DiscountHistoryScreen.dart';
import 'discountHelper.dart';
import 'discountmodel.dart';

class DiscountScreen extends StatefulWidget {
  final Discount? initialDiscount;
  final double? initialDiscountedPrice;
  final double? initialAmountSaved;

  const DiscountScreen({
    Key? key,
    this.initialDiscount,
    this.initialDiscountedPrice,
    this.initialAmountSaved,
  }) : super(key: key);

  @override
  _DiscountScreenState createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  late TextEditingController originalPriceController;
  late TextEditingController discountController;
  double discountedPrice = 0;
  double amountSaved = 0;
  bool showResult = false; // Set initial state to false

  final DiscountDatabaseHelper _databaseHelper = DiscountDatabaseHelper();

  @override
  void initState() {
    super.initState();
    originalPriceController = TextEditingController();
    discountController = TextEditingController();

    if (widget.initialDiscount != null) {
      originalPriceController.text =
          widget.initialDiscount!.originalPrice.toString();
      discountController.text =
          widget.initialDiscount!.discountPercentage.toString();
      discountedPrice = widget.initialDiscountedPrice ?? 0;
      amountSaved = widget.initialAmountSaved ?? 0;

      _calculate(); // Call calculate method to display result card
    }
  }

  @override
  void dispose() {
    originalPriceController.dispose();
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Discount',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _resetForm,
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Reset',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.history,
              size: 30,
            ),
            onPressed: () => _showHistory(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: originalPriceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 18, // Increase font size
                ),
                decoration: InputDecoration(
                  labelText: 'Original Price (\$)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 18, // Increase font size
                ),
                decoration: InputDecoration(
                  labelText: 'Discount Percentage (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Calculate'),
                ),
              ),
              SizedBox(height: 20),
              if (showResult) // Display result card only if showResult is true
                FractionallySizedBox(
                  widthFactor: 0.9, // Adjust the width factor as needed
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0, // Remove default card elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discounted Price (\$): ${discountedPrice.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Amount Saved (\$): ${amountSaved.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetForm() {
    originalPriceController.clear();
    discountController.clear();
    setState(() {
      showResult = false; // Reset showResult to false
      discountedPrice = 0;
      amountSaved = 0;
    });
  }

  void _calculate() {
    try {
      double originalPrice = double.tryParse(originalPriceController.text) ?? 0;
      double discountPercentage = double.tryParse(discountController.text) ?? 0;

      discountedPrice =
          originalPrice - (originalPrice * discountPercentage / 100);
      amountSaved = originalPrice - discountedPrice;

      setState(() {
        showResult = true; // Set showResult to true to display the result card
      });

      // Insert data into the database only if it's not pre-filled
      if (widget.initialDiscount == null) {
        DateTime dateTime = DateTime.now();
        final discount = Discount(
          originalPrice: originalPrice,
          discountPercentage: discountPercentage,
          discountedPrice: discountedPrice,
          amountSaved: amountSaved,
          dateTime: dateTime,
        );
        _insertDiscount(discount);
      }
    } catch (e) {
      print('Error calculating discount: $e');
      // Optionally show a snackbar or dialog to inform the user about the error
    }
  }

  void _insertDiscount(Discount discount) async {
    await _databaseHelper.insertDiscount(discount);
  }

  void _showHistory(BuildContext context) async {
    final List<Discount> discounts = await _databaseHelper.getDiscountHistory();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscountHistoryScreen(discounts: discounts),
      ),
    );
  }
}
