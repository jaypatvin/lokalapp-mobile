import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lokalapp/utils/themes.dart';

class NotificationSetting extends StatefulWidget {
  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool likes = false;
  bool comments = false;
  bool tags = false;
  bool messages = false;
  bool orderStatus = false;
  bool alert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF1FAFF),
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Container(
              decoration: BoxDecoration(color: kTealColor),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      // padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Notification Settings",
                        style: TextStyle(
                            fontFamily: "Goldplay",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: ListView(
            // shrinkWrap: true,
            children: [
              SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Receive notifications for",
                  style:
                      TextStyle(fontFamily: "GoldplayBold", color: kTealColor),
                ),
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Text(
                      "Likes",
                      style:
                          TextStyle(fontSize: 14, fontFamily: "GoldplayBold"),
                    ),
                    trailing: CupertinoSwitch(
                      value: likes,
                      onChanged: (value) {
                        setState(() {
                          likes = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Text(
                      "Comments",
                      style:
                          TextStyle(fontSize: 14, fontFamily: "GoldplayBold"),
                    ),
                    trailing: CupertinoSwitch(
                      value: comments,
                      onChanged: (value) {
                        setState(() {
                          comments = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Text(
                      "Tags",
                      style:
                          TextStyle(fontSize: 14, fontFamily: "GoldplayBold"),
                    ),
                    trailing: CupertinoSwitch(
                      value: tags,
                      onChanged: (value) {
                        setState(() {
                          tags = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Text(
                      "Messages",
                      style:
                          TextStyle(fontSize: 14, fontFamily: "GoldplayBold"),
                    ),
                    trailing: CupertinoSwitch(
                      value: messages,
                      onChanged: (value) {
                        setState(() {
                          messages = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Text(
                      "Order Status",
                      style:
                          TextStyle(fontSize: 14, fontFamily: "GoldplayBold"),
                    ),
                    trailing: CupertinoSwitch(
                      value: orderStatus,
                      onChanged: (value) {
                        setState(() {
                          orderStatus = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Text(
                      "Community Alerts(?)",
                      style:
                          TextStyle(fontSize: 14, fontFamily: "GoldplayBold"),
                    ),
                    trailing: CupertinoSwitch(
                      value: alert,
                      onChanged: (value) {
                        setState(() {
                          alert = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  )),
            ]));
  }
}
