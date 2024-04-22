import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fincal/setting/theme/themeprovider.dart';
import 'compound_grid_screen.dart'; // Import your main screen here

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: SplashScreenApp(), // Run the SplashScreenApp first
    ),
  );
}

class SplashScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SplashScreen',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Set your splash screen here
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // 5 seconds duration
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward().then((_) {
      // Navigate to MyApp after the animation completes
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: child,
            );
          },
          child: Image.asset(
            'assets/image/homelogo.png',
            // Replace with your home logo image asset
            width: 1000,
            height: 1000,
          ),
        ),
      ),
    );
  }
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
