import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../routers/app_router.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/overlays/constrained_scrollview.dart';
import '../settings.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ConstrainedScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Text(
                'Are you sure you want to delete your account?',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 12),
              Text(
                'Deleting your account means deleting all of your information, '
                'posts, your shop, and history.\n\n'
                'You will not be able to delete your account if you still have '
                'confirmed and paid orders that has not yet been delivered.',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                child: AppButton.filled(
                  text: 'Delete account',
                  color: kPinkColor,
                  onPressed: () => showToast('Not yet implemented.'),
                  //   () => AppRouter.rootNavigatorKey.currentState?.push(
                  // AppNavigator.appPageRoute(
                  //   builder: (context) => AccountDeleted(),
                  //  ),
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
      ),
    );
  }
}
