import 'package:flutter/material.dart';


class ProfileStoreName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
                      padding: EdgeInsets.all(17),
                      child: Text(
                        "Bakey Bakey",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ));
  }
}