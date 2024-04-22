import 'package:flutter/material.dart';
import 'package:fincal/db/dbhelper.dart';
import 'perc_history_page.dart';

class PercentageScreen extends StatefulWidget {
  final String selectedOption; // Make selectedOption optional
  final int? fromValue;
  final int? toValue;
  final double? result;
  final double? increasedValue;
  final double? decreasedValue;
  final List<String>? lao;

  const PercentageScreen({
    Key? key,
    this.selectedOption = '',
    this.fromValue,
    this.toValue,
    this.result,
    this.increasedValue,
    this.decreasedValue,
    this.lao,
  }) : super(key: key);

  @override
  _PercentageScreenState createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  late TextEditingController fromController;
  late TextEditingController toController;
  late double percentage;
  late double increasedValue;
  late double decreasedValue;
  late String _selectedOption;
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption ?? '';
    fromController =
        TextEditingController(text: widget.fromValue?.toString() ?? '');
    toController =
        TextEditingController(text: widget.toValue?.toString() ?? '');
    percentage = widget.result ?? 0.0;
    increasedValue = widget.increasedValue ?? 0.0;
    decreasedValue = widget.decreasedValue ?? 0.0;
    databaseHelper = DatabaseHelper.instance;
    fetchDataFromDatabase(); // Fetch data from the database on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Percentage Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Calculation Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              buildRadioButton(
                  'Increase/decrease X by Y%', 'increase_decrease'),
              buildRadioButton('Percent change from X to Y', 'percent_change'),
              buildRadioButton('X is what percent of Y?', 'x_percent_of_y'),
              buildRadioButton(
                  'X is Y percent of what number?', 'x_is_y_percent'),
              buildRadioButton(
                  'Percent difference between X & Y', 'percent_difference'),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: fromController,
                      decoration: InputDecoration(
                        labelText: 'Enter X',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: toController,
                      decoration: InputDecoration(
                        labelText: 'Enter Y',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    calculateResult();
                    storeDataInDatabase();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Calculate'),
                ),
              ),
              SizedBox(height: 20),
              buildResultCard(percentage),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRadioButton(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          leading: Radio(
            value: value,
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value as String;
              });
            },
            activeColor: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget buildResultCard(double result) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Result : ${result.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fetchDataFromDatabase() async {
    try {
      if (_selectedOption == 'increase_decrease') {
        Map<String, dynamic>? increaseDecreaseData =
            await databaseHelper.getIncDecData(
          title: widget.selectedOption,
          xValue: widget.fromValue!,
          yValue: widget.toValue!,
        );

        if (increaseDecreaseData != null) {
          setState(() {
            increasedValue = increaseDecreaseData['increasedValue'];
            decreasedValue = increaseDecreaseData['decreasedValue'];
          });
        }
      } else {
        // Fetch data from the percentages table
        // You can implement this based on your database structure
      }
    } catch (error) {
      print('Error fetching data from database: $error');
    }
  }

  void calculateResult() {
    int? fromValue = int.tryParse(fromController.text);
    int? toValue = int.tryParse(toController.text);

    if (fromValue != null && toValue != null) {
      if (_selectedOption == 'increase_decrease') {
        if (fromValue != 0) {
          increasedValue = fromValue + (fromValue * (toValue / 100));
          decreasedValue = fromValue - (fromValue * (toValue / 100));
          setState(() {
            percentage = 0.0;
          });
          return;
        }
      } else if (_selectedOption == 'percent_change') {
        if (fromValue != 0) {
          percentage = ((toValue - fromValue) / fromValue) * 100;
        }
      } else if (_selectedOption == 'x_percent_of_y') {
        if (toValue != 0) {
          percentage = (fromValue / toValue) * 100;
        }
      } else if (_selectedOption == 'x_is_y_percent') {
        percentage = (fromValue * 100) / toValue;
      } else if (_selectedOption == 'percent_difference') {
        if (fromValue != toValue) {
          percentage = ((toValue - fromValue) / fromValue).abs() * 100;
        }
      } else if (_selectedOption == 'x_percent_of_y_input') {
        percentage = (fromValue * toValue) / 100;
      }

      setState(() {
        increasedValue = 0.0;
        decreasedValue = 0.0;
      });
    }
  }

  void storeDataInDatabase() async {
    int? fromValue = int.tryParse(fromController.text);
    int? toValue = int.tryParse(toController.text);

    if (fromValue != null && toValue != null) {
      try {
        if (_selectedOption == 'increase_decrease') {
          await databaseHelper.insertIncreaseDecrease({
            'title': 'Increase / Decrease X by Y',
            'x': fromValue,
            'y': toValue,
            'increasedValue': increasedValue,
            'decreasedValue': decreasedValue,
          });
        } else {
          String title = '';
          double value = 0.0;
          if (_selectedOption == 'percent_change') {
            title = 'Percent Change';
            value = percentage;
          } else if (_selectedOption == 'x_percent_of_y') {
            title = 'X is what percent of Y';
            value = percentage;
          } else if (_selectedOption == 'x_is_y_percent') {
            title = 'X is Y percent of what number';
            value = percentage;
          } else if (_selectedOption == 'percent_difference') {
            title = 'Percent Difference';
            value = percentage;
          } else if (_selectedOption == 'x_percent_of_y_input') {
            title = 'X percent of Y';
            value = percentage;
          }
          await databaseHelper.insertPercentage({
            'title': title,
            'x': fromValue,
            'y': toValue,
            'value': value,
          });
        }
        // Do not clear text fields after insertion
      } catch (e) {
        print('Error inserting data into the database: $e');
      }
    }
  }
}
