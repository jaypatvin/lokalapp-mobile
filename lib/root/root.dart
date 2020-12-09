import 'package:flutter/material.dart';
import 'package:lokalapp/screens/home.dart';
import 'package:lokalapp/screens/profile_registration.dart';
import 'package:lokalapp/screens/welcome_screen.dart';
import 'package:lokalapp/models/user.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:provider/provider.dart';

enum AuthStatus { notLoggedIn, loggedIn }

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  AuthStatus _authStatus = AuthStatus.notLoggedIn;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    CurrentUser _users = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _users.onStartUp();
    if (_returnString == "success") {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch (_authStatus) {
      case AuthStatus.notLoggedIn:
        retVal = WelcomeScreen();
        break;
      case AuthStatus.loggedIn:
        retVal = Home();
    }
    return retVal;
  }
}
