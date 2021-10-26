import 'package:flutter/material.dart';
import 'invite_sent.dart';
import '../../../../utils/constants/themes.dart';

class InviteAFriend extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
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
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      "Invite a Friend",
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFFFFC700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 140,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // padding: const EdgeInsets.all(30),
                    child: Text(
                      "Expand your community!",
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 22,
                          color: kTealColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // padding: const EdgeInsets.all(8),
                child: Text(
                  "Share an invite code by entering the ",
                  style: TextStyle(
                    fontFamily: "GoldplayBold",
                    // fontSize: 22,
                    // color: kTealColor,
                    // fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Text(
                "recipient's email address below.",
                style: TextStyle(
                  fontFamily: "GoldplayBold",
                  // fontSize: 22,
                  // color: kTealColor,
                  // fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 80,
                padding: const EdgeInsets.all(10),
                child: TextField(
                  // textAlign: TextAlign.center,
                  cursorColor: Colors.grey.shade400,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email address',
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 43,
                width: 200,
                child: FlatButton(
                  // height: 50,
                  // minWidth: 100,
                  color: kTealColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: kTealColor),
                  ),
                  textColor: Colors.black,
                  child: Text(
                    "SEND INVITE CODE",
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => InviteSent()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
