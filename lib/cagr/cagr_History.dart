import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cagrModel.dart';
import 'cagr_screen.dart';
import 'cagrHelper.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<CAGRModel> cagrList;
  Set<int> _selectedIndices = Set<int>();
  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: _selectedIndices.isNotEmpty
            ? Text('Selected: ${_selectedIndices.length}', style: TextStyle(color: Colors.white))
            : Text('CAGR History', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: _selectedIndices.isNotEmpty
            ? [
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
        ]
            : [
          IconButton(
            onPressed: _toggleSelectAll,
            icon: Icon(_selectAll ? Icons.select_all : Icons.select_all),
            color: Colors.white,
          ),
        ],
      ),
      body: FutureBuilder<List<CAGRModel>>(
        future: DatabaseHelper().getCAGRList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          cagrList = snapshot.data ?? [];
          if (cagrList.isEmpty) {
            return Center(child: Text('No data'));
          }

          return ListView.separated(
            itemCount: cagrList.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final cagrData = cagrList[index];
              final isSelected = _selectedIndices.contains(index);

              return GestureDetector(
                onLongPress: () => _toggleSelection(index),
                onTap: () {
                  if (_selectedIndices.isNotEmpty) {
                    _toggleSelection(index);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CAGRScreen(cagr: cagrData),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 130,
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
                                  _formattedDate(cagrData.dateTime)[0],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  _formattedDate(cagrData.dateTime)[1],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  _formattedDate(cagrData.dateTime)[2],
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
                      const SizedBox(width: 8.0),
                      Expanded(
                        flex: 3,
                        child: ListTile(
                          title: Text(
                            'Initial Investment: ${cagrData.initialInvestment}\nFinal Investment: ${cagrData.finalInvestment}\nDuration of Investment: ${cagrData.duration}',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectAll) {
        _selectedIndices.clear();
      } else {
        _selectedIndices = Set<int>.from(
          Iterable<int>.generate(cagrList.length, (i) => i),
        );
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
    final List<CAGRModel> selectedCAGR =
    _selectedIndices.map((index) => cagrList[index]).toList();

    final dbHelper = DatabaseHelper();
    for (var cagr in selectedCAGR) {
      await dbHelper.deleteCAGR(cagr.id);
    }

    setState(() {
      cagrList.removeWhere((cagr) => selectedCAGR.contains(cagr));
      _selectedIndices.clear();
    });
  }

  List<String> _formattedDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    final month = DateFormat('MMM').format(date);
    final day = DateFormat('dd').format(date);
    final year = DateFormat('yyyy').format(date);
    return [month, day, year];
  }
}
