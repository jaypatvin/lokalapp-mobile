import 'package:flutter/material.dart';
import 'package:lokalapp/screens/bottomNavigation.dart';
import 'package:lokalapp/screens/home.dart';
import 'package:lokalapp/screens/profile_registration.dart';
import 'package:lokalapp/screens/welcome_screen.dart';
import 'package:lokalapp/models/user.dart';
import 'package:provider/provider.dart';

import 'package:lokalapp/screens/invite_page.dart';
import 'package:lokalapp/screens/profile_registration.dart';
import 'package:lokalapp/screens/spalsh.dart';
import 'package:lokalapp/screens/welcome_screen.dart';
import 'package:lokalapp/models/user.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:provider/provider.dart';

enum AuthStatus { notLoggedIn, loggedIn, unknown, notInCommunity, inCommunity }

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  // AuthStatus _authStatus = AuthStatus.notLoggedIn;
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
        // CurrentUser _users = Provider.of<CurrentUser>(context, listen: false);
        // String _returnString = await _users.onStartUp();
        if (_returnString == "success") {
          if (_users.getCurrentUser.communityId != null) {
            setState(() {
              _authStatus = AuthStatus.inCommunity;
            });
          } else
            setState(() {
              _authStatus = AuthStatus.notInCommunity;
            });
        } else {
          setState(() {
            _authStatus = AuthStatus.notLoggedIn;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = Splash();
        break;
      case AuthStatus.notLoggedIn:
        retVal = WelcomeScreen();
        break;
      case AuthStatus.loggedIn:
        retVal = BottomNavigation();
        break;
      case AuthStatus.notInCommunity:
        retVal = WelcomeScreen();
        break;
      case AuthStatus.inCommunity:
        retVal = Home();
    }
    return retVal;
  }
}
