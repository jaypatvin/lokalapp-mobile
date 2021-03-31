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
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // IconButton(
        //     icon: Icon(Icons.arrow_back_sharp),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     }),
        Center(
            child: Container(
          color: Colors.red,
          child: Text("Activity Screen"),
        )),
      ],
    ));
  }
}
