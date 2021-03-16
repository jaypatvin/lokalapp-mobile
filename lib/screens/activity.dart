import 'package:flutter/material.dart';

// import 'bottomSheet.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      color: Colors.red,
      child: Text("Activity Screen"),
    )));
  }
}
