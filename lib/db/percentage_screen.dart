import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'package:fincal/db/perc_history_page.dart';

class PercentageScreen extends StatefulWidget {
  final String? selectedOption;
  final int? fromValue;
  final int? toValue;
  final double? result;

  const PercentageScreen({
    Key? key,
    this.selectedOption,
    this.fromValue,
    this.toValue,
    this.result,
  }) : super(key: key);

  @override
  _PercentageScreenState createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  Color appBarColor = Colors.green;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  late double percentage = 0.0;
  late double increasedValue = 0.0;
  late double decreasedValue = 0.0;
  late Widget resultCard = Container(); // Added variable to hold result card
  late String _selectedOption; // Local variable to store selected option
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    // Initialize selected option based on provided data
    _selectedOption = widget.selectedOption ?? '';
    databaseHelper = DatabaseHelper.instance;
    // Check if data is pre-filled
    if (widget.fromValue != null && widget.toValue != null) {
      fromController.text = widget.fromValue!.toString();
      toController.text = widget.toValue!.toString();
      calculateResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Percentage Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              // Reset the form
              fromController.clear();
              toController.clear();
              setState(() {
                _selectedOption = '';
                resultCard = Container();
              });
            },
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
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            // Unfocus text fields when tapped outside
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Calculation Type',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                buildRadioButton(
                    'Percent change from X to Y', 'percent_change'),
                buildRadioButton('X is what percent of Y?', 'x_percent_of_y'),
                buildRadioButton(
                    'X is Y percent of what number?', 'x_is_y_percent'),
                buildRadioButton(
                    'Percent difference between X & Y', 'percent_difference'),
                buildRadioButtonWithInput(
                    'Increase/decrease X by Y%', 'increase_decrease'),
                buildRadioButtonWithInput(
                    'What is X percent of Y?', 'x_percent_of_y_input'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: fromController,
                        decoration: const InputDecoration(
                          labelText: 'Enter X',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: toController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Y',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: calculateResult,
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
                ),

                const SizedBox(height: 20),
                // Display the result card
                resultCard,
              ],
            ),
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
                _selectedOption = value as String; // Update local variable
                appBarColor = Colors.green;
              });
            },
            activeColor: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget buildRadioButtonWithInput(String title, String value) {
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
                _selectedOption = value as String; // Update local variable
                appBarColor = Colors.green;
              });
            },
            activeColor: Colors.green,
          ),
        ),
      ],
    );
  }

  void calculateResult() async {
    // Get the values from text fields
    int? fromValue = int.tryParse(fromController.text);
    int? toValue = int.tryParse(toController.text);

    if (fromValue != null && toValue != null) {
      // Perform the calculation based on selected option
      if (_selectedOption == 'percent_change') {
        percentage = ((toValue - fromValue) / fromValue) * 100;
      } else if (_selectedOption == 'x_percent_of_y') {
        percentage = (fromValue / toValue) * 100;
      } else if (_selectedOption == 'x_is_y_percent') {
        percentage = (fromValue * 100) / toValue;
      } else if (_selectedOption == 'percent_difference') {
        if (fromValue != 0) {
          percentage = ((toValue - fromValue) / fromValue).abs() * 100;
        }
      } else if (_selectedOption == 'increase_decrease') {
        if (fromValue != 0) {
          increasedValue = fromValue + (fromValue * (toValue / 100));
          decreasedValue = fromValue - (fromValue * (toValue / 100));
        }
      } else if (_selectedOption == 'x_percent_of_y_input') {
        percentage = (fromValue * toValue) / 100;
      }

      // Insert data into the database
      try {
        if (_selectedOption != 'increase_decrease') {
          await databaseHelper.insertPercentage({
            'title': _selectedOption,
            'x': fromValue,
            'y': toValue,
            'value': percentage,
          });
        } else {
          await databaseHelper.insertIncreaseDecrease({
            'x': fromValue,
            'y': toValue,
            'increasedValue': increasedValue,
            'decreasedValue': decreasedValue,
          });
        }
      } catch (e) {
        print('Error inserting data: $e');
        // Handle error if necessary
      }

      setState(() {
        // Update the state to trigger UI rebuild with the card
        resultCard = Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Result: $percentage'),
                Text('Increased value: $increasedValue'),
                Text('Decreased value: $decreasedValue'),
              ],
            ),
          ),
        );
      });
    }
  }
}
