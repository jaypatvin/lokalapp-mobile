import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_navigator.dart';
import '../../../../providers/auth.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/my_account/my_account.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import 'change_email.dart';
import 'change_password.dart';
import 'delete_account.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late final MyAccountViewModel _viewModel;
  late final StreamSubscription<String> _errorSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel = MyAccountViewModel(context.read<Auth>());
    _errorSubscription = _viewModel.errorStream.listen(
      (event) {
        if (mounted) {
          showToast(event);
        }
      },
    );
  }

  @override
  void dispose() {
    _errorSubscription.cancel();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: CustomAppBar(
        titleText: 'My Account',
        backgroundColor: kTealColor,
        titleStyle: const TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Provider<MyAccountViewModel>.value(
        value: _viewModel,
        builder: (ctx, _) {
          final viewModel = ctx.read<MyAccountViewModel>();
          return ListView(
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
                      final isEmailAuth = viewModel.ifEmailAuth();
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
                      final isEmailAuth = viewModel.ifEmailAuth();
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
          );
        },
      ),
    );
  }
}
