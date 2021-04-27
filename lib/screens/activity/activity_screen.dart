import 'package:flutter/material.dart';



import 'buyer/my_orders.dart';
import 'seller/my_shop_seller.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;
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

  TabBar get _tabBar => TabBar(
        controller: _tabController,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
          color: _indicatorColor,
        ),
        tabs: [
          Tab(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "My Orders",
                style: TextStyle(fontSize: 16, fontFamily: "GoldplayBold"),
              ),
            ),
          ),
          Tab(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "My Shop",
                style: TextStyle(fontSize: 16, fontFamily: "GoldplayBold"),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
          // physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            MyOrders(),
            MyShopSeller(),
          ],
        ),
      ),
    );
  }
}
