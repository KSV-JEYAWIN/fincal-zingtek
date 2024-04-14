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
            onPressed: () {
              originalPriceController.clear();
              discountController.clear();
              setState(() {
                discountedPrice = 0;
                amountSaved = 0;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
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
            onPressed: () async {
              final List<Discount> discounts =
                  await _databaseHelper.getDiscountHistory();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DiscountHistoryScreen(discounts: discounts),
                ),
              );
            },
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
                decoration: InputDecoration(
                  labelText: 'Original Price',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Discount Percentage',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Set width to fit screen
                child: ElevatedButton(
                  onPressed: () async {
                    double originalPrice =
                        double.tryParse(originalPriceController.text) ?? 0;
                    double discountPercentage =
                        double.tryParse(discountController.text) ?? 0;

                    discountedPrice = originalPrice -
                        (originalPrice * discountPercentage / 100);
                    amountSaved = originalPrice - discountedPrice;

                    DateTime dateTime = DateTime.now();

                    final discount = Discount(
                      originalPrice: originalPrice,
                      discountPercentage: discountPercentage,
                      discountedPrice: discountedPrice,
                      amountSaved: amountSaved,
                      dateTime: dateTime,
                    );
                    await _databaseHelper.insertDiscount(discount);

                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius as needed
                    ),
                  ),
                  child: const Text('Calculate'),
                ),
              ),
              if (discountedPrice != 0.0)
                Card(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discounted Price: ${discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Amount Saved: ${amountSaved.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
