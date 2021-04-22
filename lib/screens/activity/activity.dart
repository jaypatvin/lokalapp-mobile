import 'package:flutter/material.dart';

import 'my_orders.dart';
import 'my_shop.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Color _indicatorColor;

  @override
  void initState() {
    super.initState();
    _indicatorColor = Color(0xFF09A49A);
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      switch (_tabController?.index) {
        case 0:
          _indicatorColor = Color(0xFF09A49A);
          break;
        case 1:
          _indicatorColor = Color(0xFF57183F);
          break;
      }
    });
  }

  TabBar get _tabBar {
    return TabBar(
      controller: _tabController,
      unselectedLabelColor: Colors.black,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
        color: _indicatorColor,
      ),
      tabs: [
        Tab(
          text: 'My Orders',
        ),
        Tab(
          text: 'My Shop',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF1FAFF),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _tabBar,
            ),
          ),
          title: Center(
            child: Text(
              'Activity',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            MyOrders(),
            MyShop(),
          ],
        ),
      ),
    );
  }
}
