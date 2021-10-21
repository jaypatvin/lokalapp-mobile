import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../services/database.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../utils/shared_preference.dart';
import '../../widgets/onboarding.dart';
import 'transactions.dart';

class Activity extends StatefulWidget {
  static const routeName = "/activity";
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> with TickerProviderStateMixin {
  TabController? _tabController;

  final buyerStatuses = <int, String?>{};
  final sellerStatuses = <int, String?>{};

  Future<QuerySnapshot>? _statuses;

  late AnimationController _animationController;
  Animation<Color?>? _colorAnimation;

  @override
  void initState() {
    super.initState();
    _statuses = Database.instance.getOrderStatuses().get();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_tabSelectionHandler);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _colorAnimation = ColorTween(
      begin: kTealColor,
      end: kPurpleColor,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _tabSelectionHandler() {
    setState(() {
      switch (_tabController?.index) {
        case 0:
          _animationController.reverse();
          break;
        case 1:
          _animationController.forward();
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
        color: _colorAnimation!.value,
      ),
      labelStyle: Theme.of(context).textTheme.headline6,
      tabs: [
        Tab(text: "My Orders"),
        Tab(text: "My Shop"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Onboarding(
      screen: MainScreen.activity,
      child: FutureBuilder(
        future: _statuses,
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              snapshot.hasError) {
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Lottie.asset(kAnimationLoading),
              ),
            );
          }
          snapshot.data!.docs.forEach((doc) {
            final statusCode = int.parse(doc.id);
            final dataMap = doc.data() as Map<String, dynamic>;
            buyerStatuses[statusCode] = dataMap["buyer_status"];
            sellerStatuses[statusCode] = dataMap["seller_status"];
          });
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
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Transactions(buyerStatuses, true, _colorAnimation),
                  Transactions(sellerStatuses, false, _colorAnimation),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
