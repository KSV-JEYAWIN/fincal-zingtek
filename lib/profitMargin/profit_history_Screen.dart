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
        iconTheme: const IconThemeData(color: Colors.white),
        title: _selectedCount > 0
            ? Text(
          'Selected: $_selectedCount',
          style: TextStyle(color: Colors.white),
        )
            : Text('History', style: TextStyle(color: Colors.white)),
        actions: _selectedCount > 0
            ? [
          IconButton(
            onPressed: _deleteSelectedItems,
            icon: const Icon(Icons.delete),
            color: Colors.white,
          ),
          IconButton(
            onPressed: _cancelSelection,
            icon: const Icon(Icons.cancel),
            color: Colors.white,
          ),
        ]
            : [
          if (!_selectAll && _profitMargins.isNotEmpty)
            IconButton(
              onPressed: _toggleSelectAll,
              icon: const Icon(Icons.select_all),
              color: Colors.white,
            ),
        ],
      ),
      body: _profitMargins.isEmpty
          ? const Center(child: Text('No Data'))
          : ListView.separated(
        itemCount: _profitMargins.length,
        separatorBuilder: (context, index) => const Divider(height: 1), // Use a divider between items
        itemBuilder: (context, index) {
          final profitMargin = _profitMargins[index];
          final isSelected = _selectedItems[index];

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
                      color: isSelected ? Colors.grey : Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _formattedDate(profitMargin.dateTime)[0], // Month
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              _formattedDate(profitMargin.dateTime)[1], // Day
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              _formattedDate(profitMargin.dateTime)[2], // Year
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: ListTile(
                    title: Text(
                      'Cost Price: ${profitMargin.costPrice}\nSelling Price: ${profitMargin.sellingPrice}\nUnits Sold: ${profitMargin.unitsSold}',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateSelectedCount() {
    _selectedCount = _selectedItems.where((item) => item).length;
    setState(() {});
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      _selectedItems = List.generate(
        _profitMargins.length,
            (index) => _selectAll,
      );
      _updateSelectedCount();
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

  List<String> _formattedDate(DateTime? datetime) {
    if (datetime == null) {
      return ['', '', ''];
    }

    final parsedDate = datetime;
    final month = DateFormat('MMM').format(parsedDate);
    final day = DateFormat('dd').format(parsedDate);
    final year = DateFormat('yyyy').format(parsedDate);

    return [month, day, year];
  }
}
