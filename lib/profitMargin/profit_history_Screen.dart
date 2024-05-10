import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fincal/profitMargin/profitmaginModel.dart';
import 'package:fincal/profitMargin/profitmarginHelper.dart';
import 'profit_margin_screen.dart'; // Import your ProfitMarginScreen widget

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<ProfitMargin>>(
        future: DBHelper.instance.getAllProfitMargins(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProfitMargin>? profitMargins = snapshot.data;
            profitMargins?.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
            profitMargins = profitMargins?.take(100).toList();
            return ListView.builder(
              itemCount: (profitMargins?.length ?? 0) * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return Divider(); // Add a divider between items
                }
                final itemIndex = index ~/ 2;
                ProfitMargin? profitMargin = profitMargins?[itemIndex];
                String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                    .format(profitMargin?.dateTime ?? DateTime.now());
                Color textColor =
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfitMarginScreen(
                          costPrice: profitMargin?.costPrice,
                          sellingPrice: profitMargin?.sellingPrice,
                          unitsSold: profitMargin?.unitsSold,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 130, // Adjust the height of the card
                          child: Card(
                            color: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_formattedDate(profitMargin?.dateTime)[0]}',
                                    // Month
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    '${_formattedDate(profitMargin?.dateTime)[1]}',
                                    // Day
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    '${_formattedDate(profitMargin?.dateTime)[2]}',
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
                            'Cost Price: ${profitMargin?.costPrice}\nSelling Price : ${profitMargin?.sellingPrice}\nNumber of Unit Sold : ${profitMargin?.unitsSold}',
                            style: TextStyle(color: textColor),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profit Amount : ${profitMargin?.profitAmount}\nProfit Percentage : ${profitMargin?.profitPercentage}',
                                style: TextStyle(color: textColor),
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
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<String> _formattedDate(DateTime? datetime) {
    final parsedDate = datetime ?? DateTime.now();
    final month = '${DateFormat('MMM').format(parsedDate)}';
    final day = '${DateFormat('dd').format(parsedDate)}';
    final year = '${DateFormat('yyyy').format(parsedDate)}';
    return [month, day, year];
  }
}
