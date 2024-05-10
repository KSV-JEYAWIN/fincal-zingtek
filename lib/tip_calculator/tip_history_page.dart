import 'package:flutter/material.dart';
import 'package:fincal/tip_calculator/tipmodel.dart';
import 'package:fincal/tip_calculator/tip_screen.dart';
import 'package:fincal/tip_calculator/tiphelper.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Tip History',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Tip>>(
        future: DatabaseHelper().getAllTips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history available'));
          } else {
            List<Tip> tips = snapshot.data!;
            tips.sort((a, b) => b.datetime.compareTo(a.datetime));
            List<Tip> latestTips = tips.take(100).toList();

            return ListView.separated(
              itemCount: latestTips.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (context, index) {
                Tip tip = latestTips[index];
                DateTime dateTime = DateTime.parse(tip.datetime);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TipScreen(initialTip: tip),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Card(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_formattedDate(dateTime)[0]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  '${_formattedDate(dateTime)[1]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  '${_formattedDate(dateTime)[2]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
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
                            'Bill Amount : ${tip.billAmount}\nTip Percentage : ${tip.tipPercentage}\nNumber of Person : ${tip.numberOfPersons}',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tip Amount: ${tip.tipAmount}\nTotal Amount : ${tip.totalAmount}\nAmount Per person : ${tip.amountPerPerson}',
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
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
                                builder: (context) =>
                                    TipScreen(initialTip: tip),
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
