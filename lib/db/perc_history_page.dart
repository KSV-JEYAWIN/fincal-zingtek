import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'percentage_screen.dart';
import 'package:intl/intl.dart';

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
        history = [...percentagesList, ...incordecList];
        history.sort((a, b) => b['datetime'].compareTo(a['datetime']));

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
                            navigateToPercentageScreen(item);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Card(
                                  color: Colors.green,
                                  elevation: 4,
                                  child: Container(
                                    height: 100,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_formattedDate(item['datetime'])[0]}\n${_formattedDate(item['datetime'])[1]}\n${_formattedDate(item['datetime'])[2]}',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                flex: 3,
                                child: ListTile(
                                  title: Text(
                                    'X: ${item['x']}\nY : ${item['y']}',
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (item.containsKey('value'))
                                        Text('Result: ${item['value']}'),
                                      if (item.containsKey('increasedValue'))
                                        Text(
                                            'Increased Value: ${item['increasedValue']}'),
                                      if (item.containsKey('decreasedValue'))
                                        Text(
                                            'Decreased Value: ${item['decreasedValue']}'),
                                      Text(
                                        ' ${item['title']}',
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold, // Make it bold
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }

  void navigateToPercentageScreen(Map<String, dynamic> item) {
    print('Item: $item');
    print('Title: ${item['title']}');
    print('X: ${item['x']}');
    print('Y: ${item['y']}');
    print('Increased Value: ${item['increasedValue']}');
    print('Decreased Value: ${item['decreasedValue']}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PercentageScreen(
          selectedOption: item['title'],
          fromValue: item['x'],
          toValue: item['y'],
          increasedValue: item['increasedValue'] != null
              ? item['increasedValue'].toDouble()
              : null,
          decreasedValue: item['decreasedValue'] != null
              ? item['decreasedValue'].toDouble()
              : null,
        ),
      ),
    );
  }

  List<String> _formattedDate(String datetime) {
    final parsedDate = DateTime.parse(datetime);
    final month = DateFormat('MMM').format(parsedDate);
    final day = DateFormat('dd').format(parsedDate);
    final year = DateFormat('yyyy').format(parsedDate);
    return [month, day, year];
  }
}
