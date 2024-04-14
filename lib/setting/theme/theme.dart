import 'package:fincal/setting/theme/wallpaperoption.dart';
import 'package:flutter/material.dart';
import 'package:fincal/setting/theme/themeprovider.dart';
import 'package:provider/provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Select Theme',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          _buildThemeItem(context, 'Light Theme', ThemeType.light),
          _buildThemeItem(context, 'Dark Theme', ThemeType.dark),
        ],
      ),
    );
  }

  Widget _buildThemeItem(
      BuildContext context, String title, ThemeType themeType) {
    return InkWell(
      onTap: () {
        Provider.of<ThemeProvider>(context, listen: false).setTheme(themeType);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0),
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                bool isSelected = themeProvider.themeType == themeType;
                return Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.green : Colors.grey,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
