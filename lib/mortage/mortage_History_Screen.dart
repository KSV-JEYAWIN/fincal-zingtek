import 'package:flutter/material.dart';
import 'package:fincal/mortage/mortageModel.dart';
import 'package:fincal/mortage/mortageHelper.dart';
import 'package:fincal/mortage/mortgage_screen.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<MortgageData>>(
        future: dbHelper.getAllMortgageDataOrderedByDateTimeDesc(limit: 100),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<MortgageData> mortgageDataList = snapshot.data ?? [];
            if (mortgageDataList.isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            } else {
              return ListView.separated(
                itemCount: mortgageDataList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (context, index) {
                  MortgageData? data = mortgageDataList[index];
                  Color cardColor =
                      index % 2 == 0 ? Colors.blueGrey[100]! : Colors.white;
                  // Determine text color based on the theme brightness
                  Color textColor =
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MortgageScreen(
                            preFilledData: data,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 150, // Adjust the height as needed
                            child: Card(
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${_formattedDate(data.dateTime)[0]}',
                                      // Month
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      '${_formattedDate(data.dateTime)[1]}',
                                      // Day
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      '${_formattedDate(data.dateTime)[2]}',
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
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          flex: 3,
                          child: ListTile(
                            title: Text(
                              'Loan Amount : ${data.loanAmount}\nInterest Rate : ${data.interestRate}\nLoan Duration : ${data.loanDuration}',
                              style: TextStyle(color: textColor),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Monthly EMI: ${data.monthlyEMI}\nTotal Amount Payable: ${data.totalAmountPayable}\nInterest Rate : ${data.interestRate}',
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MortgageScreen(
                                    preFilledData: data,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  List<String> _formattedDate(String datetime) {
    final parsedDate = DateTime.parse(datetime);
    final month = '${DateFormat('MMM').format(parsedDate)}';
    final day = '${DateFormat('dd').format(parsedDate)}';
    final year = '${DateFormat('yyyy').format(parsedDate)}';
    return [month, day, year];
  }
}
