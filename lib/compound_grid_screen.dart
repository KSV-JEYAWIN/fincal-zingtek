import 'package:flutter/material.dart';
import 'package:fincal/setting/setting.dart';
import 'package:fincal/profitMargin/profit_margin_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'cagr/cagr_screen.dart';
import 'ci/compound_interest_screen.dart';
import 'discount/discount_screen.dart';
import 'mortage/mortgage_screen.dart';
import 'db/percentage_screen.dart';
import 'returnofinvestment/return_of_investment_screen.dart';
import 'tip_calculator/tip_screen.dart';
import 'vat/vat_screen.dart';
import 'salestax/sales_tax_screen.dart';

class CompoundGridScreen extends StatefulWidget {
  CompoundGridScreen({Key? key}) : super(key: key);

  @override
  _CompoundGridScreenState createState() => _CompoundGridScreenState();
}

class _CompoundGridScreenState extends State<CompoundGridScreen> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

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

  @override
  void initState() {
    super.initState();
    // Initialize the ad
    _bannerAd = BannerAd(
      adUnitId:
      'ca-app-pub-3940256099942544/6300978111', // Replace with your actual ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
        onAdOpened: (ad) {
          // Called when an ad opens an overlay that covers the screen.
          // You can add your logic here if needed.
          print('Ad opened: ${ad.adUnitId}');
        },
        onAdClosed: (ad) {
          // Called when an ad removes an overlay that covers the screen.
          // You can add your logic here if needed.
          print('Ad closed: ${ad.adUnitId}');
        },
        onAdImpression: (ad) {
          // Called when an impression occurs on the ad.
          // You can add your logic here if needed.
          print('Ad impression: ${ad.adUnitId}');
        },
      ),
    );

    // Load the ad
    _bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [Colors.black, Colors.black]
                : [Colors.white, Colors.white],
          ),
        ),
        child: Padding(
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
              if (_isLoaded) ...[
                SizedBox(height: 10), // Adjust as needed
                Container(
                  height: _bannerAd?.size.height.toDouble(),
                  alignment: Alignment.center,
                  child: AdWidget(ad: _bannerAd!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, Map<String, dynamic> compound) {
    final firstWord = compound['name'].split(' ')[0];
    final remainingWords = compound['name'].split(' ').sublist(1).join(' ');

    return InkWell(
      onTap: () => _navigateToScreen(context, compound['name']),
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
            builder: (context) => PercentageScreen(
              // selectedOption: 'Default',
              // fromValue: 0,
              // toValue: 0,
            ),
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

  @override
  void dispose() {
    _bannerAd?.dispose(); // Dispose the ad when the screen is disposed
    super.dispose();
  }
}
