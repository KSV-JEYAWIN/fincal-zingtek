import 'package:flutter/material.dart';
import 'package:fincal/profitMargin/profitmaginModel.dart';
import 'package:fincal/profitMargin/profitmarginHelper.dart';
import 'package:fincal/profitMargin/profit_history_Screen.dart';

class ProfitMarginScreen extends StatefulWidget {
  final double? costPrice;
  final double? sellingPrice;
  final int? unitsSold;

  const ProfitMarginScreen(
      {Key? key, this.costPrice, this.sellingPrice, this.unitsSold})
      : super(key: key);

  @override
  _ProfitMarginScreenState createState() => _ProfitMarginScreenState();
}

class _ProfitMarginScreenState extends State<ProfitMarginScreen> {
  TextEditingController costPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController unitsSoldController = TextEditingController();
  double profitAmount = 0;
  double profitPercentage = 0;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form fields with data from the database if available
    if (widget.costPrice != null) {
      costPriceController.text = widget.costPrice!.toString();
    }
    if (widget.sellingPrice != null) {
      sellingPriceController.text = widget.sellingPrice!.toString();
    }
    if (widget.unitsSold != null) {
      unitsSoldController.text = widget.unitsSold!.toString();
    }
    // Calculate profit if data is retrieved from the database or from the history page
    _updateProfit();
  }

  void _updateProfit() {
    double costPrice = double.tryParse(costPriceController.text) ?? 0;
    double sellingPrice = double.tryParse(sellingPriceController.text) ?? 0;
    int unitsSold = int.tryParse(unitsSoldController.text) ?? 0;
    setState(() {
      profitAmount = (sellingPrice - costPrice) * unitsSold;
      profitPercentage = (profitAmount / (costPrice * unitsSold)) * 100;
      // Show the result only if the data is retrieved from the database or when the user clicks the "Calculate and Save" button
      showResult = widget.costPrice != null ||
          widget.sellingPrice != null ||
          widget.unitsSold != null;
    });
  }

  Future<void> _saveToDatabase() async {
    double costPrice = double.tryParse(costPriceController.text) ?? 0;
    double sellingPrice = double.tryParse(sellingPriceController.text) ?? 0;
    int unitsSold = int.tryParse(unitsSoldController.text) ?? 0;

    // Get current datetime
    DateTime currentDateTime = DateTime.now();

    // Create a ProfitMargin object
    ProfitMargin profitMargin = ProfitMargin(
      costPrice: costPrice,
      sellingPrice: sellingPrice,
      unitsSold: unitsSold,
      profitAmount: profitAmount,
      profitPercentage: profitPercentage,
      dateTime: currentDateTime, // Assign current datetime here
    );

    // Insert profitMargin into the database
    await DBHelper.instance.insertProfitMargin(profitMargin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(
            color: Colors.white), // Set back arrow color to white
        title: const Text(
          'Profit Margin',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _resetForm,
            child: Text(
              'Reset',
              style: TextStyle(
                color: Colors.white,
              ),
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
                      HistoryPage(), // Navigate to the HistoryPage
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: costPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cost Price (\$)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _updateProfit(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: sellingPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Selling Price (\$)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _updateProfit(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: unitsSoldController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Units Sold',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _updateProfit(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
              onPressed: () {
                _saveToDatabase();
                setState(() {
                  showResult = true;
                });

              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Calculate'),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: showResult,
              child: FractionallySizedBox(
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //const SizedBox(height: 15),
                          Text(
                            'Profit Amount (\$): $profitAmount',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Profit Percentage (\$): $profitPercentage%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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

  // Function to reset the form
  void _resetForm() {
    setState(() {
      costPriceController.clear();
      sellingPriceController.clear();
      unitsSoldController.clear();
      profitAmount = 0;
      profitPercentage = 0;
      showResult = false;
    });
  }
}
