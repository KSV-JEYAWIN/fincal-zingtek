import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fincal/ci/ci_helper.dart';
import 'package:fincal/ci/ci_history_page.dart';

class CompoundInterestScreen extends StatefulWidget {
  final double? principal;
  final double? rate;
  final double? time;
  final String? compoundFrequency;

  const CompoundInterestScreen({
    Key? key,
    this.principal,
    this.rate,
    this.time,
    this.compoundFrequency,
  }) : super(key: key);

  @override
  _CompoundInterestScreenState createState() => _CompoundInterestScreenState();
}

class _CompoundInterestScreenState extends State<CompoundInterestScreen> {
  final TextEditingController principalController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  String compoundFrequencyValue = 'Monthly';
  String? resultText;

  @override
  void initState() {
    super.initState();
    // Fill the form fields with the received data
    principalController.text = widget.principal?.toString() ?? '';
    rateController.text = widget.rate?.toString() ?? '';
    timeController.text = widget.time?.toString() ?? '';
    compoundFrequencyValue = widget.compoundFrequency ?? 'Monthly';

    // Calculate compound interest when the screen is initialized with data from DB
    if (widget.principal != null &&
        widget.rate != null &&
        widget.time != null) {
      _calculateCompoundInterest(); // Calculate compound interest
    }
  }

  double calculateCompoundInterest(
      double principal, double rate, double time, int compoundFrequency) {
    double compoundInterest = principal *
            (pow((1 + rate / (100 * compoundFrequency)),
                (compoundFrequency * time))) -
        principal;
    return compoundInterest;
  }

  String getFrequencyLabel(String frequency) {
    switch (frequency) {
      case 'Monthly':
        return 'per month';
      case 'Quarterly':
        return 'per quarter';
      case 'Half Year':
        return 'per half year';
      case 'Yearly':
        return 'per year';
      default:
        return '';
    }
  }

  void _calculateCompoundInterest() {
    double principal = double.tryParse(principalController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;
    double time = double.tryParse(timeController.text) ?? 0;
    int compoundFrequency;

    switch (compoundFrequencyValue) {
      case 'Monthly':
        compoundFrequency = 12;
        break;
      case 'Quarterly':
        compoundFrequency = 4;
        break;
      case 'Half Year':
        compoundFrequency = 2;
        break;
      case 'Yearly':
        compoundFrequency = 1;
        break;
      default:
        compoundFrequency = 1;
    }

    double compoundInterest = calculateCompoundInterest(
      principal,
      rate,
      time,
      compoundFrequency,
    );

    setState(() {
      // Update the resultText with the calculated compound interest
      resultText =
          'Compound Interest: \$${compoundInterest.toStringAsFixed(2)} ${getFrequencyLabel(compoundFrequencyValue)}';
    });
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      principalController.clear();
      rateController.clear();
      timeController.clear();
      resultText = null;
      compoundFrequencyValue =
          'Monthly'; // Reset compound frequency to its initial value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Compound Interest Calculator',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: _resetForm,
              child: Text(
                'Reset',
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.history),
              color: Colors.white,
              onPressed: () {
                _navigateToHistory(context);
              },
            ),
          ],
        ),
        iconTheme: IconThemeData(
            color: Colors.white), // Set back arrow icon color to white
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: principalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Principal Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Interest Rate (%)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Time Period (in years)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButtonFormField(
                  value: compoundFrequencyValue,
                  items: ['Monthly', 'Quarterly', 'Half Year', 'Yearly']
                      .map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      compoundFrequencyValue = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Compound Frequency',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Calculate compound interest when the Calculate button is pressed
                  _calculateCompoundInterest();

                  // Store data in the database
                  double principal =
                      double.tryParse(principalController.text) ?? 0;
                  double rate = double.tryParse(rateController.text) ?? 0;
                  double time = double.tryParse(timeController.text) ?? 0;
                  int compoundFrequency;

                  switch (compoundFrequencyValue) {
                    case 'Monthly':
                      compoundFrequency = 12;
                      break;
                    case 'Quarterly':
                      compoundFrequency = 4;
                      break;
                    case 'Half Year':
                      compoundFrequency = 2;
                      break;
                    case 'Yearly':
                      compoundFrequency = 1;
                      break;
                    default:
                      compoundFrequency = 1;
                  }

                  double compoundInterest = calculateCompoundInterest(
                    principal,
                    rate,
                    time,
                    compoundFrequency,
                  );

                  if (compoundInterest > 0) {
                    Map<String, dynamic> compoundInterestData = {
                      'principal_amount': principal,
                      'interest_rate': rate,
                      'time_period': time,
                      'compound_frequency': compoundFrequencyValue,
                      'compound_interest': compoundInterest
                    };

                    DatabaseHelper.insertCompoundInterest(compoundInterestData)
                        .then((value) => print('Data saved to database'))
                        .catchError(
                            (error) => print('Failed to save data: $error'));
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Adjust the radius as needed
                    // You can also use other shape classes like BeveledRectangleBorder or StadiumBorder
                  ),
                ),
                child: const Text('Calculate'),
              ),
              if (resultText != null)
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
                              resultText!,
                            ),
                            SizedBox(height: 8),
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

  @override
  void dispose() {
    principalController.dispose();
    rateController.dispose();
    timeController.dispose();
    super.dispose();
  }
}
