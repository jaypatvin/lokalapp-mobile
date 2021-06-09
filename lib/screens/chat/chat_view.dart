import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/models/conversation.dart';
import 'package:lokalapp/providers/users.dart';
import 'package:lokalapp/screens/chat/chat_helpers.dart';
import 'package:lokalapp/screens/chat/chat_profile.dart';

import 'package:lokalapp/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/chat.dart';
import '../../providers/user.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import 'chat_bubble.dart';
import 'chat_message_stream.dart';
import 'package:swipe_to/swipe_to.dart';

import 'new_message.dart';

class ChatView extends StatefulWidget {
  final QueryDocumentSnapshot chatDocument;
  ChatView(this.chatDocument);
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool showSpinner = false;
  // String messageText;
  final Uuid _uuid = Uuid();
  var chatSnapshot;

  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  File pickedImage;
  TextEditingController _messageController = TextEditingController();
  Conversation replyMessage;
  bool isReplied = false;
  var snap;
  dynamic time = DateFormat.jm().format(DateTime.now());

  void replyToMessage(
    Conversation message,
  ) {
    setState(() {
      replyMessage = message;
      isReplied = true;
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }

  replied() {
    double didReplyTrue = 120.0;
    double didReplyFalse = 80.0;
    setState(() {
      isReplied ? didReplyTrue : didReplyFalse;
      isReplied = false;
    });
  }

  void onSendMessage() async {
    var user = Provider.of<CurrentUser>(context, listen: false);
    var helper = Provider.of<ChatHelpers>(context, listen: false);
    var chat = Provider.of<ChatProvider>(context, listen: false);
    var lokalUser = Provider.of<Users>(context, listen: false);
    var current = lokalUser.findById(widget.chatDocument.data()['members'][1]);
    var chatList = {
      'user_id': user.id,
      'members': [
        user.id,
        widget.chatDocument.data()['members'][1] == current.id
            ? current.id
            : current.id
      ],
      'message': _messageController.text
    };
    await chat.create(user.idToken, chatList);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    var helper = Provider.of<ChatHelpers>(context, listen: false);
    var chat = Provider.of<ChatProvider>(context, listen: false);
    var lokalUser = Provider.of<Users>(context, listen: false);
    var current = lokalUser.findById(widget.chatDocument.data()['members'][1]);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: customAppBar(
        addPaddingLeading: true,
        topLeading: 23.0,
        bottomLeading: 0.0,
        rightLeading: 0.0,
        leftLeading: 0.0,
        addPaddingText: true,
        topText: 28.0,
        bottomText: 0.0,
        leftText: 0.0,
        rightText: 0.0,
        addIcon: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatProfile(
                                chatDocument: widget.chatDocument,
                              )));
                }),
          )
        ],
        onPressedLeading: () {
          Navigator.pop(context);
        },
        titleStyle: TextStyle(
            fontFamily: "GoldplayBold",
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w600),
        titleText: widget.chatDocument.data()['title'],
        leadingColor: Colors.black,
        backgroundColor: kYellowColor,
        buildLeading: true,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 20),
          child: Container(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: MessageStream(widget.chatDocument.id, (message) {
                  replyToMessage(message);
                  focusNode.requestFocus();
                }, replyMessage),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: replied(),
                color: Color(0XFFF1FAFF),
                child: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: kTealColor),
                              color: Colors.transparent,
                              shape: BoxShape.circle),
                          child: IconButton(
                            icon: Icon(
                              Icons.attach_file,
                              color: kTealColor,
                            ),
                            onPressed: () async {
                              var photo = await Provider.of<MediaUtility>(
                                      context,
                                      listen: false)
                                  .showMediaDialog(context);
                              setState(() {
                                pickedImage = photo;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: NewMessageWidget(
                        snap: widget.chatDocument,
                        messageController: _messageController,
                        focusNode: focusNode,
                        idUser: current.id,
                        onCancelReply: cancelReply,
                        replyMessage: replyMessage,
                        onSend: () async {
                          var chatList = {
                            'user_id': user.id,
                            'members': [
                              user.id,
                              widget.chatDocument.data()['members'][1] ==
                                      current.id
                                  ? current.id
                                  : current.id
                            ],
                            'message': _messageController.text
                          };
                          await chat.create(user.idToken, chatList);
                          _messageController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final String chatId;
  final Function onSwipedMessage;
  final Conversation replyMessage;
  MessageStream(this.chatId, this.onSwipedMessage, this.replyMessage);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: MessageStreamFirebase.getConversation(this.chatId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              print(snapshot.error);
              return buildText('Something Went Wrong Try later');
            } else {
              final messages = snapshot.data.docs;

              return messages.isEmpty
                  ? buildText('Say Hi..')
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final Conversation message = Conversation.fromMap(
                          messages[index].data(),
                        );

                        return SwipeTo(
                          onRightSwipe: () => onSwipedMessage(message),
                          child: MessagesWidget(
                            isReply: replyMessage,
                            message: message,
                            isMe: message.senderId == user.id,
                          ),
                        );
                      },
                    );
            }
        }
      },
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      );
}
