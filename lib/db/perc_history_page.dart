import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dbhelper.dart';
import 'percentage_screen.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;
  String? errorMessage;
  bool isSelectMode = false; // Flag for selection mode
  Set<int> selectedIds = {}; // Set to track selected items
  bool selectAll = false; // Flag for select all functionality

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      List<Map<String, dynamic>> percentagesList = await databaseHelper.fetchRecentPercentageRows(limit: 100);
      List<Map<String, dynamic>> incordecList = await databaseHelper.fetchRecentIncordecRows(limit: 100);

      setState(() {
        history = [...percentagesList, ...incordecList];
        history.sort((a, b) => b['datetime'].compareTo(a['datetime']));
        if (history.length > 100) {
          history = history.sublist(0, 100);
        }
        isLoading = false;
        errorMessage = null;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading data: $error';
      });
    }
  }

  void toggleSelection(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
      isSelectMode = selectedIds.isNotEmpty; // Update select mode state
      selectAll = selectedIds.length == history.length; // Adjust select all state
    });
  }

  void selectAllItems() {
    setState(() {
      if (selectAll) {
        selectedIds.clear();
        selectAll = false;
      } else {
        selectedIds = history.map((item) => item['id'] as int).toSet(); // Ensure integers
        selectAll = true;
      }
      isSelectMode = selectedIds.isNotEmpty; // Update select mode state
    });
  }

  void deleteSelectedItems() async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      for (var id in selectedIds) {
        await databaseHelper.deleteFromTable('percentages', id);
        await databaseHelper.deleteFromTable('incordec', id);
      }
      setState(() {
        history.removeWhere((item) => selectedIds.contains(item['id']));
        selectedIds.clear();
        selectAll = false;
        isSelectMode = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting selected items')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          isSelectMode ? 'Selected: ${selectedIds.length}' : 'Percentage History',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (isSelectMode)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: deleteSelectedItems,
            ),

          if (isSelectMode)
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.white),
              onPressed: () {
                selectedIds.clear();
                selectAll = false;
                isSelectMode = false;
                setState(() {});
              },
            ),
          if (!isSelectMode)
            IconButton(
              icon: Icon(
                selectAll ? Icons.select_all : Icons.select_all,
                color: Colors.white,
              ),
              onPressed: selectAllItems,
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView.separated(
        itemCount: history.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          Map<String, dynamic> item = history[index];
          final id = item['id'];
          final isSelected = selectedIds.contains(id);

          return GestureDetector(
            onTap: () {
              if (isSelectMode) {
                toggleSelection(id);
              } else {
                navigateToPercentageScreen(item);
              }
            },
            onLongPress: () {
              setState(() {
                isSelectMode = true;
                toggleSelection(id);
              });
            },
            child: Row(
              children: [
                if (isSelectMode) // Checkbox before the date when in select mode
                  Checkbox(
                    value: isSelected,
                    onChanged: (checked) => toggleSelection(id),
                  ),
                Card(
                  color: isSelected ? Colors.grey : Colors.green, // Change color based on selection
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${_formattedDate(item["datetime"])[0]}\n ${_formattedDate(item["datetime"])[1]}\n ${_formattedDate(item["datetime"])[2]}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Adjust text color based on background
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: ListTile(
                    title: Text(
                      'X: ${item["x"]}  Y: ${item["y"]}',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.containsKey("value"))
                          Text('Result: ${item["value"]}'),
                        if (item.containsKey("increasedValue"))
                          Text('Increased Value: ${item["increasedValue"]}'),
                        if (item.containsKey("decreasedValue"))
                          Text('Decreased Value: ${item["decreasedValue"]}'),
                        Text(
                          item["title"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
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

  void navigateToPercentageScreen(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PercentageScreen(
          selectedOption: item["title"], // Pass the title for the radio button
          fromValue: item["x"],          // Pass the X value
          toValue: item["y"],            // Pass the Y value
          result: item.containsKey("value") ? item["value"].toDouble() : null,
          increasedValue: item.containsKey("increasedValue")
              ? item["increasedValue"].toDouble()
              : null,
          decreasedValue: item.containsKey("decreasedValue")
              ? item["decreasedValue"].toDouble()
              : null,
        ),
      ),
    );
  }


  List<String> _formattedDate(String datetime) {
    final parsedDate = DateTime.parse(datetime);
    final month = DateFormat("MMM").format(parsedDate);
    final day = DateFormat("dd").format(parsedDate);
    final year = DateFormat("yyyy").format(parsedDate);
    return [month, day, year];
  }
}
