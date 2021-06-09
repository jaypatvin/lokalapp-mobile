import 'package:flutter/material.dart';
// import 'package:lokalapp/models/chat_user.dart';

import 'package:lokalapp/models/conversation.dart';
import 'package:lokalapp/utils/themes.dart';

import 'components/reply_message.dart';

class MessagesWidget extends StatelessWidget {
  final Conversation message;
  final bool isMe;
  final Conversation isReply;
  const MessagesWidget(
      {@required this.message, @required this.isMe, @required this.isReply});

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: 140),
            decoration: BoxDecoration(
              color: isMe ? Color(0XFFF1FAFF) : kTealColor,
              borderRadius: isMe
                  ? borderRadius
                      .subtract(BorderRadius.only(bottomRight: radius))
                  : borderRadius
                      .subtract(BorderRadius.only(bottomLeft: radius)),
            ),
            child: buildMessages(),
          ),
      ],
    );
  }

  Widget buildMessages() {
    final messageWidget = Text(
      message.message,
      style: TextStyle(color: isMe ? Colors.black : Colors.white),
      textAlign: isMe ? TextAlign.end : TextAlign.start,
    );

    if (this.isReply == null) {
      return messageWidget;
    } else {
      return Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          buildReplyMessage(),
          messageWidget,
        ],
      );
    }
  }

  Widget buildReplyMessage() {
    final replyMessage = this.isReply;
    final isReplying = replyMessage != null;

    if (!isReplying) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        child: ReplyMessageWidget(
          message: replyMessage,
        ),
      );
    }
  }
}
