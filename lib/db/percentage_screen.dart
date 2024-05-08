import 'package:flutter/material.dart';
import 'package:fincal/db/dbhelper.dart';
import 'perc_history_page.dart';

class PercentageScreen extends StatefulWidget {
  final String? selectedOption;
  final int? fromValue;
  final int? toValue;
  final double? result;
  final double? increasedValue;
  final double? decreasedValue;

  PercentageScreen({
    Key? key,
    this.selectedOption,
    this.fromValue,
    this.toValue,
    this.result,
    this.increasedValue,
    this.decreasedValue,
  }) : super(key: key);

  @override
  _PercentageScreenState createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  late TextEditingController fromController;
  late TextEditingController toController;
  late double increasedValue;
  late double decreasedValue;
  late double percentage;
  late String _selectedOption;
  late DatabaseHelper databaseHelper;
  late bool _showResult; // Add boolean flag

  String? checking() {
    print(widget.selectedOption);
    if (widget.selectedOption == null) {
      return "Increase/decrease X by Y%";
    } else {
      return widget.selectedOption;
    }
  }

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper.instance;
    _selectedOption = checking()!;
    fromController =
        TextEditingController(text: widget.fromValue?.toString() ?? '');
    toController =
        TextEditingController(text: widget.toValue?.toString() ?? '');
    increasedValue = widget.increasedValue ?? 0.0;
    decreasedValue = widget.decreasedValue ?? 0.0;
    percentage = widget.result ?? 0.0;
    _showResult = false;
    if (widget.fromValue != null && widget.toValue != null) {
      onDataPrefilledFromHistory(); // Call the method when data is prefilled
    } // Initialize _showResult to false
  }

  void calculateResult() {
    int? fromValue = int.tryParse(fromController.text);
    int? toValue = int.tryParse(toController.text);

    if (fromValue != null && toValue != null) {
      if (_selectedOption == 'Increase/decrease X by Y%') {
        increasedValue = fromValue + (fromValue * (toValue / 100));
        decreasedValue = fromValue - (fromValue * (toValue / 100));
        percentage = 0.0; // Reset percentage
      } else {
        percentage = _calculatePercentageResult(fromValue, toValue);
      }

      storeResultInDatabase(fromValue, toValue);

      setState(() {
        _showResult = true; // Set _showResult to true when calculation is done
      }); // Refresh the UI to show the new result
    }
  }

  double _calculatePercentageResult(int fromValue, int toValue) {
    print(_selectedOption);
    switch (_selectedOption) {
      case 'Percent change from X to Y':
        return ((toValue - fromValue) / fromValue) * 100;
      case 'X is what percent of Y?':
        return (fromValue / toValue) * 100;
      case 'X is Y percent of what number?':
        return (fromValue * 100) / toValue;
      case 'Percent difference between X & Y':
        return ((toValue - fromValue).abs() / fromValue) * 100;
      default:
        return 0.0;
    }
  }

  void storeResultInDatabase(int fromValue, int toValue) async {
    try {
      Map<String, dynamic> record;
      String dateTimeNow =
          DateTime.now().toIso8601String(); // Current timestamp

      if (_selectedOption == 'Increase/decrease X by Y%') {
        record = {
          'title': 'Increase/decrease X by Y%',
          'x': fromValue,
          'y': toValue,
          'increasedValue': increasedValue,
          'decreasedValue': decreasedValue,
          'datetime': dateTimeNow,
        };

        await databaseHelper.insertIncreaseDecrease(record);
      } else {
        record = {
          'title': _selectedOption,
          'x': fromValue,
          'y': toValue,
          'value': percentage,
          'datetime': dateTimeNow,
        };

        await databaseHelper.insertPercentage(record);
      }
    } catch (error) {
      print("Error storing result in the database: $error");
      // Optionally, you could use a Snackbar to alert the user of the error
    }
  }

  // Add a method to set _showResult to true when data is prefilled from history
  void onDataPrefilledFromHistory() {
    setState(() {
      _showResult = true; // Set _showResult to true when data is prefilled
    });
  }

  void _resetForm() {
    setState(() {
      fromController.clear();
      toController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Percentage Calculator",
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        actions: [
          TextButton(
            onPressed: _resetForm,
            child: Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(Icons.history,
                color: Colors.white), // Set icon color to white
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.green,
        iconTheme:
            IconThemeData(color: Colors.white), // Set all icon colors to white
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRadioOptions(),
            SizedBox(height: 20),
            buildInputFields(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  calculateResult(); // Call calculateResult function to calculate the result
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
            SizedBox(height: 20, width: 500),
            if (_showResult)
              buildResultCard(), // Conditionally display result card
          ],
        ),
      ),
    );
  }

  Widget buildRadioOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRadioListTile(
            "Increase/decrease X by Y%", "Increase/decrease X by Y%"),
        buildRadioListTile(
            "Percent change from X to Y", "Percent change from X to Y"),
        buildRadioListTile(
            "X is what percent of Y?", "X is what percent of Y?"),
        buildRadioListTile(
            "X is Y percent of what number?", "X is Y percent of what number?"),
        buildRadioListTile("Percent difference between X & Y",
            "Percent difference between X & Y"),
      ],
    );
  }

  Widget buildRadioListTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: _selectedOption, // Set default to "increase_decrease"
      onChanged: (newValue) => setState(() => _selectedOption = newValue!),
      activeColor: Colors.green,
    );
  }

  Widget buildInputFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: fromController,
            decoration: InputDecoration(
              labelText: "Enter X",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: toController,
            decoration: InputDecoration(
              labelText: "Enter Y",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget buildResultCard() {
    return FractionallySizedBox(
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
                if (_selectedOption == "Increase/decrease X by Y%")
                  Column(
                    children: [
                      Text(
                        "Increased Value: ${increasedValue.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Decreased Value: ${decreasedValue.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                if (_selectedOption != "Increase/decrease X by Y%")
                  Text(
                    "Result (\$) : ${percentage.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                // Removed incorrect syntax
              ],
            ),
          ),
        ),
      ),
    );
  }
}
