import 'package:flutter/material.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: const Text("ICEM CREAM - JV"),
          backgroundColor: Colors.pink[500],
        ),
      ),
      body: Center(
        child: Text(
          "Ice Cream",
          style: TextStyle(fontSize: Theme.of(context).textTheme.displayLarge?.fontSize),
        ),
      ),
      // extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.pink[500],
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 18,
        unselectedFontSize: 16,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.pink[500],
        currentIndex: _currentIndex,
        onTap: (currentIndex) => setState(() {
          _currentIndex = currentIndex;
        }),
        items: [...BottomNavigationBarItemTemplate.items()],
      ),
    );
  }
}
