import 'package:flutter/material.dart';
import 'package:lokalapp/widgets/container.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
            SingleChildScrollView(
              child: ListView(),
            )
          ],
        ));
  }
}
