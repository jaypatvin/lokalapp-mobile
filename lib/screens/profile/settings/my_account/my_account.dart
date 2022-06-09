import 'package:flutter/material.dart';

import '../../../../models/app_navigator.dart';
import '../../../../state/mvvm_builder.widget.dart';
import '../../../../state/views/stateless.view.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/my_account/my_account.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import 'change_email.dart';
import 'change_password.dart';
import 'delete_account.dart';
import 'reset_password.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => const _MyAccountView(),
      viewModel: MyAccountViewModel(),
    );
  }
}

class _MyAccountView extends StatelessView<MyAccountViewModel> {
  const _MyAccountView({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context, MyAccountViewModel viewModel) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: CustomAppBar(
        titleText: 'My Account',
        backgroundColor: kTealColor,
        titleStyle: const TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          ...ListTile.divideTiles(
            color: const Color(0xFFF2F2F2),
            tiles: [
              ListTile(
                tileColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                onTap: () {
                  final isEmailAuth = viewModel.ifEmailAuth(
                    action: AccountActions.changeEmail,
                  );
                  if (isEmailAuth) {
                    Navigator.push(
                      context,
                      AppNavigator.appPageRoute(
                        builder: (_) => const ChangeEmail(),
                      ),
                    );
                  }
                },
                leading: Text(
                  'Change Email Address',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: kTealColor,
                ),
              ),
              ListTile(
                tileColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                onTap: () {
                  final isEmailAuth = viewModel.ifEmailAuth(
                    action: AccountActions.changePassword,
                  );
                  if (isEmailAuth) {
                    Navigator.push(
                      context,
                      AppNavigator.appPageRoute(
                        builder: (_) => const ChangePassword(),
                      ),
                    );
                  }
                },
                leading: Text(
                  'Change Password',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: kTealColor,
                ),
              ),
              ListTile(
                tileColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                onTap: () {
                  final isEmailAuth = viewModel.ifEmailAuth(
                    action: AccountActions.resetPassword,
                  );
                  if (isEmailAuth) {
                    Navigator.push(
                      context,
                      AppNavigator.appPageRoute(
                        builder: (_) => const ResetPasswordScreen(),
                      ),
                    );
                  }
                },
                leading: Text(
                  'Reset Password',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: kTealColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton.transparent(
              text: 'Delete Account',
              color: kPinkColor,
              onPressed: () => Navigator.push(
                context,
                AppNavigator.appPageRoute(
                  builder: (_) => const DeleteAccount(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
