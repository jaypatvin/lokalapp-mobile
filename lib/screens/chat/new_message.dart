import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/conversation.dart';
import 'package:lokalapp/providers/chat.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/providers/users.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

import 'chat_helpers.dart';
import 'components/reply_message.dart';

class NewMessageWidget extends StatefulWidget {
  final FocusNode focusNode;
  final String idUser;
  final Conversation replyMessage;
  final VoidCallback onCancelReply;
  final Function onSend;
  final messageController;
  final QueryDocumentSnapshot snap;
  const NewMessageWidget({
    @required this.focusNode,
    @required this.idUser,
    @required this.replyMessage,
    @required this.onCancelReply,
    @required this.messageController,
    @required this.snap,
    @required this.onSend,
    Key key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  String message = '';

  static final inputTopRadius = Radius.circular(12);
  static final inputBottomRadius = Radius.circular(24);

  @override
  Widget build(BuildContext context) {
    final isReplying = widget.replyMessage != null;

    return Stack(children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (isReplying) Expanded(child: buildReply()),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            child: Card(
              margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: kTealColor, width: 1)),
              child: TextFormField(
                cursorColor: Colors.grey,
                textCapitalization: TextCapitalization.sentences,
                controller: widget.messageController,
                focusNode: widget.focusNode,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 1,
                autocorrect: true,
                enableSuggestions: true,
                onChanged: (value) => setState(() {
                  message = value;
                }),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 1.0, left: 10.0),
                  border: InputBorder.none,
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: kTealColor,
                    ),
                    onPressed: widget.onSend,
                  ),

                  //
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ]);
  }

  Widget buildReply() => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: inputTopRadius,
            topRight: inputTopRadius,
          ),
        ),
        child: ReplyMessageWidget(
          snapshot: widget.snap,
          message: widget.replyMessage,
          onCancelReply: widget.onCancelReply,
        ),
      );
}
