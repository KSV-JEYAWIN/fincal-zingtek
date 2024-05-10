import 'package:flutter/material.dart';
import 'dart:math';
import 'cagrHelper.dart';
import 'cagrModel.dart';
import 'cagr_History.dart';

class CAGRScreen extends StatefulWidget {
  final CAGRModel? cagr;

  const CAGRScreen({Key? key, this.cagr}) : super(key: key);

  @override
  _CAGRScreenState createState() => _CAGRScreenState();
}

class _CAGRScreenState extends State<CAGRScreen> {
  TextEditingController initialInvestmentController = TextEditingController();
  TextEditingController finalInvestmentController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  double cagr = 0;

  final dbHelper = DatabaseHelper();
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    if (widget.cagr != null) {
      initialInvestmentController.text =
          widget.cagr!.initialInvestment.toString();
      finalInvestmentController.text = widget.cagr!.finalInvestment.toString();
      durationController.text = widget.cagr!.duration.toString();

      _calculateCAGR();
    }
  }

  void _calculateCAGR() {
    double initialInvestment =
        double.tryParse(initialInvestmentController.text) ?? 0;
    double finalInvestment =
        double.tryParse(finalInvestmentController.text) ?? 0;
    double duration = double.tryParse(durationController.text) ?? 0;

    if (initialInvestment != 0 && duration != 0) {
      setState(() {
        cagr =
            (pow((finalInvestment / initialInvestment), (1 / duration)) - 1) *
                100;
        showResult = true;
      });
    }
  }

  void _saveToDatabase() {
    double initialInvestment =
        double.tryParse(initialInvestmentController.text) ?? 0;
    double finalInvestment =
        double.tryParse(finalInvestmentController.text) ?? 0;
    double duration = double.tryParse(durationController.text) ?? 0;

    dbHelper.insertCAGR(CAGRModel(
      id: 0,
      initialInvestment: initialInvestment,
      finalInvestment: finalInvestment,
      duration: duration,
      cagr: cagr,
      dateTime: DateTime.now().toString(),
    ));
  }

  @override
  void dispose() {
    initialInvestmentController.dispose();
    finalInvestmentController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'CAGR',
          style: TextStyle(
            color: Colors.white,
          ),
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
              controller: initialInvestmentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Initial Investment',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: finalInvestmentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Final Investment',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration of Investment (years)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _calculateCAGR();
                  _saveToDatabase();
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
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Calculate',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            if (showResult) ...[
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CAGR: ${cagr.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
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

  void _resetForm() {
    setState(() {
      initialInvestmentController.clear();
      finalInvestmentController.clear();
      durationController.clear();
      cagr = 0;
      showResult = false;
    });
  }
}
