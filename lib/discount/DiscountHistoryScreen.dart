import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'discountmodel.dart';
import 'package:fincal/discount/discount_screen.dart'; // Import DiscountScreen
import 'package:fincal/discount/discountHelper.dart'; // Import DiscountDatabaseHelper

class DiscountHistoryScreen extends StatefulWidget {
  final List<Discount> discounts;

  const DiscountHistoryScreen({Key? key, required this.discounts})
      : super(key: key);

  @override
  _DiscountHistoryScreenState createState() => _DiscountHistoryScreenState();
}

class _DiscountHistoryScreenState extends State<DiscountHistoryScreen> {
  Set<int> _selectedIndices = Set<int>();
  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: _selectedIndices.isNotEmpty
            ? Text('Selected: ${_selectedIndices.length}',
                style: TextStyle(color: Colors.white))
            : Text('Discount History', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        // Set icon color to white
        actions: <Widget>[
          if (_selectedIndices.isNotEmpty)
            IconButton(
              onPressed: () => _deleteSelectedItems(context),
              icon: Icon(Icons.delete),
              color: Colors.white, // Set icon color to white
            ),
          if (_selectedIndices.isNotEmpty)
            IconButton(
              onPressed: _clearSelection,
              icon: Icon(Icons.cancel),
              color: Colors.white, // Set icon color to white
            ),
          if (_selectedIndices.isEmpty)
            IconButton(
              onPressed: _toggleSelectAll,
              icon: Icon(_selectAll ? Icons.select_all : Icons.select_all),
              color: Colors.white, // Set icon color to white
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.discounts.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(); // Divider between items
                },
                itemBuilder: (context, index) {
                  final discount = widget.discounts[index];
                  final isSelected = _selectedIndices.contains(index);
                  double discountedPrice = discount.originalPrice *
                      (1 - discount.discountPercentage / 100);
                  double amountSaved = discount.originalPrice - discountedPrice;
                  return GestureDetector(
                    onLongPress: () => _toggleSelection(index),
                    onTap: () {
                      if (_selectedIndices.isNotEmpty) {
                        _toggleSelection(index);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscountScreen(
                              initialDiscount: discount,
                              initialDiscountedPrice: discountedPrice,
                              initialAmountSaved: amountSaved,
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        if (_selectedIndices.isNotEmpty)
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) => _toggleSelection(index),
                          ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            color: isSelected ? Colors.grey : Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_formattedDate(discount.dateTime)[0]}',
                                    // Month
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    '${_formattedDate(discount.dateTime)[1]}',
                                    // Day
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    '${_formattedDate(discount.dateTime)[2]}',
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
                              'Original Price : ${discount.originalPrice}\nDiscount Percentage : ${discount.discountPercentage}',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
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
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectAll) {
        _selectedIndices.clear();
      } else {
        _selectedIndices = Set<int>.from(
            Iterable<int>.generate(widget.discounts.length, (i) => i));
      }
      _selectAll = !_selectAll;
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIndices.clear();
    });
  }

  Future<void> _deleteSelectedItems(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Selected Items'),
        content: Text('Are you sure you want to delete the selected items?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final List<Discount> selectedDiscounts =
          _selectedIndices.map((index) => widget.discounts[index]).toList();
      final dbHelper = DiscountDatabaseHelper();
      for (var discount in selectedDiscounts) {
        await dbHelper.deleteDiscount(discount.id!); // Assuming id is not null
      }
      setState(() {
        widget.discounts
            .removeWhere((discount) => selectedDiscounts.contains(discount));
        _selectedIndices.clear();
      });
    }
  }

  List<String> _formattedDate(DateTime datetime) {
    final month = '${DateFormat('MMM').format(datetime)}';
    final day = '${DateFormat('dd').format(datetime)}';
    final year = '${DateFormat('yyyy').format(datetime)}';
    return [month, day, year];
  }
}
