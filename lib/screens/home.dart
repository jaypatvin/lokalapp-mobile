import 'package:flutter/material.dart';
import 'package:lokalapp/models/user.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:lokalapp/root/root.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: RaisedButton(
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
      ),
    );
  }
}
