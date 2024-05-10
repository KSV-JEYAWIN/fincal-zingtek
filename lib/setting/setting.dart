import 'package:fincal/setting/theme/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:fincal/setting/theme/theme.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: themeProvider.themeType == ThemeType.light
                    ? [Colors.blueAccent, Colors.purpleAccent]
                    : [Colors.black, Colors.grey],
              ),
            ),
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildSettingsItem(
                  context,
                  'Theme Settings',
                  'Change the app\'s theme',
                  ThemeSettingsPage(),
                  Icons.color_lens,
                ),
                // _buildSettingsItem(
                //   context,
                // 'Currency Selection',
                // 'Choose your default currency',
                //  CurrencySelectionPage(),
                // Icons.attach_money,
                //  ),
                //_buildSettingsItem(
                // context,
                // 'Feedback',
                //'Give us your feedback',
                //   FeedbackPage(),
//Icons.feedback,
                // ),
                _buildSettingsItem(
                  context,
                  'Rate Us',
                  'Rate the app on the store',
                  RateUsPage(),
                  Icons.star,
                ),
                // _buildSettingsItem(
                // context,
                //   'Licenses',
//View open-source licenses',
                // LicensesPage(),
                //  Icons.description,
                // ),
                _buildSettingsItem(
                  context,
                  'Terms of Service',
                  'Read the terms of service',
                  TermsOfServicePage(),
                  Icons.assignment,
                ),
                _buildSettingsItem(
                  context,
                  'About',
                  'Learn more about the app',
                  AboutPage(),
                  Icons.info,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, String subtitle,
      Widget page, IconData iconData) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 32.0,
              color: Colors.blueAccent,
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencySelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Selection'),
      ),
      // Implement currency selection UI
    );
  }
}

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      // Implement feedback UI
    );
  }
}

class RateUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Us'),
      ),
      // Implement rate us UI
    );
  }
}

class LicensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licenses'),
      ),
      // Implement licenses UI
    );
  }
}

class TermsOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service'),
      ),
      // Implement terms of service UI
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      // Implement about UI
    );
  }
}
