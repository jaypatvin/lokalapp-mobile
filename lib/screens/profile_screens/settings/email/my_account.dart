import 'package:flutter/material.dart';
import 'change_email.dart';
import '../password/change_password.dart';
import '../../../../utils/constants/themes.dart';

class MyAccount extends StatelessWidget {
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
                      width: 60,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        "My Account",
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
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  leading: Text(
                    "Change Email Address",
                    style: TextStyle(
                      fontFamily: "Goldplay",
                      // fontWeight: FontWeight.w600
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeEmail()));
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: kTealColor,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword()));
                },
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Text(
                      "Change Password",
                      style: TextStyle(
                        fontFamily: "Goldplay",
                        //  fontWeight: FontWeight.w500
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: kTealColor,
                    ),
                  ),
                ),
              ),
            ]));
  }
}
