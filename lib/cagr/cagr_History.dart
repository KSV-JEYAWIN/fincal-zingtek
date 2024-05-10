import 'package:flutter/material.dart';
import 'cagrHelper.dart';
import 'cagrModel.dart';
import 'package:fincal/cagr/cagr_screen.dart'; // Import the CAGRScreen widget
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CAGR History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<CAGRModel>>(
        future: dbHelper.getCAGRList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          List<CAGRModel> cagrList = snapshot.data ?? [];
          // Sort the list by date/time in descending order
          cagrList.sort((a, b) =>
              DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));
          return ListView.separated(
            padding: EdgeInsets.all(8.0),
            itemCount: cagrList.length,
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey,
                height: 20,
                thickness: 2,
              );
            },
            itemBuilder: (context, index) {
              final cagrData = cagrList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CAGRScreen(cagr: cagrData),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${_formattedDate(cagrData.dateTime)[0]}',
                                // Month
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                '${_formattedDate(cagrData.dateTime)[1]}',
                                // Day
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                '${_formattedDate(cagrData.dateTime)[2]}',
                                // Year
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
                    SizedBox(width: 8.0),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Initial Investment: ${cagrData.initialInvestment}\nFinal Investment :${cagrData.finalInvestment}\nDuration of Investment :${cagrData.duration} ',
                            style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16.0),
                          ),
                          Text(
                            'CAGR: ${cagrData.cagr}',
                            style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<String> _formattedDate(String dateTime) {
    DateTime date = DateTime.parse(dateTime);
    return [
      "${DateFormat('MMM').format(date)}",
      "${date.day.toString().padLeft(2, '0')}",
      "${date.year.toString()}"
    ];
  }
}
