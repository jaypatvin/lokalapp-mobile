import 'package:flutter/material.dart';
import 'package:lokalapp/models/user.dart';
import 'package:lokalapp/root/root.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            Users _users = Provider.of<Users>(context, listen: false);
            String _returnString = await _users.onSignOut();
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
