import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'percentage_screen.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      List<Map<String, dynamic>> percentagesList = await databaseHelper
          .queryLatestRows(tableName: 'percentages', limit: 100);
      List<Map<String, dynamic>> incordecList =
          await databaseHelper.queryLatestIncordecRows(limit: 100);

      setState(() {
        // Combine and sort the lists
        history = [...percentagesList, ...incordecList];
        history.sort((a, b) => b['datetime'].compareTo(a['datetime']));

        // Trim the list to only the latest 100 items
        if (history.length > 100) {
          history = history.sublist(0, 100);
        }

        isLoading = false;
        errorMessage = null;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading data: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Percentage History',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : history.isEmpty
                  ? Center(child: Text('No history available'))
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> item = history[index];
                        return GestureDetector(
                          onTap: () {
                            // Determine the default option based on the item title
                            String defaultOption =
                                item['title'] == 'Increase / Decrease'
                                    ? 'increase_decrease'
                                    : item['title']
                                        .toString()
                                        .toLowerCase()
                                        .replaceAll(' ', '_');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PercentageScreen(
                                  selectedOption: defaultOption,
                                  fromValue: item['x'],
                                  toValue: item['y'],
                                  result: item['value'],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: index % 2 == 0
                                ? Colors.blueGrey[100]
                                : Colors.white,
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title:
                                  Text(item['title'] ?? 'Increase / Decrease'),
                              subtitle: Text(
                                'X: ${item['x']}\n'
                                'Y: ${item['y']}\n'
                                'Result: ${item['value']}\n'
                                'Increased Value: ${item['increasedValue'] ?? 'N/A'}\n'
                                'Decreased Value: ${item['decreasedValue'] ?? 'N/A'}',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
