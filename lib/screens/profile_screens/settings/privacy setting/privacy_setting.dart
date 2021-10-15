import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../privacy%20setting/delete_account.dart';

import '../../../../utils/themes.dart';

class PrivacySetting extends StatelessWidget {
  buildButton(context) => Container(
        height: 43,
        width: 300,
        padding: const EdgeInsets.all(2),
        child: FlatButton(
          color: Color(0XFFF1FAFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Color(0XFFCC3752)),
          ),
          textColor: Colors.black,
          child: Text(
            "Delete Account",
            style: TextStyle(
                fontFamily: "Goldplay",
                fontSize: 14,
                color: Color(0XFFCC3752),
                fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DeleteAccount()));
          },
        ),
      );

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
                        "Privacy Settings",
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
              buildButton(context)
            ]));
  }
}
