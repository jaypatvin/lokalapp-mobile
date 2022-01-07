import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/bank_codes.dart';
import '../providers/categories.dart';
import '../providers/products.dart';
import '../providers/shops.dart';
import '../providers/users.dart';
import '../screens/bottom_navigation.dart';
import '../screens/welcome_screen.dart';
import '../utils/constants/assets.dart';
import '../utils/constants/themes.dart';

class Root extends StatefulWidget {
  static const routeName = '/';
  const Root({this.account});

  final Map<String, String>? account;

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    _onStartUp();
  }

  Future<void> _onStartUp() async {
    final auth = context.read<Auth>();

    try {
      await auth.onStartUp();
      if (auth.user == null) throw 'user-not-registered';

      if (!mounted) return;
      context
        ..read<Shops>().fetch()
        ..read<Products>().fetch()
        ..read<Categories>().fetch()
        ..read<BankCodes>().fetch();
      await context.read<Users>().fetch();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BottomNavigation(),
          settings: const RouteSettings(name: BottomNavigation.routeName),
        ),
        (route) => false,
      );
    } catch (e) {
      await auth.logOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => WelcomeScreen(),
        ),
        (route) => false,
      );
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
        ),
      ),
    );
  }
}
