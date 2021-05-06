import 'package:flutter/material.dart';

Widget customAppBar({
  String titleText,
  Widget leading,
  bool buildLeading = true,
  TextStyle titleStyle,
  Color backgroundColor,
  bool centerTitle = true,
  Function onPressedLeading,
  double elevation = 0, //4.0,
  Color leadingColor = Colors.white,
  PreferredSizeWidget bottom,
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
                    color: leadingColor,
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
    bottom: bottom,
  );
}
