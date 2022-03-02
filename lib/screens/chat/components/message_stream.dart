import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../models/conversation.dart';
import '../../../providers/auth.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/hooks/automatic_keep_alive.dart';
import '../chat_bubble.dart';

class MessageStream extends HookWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>>? messageStream;
  final void Function(String messageId, Conversation message) onReply;
  final void Function(String messageId) onDelete;
  final Widget? trailing;
  const MessageStream({
    required this.messageStream,
    required this.onDelete,
    required this.onReply,
    this.trailing,
  });

  List<FocusedMenuItem> _buildMenuItems(
    BuildContext context,
    String messageId,
    Conversation message,
    bool isUser,
  ) {
    return [
      FocusedMenuItem(
        title: Text(
          'Reply',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        trailingIcon: const Icon(
          MdiIcons.replyOutline,
          color: kTealColor,
        ),
        onPressed: () => onReply(messageId, message),
      ),
      FocusedMenuItem(
        title: Text(
          'Copy Message',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        trailingIcon: const Icon(
          Icons.copy,
          color: kTealColor,
        ),
        onPressed: () {
          Clipboard.setData(
            ClipboardData(text: message.message),
          );
          showToast('Message copied to clipboard!');
        },
      ),
      if (isUser)
        FocusedMenuItem(
          title: Text(
            'Delete',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: kPinkColor,
                ),
          ),
          trailingIcon: const Icon(
            MdiIcons.trashCanOutline,
            color: kPinkColor,
          ),
          onPressed: () {
            debugPrint('Pressed Delete: $messageId');
            onDelete(messageId);
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

  Widget _buildItem({
    required BuildContext context,
    required String messageId,
    required Conversation message,
    required bool userMessage,
    Conversation? replyMessage,
  }) {
    return FocusedMenuHolder(
      onPressed: () {},
      menuItems: _buildMenuItems(context, messageId, message, userMessage),
      bottomOffsetHeight: kBottomNavigationBarHeight,
      blurBackgroundColor: Colors.grey.shade200.withOpacity(0.3),
      blurSize: 2.0,
      child: SwipeTo(
        onRightSwipe: userMessage ? null : () => onReply(messageId, message),
        onLeftSwipe: userMessage ? () => onReply(messageId, message) : null,
        child: ChatBubble(
          conversation: message,
          replyMessage: replyMessage,
          forFocus: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: messageStream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildText('Something went wrong, try again.');
        } else {
          final messages = snapshot.data!.docs;
          if (messages.isEmpty) return _buildText('Say Hi...');
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (ctx2, index) {
              final messageId = messages[index].id;
              final message = Conversation.fromDocument(messages[index]);
              final userMessage =
                  message.senderId == context.read<Auth>().user!.id;

              final replyTo = messages.firstWhereOrNull(
                (e) => e.id == message.replyTo?.id,
              );

              final Conversation? replyMessage =
                  replyTo != null ? Conversation.fromDocument(replyTo) : null;

              final _message = message.archived
                  ? Conversation(
                      archived: true,
                      createdAt: message.createdAt,
                      message: 'Deleted Message',
                      senderId: message.senderId,
                      sentAt: message.sentAt,
                    )
                  : message;

              final Conversation? _replyMessage;
              if (_message.archived) {
                _replyMessage = null;
              } else if (replyMessage != null && replyMessage.archived) {
                _replyMessage = Conversation(
                  archived: replyMessage.archived,
                  createdAt: replyMessage.createdAt,
                  message: 'Deleted Message',
                  senderId: replyMessage.senderId,
                  sentAt: replyMessage.sentAt,
                );
              } else {
                _replyMessage = replyMessage;
              }

              return Column(
                children: [
                  _buildItem(
                    context: context,
                    messageId: messageId,
                    message: _message,
                    userMessage: userMessage,
                    replyMessage: _replyMessage,
                  ),
                  if (index == 0 && trailing != null) trailing!,
                ],
              );
            },
          );
        }
      },
    );
  }
}
