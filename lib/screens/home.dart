import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:lokalapp/root/root.dart';

class Home extends StatefulWidget {
  final dynamic message;
  Home({this.message});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _userController = TextEditingController();
  String message;

  Padding buildTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
      child: Container(
        child: Theme(
          data: ThemeData(primaryColor: Color(0xFFE0E0E0)),
          child: TextField(
            controller: _userController,
            onSubmitted: (value) {
              _postMessage(context);
            },
            decoration: InputDecoration(
              isDense: true, // Added this
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(14.0),
                ),
              ),
              fillColor: Colors.white,
              suffixIcon: Icon(
                Icons.assignment_turned_in,
                color: Color(0xffE0E0E0),
              ),
              hintText: 'What\'s on your mind?',
              hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
            ),
          ),
        ),
      ),
    );
  }

  Future _postMessage(BuildContext context) async {
    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);
    final userId = _user.getCurrentUser.userUids;
    Map<dynamic, dynamic> _account;
    if (_userController.text.length > 0) {
      _account = {'user': userId, 'message': _userController.text};
      await Database().postMessage(_account, _userController.text);
      Navigator.pop(context, true);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please type a message'),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userController.addListener(() {
      setState(() {
        this.message = _userController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () async {
                CurrentUser _user =
                    Provider.of<CurrentUser>(context, listen: false);
                String _returnString = await _user.onSignOut();
                if (_returnString == "success") {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Root()),
                      (route) => false);
                }
              },
              child: Text("Log out"),
            ),
            RaisedButton(
              onPressed: () async {
                CurrentUser _user =
                    Provider.of<CurrentUser>(context, listen: false);
                String _returnString = await _user.linkWithFacebook();
                if (_returnString == "success") {
                  _showToast(context, "Linked with Facebook");
                }
              },
              child: Text("Link with Facebook"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userController.dispose();

    super.dispose();
  }
}
