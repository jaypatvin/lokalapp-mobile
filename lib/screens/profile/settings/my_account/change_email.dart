import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../models/app_navigator.dart';
import '../../../../state/mvvm_builder.widget.dart';
import '../../../../state/views/hook.view.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/my_account/change_email.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/overlays/screen_loader.dart';
import 'components/email_input_form.dart';
import 'confirmation.dart';

class ChangeEmail extends StatelessWidget {
  const ChangeEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ChangeEmailView(),
      viewModel: ChangeEmailViewModel(),
    );
  }
}

class _ChangeEmailView extends HookView<ChangeEmailViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, ChangeEmailViewModel viewModel) {
    final formKey = useMemoized<GlobalKey<FormState>>(
      () => GlobalKey<FormState>(),
    );

    final newEmailFocusNode = useFocusNode();
    final confirmEmailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    final isMounted = useIsMounted();

    final addPadding = useState(false);

    useEffect(() {
      void listener() {
        addPadding.value = newEmailFocusNode.hasFocus ||
            confirmEmailFocusNode.hasFocus ||
            passwordFocusNode.hasFocus;
      }

      newEmailFocusNode.addListener(listener);
      confirmEmailFocusNode.addListener(listener);
      passwordFocusNode.addListener(listener);

      return () {
        if (isMounted()) {
          newEmailFocusNode.removeListener(listener);
          confirmEmailFocusNode.removeListener(listener);
          passwordFocusNode.removeListener(listener);
        }
      };
    }, [
      newEmailFocusNode,
      confirmEmailFocusNode,
      passwordFocusNode,
    ]);

    return Scaffold(
      backgroundColor: kInviteScreenColor,
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        titleText: 'Change Email Address',
        backgroundColor: kTealColor,
        titleStyle: TextStyle(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          children: [
            Expanded(
              child: EmailInputForm(
                formKey: formKey,
                displayEmailMatchError: viewModel.displayEmailError,
                displaySignInError: viewModel.displaySignInError,
                newEmailFocusNode: newEmailFocusNode,
                confirmEmailFocusNode: confirmEmailFocusNode,
                passwordFocusNode: passwordFocusNode,
                onNewEmailChanged: viewModel.onEmailChanged,
                onConfirmEmailChanged: viewModel.onNewEmailChanged,
                onPasswordChanged: viewModel.onPasswordChanged,
                onFormSubmit: () async {
                  final success =
                      await performFuture<bool>(viewModel.onFormSubmit);
                  if (success!) {
                    Navigator.push(
                      context,
                      AppNavigator.appPageRoute(
                        builder: (_) => const MyAccountConfirmation(),
                      ),
                    );
                  }
                },
              ),
            ),
            if (viewModel.displayEmailError)
              Text(
                'Email addresses do not match!',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: kPinkColor),
              ),
            SizedBox(
              width: double.maxFinite,
              child: AppButton.filled(
                text: 'Confirm',
                onPressed: () async {
                  newEmailFocusNode.unfocus();
                  confirmEmailFocusNode.unfocus();
                  passwordFocusNode.unfocus();

                  if (!(formKey.currentState?.validate() ?? false)) return;

                  final success =
                      await performFuture<bool>(viewModel.onFormSubmit);

                  if (success!) {
                    Navigator.push(
                      context,
                      AppNavigator.appPageRoute(
                        builder: (_) => const MyAccountConfirmation(),
                      ),
                    );
                    return;
                  }
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: addPadding.value ? kKeyboardActionHeight : 0,
            ),
          ],
        ),
      ),
    );
  }
}
