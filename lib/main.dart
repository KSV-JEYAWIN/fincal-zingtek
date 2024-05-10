import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fincal/setting/theme/themeprovider.dart';
import 'compound_grid_screen.dart'; // Import your main screen here

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'FinCal',
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          home: CompoundGridScreen(), // Set your main screen here
        );
      },
    );
  }
}
