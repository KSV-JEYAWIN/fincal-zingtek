import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ci_helper.dart';
import 'compound_interest_screen.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _historyData = [];
  bool _isLoading = false;
  Set<int> _selectedIndices = {};
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _fetchHistoryData();
  }

  Future<void> _fetchHistoryData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Map<String, dynamic>> history =
          await DatabaseHelper.getAllCompoundInterest();
      setState(() {
        _historyData = history;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching history data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectAll) {
        _selectedIndices.clear();
      } else {
        _selectedIndices = {for (int i = 0; i < _historyData.length; i++) i};
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
        actions: [
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
      List<Map<String, dynamic>> selectedItems =
          _selectedIndices.map((index) => _historyData[index]).toList();

      for (var item in selectedItems) {
        await DatabaseHelper.deleteCompoundInterest(
            item['id']); // Ensure 'id' is not null
      }

      setState(() {
        _historyData.removeWhere((item) =>
            selectedItems.contains(item)); // Update the UI after deletion
        _selectedIndices.clear(); // Clear selection after deletion
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: _selectedIndices.isNotEmpty
            ? Text(
                'Selected: ${_selectedIndices.length}',
                style: TextStyle(color: Colors.white),
              )
            : Text(
                'Compound Interest History',
                style: TextStyle(color: Colors.white),
              ),
        // This makes the back arrow and all icons in the AppBar white
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (_selectedIndices.isNotEmpty) ...[
            IconButton(
              onPressed: () => _deleteSelectedItems(context),
              icon: Icon(Icons.delete),
              color: Colors.white,
            ),
            IconButton(
              onPressed: _clearSelection,
              icon: Icon(Icons.cancel),
              color: Colors.white,
            ),
          ],
          if (_selectedIndices.isEmpty)
            IconButton(
              onPressed: _toggleSelectAll,
              icon: Icon(_selectAll ? Icons.select_all : Icons.select_all),
              color: Colors.white,
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _historyData.isEmpty
              ? Center(child: Text('No history available'))
              : ListView.separated(
                  itemCount: _historyData.length,
                  separatorBuilder: (context, _) => Divider(),
                  itemBuilder: (context, index) {
                    final item = _historyData[index];
                    final parsedDateTime = DateTime.parse(item['datetime']);
                    final isSelected = _selectedIndices.contains(index);

                    return GestureDetector(
                      onTap: () {
                        if (_selectedIndices.isNotEmpty) {
                          _toggleSelection(index);
                        } else {
                          // Navigate to CompoundInterestScreen with data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompoundInterestScreen(
                                principal: item['principal_amount'] ?? 0.0,
                                rate: item['interest_rate'] ?? 0.0,
                                time: item['time_period'] ?? 0.0,
                                compoundFrequency:
                                    item['compound_frequency'] ?? 'N/A',
                              ),
                            ),
                          );
                        }
                      },
                      onLongPress: () => _toggleSelection(index),
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
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('MMM \n dd yyyy')
                                          .format(parsedDateTime),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              title: Text(
                                'Principal Amount: \$${item['principal_amount'] ?? 0}\nInterest Rate: ${item['interest_rate'] ?? 0}%\nTime Period: ${item['time_period'] ?? 0} years\nCompound Frequency: ${item['compound_frequency'] ?? "N/A"}',
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),

                              trailing: Icon(Icons
                                  .arrow_forward_ios), // Corrected error here
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
