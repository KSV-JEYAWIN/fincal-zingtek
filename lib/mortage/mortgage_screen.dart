import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fincal/mortage/mortageModel.dart';
import 'package:fincal/mortage/mortageHelper.dart';
import 'package:fincal/mortage/mortage_History_Screen.dart';

class MortgageScreen extends StatefulWidget {
  final MortgageData? preFilledData;

  const MortgageScreen({Key? key, this.preFilledData}) : super(key: key);

  @override
  _MortgageScreenState createState() => _MortgageScreenState();
}

class _MortgageScreenState extends State<MortgageScreen> {
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController loanDurationController = TextEditingController();
  late double monthlyEMI = 0.0;
  late double totalAmountPayable = 0.0;
  late double interestAmount = 0.0;
  bool showResultCard = false; // Flag to show/hide result card
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.preFilledData != null) {
      // Set text controllers with pre-filled data
      loanAmountController.text = widget.preFilledData!.loanAmount.toString();
      interestRateController.text =
          widget.preFilledData!.interestRate.toString();
      loanDurationController.text =
          widget.preFilledData!.loanDuration.toString();
      // Calculate mortgage with pre-filled data
      calculateMortgage();
      // Show result card
      showResultCard = true;
    }
  }

  // Calculate mortgage based on input values
  void calculateMortgage() {
    // Get loan amount, interest rate, and loan duration from input fields
    double loanAmount = double.tryParse(loanAmountController.text) ?? 0;
    double interestRate = double.tryParse(interestRateController.text) ?? 0;
    double loanDuration = double.tryParse(loanDurationController.text) ?? 0;

    // Calculate monthly interest rate, total payments, monthly payment, total amount, and interest
    double monthlyInterestRate = interestRate / 1200;
    int totalPayments = (loanDuration * 12).toInt();
    double monthlyPayment = (loanAmount * monthlyInterestRate) /
        (1 - pow(1 + monthlyInterestRate, -totalPayments));
    double totalAmount = monthlyPayment * totalPayments;
    double interest = totalAmount - loanAmount;

    // Update state with calculated values
    setState(() {
      monthlyEMI = monthlyPayment;
      totalAmountPayable = totalAmount;
      interestAmount = interest;
    });

    // Show the result card only if all input fields are filled
    if (loanAmount != 0 && interestRate != 0 && loanDuration != 0) {
      setState(() {
        showResultCard = true;
      });
    } else {
      setState(() {
        showResultCard = false;
      });
    }
  }

  @override
  void dispose() {
    loanAmountController.dispose();
    interestRateController.dispose();
    loanDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Mortgage',
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
                  builder: (context) => HistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: loanAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Loan Amount',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => calculateMortgage(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: interestRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Interest Rate (%)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                // Hide the result card when the user is typing in the interest rate field
                setState(() {
                  showResultCard = false;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: loanDurationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Loan Duration (years)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                // Hide the result card when the user is typing in the loan duration field
                setState(() {
                  showResultCard = false;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Calculate mortgage when button is pressed
                  calculateMortgage();
                  // Create MortgageData object
                  MortgageData mortgageData = MortgageData(
                    loanAmount: double.tryParse(loanAmountController.text) ?? 0,
                    interestRate:
                        double.tryParse(interestRateController.text) ?? 0,
                    loanDuration:
                        double.tryParse(loanDurationController.text) ?? 0,
                    monthlyEMI: monthlyEMI,
                    totalAmountPayable: totalAmountPayable,
                    interestAmount: interestAmount,
                  );

                  // Store data in SQLite
                  await dbHelper.insertMortgageData(mortgageData);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display the result using a card only if showResultCard is true
            if (showResultCard)
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
                            'Monthly EMI: $monthlyEMI',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total Amount Payable: $totalAmountPayable',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Interest Amount: $interestAmount',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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

  // Function to reset the form
  void _resetForm() {
    setState(() {
      loanAmountController.clear();
      interestRateController.clear();
      loanDurationController.clear();
      monthlyEMI = 0.0;
      totalAmountPayable = 0.0;
      interestAmount = 0.0;
      showResultCard = false;
    });
  }
}
