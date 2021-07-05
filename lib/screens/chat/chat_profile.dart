import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user.dart';
import '../../providers/users.dart';
import '../../services/database.dart';
import '../../utils/themes.dart';
import 'shared_media.dart';

class ChatProfile extends StatefulWidget {
  final QueryDocumentSnapshot chatDocument;
  ChatProfile({this.chatDocument});

  @override
  _ChatProfileState createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  buildCircleAvatar(String imgUrl, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(const Radius.circular(50.0)),
      ),
      child: ClipOval(
        child: imgUrl.isNotEmpty
            ? Image.network(
                imgUrl,
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      );
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);

    var lokalUser = Provider.of<Users>(context, listen: false);
    var current = lokalUser.findById(widget.chatDocument.data()['members'][1]);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildCircleAvatar(user.profilePhoto ?? "", 100.0, 100.0),
                SizedBox(
                  width: 5,
                ),
                buildCircleAvatar(
                    widget.chatDocument.data()['members'][1] == current.id
                        ? current.profilePhoto
                        : null,
                    100.0,
                    100.0),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.chatDocument.data()['members'][0] == user.id
                    ? Text(
                        "You , ",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18.0),
                      )
                    : user.firstName,
                Text(
                  widget.chatDocument.data()['members'][1] == current.id
                      ? current.firstName + " " + current.lastName
                      : '',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Database.instance.getUserChats(user.id),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(
                            child: buildText('Something Went Wrong Try later'));
                      } else {
                        final data = snapshot.data.docs;

                        return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor: kTealColor,
                                          buttonColor: kTealColor,
                                          accentColor: kTealColor),
                                      child: ExpansionTile(
                                        title: Text(
                                          "Chat Members",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        children: <Widget>[
                                          ListTile(
                                            leading: buildCircleAvatar(
                                                user.profilePhoto ?? '',
                                                50.0,
                                                50.0),
                                            title: Text(widget.chatDocument
                                                        .data()['members'][0] ==
                                                    user.id
                                                ? user.firstName +
                                                    " " +
                                                    user.lastName
                                                : ""),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ListTile(
                                            leading: buildCircleAvatar(
                                                widget.chatDocument.data()[
                                                            'members'][1] ==
                                                        current.id
                                                    ? current.profilePhoto
                                                    : null,
                                                50.0,
                                                50.0),
                                            title: Text(widget.chatDocument
                                                        .data()['members'][1] ==
                                                    current.id
                                                ? current.firstName +
                                                    " " +
                                                    current.lastName
                                                : ''),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor: kTealColor,
                                          buttonColor: kTealColor,
                                          accentColor: kTealColor),
                                      child: ListTile(
                                        leading: Text(
                                          "Shared Media",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        trailing: Container(
                                          width: 28,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward,
                                                color: kTealColor,
                                                size: 18.0,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SharedMedia()));
                                              }),
                                        ),
                                      ),
                                    ),
                                  ]));
                            });
                      }
                  }
                })
          ]),
        ));
  }
}
