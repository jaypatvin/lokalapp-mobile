import 'package:flutter/material.dart';
import '../../../../utils/constants/themes.dart';

class AccountDeleted extends StatelessWidget {
  buildButton(context) => Container(
        height: 43,
        width: 300,
        padding: const EdgeInsets.all(2),
        child: FlatButton(
          color: kTealColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: kTealColor),
          ),
          textColor: Colors.black,
          child: Text(
            "Okay",
            style: TextStyle(
                fontFamily: "Goldplay",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFC700),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // color: _kMainColor,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Hero(
                    tag: "home",
                    child: Image.asset("assets/Lokalv2.png"),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "LOKAL",
                      style: TextStyle(
                          letterSpacing: 3,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Color(0XFFFF7A00),
                          fontFamily: "Goldplay"),
                    ),
                  ),
                  Hero(
                    tag: "plaza",
                    child: Text(
                      "Your neighborhood plaza",
                      style: TextStyle(
                        color: kTealColor,
                        fontSize: 16,
                        fontFamily: "Goldplay",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Account Deleted!",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Goldplay",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(2),
                child: Text("We're sad to see you go :(")),
            Container(
                padding: const EdgeInsets.all(2),
                child: Text("If you change your mind, you can")),
            Container(
                padding: const EdgeInsets.all(2),
                child: Text("log back in again within 30 days!")),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            buildButton(context)
          ],
        ),
      ),
    );
  }
}
