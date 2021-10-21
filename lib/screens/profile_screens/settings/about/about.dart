import 'package:flutter/material.dart';
import '../components/appbar.dart';
import '../../../../utils/constants/themes.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF1FAFF),
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: AppBarSettings(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "About",
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Center(
              child: Hero(
                tag: "home",
                child: Image.asset("assets/Lokalv2.png"),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "LOKAL",
                  style: TextStyle(
                      letterSpacing: 3,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Color(0XFFFFC700),
                      fontFamily: "Goldplay"),
                ),
              ),
            ),
            Center(
              child: Text(
                "Lokal PH",
                style: TextStyle(
                  color: kTealColor,
                  fontSize: 16,
                  fontFamily: "Goldplay",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Version 1.0",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Goldplay",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
