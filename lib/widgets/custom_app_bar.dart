import 'package:flutter/material.dart';

Widget customAppBar({
  String titleText,
  Widget leading,
  bool buildLeading = true,
  TextStyle titleStyle,
  Color backgroundColor,
  bool centerTitle = true,
  Function onPressedLeading,
  double elevation = 4.0,
}) {
  return AppBar(
    leading: !buildLeading
        ? null
        : leading ??
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                  ),
                  onPressed: onPressedLeading,
                );
              },
            ),
    title: Text(
      titleText,
      style: TextStyle(
        color: Color(0xFFFFC700),
        fontFamily: "Goldplay",
        fontWeight: FontWeight.w800,
      ).merge(titleStyle),
    ),
    centerTitle: centerTitle,
    backgroundColor: backgroundColor ?? Color(0xff57183f),
    elevation: elevation,
  );
}
