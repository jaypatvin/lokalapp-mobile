import 'dart:io';

import 'package:flutter/material.dart';
import '../services/database.dart';
import '../services/get_stream_api_service.dart';
import '../states/current_user.dart';
import '../utils/themes.dart';
import 'package:provider/provider.dart';

class ExpandedCard extends StatefulWidget {
  final Map<String, String> account;
  final Map<dynamic, dynamic> snapshot;
  ExpandedCard({Key key, @required this.account, this.snapshot})
      : super(key: key);
  @override
  _ExpandedCardState createState() => _ExpandedCardState();
}

class _ExpandedCardState extends State<ExpandedCard> {
  Future<List<dynamic>> _activities;
  File file;
  // @override
  // void initState() {
  //   super.initState();
  //   _activities = _getActivities();
  // }

  // Future<List<dynamic>> _getActivities() async {
  //   return await GetStreamApiService().getActivities(widget.account);
  // }

  // Future _refreshActivities() async {
  //   setState(() {
  //     _activities = _getActivities();
  //   });
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    CurrentUser _user = Provider.of<CurrentUser>(context);
    return Material(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 100),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, spreadRadius: 5, blurRadius: 2)
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(color: kTealColor),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 305, top: 29),
                            child: IconButton(
                              icon: Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: 33,
                              ),
                              onPressed: () {
                                
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CircleAvatar(
                      radius: 30,
                    ),
                  ),
                  Text(
                    _user.getCurrentUser.firstName +
                        " " +
                        _user.getCurrentUser.lastName,
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          widget.snapshot["message"],
                          softWrap: true,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffE0E0E0), width: 1)),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                leading: IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.pink,
                                    ),
                                    onPressed: null),
                                trailing: // IconButton(
                                    GestureDetector(
                                      onTap: (){},
                                  child: Icon(
                                    Icons.messenger_outline,
                                    color: Colors.black,
                                    
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
