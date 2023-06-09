import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';
import '../../utils/shared_preference.dart';
import '../../utils/themes.dart';
import 'transactions.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<Activity> {
  var _userSharedPreferences = UserSharedPreferences();
  TabController _tabController;
  Color _indicatorColor;

  final buyerStatuses = <int, String>{};
  final sellerStatuses = <int, String>{};

  @override
  void initState() {
    super.initState();
    _indicatorColor = Color(0xFF09A49A);
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabSelection);
    _userSharedPreferences = UserSharedPreferences();
    _userSharedPreferences.init();
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
        Tab(text: 'My Orders'),
        Tab(text: 'My Shop'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // could probably use Firebase.instance?
      future: Database.instance.getOrderStatuses().get(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot != null &&
            (snapshot.connectionState != ConnectionState.done ||
                snapshot.hasError)) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        snapshot.data.docs.forEach((doc) {
          final statusCode = int.parse(doc.id);
          final dataMap = doc.data();
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
                Transactions(buyerStatuses, true),
                Transactions(sellerStatuses, false),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _userSharedPreferences.isActivity ? Container() : showAlert(context);
    setState(() {
      _userSharedPreferences.isActivity = true;
    });
  }

  showAlert(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22),
        // contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          height: height * 0.3,
          width: width * 0.9,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Container(
            width: width * 0.9,
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: width * 0.25,
                        child: Icon(
                          Icons.pie_chart_outlined,
                          size: 80,
                          color: Color(0xffCC3752),
                        ),
                      ),
                      Text(
                        "Activity",
                        style: TextStyle(color: Color(0xffCC3752)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 5, right: 15, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsets.only(top: 30, right: 15, bottom: 5),
                            child: Text(
                              'The Acitvity Tab is where you ',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(right: 15, bottom: 5, top: 1),
                            child: Text(
                              'can track your pending orders',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 30, bottom: 5, top: 1),
                              child: Text(
                                'from other\'s stores or other',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 30, bottom: 5, top: 1),
                              child: Text(
                                'people\'s orders from your store.',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Center(
                                child: Container(
                                  height: 43,
                                  width: 180,
                                  child: FlatButton(
                                    color: kTealColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(color: kTealColor),
                                    ),
                                    textColor: kTealColor,
                                    child: Text(
                                      "Okay!",
                                      style: TextStyle(
                                          fontFamily: "Goldplay",
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _userSharedPreferences?.dispose();
    super.dispose();
  }
}
