import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({this.text, this.sender, this.isMe, this.time});
  final String sender;
  final String text;
  final bool isMe;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          // Text(this.time),
          Text(
            this.sender,
            style: TextStyle(
                fontSize: 12.0, color: Colors.black, fontFamily: "Goldplay"),
          ),
          Material(
            borderRadius:
                isMe ? BorderRadius.circular(8) : BorderRadius.circular(8),
            elevation: 5.0,
            color: isMe ? kTealColor : Color(0xffF1FAFF),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                '$text',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
