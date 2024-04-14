import 'package:flutter/material.dart';
import 'package:fincal/setting/setting.dart';
import 'package:fincal/profitMargin/profit_margin_screen.dart';
import 'cagr/cagr_screen.dart';
import 'ci/compound_interest_screen.dart';
import 'discount/discount_screen.dart';
import 'mortage/mortgage_screen.dart';
import 'db/percentage_screen.dart';
import 'returnofinvestment/return_of_investment_screen.dart';
import 'tip_calculator/tip_screen.dart';
import 'vat/vat_screen.dart';
import 'salestax/sales_tax_screen.dart';

class CompoundGridScreen extends StatelessWidget {
  final List<Map<String, dynamic>> compounds = [
    {
      'name': 'Percentage',
      'image': 'assets/image/%.png',
      'width': 100.0,
      'height': 100.0,
    },
    {
      'name': 'Compound Interest',
      'image': 'assets/image/ci.png',
      'width': 100.0,
      'height': 100.0,
    },
    {
      'name': 'Tip',
      'image': 'assets/image/tip.png',
      'width': 100.0,
      'height': 100.0,
    },
    {
      'name': 'Discount',
      'image': 'assets/image/dis.png',
      'width': 100.0,
      'height': 100.0,
    },
    {
      'name': 'Profit Margin',
      'image': 'assets/image/pm.png',
      'width': 100.0,
      'height': 100.0,
    },
    {
      'name': 'Mortgage',
      'image': 'assets/image/mor.png',
      'width': 100.0,
      'height': 100.0,
    },
    {
      'name': 'Return of Investment',
      'image': 'assets/image/roi.png',
      'width': 100.0,
      'height': 100.0,
    },
    {
      'name': 'CAGR',
      'image': 'assets/image/cg.png',
      'width': 100.0,
      'height': 100.0,
    },
    {
      'name': 'VAT',
      'image': 'assets/image/vat.png',
      'width': 100.0,
      'height': 100.0,
    },
    {
      'name': 'Sales Tax',
      'image': 'assets/image/st.png',
      'width': 100.0,
      'height': 100.0,
    },
  ];

  CompoundGridScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/homelogo.png',
                width: 130,
                height: 130,
              ),
              const SizedBox(width: 8),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 35.0,
                children: List.generate(
                  compounds.length,
                  (index) => _buildContainer(context, compounds[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, Map<String, dynamic> compound) {
    String name = compound['name'];
    // Splitting compound name into words
    List<String> words = name.split(' ');

    // First word of the compound name
    String firstWord = words[0];

    // Remaining words joined as a string
    String remainingWords = words.sublist(1).join(' ');

    return InkWell(
      onTap: () {
        _navigateToScreen(context, name);
      },
      child: Container(
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 4,
              child: Image.asset(
                compound['image'],
                fit: BoxFit.fitHeight,
              ),
            ),

            SizedBox(
              height: 5,
            ), // Adjust as needed
            Flexible(
              flex: 1,
              child: Text(
                firstWord,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(
                remainingWords,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String screenName) {
    switch (screenName) {
      case 'Percentage':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PercentageScreen(),
          ),
        );
        break;
      case 'Compound Interest':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CompoundInterestScreen(),
          ),
        );
        break;
      case 'Tip':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TipScreen(),
          ),
        );
        break;
      case 'Discount':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DiscountScreen(),
          ),
        );
        break;
      case 'Profit Margin':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfitMarginScreen(),
          ),
        );
        break;
      case 'Mortgage':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MortgageScreen(),
          ),
        );
        break;
      case 'Return of Investment':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ReturnOfInvestmentScreen(),
          ),
        );
        break;
      case 'CAGR':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CAGRScreen(),
          ),
        );
        break;
      case 'VAT':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VATScreen(),
          ),
        );
        break;
      case 'Sales Tax':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SalesTaxScreen(),
          ),
        );
        break;
      default:
        // Handle navigation to other screens
        break;
    }
  }
}
