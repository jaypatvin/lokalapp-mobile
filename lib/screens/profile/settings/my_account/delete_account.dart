import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../routers/app_router.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../settings.dart';

class DeleteAccount extends StatefulWidget {
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Delete Account',
        backgroundColor: kTealColor,
        titleStyle: const TextStyle(
          color: Colors.white,
        ),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: Column(
          children: [
            Text(
              'Are you sure you want to delete your account?',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20.h),
            Text(
              'Deleting your account means deleting all of your information, '
              'posts, your shop, and history.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 20.h),
            Text(
              'You will not be able to delete your account if you still have '
              'confirmed and paid orders that has not yet been delivered.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: AppButton.filled(
                text: 'Delete account',
                color: kPinkColor,
                onPressed: () => showToast('Not yet implemented.'),
                // () => pushNewScreen(
                //   context,
                //   screen: AccountDeleted(),
                //   withNavBar: false,
                // ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.filled(
                text: 'Go back to settings',
                onPressed: () {
                  context
                      .read<AppRouter>()
                      .keyOf(AppRoute.profile)
                      .currentState!
                      .popUntil(ModalRoute.withName(Settings.routeName));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
