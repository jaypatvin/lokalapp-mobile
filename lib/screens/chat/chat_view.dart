import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/models/chat.dart';
import 'package:lokalapp/models/conversation.dart';
import 'package:lokalapp/screens/chat/chat_helpers.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:emoji_picker/emoji_picker.dart';
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
  // String messageText;
  final Uuid _uuid = Uuid();
  var chatSnapshot;

  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;

  TextEditingController _messageController = TextEditingController();

  dynamic time = DateFormat.jm().format(DateTime.now());
  Future createMessage() async {
    var chat = Provider.of<ChatProvider>(context, listen: false);

    var user = Provider.of<CurrentUser>(context, listen: false);

    try {
      var chatList = {
        'user_id': user.id,
        'members': [user.id],
        'message': _messageController.text
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
    var helper = Provider.of<ChatHelpers>(context, listen: false);
    var chat = Provider.of<ChatProvider>(context, listen: false);
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: MessageStream(widget.chatDocument.id),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                color: Color(0XFFF1FAFF),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: kTealColor),
                                  color: Colors.transparent,
                                  shape: BoxShape.circle),
                              child: IconButton(
                                icon: Icon(
                                  Icons.attach_file,
                                  color: kTealColor,
                                ),
                                onPressed: () {
                                  helper.openGallery(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          height: 50,
                          child: Card(
                            margin:
                                EdgeInsets.only(left: 2, right: 2, bottom: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(color: kTealColor, width: 1)),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              controller: _messageController,
                              focusNode: focusNode,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 1.0, left: 10.0),
                                border: InputBorder.none,
                                hintText: "Type a message",
                                hintStyle: TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: kTealColor,
                                    ),
                                    onPressed: () async {
                                      var chatList = {
                                        'user_id': user.id,
                                        'members': [
                                          user.id,
                                          "b0f2YX5JSskVFiorX9zc"
                                        ],
                                        'message': _messageController.text
                                      };
                                      await chat.create(user.idToken, chatList);
                                      _messageController.clear();
                                    }),
                              ),
                            ),
                          ),
                        ),
                      ],
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
