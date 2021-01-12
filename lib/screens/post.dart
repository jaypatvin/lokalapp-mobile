import 'package:flutter/material.dart';
import 'package:lokalapp/widgets/container.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE0E0E0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableContainer(
              child: Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                    child: Text("hello"),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
