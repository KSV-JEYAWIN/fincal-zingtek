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
  List<InvestmentData> _selectedInvestments = [];
  bool _isAllSelected = false;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: _selectedInvestments.isNotEmpty
            ? Text(
                'Selected item : ${_selectedInvestments.length} ',
                style: TextStyle(color: Colors.white),
              )
            : Text(
                'History',
                style: TextStyle(color: Colors.white),
              ),
        actions: _selectedInvestments.isNotEmpty
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: _deleteSelectedInvestments,
                ),
                IconButton(
                  icon: Icon(Icons.cancel),
                  color: Colors.white,
                  onPressed: _clearSelection,
                ),
              ]
            : [
                if (_selectedInvestments.isEmpty)
                  IconButton(
                    icon: Icon(Icons.select_all),
                    color: Colors.white,
                    onPressed: _selectAll,
                  ),
              ],
      ),
      body: FutureBuilder<List<InvestmentData>>(
        future: _futureInvestmentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          } else {
            List<InvestmentData> investmentDataList = snapshot.data!;

            return ListView.separated(
              itemCount: investmentDataList.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                InvestmentData data = investmentDataList[index];
                // Color? cardColor = _selectedInvestments.contains(data)
                //     ? null
                //     : index.isEven
                //         ? Colors.grey[200]
                //         : Colors.grey[100];
                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      if (_selectedInvestments.isEmpty) {
                        _toggleSelection(
                            data); // Toggle selection when long-pressed
                      }
                    });
                  },
                  onTap: () {
                    if (_selectedInvestments.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReturnOfInvestmentScreen(initialData: data),
                        ),
                      );
                    } else {
                      setState(() {
                        _toggleSelection(data); // Toggle selection when tapped
                      });
                    }
                  },
                  child: Container(
                    //color: cardColor,
                    height: 130, // Adjust the height as needed
                    child: Row(
                      children: [
                        if (_selectedInvestments.isNotEmpty)
                          Checkbox(
                            value: _selectedInvestments.contains(data),
                            onChanged: (bool? value) {
                              setState(() {
                                _toggleSelection(
                                    data); // Toggle selection when checkbox is tapped
                              });
                            },
                          ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            color: _selectedInvestments.contains(data)
                                ? Colors.grey
                                : Colors.green,
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
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),

                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
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

  void _toggleSelection(InvestmentData data) {
    setState(() {
      if (_selectedInvestments.contains(data)) {
        _selectedInvestments.remove(data);
      } else {
        _selectedInvestments.add(data);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedInvestments.clear();
      _isAllSelected = false;
    });
  }

  void _selectAll() {
    setState(() {
      _isAllSelected = true;
    });
    _futureInvestmentData.then((investments) {
      setState(() {
        _selectedInvestments.clear(); // Clear the existing selection
        _selectedInvestments.addAll(investments);
      });
    });
  }

  void _deleteSelectedInvestments() async {
    for (var investment in _selectedInvestments) {
      await DBHelper.deleteInvestmentData(investment.id!);
    }
    setState(() {
      _selectedInvestments.clear();
      _futureInvestmentData = DBHelper.getInvestmentData();
    });
  }
}
