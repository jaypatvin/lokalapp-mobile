import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/models/lokal_user.dart';
import 'package:lokalapp/providers/chat.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/chat/chat_helpers.dart';
import 'package:lokalapp/screens/chat/chat_message_stream.dart';
import 'package:lokalapp/screens/chat/chat_view.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/utils/shared_preference.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with AfterLayoutMixin<Chat> {
  final TextEditingController _searchController = TextEditingController();
  var _userSharedPreferences = UserSharedPreferences();
  @override
  void initState() {
    super.initState();

    _userSharedPreferences = UserSharedPreferences();
    _userSharedPreferences.init();
  }

  Widget get buildSearchTextField => Container(
        padding: const EdgeInsets.all(12),
        height: 65,
        child: TextField(
          enabled: false,
          controller: _searchController,
          decoration: InputDecoration(
            isDense: true, // Added this
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),
            fillColor: Color(0xffF2F2F2),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xffBDBDBD),
              size: 23,
            ),
            hintText: 'Search Chats',
            labelStyle: TextStyle(fontSize: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 1),
            hintStyle: TextStyle(color: Color(0xffBDBDBD)),
          ),
        ),
      );

  buildCircleAvatar(String imgUrl) {
    return Container(
      child: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: imgUrl.isNotEmpty ? Image.network(imgUrl) : null,
          )),
    );
  }

  dynamic time = DateFormat.jm().format(DateTime.now());
  List members;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          titleText: "",
          addIcon: false,
          backgroundColor: kYellowColor,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 20),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Chats",
                style: TextStyle(
                    fontFamily: "GoldplayBold",
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          buildLeading: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            buildSearchTextField,
            StreamBuilder<QuerySnapshot>(
                // initialData  : [],
                stream: MessageStreamFirebase.getUsers(
                    ["T5vmCrEYDoZGgl77Vzlv", "b0f2YX5JSskVFiorX9zc"],
                    "T5vmCrEYDoZGgl77Vzlv"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                        shrinkWrap: true, children: makeListWiget(snapshot)),
                  );
                }),
          ],
        ),
      ),
    );
  }

  List<Widget> makeListWiget(AsyncSnapshot snapshot) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    return snapshot.data.docs.map<Widget>((document) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatView()));
        },
        child: ListTile(
          leading: buildCircleAvatar(user.profilePhoto ?? ""),
          title: Text(document.get('title')),
          subtitle: Row(
            children: [
              Expanded(child: Text(document['last_message']['content']))
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout

    _userSharedPreferences.isChat
        ? Container()
        : Provider.of<ChatHelpers>(context, listen: false).showAlert(context);
    setState(() {
      _userSharedPreferences.isChat = true;
    });
  }

  @override
  dispose() {
    _userSharedPreferences?.dispose();
    super.dispose();
  }
}
