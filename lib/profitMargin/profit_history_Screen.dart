import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fincal/profitMargin/profitmaginModel.dart';
import 'package:fincal/profitMargin/profitmarginHelper.dart';
import 'profit_margin_screen.dart'; // Import your ProfitMarginScreen widget

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<ProfitMargin> _profitMargins;
  late List<bool> _selectedItems;
  bool _selectAll = false;
  int _selectedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _profitMargins = await DBHelper.instance.getAllProfitMargins();
    _selectedItems = List.generate(_profitMargins.length, (index) => false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set icon color to white
        ),
        title: _selectedCount > 0
            ? Text('Selected: $_selectedCount',
                style: TextStyle(color: Colors.white))
            : Text('History', style: TextStyle(color: Colors.white)),
        // Set title color to white
        actions: _selectedCount > 0
            ? [
                IconButton(
                  onPressed: _deleteSelectedItems,
                  icon: Icon(Icons.delete),
                  color: Colors.white, // Set icon color to white
                ),
                IconButton(
                  onPressed: _cancelSelection,
                  icon: Icon(Icons.cancel),
                  color: Colors.white, // Set icon color to white
                ),
              ]
            : [
                if (!_selectAll && _profitMargins.isNotEmpty)
                  IconButton(
                    onPressed: _toggleSelectAll,
                    icon: Icon(Icons.select_all),
                    color: Colors.white, // Set icon color to white
                  ),
              ],
      ),
      body: _profitMargins.isEmpty
          ? Center(
              child: Text('No Data'),
            )
          : ListView.builder(
              itemCount: _profitMargins.length,
              itemBuilder: (context, index) {
                ProfitMargin profitMargin = _profitMargins[index];
                return GestureDetector(
                  onTap: () {
                    if (_selectedCount > 0) {
                      setState(() {
                        _selectedItems[index] = !_selectedItems[index];
                        _updateSelectedCount();
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfitMarginScreen(
                            costPrice: profitMargin.costPrice,
                            sellingPrice: profitMargin.sellingPrice,
                            unitsSold: profitMargin.unitsSold,
                          ),
                        ),
                      );
                    }
                  },
                  onLongPress: () {
                    setState(() {
                      _selectedItems[index] = true;
                      _updateSelectedCount();
                    });
                  },
                  child: Row(
                    children: [
                      if (_selectedCount > 0 || _selectAll)
                        Checkbox(
                          value: _selectedItems[index],
                          onChanged: (value) {
                            setState(() {
                              _selectedItems[index] = value!;
                              _updateSelectedCount();
                            });
                          },
                        ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 130, // Adjust the height of the card
                          child: Card(
                            color: _selectedItems[index]
                                ? Colors.grey
                                : Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_formattedDate(profitMargin.dateTime)[0]}',
                                    // Month
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    '${_formattedDate(profitMargin.dateTime)[1]}',
                                    // Day
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    '${_formattedDate(profitMargin.dateTime)[2]}',
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
                            'Cost Price: ${profitMargin.costPrice}\nSelling Price : ${profitMargin.sellingPrice}\nNumber of Unit Sold : ${profitMargin.unitsSold}',
                            style: TextStyle(
                                color: _selectedItems[index]
                                    ? Colors.grey
                                    : Colors.black),
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

  List<String> _formattedDate(DateTime? datetime) {
    final parsedDate = datetime ?? DateTime.now();
    final month = '${DateFormat('MMM').format(parsedDate)}';
    final day = '${DateFormat('dd').format(parsedDate)}';
    final year = '${DateFormat('yyyy').format(parsedDate)}';
    return [month, day, year];
  }

  void _updateSelectedCount() {
    _selectedCount = _selectedItems.where((item) => item).length;
    setState(() {});
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedItems = List.generate(_profitMargins.length, (index) => true);
        _selectedCount = _profitMargins.length;
      } else {
        _selectedItems = List.generate(_profitMargins.length, (index) => false);
        _selectedCount = 0;
      }
    });
  }

  void _cancelSelection() {
    setState(() {
      _selectAll = false;
      _selectedItems = List.generate(_profitMargins.length, (index) => false);
      _selectedCount = 0;
    });
  }

  void _deleteSelectedItems() {
    for (int i = _profitMargins.length - 1; i >= 0; i--) {
      if (_selectedItems[i]) {
        DBHelper.instance.deleteProfitMargin(_profitMargins[i].id!);
        _profitMargins.removeAt(i);
        _selectedItems.removeAt(i);
      }
    }
    _selectedCount = 0;
    setState(() {});
  }
}
