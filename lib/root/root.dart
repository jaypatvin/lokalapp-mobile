import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../models/failure_exception.dart';
import '../providers/auth.dart';
import '../providers/bank_codes.dart';
import '../providers/categories.dart';
import '../providers/products.dart';
import '../providers/shops.dart';
import '../providers/users.dart';
import '../routers/app_router.dart';
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
      if (auth.user == null) throw FailureException('user-not-registered');

      if (!mounted) return;
      await Future.wait([
        context.read<Shops>().fetch(),
        context.read<Products>().fetch(),
        context.read<Categories>().fetch(),
        context.read<BankCodes>().fetch(),
        context.read<Users>().fetch(),
      ]);
      if (!mounted) return;
      AppRouter.rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        BottomNavigation.routeName,
        (route) => false,
      );
    } catch (e) {
      if (e is FailureException && e.message == 'user-not-registered') {
        await auth.logOut();
        if (!mounted) return;
        AppRouter.rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
          WelcomeScreen.routeName,
          (route) => false,
        );
        return;
      }

      showToast(e.toString());
      if (!mounted) return;
      AppRouter.rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        BottomNavigation.routeName,
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
