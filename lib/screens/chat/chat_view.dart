import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/utils/utility.dart';
import 'package:lokalapp/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _picker = ImagePicker();
  TextEditingController _messageController = TextEditingController();
  openGallery(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              _picker.getImage(source: ImageSource.camera);
                            },
                            child: Container(
                              height: 125.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                color: Color(0XFFFF7A00),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Take a photo",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "GoldplayBold"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 125.0,
                            width: 130.0,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi1.wp.com%2Fkatzenworld.co.uk%2Fwp-content%2Fuploads%2F2019%2F06%2Ffunny-cat.jpeg%3Ffit%3D1920%252C1920%26ssl%3D1&f=1&nofb=1'))),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 125.0,
                            width: 130.0,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2F4.bp.blogspot.com%2F-Jx21kNqFSTU%2FUXemtqPhZCI%2FAAAAAAAAh74%2FBMGSzpU6F48%2Fs640%2Ffunny-cat-pictures-047-001.jpg&f=1&nofb=1'))),
                          )
                        ],
                      ),
                    ],
                  ),
                ]),
            // height: ,
            height: MediaQuery.of(context).size.height * 0.23,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color(0xffF1FAFF),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How can I help you?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is the chocolate cake still available?",
        messageType: "sender"),
    ChatMessage(
        messageContent: "Yes, it is. What size would you want to order?",
        messageType: "receiver"),
    ChatMessage(
        messageContent: "I'll get the family sized cake. ",
        messageType: "sender"),
  ];

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
        // iconTrailing: Icon(
        //   Icons.more_horiz,
        //   color: Colors.black,
        //   size: 28,
        // ),
        // onPressedTrailing: () {},
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
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                padding: const EdgeInsets.all(20.0), child: Text("$time")),
          ),
          Positioned(
            top: 40,
            bottom: 0,
            left: 0,
            right: 0,
            child: ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: (messages[index].messageType == "receiver"
                            ? kTealColor
                            : Color(0xffF1FAFF)),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        messages[index].messageContent,
                        style: TextStyle(
                            fontSize: 15,
                            color: messages[index].messageType == 'receiver'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Color(0xffF1FAFF),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      openGallery(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
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
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.send,
                          color: kTealColor,
                          size: 18,
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
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
}
