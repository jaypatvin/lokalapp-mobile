import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../state/mvvm_builder.widget.dart';
import '../../../../state/views/hook.view.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/my_account/reset_password.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/inputs/input_email_field.dart';
import '../../../../widgets/overlays/screen_loader.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ResetPasswordView(),
      viewModel: ResetPasswordViewModel(),
    );
  }
}

class _ResetPasswordView extends HookView<ResetPasswordViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, ResetPasswordViewModel viewModel) {
    final emailFocusNode = useFocusNode();

    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: const CustomAppBar(
        backgroundColor: Colors.transparent,
        leadingColor: kTealColor,
      ),
      body: KeyboardActions(
        config: KeyboardActionsConfig(
          nextFocus: false,
          actions: [
            KeyboardActionsItem(
              focusNode: emailFocusNode,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Reset your password?',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Text(
                'Enter the email associated with your account below and '
                "we'll send a link to reset your password.",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: InputEmailField(
                focusNode: emailFocusNode,
                onChanged: viewModel.onEmailAddressChanged,
              ),
            ),
            const SizedBox(height: 12),
            AppButton.filled(
              text: 'Submit',
              onPressed: () async => performFuture(viewModel.onSubmit),
            ),
          ],
        ),
      ),
    );
  }
}
