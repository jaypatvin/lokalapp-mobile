import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../models/conversation.dart';
import '../chat_bubble.dart';

class MessageStream extends StatelessWidget {
  final Stream<QuerySnapshot> messageStream;
  final Function(String, Conversation) onRightSwipe;
  const MessageStream({@required this.messageStream, this.onRightSwipe});

  Widget buildText(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: this.messageStream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot == null) {
          return buildText("Something went wrong, try again.");
        } else {
          final messages = snapshot.data.docs;
          if (messages.isEmpty) return buildText("Say Hi...");

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (ctx2, index) {
              final message = Conversation.fromMap(messages[index].data());
              final replyTo = message.replyTo;
              return SwipeTo(
                onRightSwipe: () => onRightSwipe(messages[index].id, message),
                child: ChatBubble(
                  conversation: message,
                  replyMessage: replyTo,
                ),
              );
            },
          );
        }
      },
    );
  }
}
