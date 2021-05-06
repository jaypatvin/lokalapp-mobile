import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/lokal_user.dart';
import 'package:lokalapp/screens/profile_screens/settings/email/email_changed.dart';
import 'package:lokalapp/utils/themes.dart';

class ChatSettings extends StatefulWidget {
  @override
  _ChatSettingsState createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  bool isSwitched = false;
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
                        "Chat Settings",
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
                  color: Colors.white,
                  child: ListTile(
                    leading: Text(
                      "Show Read Receipients",
                      style:
                          TextStyle(fontSize: 14, fontFamily: "GoldplayBold"),
                    ),
                    trailing: CupertinoSwitch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print(isSwitched);
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  )),
            ]));
  }
}
