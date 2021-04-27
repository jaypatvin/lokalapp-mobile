import 'package:flutter/material.dart';

import 'package:lokalapp/screens/discover/discover.dart';
import 'package:lokalapp/utils/themes.dart';

class OrderPlaced extends StatelessWidget {
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
              "GO TO MY ACTIVIY",
              style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              //dont add yet. it cant push to a screen within bottom navigation
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ActivityScreen()));
            },
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
                    padding: const EdgeInsets.all(18.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Discover()),
                            (route) => false);
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
                      "Order Placed!",
                      style: TextStyle(
                          color: kTealColor,
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
                          "You can track you order using",
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
                          child: RichText(
                        text: TextSpan(
                          text: 'the ',
                          // style: TextStyle(fontFamily: "Goldplay"),
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: 'My Activity ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Goldplay")),
                            TextSpan(
                                text: 'page.',
                                style: TextStyle(fontFamily: "GoldplayBold")),
                          ],
                        ),
                      )),
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
