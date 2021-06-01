import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:lokalapp/models/user_shop.dart';

import 'package:lokalapp/providers/user.dart';

import 'package:lokalapp/screens/chat/chat_helpers.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/utils/themes.dart';

import 'package:lokalapp/widgets/custom_app_bar.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'chat_bubble.dart';

class ChatView extends StatefulWidget {
  final ShopModel shopId;
  final String buyerId;
  final String communityId;
  ChatView({this.shopId, this.buyerId, this.communityId});
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool showSpinner = false;
  String messageText;
  final Uuid _uuid = Uuid();
  void messageStream() async {
    await for (var snapshot in messageRef.snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  TextEditingController _messageController = TextEditingController();

  dynamic time = DateFormat.jm().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
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
        iconTrailing: Icon(
          Icons.more_horiz,
          color: Colors.black,
          size: 28,
        ),
        onPressedLeading: () {
          Navigator.pop(context);
        },
        titleStyle: TextStyle(
            fontFamily: "GoldplayBold",
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w600),
        titleText: user.firstName + " " + user.lastName,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: BoxDecoration(color: Color(0xffF1FAFF)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<ChatHelpers>(context, listen: false)
                          .openGallery(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: kTealColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: kTealColor,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _messageController.clear();
                            var conversationId = _uuid.v4();
                            var lastMessage = {
                              'content': messageText,
                              'created_at': DateTime.now(),
                              'sender': widget.buyerId
                            };
                            Database.uploadChats(
                                false,
                                lastMessage,
                                widget.shopId,
                                widget.buyerId,
                                widget.communityId,
                                widget.buyerId,
                                user.id);
                            Database.uploadConversations(conversationId,
                                messageText, widget.buyerId, false);
                            setState(() {
                              conversationId = null;
                            });
                          },
                          child: Icon(
                            Icons.send,
                            color: kTealColor,
                            size: 18,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(12),
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: kTealColor),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: kTealColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

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
            // final messageSent = message.data()['sent_at'];
            final currentUser = user.email;
            final messageBubble = ChatBubble(
              // time: messageSent,
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
