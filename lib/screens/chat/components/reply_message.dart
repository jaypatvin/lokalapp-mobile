import 'package:flutter/material.dart';

import '../../../models/conversation.dart';
import '../../../utils/themes.dart';

class ReplyMessageWidget extends StatelessWidget {
  final bool isRepliedByUser;
  final Conversation message;
  final VoidCallback onCancelReply;

  const ReplyMessageWidget({
    @required this.message,
    this.isRepliedByUser = true,
    this.onCancelReply,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            color: isRepliedByUser ? kTealColor : Color(0xFFF1FAFF),
            width: 4,
          ),
          SizedBox(width: 8),
          Expanded(child: buildReplyMessage()),
        ],
      ),
    );
  }

  Widget buildReplyMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Replying to",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: isRepliedByUser ? kTealColor : Color(0xFFF1FAFF),
                  ),
                ),
              ),
              if (onCancelReply != null)
                GestureDetector(
                  child: Icon(Icons.close, size: 16),
                  onTap: onCancelReply,
                )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.message,
            style: TextStyle(
                color: isRepliedByUser ? Colors.black : Color(0xFFF1FAFF)),
          ),
        ],
      ),
    );
  }
}
