import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

class AppBarSettings extends StatelessWidget {
  Function onPressed;
  String text;
  AppBarSettings({this.onPressed, this.text});

  Widget get appBar => PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ],
          ),
          width: double.infinity,
          // MediaQuery.of(context).size.width,
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
                      onPressed: onPressed,
                      // () {
                      // Navigator.pop(context);
                      // }
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Container(
                    // padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      text,
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
      );

  @override
  Widget build(BuildContext context) {
    return appBar;
  }
}
