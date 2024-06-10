import 'package:flutter/material.dart';
import 'package:fincal/mortage/mortageModel.dart';
import 'package:fincal/mortage/mortageHelper.dart';
import 'package:fincal/mortage/mortgage_screen.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final dbHelper = DatabaseHelper();
  List<MortgageData> _mortgageDataList = [];
  Set<int> _selectedIndices = {};
  bool _isAllSelected = false;
  bool _isDarkMode = false;
  bool _isAnyItemSelected = false;

  @override
  void initState() {
    super.initState();
    _fetchMortgageData();
  }

  void _fetchMortgageData() async {
    List<MortgageData> data =
    await dbHelper.getAllMortgageDataOrderedByDateTimeDesc(limit: 100);
    setState(() {
      _mortgageDataList = data;
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        _isAnyItemSelected = _selectedIndices.isNotEmpty;
      } else {
        _selectedIndices.add(index);
        _isAnyItemSelected = true;
      }
    });
  }

  void _deleteSelectedItems() async {
    List<int> idsToDelete =
    _selectedIndices.map((index) => _mortgageDataList[index].id!).toList();
    await dbHelper.deleteMortgageDataByIds(idsToDelete);
    _fetchMortgageData();
    _resetSelection();
  }

  void _resetSelection() {
    setState(() {
      _selectedIndices.clear();
      _isAnyItemSelected = false;
    });
  }

  void _navigateToMortgageScreen(MortgageData data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MortgageScreen(
          preFilledData: data,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: _selectedIndices.isEmpty
            ? const Text(
          'History',
          style: TextStyle(
            color: Colors.white,
          ),
        )
            : Text(
          '${_selectedIndices.length} selected',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: _selectedIndices.isNotEmpty
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteSelectedItems,
          ),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: _resetSelection,
          ),
        ]
            : [
          IconButton(
            icon: Icon(Icons.select_all),
            onPressed: _selectAll,
          ),
        ],
      ),
      body: _mortgageDataList.isEmpty
          ? Center(
        child: Text('No data available'),
      )
          : ListView.separated(
        itemCount: _mortgageDataList.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (context, index) {
          MortgageData data = _mortgageDataList[index];
          bool isSelected = _selectedIndices.contains(index);
          return GestureDetector(
            onTap: () {
              if (_isAnyItemSelected) {
                _toggleSelection(index);
              } else {
                _navigateToMortgageScreen(data);
              }
            },
            onLongPress: () {
              _toggleSelection(index);
            },
            child: Row(
              children: [
                if (_selectedIndices.isNotEmpty)
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSelection(index),
                  ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 130, // Adjust the height of the card
                    child: Card(
                      color: isSelected ? Colors.grey : Colors.green,
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
          );
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

  void _selectAll() {
    setState(() {
      if (_isAllSelected) {
        _selectedIndices.clear();
        _isAnyItemSelected = false;
      } else {
        _selectedIndices = Set<int>.from(
            List.generate(_mortgageDataList.length, (index) => index));
        _isAnyItemSelected = true;
      }
      _isAllSelected = !_isAllSelected;
    });
  }
}
