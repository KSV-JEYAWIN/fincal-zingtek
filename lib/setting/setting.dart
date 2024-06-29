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
                    : [Colors.black, Colors.black],
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
                //   'Feedback',
                //   'Give us your feedback',
                //   FeedbackPage(),
                //   Icons.feedback,
                // ),
                _buildSettingsItem(
                  context,
                  'Rate Us',
                  'Rate the app on the store',
                  RateUsPage(),
                  Icons.star,
                ),
                // _buildSettingsItem(
                //   context,
                //   'Licenses',
                //   'View open-source licenses',
                //   LicensesPage(),
                //   Icons.description,
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
                _buildSettingsItem(
                  context,
                  'Privacy policy',
                  'Privacy Policy of our application',
                  PrivacyPage(),
                  Icons.privacy_tip,
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
              color: Colors.green,
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

// class CurrencySelectionPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Currency Selection'),
//       ),
//       // Implement currency selection UI
//     );
//   }
// }

// class FeedbackPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feedback'),
//       ),
//       // Implement feedback UI
//     );
//   }
// }

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Welcome to the FinCal mobile application provided by ZingTek Innovations. By downloading, installing, or using this application, you agree to abide by the following terms and conditions:\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'Description of Service:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'The FinCal application provides various financial calculation tools including percentage calculation, compound interest calculation, tip calculation, discount calculation, profit margin calculation, mortgage calculation, return of investment calculation, CAGR calculation, VAT calculation, and sales tax calculation.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'No Permissions Required:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'You do not need to grant any permissions to access or use the FinCal application. We do not require access to any personal information or data on your device.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'Disclaimer:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'The calculations provided by the App are for informational purposes only and should not be considered financial advice. Users are advised to consult with qualified professionals for financial advice and decision-making.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            // Text(
            //   'Intellectual Property:\n',
            //   style: TextStyle(
            //     fontSize: 18.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Text(
            //   'The FinCal application, including its content, design, and functionality, is the property of ZingTek Innovations and is protected by international copyright laws. Unauthorized use, reproduction, or distribution of the App is prohibited.\n',
            //   style: TextStyle(
            //     fontSize: 16.0,
            //   ),
            // ),

            Text(
              'Changes to our Terms of service:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'If we decide to change our terms and service, we will post those changes on this page and in our application.This policy was last modified on 27th June2024.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            // Text(
            //   'Termination:\n',
            //   style: TextStyle(
            //     fontSize: 18.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Text(
            //   'ZingTek Innovations reserves the right to terminate or suspend access to the App at any time without prior notice or liability.\n',
            //   style: TextStyle(
            //     fontSize: 16.0,
            //   ),
            // ),
            Text(
              'Contact Us:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'If you have any questions or concerns about these Terms, please contact us at zingtekinnovations@gmail.com\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'By using the FinCal application, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the FinCal app Version 1.0.01\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Introduction:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'FinCal app is your go-to tool for a wide range of financial calculations, designed to simplify your everyday financial tasks. Whether you\'re calculating percentages, estimating compound interest, or determining the ROI on an investment, FinCal has you covered. Developed by ZingTek Innovations, our app offers a comprehensive suite of calculators to help you with various financial scenarios.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'Features:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Percentage Calculation: Quickly calculate percentages for various purposes such as discounts, markups, and taxes.\n'
              'Compound Interest Calculation: Estimate the growth of your investments over time with compound interest calculations.\n'
              'Tip Calculation: Easily calculate tips for dining out or other services.\n'
              'Discount Calculation: Determine the discounted price of an item or service.\n'
              'Profit Margin Calculation: Analyze the profitability of your business or investments by calculating profit margins.\n'
              'Mortgage Calculation: Plan your home purchase or refinancing with mortgage calculations.\n'
              'Return on Investment (ROI) Calculation: Evaluate the performance of your investments with ROI calculations.\n'
              'Compound Annual Growth Rate (CAGR) Calculation: Assess the growth rate of your investments over multiple periods.\n'
              'VAT Calculation: Calculate the value-added tax (VAT) for goods and services.\n'
              'Sales Tax Calculation: Estimate the sales tax on purchases.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'About ZingTek Innovations:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ZingTek Innovations is dedicated to creating innovative solutions to simplify complex tasks. Our team comprises passionate individuals committed to leveraging technology to empower users and enhance their financial decision-making process. We strive to deliver high-quality apps that not only meet but exceed user expectations.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'Contact Us:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Have feedback or questions? We\'d love to hear from you! Feel free to reach out to us at zingtekinnovations@gmail.com. Your input helps us improve FinCal and ensures that it continues to meet your financial needs effectively.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'Get the Latest Version:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Make sure you have the latest features and improvements! Download or update the app on the Google Play Store. Stay up-to-date with new features, bug fixes, and enhancements to enhance your financial calculations experience.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'Thank you for choosing the FinCal application for your financial needs!',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Welcome to the FinCal mobile application provided by ZingTek Innovations. By downloading, installing, or using this application, you agree to abide by the following privacy policy:\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'What do we collect :\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'We never collect any user information apart from the inputs for calculation. Our aim is to help you with your personal finances by providing you with valuable content related to personal finance so that you can manage your finances easily and without any stress. we will not use or share your information with anyone except as described in this Privacy Policy.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'Do we transfer any information to outside parties?\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Since we do not collect any user information directly or indirectly, we do not have any user information to share with others. You just enter numeric values as an input to perform a calculation.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'Third party links :\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Occasionally, at our discretion, we may include or offer third-party products or services on our app via ads (Admob). These third-party sites have separate and independent privacy policies. We, therefore, have no responsibility or liability for the content and activities of these linked sites. Please read the privacy policy of Admob by using this link. https://support.google.com/admob/answer/6128543?hl=en\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            // Text(
            //   'Intellectual Property:\n',
            //   style: TextStyle(
            //     fontSize: 18.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Text(
            //   'The FinCal application, including its content, design, and functionality, is the property of ZingTek Innovations and is protected by international copyright laws. Unauthorized use, reproduction, or distribution of the App is prohibited.\n',
            //   style: TextStyle(
            //     fontSize: 16.0,
            //   ),
            // ),

            Text(
              'Storage:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'We store all the calculated data in the local database sqlite in your device. This application does not transfer any information to other networked systems. The data that we get in input will be stored with a result value.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),

            Text(
              'Deletion of Data : \n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'The Numeric value that we get from the user to perform a calculation will be stored only in the local database inside your mobile. The user will be able to delete the data which is stored in your devices local database by deleting the history page in the application or  by uninstalling the application the whole data will be deleted from your device.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),

            Text(
              'Do we use cookies?\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'No, We do not use cookies.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),

            Text(
              'Do we sell your data?\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'No, we never sold your data. The data which we collect will only be stored in the local database sqlite that is stored only in your mobile device. We never able to read, edit or access the data which is stored in your device local database. \n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),

            Text(
              'Changes to our Privacy Policy:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'If we decide to change our terms and service, we will post those changes on this page and in our application.This policy was last modified on 27th June2024.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            // Text(
            //   'Termination:\n',
            //   style: TextStyle(
            //     fontSize: 18.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Text(
            //   'ZingTek Innovations reserves the right to terminate or suspend access to the App at any time without prior notice or liability.\n',
            //   style: TextStyle(
            //     fontSize: 16.0,
            //   ),
            // ),
            Text(
              'Contact Us:\n',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'If you have any questions or concerns about these Terms, please contact us at zingtekinnovations@gmail.com\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'By using the FinCal application, you acknowledge that you have read, understood, and agree to be bound by these privacy policy.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
