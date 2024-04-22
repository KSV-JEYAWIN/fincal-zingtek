import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fincal/salestax/salestaxModel.dart';
import 'package:fincal/salestax/salestaxHelper.dart';
import 'package:fincal/salestax/sales_tax_screen.dart'; // Import SalesTaxScreen

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<SalesTax> _salesTaxList = [];
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _retrieveSalesTaxData();
  }

  Future<void> _retrieveSalesTaxData() async {
    final salesTaxList = await DatabaseHelper.getAllSalesTax();
    setState(() {
      _salesTaxList = salesTaxList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: _isSelecting
            ? Text('Selected ${_selectedItemCount()}',
                style: TextStyle(color: Colors.white))
            : Text(
                'Sales Tax History',
                style: TextStyle(color: Colors.white),
              ),
        actions: _buildAppBarActions(),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _salesTaxList.isEmpty
          ? Center(
              child: Text(
                'No sales tax data available',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(8.0),
              itemCount: _salesTaxList.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final salesTax = _salesTaxList[index];
                return GestureDetector(
                  onLongPress: () {
                    _startSelection(salesTax);
                  },
                  onTap: () {
                    if (_isSelecting) {
                      _toggleSelection(salesTax);
                    } else {
                      _navigateToDetails(salesTax);
                    }
                  },
                  child: buildHistoryListItem(salesTax, isDarkMode),
                );
              },
            ),
    );
  }

  // Function to build history list item
  Widget buildHistoryListItem(SalesTax salesTax, bool isDarkMode) {
    return Row(
      children: [
        if (_isSelecting)
          Checkbox(
            value: salesTax.isSelected ?? false,
            onChanged: (newValue) {
              _toggleSelection(salesTax);
            },
          ),
        Expanded(
          flex: 1,
          child: Card(
            color: salesTax.isSelected ?? false ? Colors.grey : Colors.green,
            // Set color to grey if selected, otherwise green
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${_formattedDate(salesTax.datetime)[0]}', // Month
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '${_formattedDate(salesTax.datetime)[1]}', // Day
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '${_formattedDate(salesTax.datetime)[2]}', // Year
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
              'Net Price: ${salesTax.netPrice}\n Sales Tax Rate : ${salesTax.salesTaxRate}',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
        ),
      ],
    );
  }

  // Function to start selection mode
  void _startSelection(SalesTax salesTax) {
    setState(() {
      _isSelecting = true;
      salesTax.isSelected = true;
    });
  }

  // Function to toggle selection of an item
  void _toggleSelection(SalesTax salesTax) {
    setState(() {
      salesTax.isSelected = !salesTax.isSelected!;
    });
  }

  // Function to navigate to details screen
  void _navigateToDetails(SalesTax salesTax) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalesTaxScreen(salesTax: salesTax),
      ),
    );
  }

  // Function to build app bar actions based on selection mode
  List<Widget> _buildAppBarActions() {
    if (_isSelecting) {
      return [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: _deleteSelectedItems,
        ),
        IconButton(
          icon: Icon(Icons.cancel),
          onPressed: _cancelSelection,
        ),
      ];
    } else {
      return [
        GestureDetector(
          onTap: () {
            // Enter selection mode when long-pressed
            setState(() {
              _isSelecting = true;
              // Select all items
              _selectAllItems();
            });
          },
          child: IconButton(
            icon: Icon(Icons.select_all),
            onPressed: null, // Disable regular tap
            tooltip: 'Select All',
          ),
        ),
      ];
    }
  }

  // Function to count selected items
  int _selectedItemCount() {
    return _salesTaxList
        .where((salesTax) => salesTax.isSelected ?? false)
        .length;
  }

  // Function to delete selected items
  void _deleteSelectedItems() async {
    final selectedItems = _salesTaxList
        .where((salesTax) => salesTax.isSelected ?? false)
        .toList();
    for (var item in selectedItems) {
      await DatabaseHelper.deleteSalesTax(item.id);
    }
    setState(() {
      _salesTaxList.removeWhere((salesTax) => salesTax.isSelected ?? false);
      _isSelecting = false;
    });
  }

  // Function to cancel selection mode
  void _cancelSelection() {
    setState(() {
      _salesTaxList.forEach((salesTax) {
        salesTax.isSelected = false;
      });
      _isSelecting = false;
    });
  }

  // Function to select all items
  void _selectAllItems() {
    setState(() {
      _salesTaxList.forEach((salesTax) {
        salesTax.isSelected = true;
      });
    });
  }

  // Function to format date
  List<String> _formattedDate(String? datetime) {
    final parsedDate =
        DateTime.parse(datetime!); // Use the non-null assertion operator !
    final month = '${DateFormat('MMM').format(parsedDate)}';
    final day = '${DateFormat('dd').format(parsedDate)}';
    final year = '${DateFormat('yyyy').format(parsedDate)}';
    return [month, day, year];
  }
}
