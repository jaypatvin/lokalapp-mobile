import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/services/database.dart';
import 'package:provider/provider.dart';

import 'chat_bubble.dart';

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
        stream: messageRef.doc().collection('conversation').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }

          final messages = snapshot.data.docs.reversed;
          List messageWidgets = [];
          messageWidgets = messages.map((message) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];
            final currentUser = user.email;
            final messageBubble = ChatBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );

            return messageBubble;
          }).toList();

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageWidgets,
            ),
          );
        });
  }
}
