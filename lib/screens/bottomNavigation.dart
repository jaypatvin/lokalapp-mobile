import 'package:flutter/material.dart';
import 'package:lokalapp/screens/profile.dart';

import 'activity.dart';
import 'chat.dart';
import 'discover.dart';
import 'home.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int pageIndex = 0;
  PageController _pageController = PageController();

  void _onTap(int value) {
    setState(() {
      pageIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black87,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_tree_rounded), label: "Discover"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_rounded), label: "Activity"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile"),
        ],
      ),
      body: PageView(
        children: [Home(), Discover(), Chat(), Activity(), Profile()],
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }
}