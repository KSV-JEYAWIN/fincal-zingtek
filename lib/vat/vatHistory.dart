import 'package:flutter/material.dart';
import 'vatHelper.dart';
import 'vatModel.dart';
import 'vat_screen.dart'; // Import the VATScreen widget
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<VATData> _vatDataList = [];
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _retrieveVATData();
  }

  Future<void> _retrieveVATData() async {
    final vatDataList = await DBHelper.instance.getVATDataList();
    setState(() {
      _vatDataList = vatDataList;
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
                'VAT Data History',
                style: TextStyle(color: Colors.white),
              ),
        actions: _buildAppBarActions(),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _vatDataList.isEmpty
          ? Center(
              child: Text(
                'No VAT data available',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(8.0),
              itemCount: _vatDataList.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final vatData = _vatDataList[index];
                return GestureDetector(
                  onLongPress: () {
                    _startSelection(vatData);
                  },
                  onTap: () {
                    if (_isSelecting) {
                      _toggleSelection(vatData);
                    } else {
                      _navigateToDetails(vatData);
                    }
                  },
                  child: buildHistoryListItem(vatData, isDarkMode),
                );
              },
            ),
    );
  }

  // Function to build history list item
  // Function to build history list item
  // Function to build history list item
  // Function to build history list item
  Widget buildHistoryListItem(VATData vatData, bool isDarkMode) {
    return Row(
      children: [
        if (_isSelecting)
          Checkbox(
            value: vatData.isSelected ?? false,
            onChanged: (newValue) {
              _toggleSelection(vatData);
            },
          ),
        Expanded(
          flex: 1,
          child: Card(
            color: vatData.isSelected ?? false ? Colors.grey : Colors.green,
            // Set color to grey if selected, otherwise green
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${_formattedDate(vatData.dateTime)[0]}', // Month
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '${_formattedDate(vatData.dateTime)[1]}', // Day
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '${_formattedDate(vatData.dateTime)[2]}', // Year
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
              'Net Price: ${vatData.netPrice}\n VAT Percentage : ${vatData.vatPercentage}',
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
  void _startSelection(VATData vatData) {
    setState(() {
      _isSelecting = true;
      vatData.isSelected = true;
    });
  }

  // Function to toggle selection of an item
  void _toggleSelection(VATData vatData) {
    setState(() {
      vatData.isSelected = !vatData.isSelected!;
    });
  }

  // Function to navigate to details screen
  void _navigateToDetails(VATData vatData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VATScreen(vatData: vatData),
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
    return _vatDataList.where((vatData) => vatData.isSelected ?? false).length;
  }

  // Function to delete selected items
  void _deleteSelectedItems() async {
    final selectedItems =
        _vatDataList.where((vatData) => vatData.isSelected ?? false).toList();
    for (var item in selectedItems) {
      await DBHelper.instance.deleteVATData(item.id!);
    }
    setState(() {
      _vatDataList.removeWhere((vatData) => vatData.isSelected ?? false);
      _isSelecting = false;
    });
  }

  // Function to cancel selection mode
  void _cancelSelection() {
    setState(() {
      _vatDataList.forEach((vatData) {
        vatData.isSelected = false;
      });
      _isSelecting = false;
    });
  }

  // Function to select all items
  void _selectAllItems() {
    setState(() {
      _vatDataList.forEach((vatData) {
        vatData.isSelected = true;
      });
    });
  }

  // Function to format date
  List<String> _formattedDate(String datetime) {
    final parsedDate = DateTime.parse(datetime);
    final month = '${DateFormat('MMM').format(parsedDate)}';
    final day = '${DateFormat('dd').format(parsedDate)}';
    final year = '${DateFormat('yyyy').format(parsedDate)}';
    return [month, day, year];
  }
}
