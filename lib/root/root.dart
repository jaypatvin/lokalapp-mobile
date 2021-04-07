import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../providers/user_auth.dart';
import '../screens/bottom_navigation.dart';
import '../screens/welcome_screen.dart';

class Root extends StatefulWidget {
  final Map<String, String> account;
  Root({this.account});
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  UserState _userState;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    UserAuth auth = Provider.of<UserAuth>(context, listen: false);
    AuthStatus authStatus = await auth.onStartUp();

    if (authStatus == AuthStatus.Success) {
      CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
      await user.fetch(auth.user);
      setState(() => _userState = user.state);
    } else {
      setState(() => _userState = UserState.Error);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_userState) {
      case UserState.LoggedIn:
        return BottomNavigation();

      default:
        return WelcomeScreen();
    }
  }
}
