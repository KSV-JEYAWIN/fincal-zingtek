import 'package:flutter/material.dart';
import 'package:fincal/tip_calculator/tipmodel.dart';
import 'package:fincal/tip_calculator/tiphelper.dart';
import 'package:fincal/tip_calculator/tip_history_page.dart';

class TipScreen extends StatefulWidget {
  final Tip? initialTip;

  const TipScreen({Key? key, this.initialTip}) : super(key: key);

  @override
  _TipScreenState createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  final TextEditingController billAmountController = TextEditingController();
  final TextEditingController tipPercentageController = TextEditingController();
  final TextEditingController numberOfPersonsController =
      TextEditingController();

  double tipAmount = 0.0;
  double totalAmount = 0.0;
  double amountPerPerson = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialTip != null) {
      billAmountController.text =
          widget.initialTip!.billAmount.toStringAsFixed(2);
      tipPercentageController.text =
          widget.initialTip!.tipPercentage.toStringAsFixed(0);
      numberOfPersonsController.text =
          widget.initialTip!.numberOfPersons.toStringAsFixed(0);
      _calculateTip(); // Calculate tip when data is retrieved
    }
  }

  void _calculateTip() {
    double billAmount = double.tryParse(billAmountController.text) ?? 0.0;
    double tipPercentage = double.tryParse(tipPercentageController.text) ?? 0.0;
    int numberOfPersons = int.tryParse(numberOfPersonsController.text) ?? 1;

    setState(() {
      tipAmount = (billAmount * tipPercentage) / 100;
      totalAmount = billAmount + tipAmount;
      amountPerPerson = totalAmount / numberOfPersons;
    });
  }

  void _storeTipData() {
    double billAmount = double.tryParse(billAmountController.text) ?? 0.0;
    double tipPercentage = double.tryParse(tipPercentageController.text) ?? 0.0;
    int numberOfPersons = int.tryParse(numberOfPersonsController.text) ?? 1;

    String datetime = DateTime.now().toString();

    Tip tip = Tip(
      billAmount: billAmount,
      tipPercentage: tipPercentage,
      numberOfPersons: numberOfPersons,
      tipAmount: tipAmount,
      totalAmount: totalAmount,
      amountPerPerson: amountPerPerson,
      datetime: datetime,
    );

    // Store data in the database
    DatabaseHelper().insertTip(tip);

    // You can also show a message or perform any other action after storing data if needed
  }

  void _resetForm() {
    setState(() {
      billAmountController.clear();
      tipPercentageController.clear();
      numberOfPersonsController.clear();
      tipAmount = 0.0;
      totalAmount = 0.0;
      amountPerPerson = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Tips Calculator',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _resetForm,
            child: Text(
              'Clear',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
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
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: billAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bill Amount (\$)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: tipPercentageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tip Percentage (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: numberOfPersonsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Persons',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _calculateTip(); // Calculate tip when the "Calculate" button is clicked
                _storeTipData(); // Store data in the database
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                // Text color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the radius as needed
                  // You can also use other shape classes like BeveledRectangleBorder or StadiumBorder
                ),
              ),
              child: const Text('Calculate'),
            ),
            if (tipAmount != 0.0)
              Card(
                margin: const EdgeInsets.only(top: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tip Amount: \$${tipAmount.toStringAsFixed(2)}'),
                      Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
                      Text(
                          'Amount Per Person: \$${amountPerPerson.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    billAmountController.dispose();
    tipPercentageController.dispose();
    numberOfPersonsController.dispose();
    super.dispose();
  }
}
