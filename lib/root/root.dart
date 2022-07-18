import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../app/app_router.dart';
import '../models/failure_exception.dart';
import '../providers/auth.dart';
import '../providers/bank_codes.dart';
import '../providers/categories.dart';
import '../utils/constants/assets.dart';
import '../utils/constants/themes.dart';

class Root extends StatefulWidget {
  const Root({this.account});

  final Map<String, String>? account;

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final _appRouter = locator<AppRouter>();

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
      context.read<Categories>().fetch();
      context.read<BankCodes>().fetch();

      if (!mounted) return;
      _appRouter.pushNamedAndRemoveUntil(
        AppRoute.root,
        Routes.dashboard,
      );
    } catch (e) {
      if (e is FailureException && e.message == 'user-not-registered') {
        await auth.logOut();
        if (!mounted) return;
        _appRouter.pushNamedAndRemoveUntil(
          AppRoute.root,
          Routes.welcomeScreen,
        );
        return;
      }

      showToast(e.toString());
      if (!mounted) return;
      _appRouter.pushNamedAndRemoveUntil(
        AppRoute.root,
        Routes.dashboard,
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
