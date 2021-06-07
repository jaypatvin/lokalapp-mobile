import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/models/chat.dart';
import 'package:lokalapp/models/conversation.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_shop.dart';
import '../../providers/chat.dart';
import '../../providers/user.dart';
import '../../services/database.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import 'chat_bubble.dart';
import 'chat_message_stream.dart';

class ChatView extends StatefulWidget {
  final QueryDocumentSnapshot chatDocument;
  ChatView(this.chatDocument);
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool showSpinner = false;
  String messageText;
  final Uuid _uuid = Uuid();
  var chatSnapshot;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   getUsers();
  //   super.initState();
  // }

  void messageStream() async {
    await for (var snapshot in messageRef.snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  getUsers() async {
    var user = Provider.of<CurrentUser>(context, listen: false);
    var members;
    chatSnapshot = await messageRef
        .where(members, arrayContainsAny: [user.id]).snapshots();
  }

  TextEditingController _messageController = TextEditingController();

  dynamic time = DateFormat.jm().format(DateTime.now());
  Future<bool> createProduct() async {
    var chat = Provider.of<ChatProvider>(context, listen: false);

    var user = Provider.of<CurrentUser>(context, listen: false);

    try {
      var chatList = {
        // 'user_id': document.id,
        'members': [user.id],
        'message': messageText
      };
      await chat.create(user.idToken, chatList);
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

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
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: MessageStream(widget.chatDocument.id),
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
  MessageStream(this.chatId);
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
                        return MessagesWidget(
                          message: message,
                          isMe: message.senderId == user.id,
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
