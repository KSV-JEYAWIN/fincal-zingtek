import 'package:flutter/material.dart';
import 'package:fincal/tip_calculator/tipmodel.dart';
import 'package:fincal/tip_calculator/tip_screen.dart';
import 'package:fincal/tip_calculator/tiphelper.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<Tip> _tips;
  List<bool> _isSelected = [];
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  Future<void> _loadTips() async {
    final tips = await DatabaseHelper().getAllTips();
    setState(() {
      _tips = tips ?? [];
      _isSelected = List<bool>.filled(_tips.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: _isSelecting
            ? Row(
                children: [
                  Expanded(
                    child: Text(
                      'Selected ${_selectedItemCount()}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            : const Text(
                'Tip History',
                style: TextStyle(color: Colors.white),
              ),
        iconTheme: IconThemeData(color: Colors.white),
        // Set icon color to white
        actions:
            _isSelecting ? _buildSelectingActions() : _buildAppBarActions(),
        actionsIconTheme: IconThemeData(
            color: Colors.white), // Set actions icon color to white
      ),
      body: FutureBuilder<List<Tip>>(
        future: DatabaseHelper().getAllTips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history available'));
          } else {
            List<Tip> tips = snapshot.data!;
            tips.sort((a, b) => b.datetime.compareTo(a.datetime));
            List<Tip> latestTips = tips.take(100).toList();

            return ListView.separated(
              itemCount: latestTips.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (context, index) {
                Tip tip = latestTips[index];
                DateTime dateTime = DateTime.parse(tip.datetime);
                return GestureDetector(
                  onLongPress: () {
                    _startSelection(index);
                  },
                  onTap: () {
                    if (_isSelecting) {
                      _toggleSelection(index);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TipScreen(initialTip: tip),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      if (_isSelecting)
                        Checkbox(
                          value: _isSelected[index],
                          onChanged: (value) {
                            _toggleSelection(index);
                          },
                        ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          color:
                              _isSelected[index] ? Colors.grey : Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    '${_formattedDate(dateTime)[0]} \n ${_formattedDate(dateTime)[1]} \n ${_formattedDate(dateTime)[2]}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                    ),
                                    textAlign: TextAlign.center,
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
                            'Bill Amount : ${tip.billAmount}\nTip Percentage : ${tip.tipPercentage}\nNumber of Person : ${tip.numberOfPersons}',
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
            );
          }
        },
      ),
    );
  }

  void _startSelection(int index) {
    setState(() {
      _isSelecting = true;
      _isSelected = List<bool>.filled(_tips.length, false);
      _isSelected[index] = true;
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index];
    });
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: Icon(Icons.select_all),
        onPressed: () {
          setState(() {
            _isSelecting = true;
            _selectAll();
          });
        },
      ),
    ];
  }

  List<Widget> _buildSelectingActions() {
    return [
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: _deleteSelected,
      ),
      IconButton(
        icon: Icon(Icons.cancel),
        onPressed: _cancelSelection,
      ),
    ];
  }

  void _deleteSelected() async {
    List<Tip> selectedTips = [];
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected[i]) {
        selectedTips.add(_tips[i]);
      }
    }
    for (final tip in selectedTips) {
      if (tip.id != null) {
        await DatabaseHelper().deleteTip(tip.id!);
      }
    }
    _loadTips();
    setState(() {
      _isSelecting = false;
    });
  }

  void _cancelSelection() {
    setState(() {
      _isSelecting = false;
      _isSelected = List<bool>.filled(_tips.length, false);
    });
  }

  int _selectedItemCount() {
    return _isSelected.where((selected) => selected).length;
  }

  void _selectAll() {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = true;
      }
    });
  }

  List<String> _formattedDate(DateTime datetime) {
    final month = '${DateFormat('MMM').format(datetime)}';
    final day = '${DateFormat('dd').format(datetime)}';
    final year = '${DateFormat('yyyy').format(datetime)}';
    return [month, day, year];
  }
}
