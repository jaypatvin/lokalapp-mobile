import 'package:flutter/material.dart';
import '../screens/bottom_navigation.dart';
import '../screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../screens/splash.dart';
import '../states/current_user.dart';

enum AuthStatus { notLoggedIn, loggedIn, unknown, notInCommunity, inCommunity }

class Root extends StatefulWidget {
  final Map<String, String> account;
  Root({this.account});
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
      case AuthStatus.notInCommunity:
        retVal = WelcomeScreen();
        break;

      case AuthStatus.loggedIn:
      case AuthStatus.inCommunity:
        retVal = BottomNavigation();
    }
    return retVal;
  }
}
