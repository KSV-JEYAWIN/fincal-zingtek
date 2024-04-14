import 'package:flutter/material.dart';
import 'package:fincal/vat/vatModel.dart';
import 'vatHelper.dart';
import 'vatHistory.dart'; // Import the HistoryPage widget

class VATScreen extends StatefulWidget {
  final VATData? vatData; // Make vatData nullable

  const VATScreen({Key? key, this.vatData}) : super(key: key);

  @override
  _VATScreenState createState() => _VATScreenState();
}

class _VATScreenState extends State<VATScreen> {
  late TextEditingController netPriceController;
  late TextEditingController vatPercentageController;
  double vatAmount = 0;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();

    // Initialize the text editing controllers
    netPriceController = TextEditingController();
    vatPercentageController = TextEditingController();

    // Prefill the form fields if vatData is provided
    if (widget.vatData != null) {
      // Prefill the form fields with the provided data
      netPriceController.text = widget.vatData!.netPrice.toString();
      vatPercentageController.text = widget.vatData!.vatPercentage.toString();
      // Calculate and display result card
      _calculate();
    }
  }

  @override
  void dispose() {
    // Dispose the text editing controllers
    netPriceController.dispose();
    vatPercentageController.dispose();
    super.dispose();
  }

  // Function to reset the form
  void _resetForm() {
    setState(() {
      netPriceController.clear();
      vatPercentageController.clear();
      vatAmount = 0;
      totalPrice = 0;
    });
  }

  // Function to calculate VAT amount and total price
  void _calculate() {
    // Get the values from the text controllers
    double netPrice = double.tryParse(netPriceController.text) ?? 0;
    double vatPercentage = double.tryParse(vatPercentageController.text) ?? 0;

    // Calculate the VAT amount and total price
    double calculatedVatAmount = (netPrice * vatPercentage) / 100;
    double calculatedTotalPrice = netPrice + calculatedVatAmount;

    // Update the state with the calculated values
    setState(() {
      vatAmount = calculatedVatAmount;
      totalPrice = calculatedTotalPrice;
    });
  }

  // Function to save data to the database
  void _saveDataToDatabase() async {
    // Get the values from the text controllers
    double netPrice = double.tryParse(netPriceController.text) ?? 0;
    double vatPercentage = double.tryParse(vatPercentageController.text) ?? 0;

    // Create a VATData object
    VATData data = VATData(
      netPrice: netPrice,
      vatPercentage: vatPercentage,
      vatAmount: vatAmount,
      totalPrice: totalPrice,
      dateTime: DateTime.now().toString(),
    );

    // Insert data into the database
    await DBHelper.instance.insertVATData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'VAT Calculator',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Button to reset the form
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
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(),
                ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: netPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Net Price',
                border: OutlineInputBorder(), // Add border property
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: vatPercentageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'VAT Percentage',
                border: OutlineInputBorder(), // Add border property
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _calculate(); // Calculate VAT amount and total price
                  _saveDataToDatabase(); // Save data to the database
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Calculate',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display the result card if vatAmount and totalPrice are greater than 0
            if (vatAmount > 0 && totalPrice > 0) ...[
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  // Add elevation to create a shadow
                  shadowColor: Colors.black.withOpacity(0.3),
                  // Set shadow color and opacity
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VAT Amount: $vatAmount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total Price: $totalPrice',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
