import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fincal/salestax/salestaxModel.dart';
import 'package:fincal/salestax/salestaxHelper.dart';
import 'package:fincal/salestax/sales_tax_screen.dart'; // Import SalesTaxScreen

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Tax History',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.green, // Set background color to green
        iconTheme:
            IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: FutureBuilder<List<SalesTax>>(
        future: DatabaseHelper.getAllSalesTax(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final salesTaxList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: salesTaxList.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final salesTax = salesTaxList[index];
                  final formattedDate = _formattedDate(
                      salesTax.datetime!); // Asserting datetime is not null
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SalesTaxScreen(salesTax: salesTax),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            color: Colors.green,
                            elevation: 4, // Add elevation for a shadow effect
                            child: Container(
                              height: 100, // Set a fixed height
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // Center align text
                                children: [
                                  Text(
                                    formattedDate[0], // Month
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors
                                          .white, // Set text color to white in dark mode
                                    ),
                                    textAlign:
                                        TextAlign.center, // Center align text
                                  ),
                                  Text(
                                    formattedDate[1], // Day
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors
                                          .white, // Set text color to white in dark mode
                                    ),
                                    textAlign:
                                        TextAlign.center, // Center align text
                                  ),
                                  Text(
                                    formattedDate[2], // Year
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors
                                          .white, // Set text color to white in dark mode
                                    ),
                                    textAlign:
                                        TextAlign.center, // Center align text
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
                              'Net Price: ${salesTax.netPrice}\nSales Price : ${salesTax.salesTaxRate}',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors
                                        .black, // Set text color to white in dark mode
                              ),
                            ),
                            subtitle: Text(
                              'Sales Tax Amount: ${salesTax.salesTaxAmount}\nTotal Price : ${salesTax.totalPrice}',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors
                                        .black, // Set text color to white in dark mode
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0), // Add ">" icon as trailing
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
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
