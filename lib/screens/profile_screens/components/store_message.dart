import 'package:flutter/material.dart';


class StoreMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return    Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(22),
                        child: Text(
                          "Bacon ipsum dolor amet turducken prosciutto shankle buffalo burgdoggen chicken picanha tail. Filet mignon meatball ball tip, buffalo ham chislic jowl drumstick tongue turkey boudin prosciutto cow turducken swine.",
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