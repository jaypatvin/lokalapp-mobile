import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../states/current_user.dart';
import '../widgets/rounded_button.dart';

class DraftPost extends StatefulWidget {
  @override
  _DraftPostState createState() => _DraftPostState();
}

class _DraftPostState extends State<DraftPost> {
  TextEditingController _userController = TextEditingController();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  CurrentUser _user;
  dynamic message;

  @override
  void initState() {
    _user = Provider.of<CurrentUser>(context, listen: false);
    super.initState();
    _userController.addListener(() {
      setState(() {
        this.message = _userController.text;
      });
    });
  }

  FlatButton cancelButton() {
    return FlatButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: Text(
          "Cancel",
          style: TextStyle(
              fontFamily: "Goldplay",
              color: Color(0xff828282),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ));
  }

  Card buildCard() {
    return Card(
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 0),
          child: TextField(
            controller: _userController,
            cursorColor: Colors.black,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "What's on your mind?"),
          )),
    );
  }

  Row postButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 20),
          child: RoundedButton(
            onPressed: () async {
              bool postSuccess =
                  await _user.postActivityFeed(_userController.text);
              if (postSuccess) {
                Navigator.pop(context, true);
              }
            },
            label: "Post",
            fontFamily: "Goldplay",
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1FAFF)),
              child: Container(
                margin: const EdgeInsets.only(top: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [cancelButton()],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.30,
                child: buildCard()),
            postButton()
          ],
        ),
      ),
    );
  }
}
