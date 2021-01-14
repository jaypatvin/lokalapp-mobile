import 'package:flutter/material.dart';

class ReusableContainer extends StatelessWidget {
  final Widget child;
  final padding;
  ReusableContainer({this.child, this.padding});
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: padding,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(4.0, 4.0),
          )
        ],
      ),
      child: child,
    );
  }
}
