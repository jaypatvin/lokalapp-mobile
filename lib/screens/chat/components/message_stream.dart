import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../models/conversation.dart';
import '../../../providers/user.dart';
import '../../../utils/themes.dart';
import '../chat_bubble.dart';

class MessageStream extends StatelessWidget {
  final Stream<QuerySnapshot> messageStream;
  final void Function(String messageId, Conversation message) onReply;
  final void Function(String messageId) onDelete;
  const MessageStream({
    @required this.messageStream,
    @required this.onDelete,
    @required this.onReply,
  });

  List<FocusedMenuItem> _buildMenuItems(
    BuildContext context,
    String messageId,
    Conversation message,
    isUser,
  ) {
    return [
      FocusedMenuItem(
        title: Text(
          "Repy",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        trailingIcon: Icon(
          MdiIcons.replyOutline,
          color: kTealColor,
        ),
        onPressed: () => onReply(messageId, message),
      ),
      FocusedMenuItem(
        title: Text(
          "Copy Message",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        trailingIcon: Icon(
          Icons.copy,
          color: kTealColor,
        ),
        onPressed: () {
          Clipboard.setData(
            ClipboardData(text: message.message),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Message copied to clipboard!",
              ),
            ),
          );
        },
      ),
      if (isUser)
        FocusedMenuItem(
          title: Text(
            "Delete",
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: kPinkColor,
                ),
          ),
          trailingIcon: Icon(
            MdiIcons.trashCanOutline,
            color: kPinkColor,
          ),
          onPressed: () {
            debugPrint("Pressed Delete: $messageId");
            this.onDelete(messageId);
          },
        ),
    ];
  }

  Widget _buildText(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0.sp, color: Colors.black),
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
          return _buildText("Something went wrong, try again.");
        } else {
          final messages = snapshot.data.docs;
          if (messages.isEmpty) return _buildText("Say Hi...");
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (ctx2, index) {
              final messageId = messages[index].id;
              final message = Conversation.fromDocument(messages[index]);
              final userMessage =
                  message.senderId == context.read<CurrentUser>().id;
              final replyTo = message.replyTo;
              return FocusedMenuHolder(
                onPressed: () {},
                menuItems:
                    _buildMenuItems(ctx2, messageId, message, userMessage),
                bottomOffsetHeight: kBottomNavigationBarHeight,
                blurBackgroundColor: Colors.grey.shade200.withOpacity(0.3),
                blurSize: 2.0,
                child: SwipeTo(
                  onRightSwipe:
                      userMessage ? null : () => onReply(messageId, message),
                  onLeftSwipe:
                      userMessage ? () => onReply(messageId, message) : null,
                  child: ChatBubble(
                    conversation: message,
                    replyMessage: replyTo,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
