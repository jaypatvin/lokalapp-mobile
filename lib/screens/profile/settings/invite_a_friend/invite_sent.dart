import 'package:flutter/material.dart';
import '../../../../utils/constants/themes.dart';

class InviteSent extends StatelessWidget {
  buildButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 43,
          width: 180,
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
              "COPY INVITE CODE",
              style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF1FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                            color: kTealColor,
                            fontSize: 16,
                            fontFamily: "GoldplayBold",
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 100, right: 80),
                    child: IconButton(
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: Color(0XFFFFC700),
                          size: 120,
                        ),
                        onPressed: () {}),
                  )
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  Container(
                    child: Text(
                      "Invite Sent!",
                      style: TextStyle(
                          color: kTealColor,
                          fontFamily: "Goldplay",
                          fontWeight: FontWeight.w700,
                          fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "Your friend should recievean invite",
                          style: TextStyle(
                            fontFamily: "GoldplayBold",
                            // fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text("code in the email provided."),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      buildButtons(context)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
