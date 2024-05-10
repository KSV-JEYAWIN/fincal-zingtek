import 'package:flutter/material.dart';
import 'package:fincal/ci/ci_helper.dart';
import 'package:fincal/ci/compound_interest_screen.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _historyData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchHistoryData();
  }

  Future<void> _fetchHistoryData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Map<String, dynamic>> history =
          await DatabaseHelper.getAllCompoundInterest();
      setState(() {
        _historyData = history;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching history data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'History',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _historyData.isEmpty
              ? Center(child: Text('No history available'))
              : ListView.separated(
                  itemCount: _historyData.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (context, index) {
                    final item = _historyData[index];
                    final parsedDateTime = DateTime.parse(item['datetime']);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompoundInterestScreen(
                              principal: item['principal_amount'],
                              rate: item['interest_rate'],
                              time: item['time_period'],
                              compoundFrequency: item['compound_frequency'],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 150,
                              child: Card(
                                color: Colors.green,
                                elevation: 4,
                                margin: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${_formattedDate(parsedDateTime ?? DateTime.now())[0]}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        '${_formattedDate(parsedDateTime ?? DateTime.now())[1]}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        '${_formattedDate(parsedDateTime ?? DateTime.now())[2]}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              title: Text(
                                'Principal Amount : ${item['principal_amount']}\nInterest Rate : ${item['interest_rate']}\nTime Period : ${item['time_period']}\nCompound Frequency :${item['compound_frequency']}',
                                style: TextStyle(
                                  color: isDarkTheme
                                      ? Colors.white
                                      : Colors
                                          .black, // Adjust text color based on theme
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Compound Interest  : ${item['compound_interest']}',
                                    style: TextStyle(
                                      color: isDarkTheme
                                          ? Colors.white
                                          : Colors
                                              .black, // Adjust text color based on theme
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

  List<String> _formattedDate(DateTime datetime) {
    final month = '${DateFormat('MMM').format(datetime)}';
    final day = '${DateFormat('dd').format(datetime)}';
    final year = '${DateFormat('yyyy').format(datetime)}';
    return [month, day, year];
  }
}
