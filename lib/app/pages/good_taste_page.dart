import 'package:app_good_taste/app/models/backup.dart';
import 'package:app_good_taste/app/pages/backup_page.dart';
import 'package:app_good_taste/app/utils/permission_use_app.dart';
import 'package:app_good_taste/app/utils/share.dart';
import 'package:flutter/material.dart';
import 'package:app_good_taste/app/pages/feedstock_page.dart';
import 'package:app_good_taste/app/pages/movement_details_page.dart';
import 'package:app_good_taste/app/pages/product_page.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../template/bottom_navigation_bar_item.dart';
import '../utils/dialog_exit_app.dart';

class GoodTastePage extends StatefulWidget {
  const GoodTastePage({super.key});

  @override
  State<GoodTastePage> createState() => _GoodTastPageState();
}

class _GoodTastPageState extends State<GoodTastePage> {
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

  Future<bool> screen() async {
    final confirmExit = await showDialogApp(
        context, "Deseja gerar backup ao sair do aplicativo?");
    if (confirmExit != null) {
      if (confirmExit == "Sair e gerar backup") {
        bool isGranted = await isGrantedRequestPermissionStorage();

        if (isGranted) {
          await Backup.toGenerate();
          await Future.delayed(
            const Duration(milliseconds: 300),
          );

          ShareUtils.share();
        } else {
          openAppSettings();
          return false;
        }
      }

      SystemNavigator.pop(animated: false);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: screen,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: setCurrentPage,
          children: const [
            MovementDetailsPage(),
            FeedstockPage(),
            ProductPage(),
            BackupPage()
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
      ),
    );
  }
}
