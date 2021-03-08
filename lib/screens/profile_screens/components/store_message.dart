import 'package:flutter/material.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';

class StoreMessage extends StatefulWidget {
  final String description;
  StoreMessage({this.description});

  @override
  _StoreMessageState createState() => _StoreMessageState();
}

class _StoreMessageState extends State<StoreMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
              padding: EdgeInsets.all(22),
              child: Text(
                widget.description,
                // "Bacon ipsum dolor amet turducken prosciutto shankle buffalo burgdoggen chicken picanha tail. Filet mignon meatball ball tip, buffalo ham chislic jowl drumstick tongue turkey boudin prosciutto cow turducken swine.",
                style: TextStyle(
                    fontFamily: "GoldplayBold",
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              )),
        )
      ],
    );
  }
}
