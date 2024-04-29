import 'package:flutter/material.dart';
import 'package:fincal/salestax/salestaxModel.dart';
import 'package:fincal/salestax/salestaxHelper.dart';
import 'package:fincal/salestax/satHistory.dart'; // Import HistoryPage

class SalesTaxScreen extends StatefulWidget {
  final SalesTax? salesTax;

  const SalesTaxScreen({Key? key, this.salesTax}) : super(key: key);

  @override
  _SalesTaxScreenState createState() => _SalesTaxScreenState();
}

class _SalesTaxScreenState extends State<SalesTaxScreen> {
  TextEditingController netPriceController = TextEditingController();
  TextEditingController salesTaxRateController = TextEditingController();
  double salesTaxAmount = 0;
  double totalPrice = 0;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill text fields with data from the received SalesTax object if available
    if (widget.salesTax != null) {
      netPriceController.text = widget.salesTax!.netPrice.toString();
      salesTaxRateController.text = widget.salesTax!.salesTaxRate.toString();
      // If data is pre-filled, show the result card
      showResult = true;
      // Calculate sales tax amount and total price
      double netPrice = double.parse(netPriceController.text);
      double salesTaxRate = double.parse(salesTaxRateController.text);
      salesTaxAmount = (netPrice * salesTaxRate) / 100;
      totalPrice = netPrice + salesTaxAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Sales Tax',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _resetForm,
            child: Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.history,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HistoryPage()), // Use HistoryPage here
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: netPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Net Price',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: salesTaxRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Sales Tax Rate (%)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Text(
                  'Calculate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (showResult)
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
                            'Sales Tax Amount: $salesTaxAmount',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Total Price: $totalPrice',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
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
    );
  }

  void _resetForm() {
    setState(() {
      netPriceController.clear();
      salesTaxRateController.clear();
      salesTaxAmount = 0;
      totalPrice = 0;
      showResult = false;
    });
  }

  void _calculate() {
    double netPrice = double.tryParse(netPriceController.text) ?? 0;
    double salesTaxRate = double.tryParse(salesTaxRateController.text) ?? 0;

    // Calculate sales tax amount
    salesTaxAmount = (netPrice * salesTaxRate) / 100;

    // Calculate total price
    totalPrice = netPrice + salesTaxAmount;

    SalesTax salesTax = SalesTax(
      netPrice: netPrice,
      salesTaxRate: salesTaxRate,
      salesTaxAmount: salesTaxAmount,
      totalPrice: totalPrice,
      datetime: DateTime.now().toIso8601String(),
    );

    // Insert data into the database
    DatabaseHelper.insertSalesTax(salesTax);

    // Show the result card
    setState(() {
      showResult = true;
    });
  }
}
