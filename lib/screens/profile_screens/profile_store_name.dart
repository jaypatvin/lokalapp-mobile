import 'package:flutter/material.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';

class ProfileStoreName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CurrentUser _user = Provider.of(context, listen: false);
    return Container(
        padding: EdgeInsets.all(17),
        child: Text(
          _user.firstName + " " + _user.lastName,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ));
  }
}
