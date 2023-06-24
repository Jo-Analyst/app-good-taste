import 'package:flutter/material.dart';
import 'package:ice_cream/app/page/home_page.dart';

import '../template/bottom_navigation_bar_item.dart';

class IceCreamView extends StatefulWidget {
  const IceCreamView({super.key});

  @override
  State<IceCreamView> createState() => _IceCreamViewState();
}

class _IceCreamViewState extends State<IceCreamView> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(100),
      //   child: AppBar(
      //     title: const Text("ICEM CREAM - JV"),
      //     backgroundColor: Theme.of(context).primaryColor,
      //   ),
      // ),
      body: const HomePage(),
      // extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 18,
        unselectedFontSize: 16,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        fixedColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: (currentIndex) => setState(() {
          _currentIndex = currentIndex;
        }),
        items: [...BottomNavigationBarItemTemplate.items()],
      ),
    );
  }
}
