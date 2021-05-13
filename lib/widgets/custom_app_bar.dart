import 'package:flutter/material.dart';

Widget customAppBar({
  String titleText,
  Widget leading,
  bool buildLeading = true,
  TextStyle titleStyle,
  bool addPaddingLeading = false,
  double topLeading,
  double leftLeading,
  double rightLeading,
  double bottomLeading,
  bool addPaddingText = false,
  double topText,
  double bottomText,
  double rightText,
  double leftText,
  Color backgroundColor,
  Icon iconTrailing,
  bool addIcon = false,
  bool centerTitle = true,
  Function onPressedLeading,
  Function onPressedTrailing,
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
                return Container(
                  padding: addPaddingLeading
                      ? EdgeInsets.only(
                          top: topLeading,
                          bottom: bottomLeading,
                          left: leftLeading,
                          right: rightLeading)
                      : EdgeInsets.zero,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_sharp,
                      color: leadingColor,
                    ),
                    onPressed: onPressedLeading,
                  ),
                );
              },
            ),
    title: Padding(
      padding: addPaddingText
          ? EdgeInsets.only(
              top: topText,
              bottom: bottomText,
              left: leftText,
              right: rightText)
          : EdgeInsets.zero,
      child: Text(
        titleText,
        style: TextStyle(
          color: Color(0xFFFFC700),
          fontFamily: "Goldplay",
          fontWeight: FontWeight.w800,
        ).merge(titleStyle),
      ),
    ),
    // actions: [
    //   Visibility(
    //       visible: addIcon,
    //       child: IconButton(icon: iconTrailing, onPressed: onPressedTrailing))
    // ],
    centerTitle: centerTitle,
    backgroundColor: backgroundColor ?? Color(0xff57183f),
    elevation: elevation,
    bottom: bottom,
  );
}
