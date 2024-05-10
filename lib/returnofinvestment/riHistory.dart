import 'package:flutter/material.dart';
import 'riModel.dart';
import 'riHelper.dart';
import 'return_of_investment_screen.dart';
import 'package:intl/intl.dart'; // Import the ReturnOfInvestmentScreen

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<InvestmentData>> _futureInvestmentData;

  @override
  void initState() {
    super.initState();
    _futureInvestmentData = DBHelper.getInvestmentData();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<InvestmentData>>(
        future: _futureInvestmentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<InvestmentData> investmentDataList = snapshot.data!;
            investmentDataList.sort((a, b) =>
                b.dateTime?.compareTo(a.dateTime ?? DateTime(0)) ?? 0);

            if (investmentDataList.isEmpty) {
              return Center(child: Text('No data available.'));
            } else {
              return ListView.separated(
                itemCount: investmentDataList.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  InvestmentData data = investmentDataList[index];
                  Color cardColor =
                      index.isEven ? Colors.grey[200]! : Colors.grey[100]!;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReturnOfInvestmentScreen(
                                  initialData: data,
                                )),
                      );
                    },
                    child: Container(
                      height: 210, // Adjust the height as needed
                      child: Row(
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
                          SizedBox(width: 8.0),
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              title: Text(
                                'Invested Amount: ${data.investedAmount}\nAmount Returned : ${data.amountReturned}\nAnnual Period : ${data.annualPeriod}',
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Gain of Investment : ${data.totalGain}\nReturn of Investmrnt : ${data.returnOfInvestment}\nPer Year % : ${data.simpleAnnualGrowthRate}',
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReturnOfInvestmentScreen(
                                            initialData: data),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }

  List<String> _formattedDate(DateTime? dateTime) {
    if (dateTime == null) {
      return ['', '', ''];
    }
    final month = DateFormat('MMM').format(dateTime);
    final day = DateFormat('dd').format(dateTime);
    final year = DateFormat('yyyy').format(dateTime);
    return [month, day, year];
  }
}
