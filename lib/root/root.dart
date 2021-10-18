import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/activities.dart';
import '../providers/categories.dart';
import '../providers/products.dart';
import '../providers/shops.dart';
import '../providers/user.dart';
import '../providers/user_auth.dart';
import '../providers/users.dart';
import '../screens/bottom_navigation.dart';
import '../screens/welcome_screen.dart';
import '../utils/constants.dart';
import '../utils/themes.dart';

class Root extends StatefulWidget {
  final Map<String, String>? account;
  Root({
    this.account,
  });
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  initState() {
    super.initState();
    _onStartUp();
  }

  Future<void> _onStartUp() async {
    final auth = Provider.of<UserAuth>(context, listen: false);

    final authStatus = await auth.onStartUp();

    if (authStatus == AuthStatus.Success) {
      CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
      await user.fetch(auth.user!);
      if (user.state == UserState.LoggedIn) {
        await context.read<Activities>().fetch();
        await context.read<Shops>().fetch();
        await context.read<Products>().fetch();
        await context.read<Users>().fetch();
        await context.read<Categories>().fetch();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => BottomNavigation(),
              settings: RouteSettings(name: BottomNavigation.routeName),
            ),
            (route) => false);
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => WelcomeScreen(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kOrangeColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SvgPicture.asset(
          kSvgLokalLogo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
