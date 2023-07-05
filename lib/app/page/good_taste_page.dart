import 'package:app_good_taste/app/page/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:app_good_taste/app/page/feedstock_page.dart';
import 'package:app_good_taste/app/page/movement_details_page.dart';
import 'package:app_good_taste/app/page/product_page.dart';

import '../template/bottom_navigation_bar_item.dart';

class GoodTastPage extends StatefulWidget {
  const GoodTastPage({super.key});

  @override
  State<GoodTastPage> createState() => _GoodTastPageState();
}

class _GoodTastPageState extends State<GoodTastPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void setCurrentPage(currentIndex) {
    setState(() {
      _currentIndex = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: setCurrentPage,
        children: const [
          MovementDetailsPage(),
          FeedstockPage(),
          ProductPage(),
          SettingPage(),
        ],
      ),
      // extendBody: true,

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 18,
        unselectedFontSize: 16,
        unselectedItemColor: Colors.black87,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        fixedColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: (page) => _pageController.animateToPage(
          page,
          duration: const Duration(microseconds: 400),
          curve: Curves.ease,
        ),
        items: BottomNavigationBarItemTemplate.items(),
      ),
    );
  }
}
