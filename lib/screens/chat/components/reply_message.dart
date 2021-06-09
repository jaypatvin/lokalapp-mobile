import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/conversation.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/providers/users.dart';
import 'package:provider/provider.dart';

class ReplyMessageWidget extends StatelessWidget {
  final Conversation message;
  final VoidCallback onCancelReply;
  final QueryDocumentSnapshot snapshot;
  const ReplyMessageWidget({
    @required this.message,
    this.onCancelReply,
    this.snapshot,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            Container(
              color: Colors.green,
              width: 4,
            ),
            SizedBox(width: 8),
            Expanded(child: buildReplyMessage(context)),
          ],
        ),
      );

  Widget buildReplyMessage(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    var lokalUser = Provider.of<Users>(context, listen: false);

    var snap = snapshot.data()['members'];
    var current = lokalUser.findById(snap[1]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${snap[0] == message.senderId ? user.firstName : current.firstName}',
                style: TextStyle(fontWeight: FontWeight.bold),
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
        Text(message.message, style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}
