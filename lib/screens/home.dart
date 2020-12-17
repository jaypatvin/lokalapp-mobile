import 'package:flutter/material.dart';
import 'package:lokalapp/models/user.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:lokalapp/root/root.dart';

class Home extends StatelessWidget {
  void _showToast(BuildContext context, String text) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
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
}
