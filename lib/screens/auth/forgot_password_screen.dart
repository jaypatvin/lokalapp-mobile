import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/auth/forgot_password_screen.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/inputs/input_email_field.dart';
import '../../widgets/overlays/screen_loader.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ForgotPasswordScreenView(),
      viewModel: ForgotPasswordScreenViewModel(),
    );
  }
}

class _ForgotPasswordScreenView extends HookView<ForgotPasswordScreenViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, ForgotPasswordScreenViewModel viewModel) {
    final _emailFocusNode = useFocusNode();

    return Scaffold(
      backgroundColor: kInviteScreenColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: KeyboardActions(
            config: KeyboardActionsConfig(
              nextFocus: false,
              actions: [
                KeyboardActionsItem(
                  focusNode: _emailFocusNode,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Forgot your password?',
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
                    focusNode: _emailFocusNode,
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
        ),
      ),
    );
  }
}
