import 'package:flutter/material.dart';

class BasicInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Basic Information",
          style: TextStyle(
              fontFamily: "Goldplay",
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
