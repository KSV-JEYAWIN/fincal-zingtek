import 'package:flutter/material.dart';
import 'package:fincal/returnofinvestment/riModel.dart';
import 'package:fincal/returnofinvestment/riHelper.dart';
import 'riHistory.dart'; // Make sure this import is correct

class ReturnOfInvestmentScreen extends StatefulWidget {
  final InvestmentData? initialData;

  const ReturnOfInvestmentScreen({Key? key, this.initialData})
      : super(key: key);

  @override
  _ReturnOfInvestmentScreenState createState() =>
      _ReturnOfInvestmentScreenState();
}

class _ReturnOfInvestmentScreenState extends State<ReturnOfInvestmentScreen> {
  late TextEditingController investedAmountController;
  late TextEditingController amountReturnedController;
  late TextEditingController annualPeriodController;
  late String result;
  bool showResult = false; // Declare and initialize showResult variable

  @override
  void initState() {
    super.initState();
    investedAmountController = TextEditingController(
      text: widget.initialData?.investedAmount.toString() ?? '',
    );
    amountReturnedController = TextEditingController(
      text: widget.initialData?.amountReturned.toString() ?? '',
    );
    annualPeriodController = TextEditingController(
      text: widget.initialData?.annualPeriod.toString() ?? '',
    );

    // Calculate the result when the data is prefilled
    if (widget.initialData != null) {
      double investedAmount = widget.initialData!.investedAmount;
      double amountReturned = widget.initialData!.amountReturned;
      double annualPeriod = widget.initialData!.annualPeriod;

      double totalGain = amountReturned - investedAmount;
      double returnOfInvestment = (totalGain / investedAmount) * 100;
      double simpleAnnualGrowthRate =
          (totalGain / (investedAmount * annualPeriod)) * 100;

      result = '''
        Total Gain of Investment: $totalGain
        Return of Investment (%): $returnOfInvestment
        Simple Annual Growth Rate per Year (%): $simpleAnnualGrowthRate
      ''';
      showResult = true;
    } else {
      result = '';
    }
  }

  @override
  void dispose() {
    investedAmountController.dispose();
    amountReturnedController.dispose();
    annualPeriodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Return of Investment',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _resetForm,
            child: Text(
              'Clear',
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
                MaterialPageRoute(builder: (context) => HistoryPage()),
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
              controller: investedAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Invested Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: amountReturnedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount Returned',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: annualPeriodController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Annual Period',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  double investedAmount =
                      double.tryParse(investedAmountController.text) ?? 0;
                  double amountReturned =
                      double.tryParse(amountReturnedController.text) ?? 0;
                  double annualPeriod =
                      double.tryParse(annualPeriodController.text) ?? 0;

                  double totalGain = amountReturned - investedAmount;
                  double returnOfInvestment =
                      (totalGain / investedAmount) * 100;
                  double simpleAnnualGrowthRate =
                      (totalGain / (investedAmount * annualPeriod)) * 100;

                  setState(() {
                    result = '''
                      Total Gain of Investment: $totalGain
                      Return of Investment (%): $returnOfInvestment
                      Simple Annual Growth Rate per Year (%): $simpleAnnualGrowthRate
                    ''';
                    showResult = true;
                  });

                  InvestmentData data = InvestmentData(
                    investedAmount: investedAmount,
                    amountReturned: amountReturned,
                    annualPeriod: annualPeriod,
                    totalGain: totalGain,
                    returnOfInvestment: returnOfInvestment,
                    simpleAnnualGrowthRate: simpleAnnualGrowthRate,
                    dateTime: DateTime.now(),
                  );

                  await DBHelper.insertInvestmentData(data);
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
            SizedBox(height: 20),
            if (showResult)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20), // Add top padding
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.5),
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
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        result,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign:
                            TextAlign.left, // Ensure text alignment is left
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
      investedAmountController.clear();
      amountReturnedController.clear();
      annualPeriodController.clear();
      result = '';
      showResult = false;
    });
  }
}
